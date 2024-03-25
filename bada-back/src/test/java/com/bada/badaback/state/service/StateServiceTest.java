package com.bada.badaback.state.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.state.domain.State;
import com.bada.badaback.state.dto.StateResponseDto;
import com.bada.badaback.state.exception.StateErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.StateFixture.STATE1;
import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
import static org.assertj.core.api.FactoryBasedNavigableListAssert.assertThat;
import static org.junit.jupiter.api.Assertions.*;

class StateServiceTest extends ServiceTest {
    @Autowired
    private StateService stateService;
    @Autowired
    private StateFindService stateFindService;

    private static Member parent;
    private static Member child;
    private static Member stranger;
    private static State state;


    @BeforeEach
    void setUp() {
        parent = memberRepository.save(JIYEON.toMember());
        stranger = memberRepository.save(HWIWON.toMember());
        child = memberRepository.save(YONGJUN.toMember());
        stateService.createState(STATE1.getStartLatitude(), STATE1.getStartLongitude(), STATE1.getEndLatitude(), STATE1.getEndLongitude(), STATE1.getNowLatitude(), STATE1.getNowLongitude(), child.getId());
    }

    @Test
    void createState() {
        //then
        State findState = stateFindService.findByMember(child);
        assertAll(
                () -> assertEquals(STATE1.getStartLatitude(), findState.getStartLatitude()),
                () -> assertEquals(STATE1.getStartLongitude(), findState.getStartLongitude()),
                () -> assertEquals(STATE1.getEndLatitude(), findState.getEndLatitude()),
                () -> assertEquals(STATE1.getEndLongitude(), findState.getEndLongitude()),
                () -> assertEquals(STATE1.getNowLatitude(), findState.getNowLatitude()),
                () -> assertEquals(STATE1.getNowLongitude(), findState.getNowLongitude()),
                () -> assertEquals(child.getId(), findState.getMember().getId())
        );
    }

    @Test
    void findStateByMemberId() {
        //when
        StateResponseDto responseDto = stateService.findStateByMemberId(parent.getId(), child.getId());

        //then
        assertAll(
                () -> assertEquals(STATE1.getStartLatitude(), responseDto.startLat()),
                () -> assertEquals(STATE1.getStartLongitude(), responseDto.startLong()),
                () -> assertEquals(STATE1.getEndLatitude(), responseDto.endLat()),
                () -> assertEquals(STATE1.getEndLongitude(), responseDto.endLong()),
                () -> assertEquals(STATE1.getNowLatitude(), responseDto.nowLat()),
                () -> assertEquals(STATE1.getNowLongitude(), responseDto.nowLong()),
                () -> assertEquals(child.getId(), responseDto.childId())
        );
    }

    @Test
    void strangerFindStateByMemberId() {
        //then
        assertThatThrownBy(()->stateService.findStateByMemberId(stranger.getId(), child.getId()))
                .isInstanceOf(BaseException.class).hasMessage(StateErrorCode.NOT_FAMILY.getMessage());
    }

    @Test
    void modifyState() {
        //when
        stateService.modifyState(child.getId(),"36.421716","127.387829");

        //then
        State findState = stateFindService.findByMember(child);
        assertAll(
                () -> assertEquals(STATE1.getStartLatitude(), findState.getStartLatitude()),
                () -> assertEquals(STATE1.getStartLongitude(), findState.getStartLongitude()),
                () -> assertEquals(STATE1.getEndLatitude(), findState.getEndLatitude()),
                () -> assertEquals(STATE1.getEndLongitude(), findState.getEndLongitude()),
                () -> assertEquals("36.421716", findState.getNowLatitude()),
                () -> assertEquals("127.387829", findState.getNowLongitude()),
                () -> assertEquals(child.getId(), findState.getMember().getId())
        );
    }

    @Test
    void deleteState() {
        //when
        stateService.deleteState(child.getId());

        //then
        assertThatThrownBy(()->stateFindService.findByMember(child)).isInstanceOf(BaseException.class).hasMessage(StateErrorCode.STATE_NOT_FOUND.getMessage());

    }
}