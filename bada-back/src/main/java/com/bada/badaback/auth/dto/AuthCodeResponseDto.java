package com.bada.badaback.auth.dto;

import com.bada.badaback.auth.domain.AuthCode;
import lombok.Builder;

@Builder
public record AuthCodeResponseDto(
        String authCode
) {
    public static AuthCodeResponseDto from(AuthCode findAuthCode) {
        return AuthCodeResponseDto.builder()
                .authCode(findAuthCode.getCode())
                .build();
    }
}
