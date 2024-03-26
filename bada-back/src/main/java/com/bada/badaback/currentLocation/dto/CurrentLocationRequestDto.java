package com.bada.badaback.currentLocation.dto;

import jakarta.validation.constraints.NotBlank;

public record CurrentLocationRequestDto(
        @NotBlank(message = "현재위치 위도는 필수입니다.")
        String currentLatitude,
        @NotBlank(message = "현재위치 경도는 필수입니다.")
        String currentLongitude
) {
}
