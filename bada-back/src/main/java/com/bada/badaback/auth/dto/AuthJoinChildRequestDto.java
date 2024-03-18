package com.bada.badaback.auth.dto;

import jakarta.validation.constraints.NotBlank;

public record AuthJoinChildRequestDto(
        @NotBlank(message = "이름은 필수입니다.")
        String name,
        String phone,
        String profileUrl,
        @NotBlank(message = "인증코드는 필수입니다.")
        String code
) {
}
