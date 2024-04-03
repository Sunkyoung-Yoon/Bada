package com.bada.badaback.route.service;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.safefacility.domain.Point;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class RouteSearchService {
    private final TmapApiService tmapApiService;
    private final MemberFindService memberFindService;

    public RouteResponseDto searchRoute(Long memberId, String startLat, String startLng, String endLat, String endLng, String addressName, String placeName) throws IOException {
        Member child = memberFindService.findById(memberId);
        List<Point> pointList = tmapApiService.getPoint(startLat, startLng, endLat, endLng);
        return RouteResponseDto.from(Double.parseDouble(startLat), Double.parseDouble(startLng),
                Double.parseDouble(endLat), Double.parseDouble(endLng),
                pointList,
                addressName,
                placeName);
    }
}
