package com.bada.badaback.route.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.exception.MyPlaceErrorCode;
import com.bada.badaback.myplace.service.MyPlaceFindService;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.domain.RouteRepository;
import com.bada.badaback.route.dto.RoutePlaceResponseDto;
import com.bada.badaback.route.dto.RouteRequestDto;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.route.exception.RouteErrorCode;
import com.bada.badaback.safefacility.domain.Point;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class RouteService {
    private final RouteRepository routeRepository;
    private final MemberFindService memberFindService;
    private final RouteFindService routeFindService;
    private final TmapApiService tmapApiService;
    private final MyPlaceFindService myPlaceFindService;

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
        Route route = Route.createRoute(routeRequestDto.startLat(), routeRequestDto.startLng(), routeRequestDto.endLat(), routeRequestDto.endLng(), sb.toString(), routeRequestDto.addressName(), routeRequestDto.placeName(), child);
        try{
            routeRepository.save(route);
        }catch (Exception e){
            throw BaseException.type(RouteErrorCode.ALREADY_EXIST_ROUTE);
        }
    }

    public RoutePlaceResponseDto getRoute(Long memberId, Long childId) {
        log.info("============경로 찾기 서비스 호출==============");
        // 부모가 있는지 확인
        Member member = memberFindService.findById(memberId);
        // 자식이 있는지 확인
        Member child = memberFindService.findById(childId);
        log.info("==============가족 확인 시작===============");
        if (member.getFamilyCode().equals(child.getFamilyCode())) {
            log.info("{}번과 {}번은 가족입니다.",memberId, childId);
            //같은 가족일 때
            Route childRoute = routeFindService.findByMember(child);
            String lng = childRoute.getEndLongitude();
            String lat = childRoute.getEndLatitude();
            List<MyPlace> myPlaceList = myPlaceFindService.findRoutePlace(lat, lng);
            MyPlace myPlace = null;
            if(!myPlaceList.isEmpty()){
                myPlace = myPlaceList.get(0);
            }
            //pointList를 String에서 PointList로 변환 작업
            List<Point> pointList = new ArrayList<>();
            String[] str = childRoute.getPointList().split("_");
            log.info("==========pointList로 변환 작업 시작==============");
            for (String s : str) {
                String[] pointString = s.split(", ");
                double Lat = Double.parseDouble(pointString[0]);
                double Lng = Double.parseDouble(pointString[1]);
                pointList.add(new Point(Lat, Lng));
            }
            log.info("=====================변환 완료=====================");
            if(myPlace!=null){
                return RoutePlaceResponseDto.from(Double.parseDouble(childRoute.getStartLatitude()),
                        Double.parseDouble(childRoute.getStartLongitude()),
                        Double.parseDouble(childRoute.getEndLatitude()),
                        Double.parseDouble(childRoute.getEndLongitude()),
                        pointList,
                        childRoute.getAddressName(),
                        childRoute.getPlaceName(),myPlace.getId(),myPlace.getIcon());
            }else {
                throw BaseException.type(MyPlaceErrorCode.MYPLACE_NOT_FOUND);
            }

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
