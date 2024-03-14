package com.bada.badaback.global.annotation;

import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.auth.utils.AuthorizationExtractor;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.global.security.JwtProvider;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@RequiredArgsConstructor
public class ExtractPayloadArgumentResolver implements HandlerMethodArgumentResolver {
    private final JwtProvider jwtProvider;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(ExtractPayload.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
        String token = AuthorizationExtractor.extractToken(request)
                .orElseThrow(() -> BaseException.type(AuthErrorCode.INVALID_PERMISSION));
        validateTokenIntegrity(token);
        return jwtProvider.getId(token);
    }

    private void validateTokenIntegrity(String token) {
        jwtProvider.validateToken(token);
    }
}


