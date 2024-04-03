package com.bada.badaback.member.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.exception.MemberErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("Member [Service Layer] -> MemberFindService 테스트")
public class MemberFindServiceTest extends ServiceTest {
    @Autowired
    private MemberFindService memberFindService;

    private Member member;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
    }

    @Test
    @DisplayName("ID(PK)로 회원을 조회한다")
    void findById() {
        // when
        Member findMember = memberFindService.findById(member.getId());

        // then
        assertThatThrownBy(() -> memberFindService.findById(member.getId() + 100L))
                .isInstanceOf(BaseException.class)
                .hasMessage(MemberErrorCode.MEMBER_NOT_FOUND.getMessage());

        assertThat(findMember).isEqualTo(member);
    }

    @Test
    @DisplayName("email과 social로 회원을 조회한다")
    void findByEmailAndSocial() {
        // when
        Member findMember = memberFindService.findByEmailAndSocial(member.getEmail(), member.getSocial());

        // then
        assertThatThrownBy(() -> memberFindService.findByEmailAndSocial("abc@gmail.com", member.getSocial()))
                .isInstanceOf(BaseException.class)
                .hasMessage(MemberErrorCode.MEMBER_NOT_FOUND.getMessage());

        assertThat(findMember).isEqualTo(member);
    }

    @Test
    @DisplayName("name과 familyCode로 회원을 조회한다")
    void findByNameAndFamilyCode() {
        // when
        Member findMember = memberFindService.findByNameAndFamilyCodeAndIsParent(member.getName(), member.getFamilyCode(), member.getIsParent());

        // then
        assertThatThrownBy(() -> memberFindService.findByNameAndFamilyCodeAndIsParent(member.getName()+"가짜이름", member.getFamilyCode(), member.getIsParent()))
                .isInstanceOf(BaseException.class)
                .hasMessage(MemberErrorCode.MEMBER_NOT_FOUND.getMessage());

        assertThat(findMember).isEqualTo(member);
    }

}
