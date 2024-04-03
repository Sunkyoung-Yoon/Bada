package com.bada.badaback.route.dto;

import com.bada.badaback.safefacility.domain.Point;
import lombok.Builder;

import java.util.List;

@Builder
public record RoutePlaceResponseDto(
        double startLng,
        double startLat,
        double endLng,
        double endLat,
        String addressName,
        String placeName,
        Long placeId,
        String destinationIcon,
        List<Point> pointList
) {
    public static RoutePlaceResponseDto from(double startLat, double startLng, double endLat, double endLng, List<Point> pointList, String addressName, String placeName,Long placeId,String destinationIcon) {
        return RoutePlaceResponseDto.builder().startLng(startLng)
                .startLat(startLat)
                .endLng(endLng)
                .endLat(endLat)
                .pointList(pointList)
                .addressName(addressName)
                .placeName(placeName)
                .placeId(placeId)
                .destinationIcon(destinationIcon)
                .build();
    }
}
