package com.bada.badaback.member.service;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.auth.service.AuthCodeFindService;
import com.bada.badaback.auth.service.TokenService;
import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.dto.MemberDetailResponseDto;
import com.bada.badaback.member.exception.MemberErrorCode;
import com.bada.badaback.state.exception.StateErrorCode;
import com.bada.badaback.state.service.StateFindService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.AuthCodeFixture.AUTHCODE_0;
import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Member [Service Layer] -> MemberService 테스트")
public class MemberServiceTest extends ServiceTest {
    @Autowired
    private MemberFindService memberFindService;

    @Autowired
    private MemberService memberService;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private StateFindService stateFindService;

    private Member member;
    private AuthCode authCode;

    private Family family;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        authCode = authCodeRepository.save(AUTHCODE_0.toAuthCode(member));
        family = familyRepository.save(FAMILY_0.toFamily(member.getFamilyCode()));
    }

    @Nested
    @DisplayName("회원 상세 조회")
    class read {
        @Test
        @DisplayName("회원 상세 조회에 성공한다")
        void success() {
            // when
            MemberDetailResponseDto memberDetailResponseDto = memberService.read(member.getId());

            // then
            assertAll(
                    () -> assertThat(memberDetailResponseDto.memberId()).isEqualTo(member.getId()),
                    () -> assertThat(memberDetailResponseDto.name()).isEqualTo(member.getName()),
                    () -> assertThat(memberDetailResponseDto.phone()).isEqualTo(member.getPhone()),
                    () -> assertThat(memberDetailResponseDto.email()).isEqualTo(member.getEmail()),
                    () -> assertThat(memberDetailResponseDto.social()).isEqualTo(member.getSocial().getSocialType()),
                    () -> assertThat(memberDetailResponseDto.profileUrl()).isEqualTo(member.getProfileUrl()),
                    () -> assertThat(memberDetailResponseDto.createdAt()).isEqualTo(member.getCreatedAt()),
                    () -> assertThat(memberDetailResponseDto.movingState()).isEqualTo(member.getMovingState()),
                    () -> assertThat(memberDetailResponseDto.fcmToken()).isEqualTo(member.getFcmToken())
            );
        }
    }


    @Nested
    @DisplayName("회원 정보 수정")
    class update {
        @Test
        @DisplayName("회원 정보 수정에 성공한다")
        void success() {
            // given
            memberService.update(member.getId(), "새로운이름", null);

            // when
            Member findmember = memberFindService.findById(member.getId());

            // then
            assertAll(
                    () -> assertThat(findmember.getName()).isEqualTo("새로운이름"),
                    () -> assertThat(findmember.getProfileUrl()).isEqualTo(null)
            );
        }
    }

    @Nested
    @DisplayName("회원 탈퇴")
    class delete {
        @Test
        @DisplayName("회원 탈퇴에 성공한다")
        void success() {
            // given
            boolean actual1 = tokenService.isRefreshTokenExists(member.getId(), "refresh_token");
            memberService.delete(member.getId());

            // when - then
            assertThatThrownBy(() -> memberFindService.findById(member.getId()))
                    .isInstanceOf(BaseException.class)
                    .hasMessage(MemberErrorCode.MEMBER_NOT_FOUND.getMessage());
            assertThatThrownBy(() -> stateFindService.findByMember(member))
                    .isInstanceOf(BaseException.class)
                    .hasMessage(StateErrorCode.STATE_NOT_FOUND.getMessage());
            assertThat(actual1).isFalse();
        }
    }

}
