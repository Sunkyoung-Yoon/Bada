package com.bada.badaback.route.dto;

import com.bada.badaback.route.domain.Route;
import com.bada.badaback.safefacility.domain.Point;
import lombok.Builder;

import java.util.List;

@Builder
public record RouteResponseDto(
        double startLng,
        double startLat,
        double endLng,
        double endLat,
        List<Point> pointList
) {
    public static RouteResponseDto from(double startLat, double startLng, double endLat, double endLng, List<Point> pointList) {
        return RouteResponseDto.builder().startLng(startLng)
                .startLat(startLat)
                .endLng(endLng)
                .endLat(endLat)
                .pointList(pointList)
                .build();
    }
}
