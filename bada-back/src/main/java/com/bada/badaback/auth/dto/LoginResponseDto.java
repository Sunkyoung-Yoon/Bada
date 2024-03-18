package com.bada.badaback.auth.dto;

import lombok.Builder;

@Builder
public record LoginResponseDto(
        Long memberId,
        String name,
        String familyCode,
        String accessToken,
        String refreshToken
) {
}
