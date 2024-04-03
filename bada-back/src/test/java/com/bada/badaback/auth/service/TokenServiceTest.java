package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.Token;
import com.bada.badaback.common.ServiceTest;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Auth [Service Layer] -> TokenService 테스트")
public class TokenServiceTest extends ServiceTest {
    @Autowired
    private TokenService tokenService;

    private final Long MEMBER_ID = 1L;
    private final String REFRESHTOKEN = "refresh_token";

    @Nested
    @DisplayName("Refresh Token 발급한다")
    class synchronizeRefreshToken {
        @Test
        @DisplayName("RefreshToken을 보유하지 않은 사용자라면 새로운 RefreshToken을 발급한다")
        void newUser() {
            // when
            tokenService.synchronizeRefreshToken(MEMBER_ID, REFRESHTOKEN);

            // then
            Token findToken = tokenRepository.findByMemberId(MEMBER_ID).orElseThrow();
            assertThat(findToken.getRefreshToken()).isEqualTo(REFRESHTOKEN);
        }

        @Test
        @DisplayName("RefreshToken을 보유하고 있는 사용자라면 RefreshToken을 업데이트한다")
        void oldUser() {
            // given
            tokenRepository.save(Token.createToken(MEMBER_ID, REFRESHTOKEN));

            // when
            String newRefreshToken = REFRESHTOKEN + "new";
            tokenService.synchronizeRefreshToken(MEMBER_ID, newRefreshToken);

            // then
            Token findToken = tokenRepository.findByMemberId(MEMBER_ID).orElseThrow();
            assertThat(findToken.getRefreshToken()).isEqualTo(newRefreshToken);
        }
    }

    @Test
    @DisplayName("RTR정책에 의해서 RefreshToken을 재발급한다")
    void reissueRefreshTokenByRtrPolicy() {
        // given
        tokenRepository.save(Token.createToken(MEMBER_ID, REFRESHTOKEN));

        // when
        final String newRefreshToken = REFRESHTOKEN + "new";
        tokenService.reissueRefreshTokenByRtrPolicy(MEMBER_ID, newRefreshToken);

        // then
        Token findToken = tokenRepository.findByMemberId(MEMBER_ID).orElseThrow();
        assertThat(findToken.getRefreshToken()).isEqualTo(newRefreshToken);
    }

    @Test
    @DisplayName("사용자가 보유하고 있는 RefreshToken을 삭제한다")
    void deleteRefreshTokenByMemberId() {
        // given
        tokenRepository.save(Token.createToken(MEMBER_ID, REFRESHTOKEN));

        // when
        tokenService.deleteRefreshTokenByMemberId(MEMBER_ID);

        // then
        assertThat(tokenRepository.findByMemberId(MEMBER_ID)).isEmpty();
    }

    @Test
    @DisplayName("해당 RefreshToken을 사용자가 보유하고 있는지 확인한다")
    void isRefreshTokenExists() {
        // given
        tokenRepository.save(Token.createToken(MEMBER_ID, REFRESHTOKEN));

        // when
        final String fakeRefreshToken = REFRESHTOKEN + "fff";
        boolean actual1 = tokenService.isRefreshTokenExists(MEMBER_ID, REFRESHTOKEN);
        boolean actual2 = tokenService.isRefreshTokenExists(MEMBER_ID, fakeRefreshToken);

        // then
        assertAll(
                () -> assertThat(actual1).isTrue(),
                () -> assertThat(actual2).isFalse()
        );
    }
}


