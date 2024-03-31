package com.bada.badaback.route.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.route.dto.RouteRequestDto;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.route.service.RouteSearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/api/path")
@RequiredArgsConstructor
public class RouteSearchController {
    private final RouteSearchService routeSearchService;

    @PostMapping
    public ResponseEntity<RouteResponseDto> searchRoute(@ExtractPayload Long memberId,
                                                        @RequestBody RouteRequestDto routeRequestDto) throws IOException {
        RouteResponseDto routeResponseDto = routeSearchService.searchRoute(memberId, routeRequestDto.startLat(), routeRequestDto.startLng(),
                routeRequestDto.endLat(), routeRequestDto.endLng());

        return ResponseEntity.ok(routeResponseDto);
    }

}
