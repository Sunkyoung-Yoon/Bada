package com.bada.badaback.state.dto;

import jakarta.validation.constraints.NotBlank;

public record StateNowRequestDto(
        @NotBlank(message = "현재 위도는 필수입니다.")
        String nowLat,
        @NotBlank(message = "현재 경도는 필수입니다.")
        String nowLong
){
}
