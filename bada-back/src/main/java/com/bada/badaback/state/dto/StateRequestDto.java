package com.bada.badaback.state.dto;

import jakarta.validation.constraints.NotBlank;

public record StateRequestDto(
        @NotBlank(message = "시작 위도는 필수입니다.")
        String startLat,
        @NotBlank(message = "시작 경도는 필수입니다.")
        String startLong,
        @NotBlank(message = "도착 위도는 필수입니다.")
        String endLat,
        @NotBlank(message = "도착 경도는 필수입니다.")
        String endLong,
        @NotBlank(message = "현재 위도는 필수입니다.")
        String nowLat,
        @NotBlank(message = "현재 경도는 필수입니다.")
        String nowLong
) {
}
