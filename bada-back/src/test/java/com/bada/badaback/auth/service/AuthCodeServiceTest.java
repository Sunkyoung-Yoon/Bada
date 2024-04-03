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
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("AuthCode [Service Layer] -> AuthCodeService 테스트")
public class AuthCodeServiceTest extends ServiceTest {
    @Autowired
    private AuthCodeService authCodeService;

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
    @DisplayName("회원 ID(PK)로 인증코드를 발급한다")
    void issueCode() {
        // given
        Long authCodeId = authCodeService.issueCode(member.getId());

        // when
        AuthCode memberAuthCode = authCodeFindService.findByMemberId(member.getId());
        AuthCode authCode = authCodeRepository.findById(authCodeId).orElseThrow();

        // then
        assertThat(authCode).isEqualTo(memberAuthCode);
    }

    @Test
    @DisplayName("인증코드로 회원을 조회한다")
    void readCode() {
        // when
        AuthCode authCode = authCodeRepository.save(AUTHCODE_0.toAuthCode(member));
        Member findMember = authCodeFindService.findMemberByCode(authCode.getCode());

        // then
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo(member.getName()),
                () -> assertThat(findMember.getPhone()).isEqualTo(member.getPhone()),
                () -> assertThat(findMember.getEmail()).isEqualTo(member.getEmail()),
                () -> assertThat(findMember.getSocial()).isEqualTo(member.getSocial()),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(member.getProfileUrl()),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo(member.getFamilyCode())
        );
    }

    @Test
    @DisplayName("인증코드 삭제에 성공한다")
    void success() {
        // given
        authCodeService.delete(member.getId());

        // when - then
        assertThatThrownBy(() -> authCodeFindService.findByMemberId(member.getId()))
                .isInstanceOf(BaseException.class)
                .hasMessage(AuthErrorCode.AUTHCODE_NOT_FOUND.getMessage());
    }
}
