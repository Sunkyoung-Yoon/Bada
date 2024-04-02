package com.bada.badaback.member.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum MemberErrorCode implements ErrorCode {
    MEMBER_NOT_FOUND(HttpStatus.NOT_FOUND, "MEMBER_001", "회원 정보를 찾을 수 없습니다."),
    MEMBER_IS_NOT_CHILD_PARENT(HttpStatus.BAD_REQUEST, "MEMBER_002", "본인 패밀리 그룹에 속한 아이의 정보만 수정할 수 있습니다.")
    ;

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}

