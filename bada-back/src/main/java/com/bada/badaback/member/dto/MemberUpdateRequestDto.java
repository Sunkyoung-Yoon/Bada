package com.bada.badaback.member.dto;

import jakarta.validation.constraints.NotBlank;

public record MemberUpdateRequestDto(
        @NotBlank(message = "이름은 필수입니다.")
        String name
) {
}
