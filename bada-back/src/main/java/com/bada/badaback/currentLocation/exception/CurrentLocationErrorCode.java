package com.bada.badaback.currentLocation.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum CurrentLocationErrorCode implements ErrorCode {
    CURRENT_LOCATION_NOT_FOUND(HttpStatus.NOT_FOUND, "CURRENT_LOCATION_001", "현재 위치 정보를 찾을 수 없습니다."),
    MEMBER_IS_NOT_CHILD_PARENT(HttpStatus.BAD_REQUEST, "CURRENT_LOCATION_002", "본인 패밀리 그룹에 속한 아이의 위치만 조회할 수 있습니다.")
    ;

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}
