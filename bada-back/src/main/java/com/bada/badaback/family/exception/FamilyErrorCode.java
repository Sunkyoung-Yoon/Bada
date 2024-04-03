package com.bada.badaback.family.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum FamilyErrorCode implements ErrorCode {
    FAMILY_NOT_FOUND(HttpStatus.NOT_FOUND, "Family_001", "패밀리 정보를 찾을 수 없습니다."),
    UNABLE_TO_CONVERT_LIST_TO_STRING(HttpStatus.BAD_REQUEST, "Family_002", "도착지 목록을 저장할 수 없습니다."),
    UNABLE_TO_CONVERT_STRING_TO_LIST(HttpStatus.BAD_REQUEST, "Family_003", "도착지 목록을 불러올 수 없습니다.")
    ;

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}
