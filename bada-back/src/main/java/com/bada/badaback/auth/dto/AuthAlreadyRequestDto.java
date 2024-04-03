package com.bada.badaback.auth.dto;

import jakarta.validation.constraints.NotBlank;

public record AuthAlreadyRequestDto(
        @NotBlank(message = "email은 필수입니다.")
        String email,
        @NotBlank(message = "social은 필수입니다.")
        String social,
        @NotBlank(message = "fcmToken은 필수입니다.")
        String fcmToken
) {
}
