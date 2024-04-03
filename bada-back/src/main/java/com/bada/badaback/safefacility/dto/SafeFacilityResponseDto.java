package com.bada.badaback.safefacility.dto;

import com.bada.badaback.safefacility.domain.Point;
import lombok.Builder;

import java.util.List;

@Builder
public record SafeFacilityResponseDto(
        double startX,
        double startY,
        double endX,
        double endY,
        List<Point> pointList
) {
    public static SafeFacilityResponseDto from(Point start,
                                        Point end,
                                        List<Point> pointList){
        return SafeFacilityResponseDto.builder()
                .startX(start.getLongitude())
                .startY(start.getLatitude())
                .endX(end.getLongitude())
                .endY(end.getLatitude())
                .pointList(pointList)
                .build();
    }
}
