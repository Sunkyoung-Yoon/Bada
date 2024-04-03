package com.bada.badaback.family.dto;

import lombok.Builder;

import java.util.List;

@Builder
public record FamilyPlaceListResponseDto(
        List<Long> placeList
) {
}
