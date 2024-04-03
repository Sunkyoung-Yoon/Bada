package com.bada.badaback.safefacility.dto;

import com.bada.badaback.safefacility.domain.Point;
import lombok.Builder;

@Builder
public record SafeFacilityTestResponseDto(
        double startX,
        double startY,
        double endX,
        double endY,
        String passList
) {
    public static SafeFacilityTestResponseDto from(Point start,
                                               Point end,
                                               String pointList) {
        return SafeFacilityTestResponseDto.builder()
                .startX(start.getLongitude())
                .startY(start.getLatitude())
                .endX(end.getLongitude())
                .endY(end.getLatitude())
                .passList(pointList)
                .build();
    }

}
