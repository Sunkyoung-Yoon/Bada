package com.bada.badaback.auth.controller;

import com.bada.badaback.auth.dto.TokenResponseDto;
import com.bada.badaback.auth.service.TokenReissueService;
import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.global.annotation.ExtractToken;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "토큰 재발급", description = "TokenReissueApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/token/reissue")
public class TokenReissueApiController {
    private final TokenReissueService tokenReissueService;

    @PostMapping
    public ResponseEntity<TokenResponseDto> reissueTokens(@ExtractPayload Long memberId, @ExtractToken String refreshToken) {
        TokenResponseDto tokenResponseDto = tokenReissueService.reissueTokens(memberId, refreshToken);
        return ResponseEntity.ok(tokenResponseDto);
    }
}
