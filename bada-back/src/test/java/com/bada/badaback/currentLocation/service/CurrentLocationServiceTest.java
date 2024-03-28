package com.bada.badaback.currentLocation.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.currentLocation.domain.CurrentLocation;
import com.bada.badaback.currentLocation.dto.CurrentLocationResponseDto;
import com.bada.badaback.currentLocation.exception.CurrentLocationErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.CurrentLocationFixture.CURRENT_LOCATION_0;
import static com.bada.badaback.feature.MemberFixture.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("CurrentLocation [Service Layer] -> CurrentLocationService 테스트")
public class CurrentLocationServiceTest extends ServiceTest {
    @Autowired
    private CurrentLocationFindService currentLocationFindService;

    @Autowired
    private CurrentLocationService currentLocationService;

    private Member parent;
    private Member[] child = new Member[2];
    private CurrentLocation currentLocation;

    @BeforeEach
    void setup() {
        parent = memberRepository.save(SUNKYOUNG.toMember());
        child[0] = memberRepository.save(YONGJUN.toMember());
        child[1] = memberRepository.save(YONGJUN.toMember());
        currentLocation = currentLocationRepository.save(CURRENT_LOCATION_0.toCurrentLocation(child[0]));
    }

    @Test
    @DisplayName("현재위치 등록에 성공한다")
    void create() {
        // when
        currentLocationService.create(child[1].getId(), currentLocation.getCurrentLatitude(), currentLocation.getCurrentLongitude());

        // then
        CurrentLocation findCurrentLocation = currentLocationFindService.findByMember(child[1]);
        assertAll(
                () -> assertThat(findCurrentLocation.getCurrentLatitude()).isEqualTo(currentLocation.getCurrentLatitude()),
                () -> assertThat(findCurrentLocation.getCurrentLongitude()).isEqualTo(currentLocation.getCurrentLongitude()),
                () -> assertThat(findCurrentLocation.getMember()).isEqualTo(child[1])
        );
    }


    @Test
    @DisplayName("현재위치 수정에 성공한다")
    void update() {
        // when
        currentLocationService.update(child[0].getId(), "36.4216841", "127.3842417");

        // then
        CurrentLocation findCurrentLocation = currentLocationFindService.findByMember(child[0]);
        assertAll(
                () -> assertThat(findCurrentLocation.getCurrentLatitude()).isEqualTo("36.4216841"),
                () -> assertThat(findCurrentLocation.getCurrentLongitude()).isEqualTo("127.3842417")
        );
    }

    @Test
    @DisplayName("현재위치 삭제에 성공한다")
    void delete() {
        // when
        currentLocationService.delete(child[0].getId());

        // then
        assertThatThrownBy(() -> currentLocationFindService.findByMember(child[0]))
                .isInstanceOf(BaseException.class)
                .hasMessage(CurrentLocationErrorCode.CURRENT_LOCATION_NOT_FOUND.getMessage());
    }

    @Test
    @DisplayName("현재위치 상세 조회에 성공한다")
    void read() {
        // when
        CurrentLocationResponseDto responseDto = currentLocationService.read(parent.getId(), child[0].getId());

        // then
        assertAll(
                () -> assertThat(responseDto.currentLatitude()).isEqualTo(Double.parseDouble(currentLocation.getCurrentLatitude())),
                () -> assertThat(responseDto.currentLongitude()).isEqualTo(Double.parseDouble(currentLocation.getCurrentLongitude())),
                () -> assertThat(responseDto.childId()).isEqualTo(child[0].getId()),
                () -> assertThat(responseDto.name()).isEqualTo(child[0].getName()),
                () -> assertThat(responseDto.profileUrl()).isEqualTo(child[0].getProfileUrl())
        );
    }
}
