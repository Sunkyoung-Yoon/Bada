package com.bada.badaback.safefacility.dto;

import jakarta.validation.constraints.NotBlank;

public record SafeFacilityRequestDto(
        @NotBlank(message = "출발 longitude는 필수입니다.")
        String startX,
        @NotBlank(message = "출발 latitude는 필수입니다.")
        String startY,
        @NotBlank(message = "도착 longitude는 필수입니다.")
        String endX,
        @NotBlank(message = "도착 latitude는 필수입니다.")
        String endY
) {
}
