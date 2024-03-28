package com.bada.badaback.currentLocation.domain;

import com.bada.badaback.common.RepositoryTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.CurrentLocationFixture.CURRENT_LOCATION_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("CurrentLocation [Repository Test] -> CurrentLocationRepository 테스트")
public class CurrentLocationRepositoryTest extends RepositoryTest {
    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private CurrentLocationRepository currentLocationRepository;

    private Member member;
    private CurrentLocation currentLocation;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        currentLocation = currentLocationRepository.save(CURRENT_LOCATION_0.toCurrentLocation(member));
    }

    @Test
    @DisplayName("회원으로 그 회원의 현재 위치를 확인한다")
    void findByMember() {
        // when
        CurrentLocation findCurrentLocation = currentLocationRepository.findByMember(member).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findCurrentLocation.getCurrentLatitude()).isEqualTo(CURRENT_LOCATION_0.getCurrentLatitude()),
                () -> assertThat(findCurrentLocation.getCurrentLongitude()).isEqualTo(CURRENT_LOCATION_0.getCurrentLongitude()),
                () -> assertThat(findCurrentLocation.getMember()).isEqualTo(member)
        );
    }
}
