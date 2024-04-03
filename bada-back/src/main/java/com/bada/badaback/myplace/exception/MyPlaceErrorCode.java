package com.bada.badaback.myplace.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum MyPlaceErrorCode implements ErrorCode {
    MYPLACE_NOT_FOUND(HttpStatus.NOT_FOUND, "MYPLACE_001", "마이플레이스 정보를 찾을 수 없습니다.")
    ;

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}
