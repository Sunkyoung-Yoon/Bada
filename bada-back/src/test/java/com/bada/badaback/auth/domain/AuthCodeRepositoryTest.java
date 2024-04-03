package com.bada.badaback.auth.domain;

import com.bada.badaback.common.RepositoryTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.AuthCodeFixture.AUTHCODE_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("AuthCode [Repository Test] -> AuthCodeRepository 테스트")
public class AuthCodeRepositoryTest extends RepositoryTest {

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private AuthCodeRepository authCodeRepository;

    private Member member;
    private AuthCode authCode;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        authCode = authCodeRepository.save(AUTHCODE_0.toAuthCode(member));
    }

    @Test
    @DisplayName("회원 Id(pk)가 보유하고 있는 인증코드 존재 여부를 확인한다")
    void existsByMemberId() {
        // when
        boolean actual1 = authCodeRepository.existsByMemberId(member.getId());
        boolean actual2 = authCodeRepository.existsByMemberId(member.getId()+100L);

        // then
        assertAll(
                () -> assertThat(actual1).isTrue(),
                () -> assertThat(actual2).isFalse()
        );
    }

    @Test
    @DisplayName("회원 Id(pk)가 보유하고 있는 인증코드를 확인한다")
    void findByMemberId() {
        // when
        AuthCode findAuthCode = authCodeRepository.findByMemberId(member.getId()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findAuthCode.getMember()).isEqualTo(member),
                () -> assertThat(findAuthCode.getCode()).isEqualTo(authCode.getCode())
        );
    }

    @Test
    @DisplayName("인증코드를 통해서 회원을 확인한다")
    void findMemberByCode() {
        // when
        Member findMember = authCodeRepository.findMemberByCode(authCode.getCode()).orElseThrow();

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
}
