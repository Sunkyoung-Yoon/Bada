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
    public static RouteResponseDto from(Route route, List<Point> pointList) {
        return RouteResponseDto.builder().startLng(Double.parseDouble(route.getStartLongitude()))
                .startLat(Double.parseDouble(route.getStartLatitude()))
                .endLng(Double.parseDouble(route.getEndLongitude()))
                .endLat(Double.parseDouble(route.getEndLatitude()))
                .pointList(pointList)
                .build();
    }
}
