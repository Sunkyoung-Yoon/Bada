package com.bada.badaback.safefacility.dto;

import com.bada.badaback.safefacility.domain.Point;
import lombok.Builder;

@Builder
public record SafeFacilityResponseDto(
        String startX,
        String startY,
        String endX,
        String endY,
        String passList
) {
    public static SafeFacilityResponseDto from(Point start,
                                        Point end,
                                        String passList){
        return SafeFacilityResponseDto.builder()
                .startX(start.getLongitude().toString())
                .startY(start.getLatitude().toString())
                .endX(end.getLongitude().toString())
                .endY(end.getLatitude().toString())
                .passList(passList)
                .build();
    }
}
