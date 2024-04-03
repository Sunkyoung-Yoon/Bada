package com.bada.badaback.global.security;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.global.exception.GlobalErrorCode;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

@Component
public class JwtAccessDeniedHandler implements AccessDeniedHandler {
    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException accessDeniedException) {
        throw BaseException.type(GlobalErrorCode.INVALID_USER); // 필요한 권한 x -> 403

    }
}

