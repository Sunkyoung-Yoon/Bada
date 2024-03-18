package com.bada.badaback.auth.dto;

import jakarta.validation.constraints.NotBlank;

public record AuthJoinRequestDto(
        @NotBlank(message = "이름은 필수입니다.")
        String name,
        String phone,
        String email,
        String social,
        String profileUrl,
        @NotBlank(message = "인증코드는 필수입니다.")
        String code
) {
}
