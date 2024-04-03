package com.bada.badaback.route.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.service.MemberService;
import com.bada.badaback.route.dto.RoutePlaceResponseDto;
import com.bada.badaback.route.dto.RouteRequestDto;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.route.service.RouteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@Slf4j
@RestController
@RequestMapping("/api/route")
@RequiredArgsConstructor
public class RouteController {
    private final RouteService routeService;
    private final MemberService memberService;

    /**
     * 아이가 자신의 현재 경로를 생성한다
     * @param memberId
     * @param routeRequestDto
     * @return
     * @throws IOException
     */
    @PostMapping
    public ResponseEntity<RoutePlaceResponseDto> creteRoute(@ExtractPayload Long memberId, @RequestBody @Valid RouteRequestDto routeRequestDto) throws IOException {
        routeService.createRoute(memberId, routeRequestDto);
        RoutePlaceResponseDto routePlaceResponseDto = routeService.getRoute(memberId, memberId);
        memberService.updateMovingState(memberId, 1);
        return ResponseEntity.ok(routePlaceResponseDto);
    }

    /**
     * 부모의 멤버id를 받아서 현재 사용자와 아이의 멤버id가 같은 가족이라면 경로를 조회한다.
     * @param memberId
     * @param childId
     * @return
     */
    @GetMapping("/{childId}")
    public ResponseEntity<RoutePlaceResponseDto> getRoute(@ExtractPayload Long memberId, @PathVariable("childId") Long childId) {
        log.info("===============childId로 경로 조회 Controller==================");
        RoutePlaceResponseDto routeResponseDto = routeService.getRoute(memberId, childId);
        log.info("==================Service에서 결과 도착======================");
        log.info("결과: {}",routeResponseDto);
        return ResponseEntity.ok(routeResponseDto);
    }

    /**
     * 아이가 도착을 누르면 아이의 경로를 삭제한다
     * @param memberId
     * @return
     */
    @DeleteMapping
    public ResponseEntity<Void> deleteRoute(@ExtractPayload Long memberId) {
        routeService.deleteRoute(memberId);
        memberService.updateMovingState(memberId, 0);
        return ResponseEntity.ok().build();
    }
}
