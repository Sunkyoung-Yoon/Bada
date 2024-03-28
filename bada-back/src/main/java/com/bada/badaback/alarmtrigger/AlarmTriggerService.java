package com.bada.badaback.alarmtrigger;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.service.RouteFindService;
import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.service.SafeFacilityService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlarmTriggerService {

    private final MemberFindService memberFindService;
    private final RouteFindService routeFindService;
    private final SafeFacilityService safeFacilityService;

    public boolean inPath(Long childId, double Lat, double Lng) {
        Member child = memberFindService.findById(childId);
        Route route = routeFindService.findByMember(child);
        //현재 위치와 경로상의 도착지 출발지 거리 비교
        Point start = new Point(Double.parseDouble(route.getStartLatitude()), Double.parseDouble(route.getStartLongitude()));
        Point end = new Point(Double.parseDouble(route.getEndLatitude()), Double.parseDouble(route.getEndLongitude()));

        double distance = safeFacilityService.distance(start.getLatitude(), start.getLongitude(), end.getLatitude(), end.getLongitude());
        Point mid = safeFacilityService.calculateMidpoint(start, end);
        double childDis = safeFacilityService.distance(mid.getLatitude(), mid.getLongitude(), Lat, Lng);
        log.info("===============경로 이탈 비교===============");
        log.info("시작 - 도착 거리: "+distance);
        log.info("중간지점 - 현재 위치 거리: "+childDis);

        if (childDis<distance*0.7){
            return true;
        }else {
            return false;
        }
    }
}
