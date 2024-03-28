package com.bada.badaback.route.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;

@Builder
public record TmapRequestDto(
        @NotBlank(message = "출발 longitude는 필수입니다.")
        String startX,
        @NotBlank(message = "출발 latitude는 필수입니다.")
        String startY,
        @NotBlank(message = "도착 longitude는 필수입니다.")
        String endX,
        @NotBlank(message = "도착 latitude는 필수입니다.")
        String endY,
        String reqCoordType,
        String resCoordType,
        String startName,
        String endName,
        String passList
) {
}
