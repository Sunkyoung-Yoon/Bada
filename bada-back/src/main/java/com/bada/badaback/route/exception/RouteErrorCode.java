package com.bada.badaback.route.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum RouteErrorCode implements ErrorCode {
    NOT_FAMILY(HttpStatus.NOT_FOUND,"ROUTE_001","가족이 아닙니다."),
    ROUTE_NOT_FOUND(HttpStatus.NOT_FOUND,"ROUTE_002","회원의 경로를 찾을 수 없습니다."),
    ALREADY_EXIST_ROUTE(HttpStatus.BAD_REQUEST, "ROUTE_003","이미 회원의 경로가 존재합니다. 삭제 후 다시 시도해주세요."),
    CANT_FIND_PASSLIST(HttpStatus.NOT_FOUND,"ROUTE_004","경유지를 선정할 수 없습니다."),
    TMAP_ERROR(HttpStatus.BAD_REQUEST,"ROUTE_005","Tmap api 호출 중 에러 발생했습니다."),
    CANT_MAKE_LAYER(HttpStatus.NOT_FOUND,"ROUTE_006","레이어를 만들 수 없습니다."),
    CANT_SAVE(HttpStatus.BAD_REQUEST,"ROUTE_007","경로 저장에 실패했습니다. 경로 거리 혹은 파라미터 형태를 체크해주세요.");

    private final HttpStatus status;
    private final String errorCode;
    private final String message;
}
