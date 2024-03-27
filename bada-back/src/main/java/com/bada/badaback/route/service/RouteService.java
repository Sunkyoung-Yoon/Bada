package com.bada.badaback.route.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.domain.RouteRepository;
import com.bada.badaback.route.dto.RouteRequestDto;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.route.exception.RouteErrorCode;
import com.bada.badaback.safefacility.domain.Point;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RouteService {
    private final RouteRepository routeRepository;
    private final MemberFindService memberFindService;
    private final RouteFindService routeFindService;
    private final TmapApiService tmapApiService;

    @Transactional
    public void createRoute(Long childId, RouteRequestDto routeRequestDto) throws IOException {
        Member child = memberFindService.findById(childId);
        List<Point> pointList = tmapApiService.getPoint(routeRequestDto.startLat(), routeRequestDto.startLng(), routeRequestDto.endLat(), routeRequestDto.endLng());
        StringBuilder sb = new StringBuilder();
        Iterator<Point> pointIte = pointList.iterator();
        while (pointIte.hasNext()) {
            Point p = pointIte.next();
            sb.append(p.getLatitude() + ", " + p.getLongitude());
            if (pointIte.hasNext()) {
                sb.append("_");
            }
        }
        Route route = Route.createRoute(routeRequestDto.startLat(), routeRequestDto.startLng(), routeRequestDto.endLat(), routeRequestDto.endLng(), sb.toString(), child);
        routeRepository.save(route);
    }

    public RouteResponseDto getRoute(Long memberId, Long childId) {
        // 부모가 있는지 확인
        Member member = memberFindService.findById(memberId);
        // 자식이 있는지 확인
        Member child = memberFindService.findById(childId);
        if (member.getFamilyCode().equals(child.getFamilyCode())) {
            //같은 가족일 때
            Route childRoute = routeFindService.findByMember(child);
            //pointList를 String에서 PointList로 변환 작업
            List<Point> pointList = new ArrayList<>();
            String[] str = childRoute.getPointList().split("_");
            for (String s : str) {
                String[] pointString = s.split(", ");
                double Lat = Double.parseDouble(pointString[0]);
                double Lng = Double.parseDouble(pointString[1]);
                pointList.add(new Point(Lat, Lng));
            }
            return RouteResponseDto.from(childRoute, pointList);
        } else {
            //같은 가족이 아닐 때
            throw BaseException.type(RouteErrorCode.NOT_FAMILY);
        }
    }

    @Transactional
    public void deleteRoute(Long memberId) {
        Member member = memberFindService.findById(memberId);
        Route route = routeFindService.findByMember(member);
        //해당 멤버로 찾아온 route가 있다면
        routeRepository.delete(route);
    }
}
