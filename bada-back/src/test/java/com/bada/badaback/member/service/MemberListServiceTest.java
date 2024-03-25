package com.bada.badaback.member.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.dto.MemberListResponseDto;
import com.bada.badaback.member.dto.MemberResponseDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static com.bada.badaback.feature.MemberFixture.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Member [Service Layer] -> MemberListService 테스트")
public class MemberListServiceTest extends ServiceTest {
    @Autowired
    private MemberListService memberListService;

    private Member[] memberList = new Member[5];

    @BeforeEach
    void setup() {
        memberList[0] = memberRepository.save(SUNKYOUNG.toMember()); // 가족코드 AB1111
        memberList[1] = memberRepository.save(JIYEON.toMember());
        memberList[2] = memberRepository.save(YONGJUN.toMember());
        memberList[3] = memberRepository.save(HWIWON.toMember()); // 가족코드 AB2222
        memberList[4] = memberRepository.save(CHANGHEON.toMember());
    }

    @Test
    @DisplayName("가족코드로 패밀리를 조회한다")
    void findById() {
        // when
        MemberListResponseDto familyList = memberListService.familyList(memberList[0].getId());

        // then
        assertAll(
                () -> assertThat(familyList.familyList()).size().isEqualTo(3),
                () -> assertThat(familyList.familyList().get(0).memberId()).isEqualTo(memberList[2].getId()),
                () -> assertThat(familyList.familyList().get(0).name()).isEqualTo(memberList[2].getName()),
                () -> assertThat(familyList.familyList().get(0).isParent()).isEqualTo(0),
                () -> assertThat(familyList.familyList().get(0).profileUrl()).isEqualTo(null),
                () -> assertThat(familyList.familyList().get(0).movingState()).isEqualTo(0),
                () -> assertThat(familyList.familyList().get(0).fcmToken()).isEqualTo(memberList[2].getFcmToken())
        );

    }
}
