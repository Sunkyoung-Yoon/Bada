package com.bada.badaback.route.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.domain.RouteRepository;
import com.bada.badaback.route.exception.RouteErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class RouteFindService {
    private final RouteRepository routeRepository;

    public Route findByMember(Member child){
        log.info("==========경로 찾기 FindService 호출=============");
        return routeRepository.findByMember(child).orElseThrow(()-> BaseException.type(RouteErrorCode.ROUTE_NOT_FOUND));
    }
}
