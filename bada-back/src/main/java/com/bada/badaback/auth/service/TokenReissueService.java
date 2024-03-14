package com.bada.badaback.auth.service;


import com.bada.badaback.auth.dto.TokenResponseDto;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.global.security.JwtProvider;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TokenReissueService {
    private final TokenService tokenService;
    private final JwtProvider jwtProvider;
    private final MemberFindService memberFindService;

    @Transactional
    public TokenResponseDto reissueTokens(Long memberId, String refreshToken) {
        Member findMember = memberFindService.findById(memberId);

        // 사용자가 보유하고 있는 Refresh Token인지
        if (!tokenService.isRefreshTokenExists(memberId, refreshToken)) {
            throw BaseException.type(AuthErrorCode.AUTH_INVALID_TOKEN);
        }

        String newAccessToken = jwtProvider.createAccessToken(findMember.getId(), findMember.getRole());
        String newRefreshToken = jwtProvider.createRefreshToken(findMember.getId(), findMember.getRole());

        // RTR 정책에 의해 사용자가 보유하고 있는 Refresh Token 업데이트
        tokenService.reissueRefreshTokenByRtrPolicy(memberId, newRefreshToken);

        return new TokenResponseDto(newAccessToken, newRefreshToken);
    }
}

