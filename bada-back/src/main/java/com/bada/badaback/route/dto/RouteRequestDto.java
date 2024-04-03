package com.bada.badaback.route.dto;

import jakarta.validation.constraints.NotBlank;

public record RouteRequestDto(
        @NotBlank(message = "출발 latitude는 필수입니다.")
        String startLat,
        @NotBlank(message = "출발 longitude는 필수입니다.")
        String startLng,
        @NotBlank(message = "도착 latitude는 필수입니다.")
        String endLat,
        @NotBlank(message = "도착 longitude는 필수입니다.")
        String endLng,
        @NotBlank(message = "출발지 이름은 필수입니다.")
        String addressName,
        @NotBlank(message = "도착지 이름은 필수입니다.")
        String placeName
) {
}
