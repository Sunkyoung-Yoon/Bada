package com.bada.badaback.alarmtrigger;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.route.domain.Route;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.AlarmTriggerFixture.IN_PATH;
import static com.bada.badaback.feature.AlarmTriggerFixture.OUT_OF_PATH;
import static com.bada.badaback.feature.MemberFixture.YONGJUN;
import static com.bada.badaback.feature.RouteFixture.ROUTE1;
import static org.junit.jupiter.api.Assertions.assertEquals;

class AlarmTriggerServiceTest extends ServiceTest {
    @Autowired
    private AlarmTriggerService alarmTriggerService;
    private static Member child;
    private static Route route;

    @BeforeEach
    void setUp() {
        child = memberRepository.save(YONGJUN.toMember());
        route = routeRepository.save(ROUTE1.toRoute(child));
    }
    @Test
    @DisplayName("경로를 이탈했을 때")
    void OutOfPath() {
        //when
        boolean outOfCourse =alarmTriggerService.inPath(child.getId(), OUT_OF_PATH.getLat(), OUT_OF_PATH.getLng());
        //then
        assertEquals(false,outOfCourse);
    }
    @Test
    @DisplayName("경로를 이탈했을 때")
    void InPath() {
        //when
        boolean outOfCourse =alarmTriggerService.inPath(child.getId(), IN_PATH.getLat(), IN_PATH.getLng());
        //then
        assertEquals(true,outOfCourse);
    }
}