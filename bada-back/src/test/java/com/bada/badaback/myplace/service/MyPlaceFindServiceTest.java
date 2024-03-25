package com.bada.badaback.myplace.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.exception.MyPlaceErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static com.bada.badaback.feature.MyPlaceFixture.MYPLACE_0;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("MyPlace [Service Layer] -> MyPlaceFindService 테스트")
public class MyPlaceFindServiceTest extends ServiceTest {
    @Autowired
    private MyPlaceFindService myPlaceFindService;

    private Member member;
    private MyPlace myPlace;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        myPlace = myPlaceRepository.save(MYPLACE_0.toMyPlace(member.getFamilyCode()));
    }

    @Test
    @DisplayName("ID(PK)로 마이 플레이스를 조회한다")
    void findById() {
        // when
        MyPlace findMyPlace = myPlaceFindService.findById(myPlace.getId());

        // then
        assertThatThrownBy(() -> myPlaceFindService.findById(myPlace.getId() + 100L))
                .isInstanceOf(BaseException.class)
                .hasMessage(MyPlaceErrorCode.MYPLACE_NOT_FOUND.getMessage());

        assertThat(findMyPlace).isEqualTo(myPlace);
    }
}
