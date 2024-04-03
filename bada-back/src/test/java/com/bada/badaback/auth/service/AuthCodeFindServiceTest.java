package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.AuthCodeFixture.AUTHCODE_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("AuthCode [Service Layer] -> AuthCodeFindService 테스트")
public class AuthCodeFindServiceTest extends ServiceTest {
    @Autowired
    private AuthCodeFindService authCodeFindService;

    private Member member;
    private AuthCode authCode;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        authCode = authCodeRepository.save(AUTHCODE_0.toAuthCode(member));
    }

    @Test
    @DisplayName("회원 ID(PK)로 인증코드를 조회한다")
    void findByMemberId() {
        // when
        AuthCode findAuthCode = authCodeFindService.findByMemberId(member.getId());

        // then
        assertThatThrownBy(() -> authCodeFindService.findByMemberId(member.getId() + 100L))
                .isInstanceOf(BaseException.class)
                .hasMessage(AuthErrorCode.AUTHCODE_NOT_FOUND.getMessage());

        assertThat(findAuthCode).isEqualTo(authCode);
    }

    @Test
    @DisplayName("인증코드를 통해서 회원을 조회한다")
    void findMemberByCode() {
        // when
        Member findMember = authCodeFindService.findMemberByCode(authCode.getCode());

        // then
        assertThatThrownBy(() -> authCodeFindService.findMemberByCode(authCode.getCode()+"aaa"))
                .isInstanceOf(BaseException.class)
                .hasMessage(AuthErrorCode.MEMBER_IS_NOT_AUTHCODE_MEMBER.getMessage());

        assertThat(findMember).isEqualTo(member);
    }
}
