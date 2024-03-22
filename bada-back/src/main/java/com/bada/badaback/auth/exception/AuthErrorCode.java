package com.bada.badaback.auth.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum AuthErrorCode implements ErrorCode {
    AUTH_EXPIRED_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH_001", "토큰의 유효기간이 만료되었습니다."),
    AUTH_INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH_002", "토큰이 유효하지 않습니다."),
    INVALID_PERMISSION(HttpStatus.FORBIDDEN, "AUTH_003", "권한이 없습니다. 로그인 먼저 해주세요."),
    AUTHCODE_NOT_FOUND(HttpStatus.NOT_FOUND, "AUTH_004", "인증 코드 정보를 찾을 수 없습니다."),
    AUTH_EXPIRED_AUTHCODE(HttpStatus.NOT_FOUND, "AUTH_005", "인증코드의 유효기간이 만료되었습니다.")
    ;

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}
