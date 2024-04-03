package com.bada.badaback.currentLocation.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.currentLocation.domain.CurrentLocation;
import com.bada.badaback.currentLocation.exception.CurrentLocationErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.CurrentLocationFixture.CURRENT_LOCATION_0;
import static com.bada.badaback.feature.MemberFixture.JIYEON;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("CurrentLocation [Service Layer] -> CurrentLocationFindService 테스트")
public class CurrentLocationFindServiceTest extends ServiceTest {
    @Autowired
    private CurrentLocationFindService currentLocationFindService;

    private Member member;
    private Member notMovingMember;
    private CurrentLocation currentLocation;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        notMovingMember = memberRepository.save(JIYEON.toMember());
        currentLocation = currentLocationRepository.save(CURRENT_LOCATION_0.toCurrentLocation(member));
    }

    @Test
    @DisplayName("회원을 통해 그 회원의 현재 위치를 조회한다")
    void findByMemberId() {
        // when
        CurrentLocation findCurrentLocation = currentLocationFindService.findByMember(member);

        // then
        assertThatThrownBy(() -> currentLocationFindService.findByMember(notMovingMember))
                .isInstanceOf(BaseException.class)
                .hasMessage(CurrentLocationErrorCode.CURRENT_LOCATION_NOT_FOUND.getMessage());

        assertThat(findCurrentLocation).isEqualTo(currentLocation);
    }
}
