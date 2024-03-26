package com.bada.badaback.myplace.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.dto.MyPlaceListResponseDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.MyPlaceFixture.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("MyPlace [Service Layer] -> MyPlaceListService 테스트")
public class MyPlaceListServiceTest extends ServiceTest {
    @Autowired
    private MyPlaceListService myPlaceListService;

    private Member member;
    private Family family;
    private MyPlace[] placeList = new MyPlace[4];

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        family = familyRepository.save(FAMILY_0.toFamily(member.getFamilyCode()));
        placeList[0] = myPlaceRepository.save(MYPLACE_0.toMyPlace(member.getFamilyCode()));
        placeList[1] = myPlaceRepository.save(MYPLACE_1.toMyPlace(member.getFamilyCode()));
        placeList[2] = myPlaceRepository.save(MYPLACE_2.toMyPlace(member.getFamilyCode()));
        placeList[3] = myPlaceRepository.save(MYPLACE_3.toMyPlace(member.getFamilyCode()));
    }

    @Test
    @DisplayName("회원 ID(PK)로 마이 플레이스 리스트를 조회한다")
    void findById() {
        //given
        List<Long> myPlaceIdList = new ArrayList<>();
        myPlaceIdList.add(1L);
        myPlaceIdList.add(2L);
        myPlaceIdList.add(3L);
        myPlaceIdList.add(4L);

        // when
        MyPlaceListResponseDto myPlaceList = myPlaceListService.myPlaceList(myPlaceIdList);

        // then
        assertAll(
                () -> assertThat(myPlaceList.MyPlaceList()).size().isEqualTo(4),
                () -> assertThat(myPlaceList.MyPlaceList().get(0).myPlaceId()).isEqualTo(placeList[3].getId()),
                () -> assertThat(myPlaceList.MyPlaceList().get(0).placeName()).isEqualTo(placeList[3].getPlaceName()),
                () -> assertThat(myPlaceList.MyPlaceList().get(0).icon()).isEqualTo(placeList[3].getIcon()),
                () -> assertThat(myPlaceList.MyPlaceList().get(0).addressName()).isEqualTo(placeList[3].getAddressName()),
                () -> assertThat(myPlaceList.MyPlaceList().get(0).addressRoadName()).isEqualTo(placeList[3].getAddressRoadName())
        );

    }
}