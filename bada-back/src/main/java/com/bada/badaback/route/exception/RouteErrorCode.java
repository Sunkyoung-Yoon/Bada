package com.bada.badaback.route.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum RouteErrorCode implements ErrorCode {
    NOT_FAMILY(HttpStatus.NOT_FOUND,"ROUTE_001","가족이 아닙니다."),
    ROUTE_NOT_FOUND(HttpStatus.NOT_FOUND,"ROUTE_002","회원의 상태를 찾을 수 없습니다.");

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}
