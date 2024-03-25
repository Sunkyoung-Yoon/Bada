package com.bada.badaback.safefacility.dto;

import com.bada.badaback.safefacility.domain.Point;
import lombok.Builder;

@Builder
public record SafeFacilityResponseDto(
        double startX,
        double startY,
        double endX,
        double endY,
        String passList
) {
    public static SafeFacilityResponseDto from(Point start,
                                        Point end,
                                        String passList){
        return SafeFacilityResponseDto.builder()
                .startX(start.getLongitude())
                .startY(start.getLatitude())
                .endX(end.getLongitude())
                .endY(end.getLatitude())
                .passList(passList)
                .build();
    }
}
