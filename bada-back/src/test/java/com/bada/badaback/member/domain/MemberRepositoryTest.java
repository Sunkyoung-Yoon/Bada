package com.bada.badaback.member.domain;

import com.bada.badaback.common.RepositoryTest;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Member [Repository Test] -> MemberRepository 테스트")
public class MemberRepositoryTest extends RepositoryTest {
    @Autowired
    private MemberRepository memberRepository;

    private Member member;

    @BeforeEach
    void setUp() {
        member = memberRepository.save(SUNKYOUNG.toMember());
    }

    @Test
    @DisplayName("이메일로 회원을 확인한다")
    void findByEmail() {
        // when
        Member findMember = memberRepository.findByEmail(member.getEmail()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo(member.getName()),
                () -> assertThat(findMember.getPhone()).isEqualTo(member.getPhone()),
                () -> assertThat(findMember.getEmail()).isEqualTo(member.getEmail()),
                () -> assertThat(findMember.getSocial()).isEqualTo(member.getSocial()),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(member.getProfileUrl()),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo(member.getFamilyCode()),
                () -> assertThat(findMember.getMovingState()).isEqualTo(member.getMovingState()),
                () -> assertThat(findMember.getFcmToken()).isEqualTo(member.getFcmToken())
        );

    }

    @Test
    @DisplayName("이메일과 소셜타입에 일치하는 회원의 존재 여부를 확인한다")
    void existsByEmailAndSocial() {
        boolean actual1 = memberRepository.existsByEmailAndSocial(member.getEmail(), member.getSocial());
        boolean actual2 =  memberRepository.existsByEmailAndSocial("123@naver.com", member.getSocial());;

        // then
        Assertions.assertAll(
                () -> assertThat(actual1).isTrue(),
                () -> assertThat(actual2).isFalse()
        );
    }

    @Test
    @DisplayName("이메일과 소셜타입에 일치하는 회원을 확인한다")
    void findByEmailAndSocial() {
        // when
        Member findMember = memberRepository.findByEmailAndSocial(member.getEmail(), member.getSocial()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo(member.getName()),
                () -> assertThat(findMember.getPhone()).isEqualTo(member.getPhone()),
                () -> assertThat(findMember.getEmail()).isEqualTo(member.getEmail()),
                () -> assertThat(findMember.getSocial()).isEqualTo(member.getSocial()),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(member.getProfileUrl()),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo(member.getFamilyCode()),
        () -> assertThat(findMember.getMovingState()).isEqualTo(member.getMovingState()),
                () -> assertThat(findMember.getFcmToken()).isEqualTo(member.getFcmToken())
        );
    }
}
