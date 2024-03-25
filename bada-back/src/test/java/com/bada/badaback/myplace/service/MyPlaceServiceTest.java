package com.bada.badaback.myplace.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.dto.MyPlaceDetailResponseDto;
import com.bada.badaback.myplace.exception.MyPlaceErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static com.bada.badaback.feature.MyPlaceFixture.MYPLACE_0;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("MyPlace [Service Layer] -> MyPlaceService 테스트")
public class MyPlaceServiceTest extends ServiceTest {
    @Autowired
    private MyPlaceFindService myPlaceFindService;

    @Autowired
    private MyPlaceService myPlaceService;

    private Member member;
    private Family family;
    private MyPlace myPlace;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        family = familyRepository.save(FAMILY_0.toFamily(member.getFamilyCode()));
        myPlace = myPlaceRepository.save(MYPLACE_0.toMyPlace(member.getFamilyCode()));
    }

    @Test
    @DisplayName("마이플레이스 등록에 성공한다")
    void create() {
        // when
        Long myPlaceId = myPlaceService.create(member.getId(),"집", "35.111111", "127.111111", "SC4", "아파트",
                "042-1111-1111", "icon0", "지번 주소", "도로명 주소","11111111");

        // then
        MyPlace findMyPlace = myPlaceFindService.findById(myPlaceId);
        assertAll(
                () -> assertThat(findMyPlace.getPlaceName()).isEqualTo(myPlace.getPlaceName()),
                () -> assertThat(findMyPlace.getPlaceLatitude()).isEqualTo(myPlace.getPlaceLatitude()),
                () -> assertThat(findMyPlace.getPlaceLongitude()).isEqualTo(myPlace.getPlaceLongitude()),
                () -> assertThat(findMyPlace.getPlaceCategoryCode()).isEqualTo(myPlace.getPlaceCategoryCode()),
                () -> assertThat(findMyPlace.getPlacePhoneNumber()).isEqualTo(myPlace.getPlacePhoneNumber()),
                () -> assertThat(findMyPlace.getIcon()).isEqualTo(myPlace.getIcon()),
                () -> assertThat(findMyPlace.getFamilyCode()).isEqualTo(myPlace.getFamilyCode())
        );
    }


    @Test
    @DisplayName("마이플레이스 수정에 성공한다")
    void update() {
        // when
        myPlace.updateMyPlace("이름 수정", "아이콘번호 수정");

        // then
        MyPlace findMyPlace = myPlaceFindService.findById(myPlace.getId());
        assertAll(
                () -> assertThat(findMyPlace.getPlaceName()).isEqualTo("이름 수정"),
                () -> assertThat(findMyPlace.getIcon()).isEqualTo("아이콘번호 수정")
        );
    }

    @Test
    @DisplayName("마이플레이스 삭제에 성공한다")
    void delete() {
        // when
        myPlaceService.delete(member.getId(), myPlace.getId());

        // then
        assertThatThrownBy(() -> myPlaceFindService.findById(myPlace.getId()))
                .isInstanceOf(BaseException.class)
                .hasMessage(MyPlaceErrorCode.MYPLACE_NOT_FOUND.getMessage());
    }

    @Test
    @DisplayName("마이플레이스 상세 조회에 성공한다")
    void read() {
        // when
        MyPlaceDetailResponseDto responseDto = myPlaceService.read(member.getId(), myPlace.getId());

        // then
        assertAll(
                () -> assertThat(responseDto.myPlaceId()).isEqualTo(myPlace.getId()),
                () -> assertThat(responseDto.placeName()).isEqualTo(myPlace.getPlaceName()),
                () -> assertThat(responseDto.placeLatitude()).isEqualTo(myPlace.getPlaceLatitude()),
                () -> assertThat(responseDto.placeLongitude()).isEqualTo(myPlace.getPlaceLongitude()),
                () -> assertThat(responseDto.placeCategoryCode()).isEqualTo(myPlace.getPlaceCategoryCode()),
                () -> assertThat(responseDto.placeCategoryName()).isEqualTo(myPlace.getPlaceCategoryName()),
                () -> assertThat(responseDto.placePhoneNumber()).isEqualTo(myPlace.getPlacePhoneNumber()),
                () -> assertThat(responseDto.icon()).isEqualTo(myPlace.getIcon()),
                () -> assertThat(responseDto.familyCode()).isEqualTo(myPlace.getFamilyCode()),
                () -> assertThat(responseDto.addressName()).isEqualTo(myPlace.getAddressName()),
                () -> assertThat(responseDto.addressRoadName()).isEqualTo(myPlace.getAddressRoadName())
        );
    }

}
