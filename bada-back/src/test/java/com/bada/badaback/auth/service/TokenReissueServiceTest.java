package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.Token;
import com.bada.badaback.auth.dto.TokenResponseDto;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.global.security.JwtProvider;
import com.bada.badaback.member.domain.Member;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Auth [Service Layer] -> TokenReissueService 테스트")
class TokenReissueServiceTest extends ServiceTest {
    @Autowired
    private TokenReissueService tokenReissueService;

    @Autowired
    private JwtProvider jwtProvider;

    private Member member;
    private String REFRESHTOKEN;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        REFRESHTOKEN = jwtProvider.createRefreshToken(member.getId(), member.getRole());
    }

    @Nested
    @DisplayName("토큰 재발급")
    class reissueTokens {
        @Test
        @DisplayName("RefreshToken이 유효하지 않으면 예외가 발생한다")
        void throwExceptionByAuthInvalidToken() {
            // when - then
            assertThatThrownBy(() -> tokenReissueService.reissueTokens(member.getId(), REFRESHTOKEN))
                    .isInstanceOf(BaseException.class)
                    .hasMessage(AuthErrorCode.AUTH_INVALID_TOKEN.getMessage());
        }

        @Test
        @DisplayName("RefreshToken을 이용해 AccessToken과 RefreshToken을 재발급받는데 성공한다")
        void success() {
            // given
            tokenRepository.save(Token.createToken(member.getId(), REFRESHTOKEN));

            // when
            TokenResponseDto tokenResponseDto = tokenReissueService.reissueTokens(member.getId(), REFRESHTOKEN);

            // then
            assertAll(
                    () -> assertThat(tokenResponseDto).isNotNull(),
                    () -> assertThat(tokenResponseDto).usingRecursiveComparison().isNotNull()
            );
        }
    }
}


