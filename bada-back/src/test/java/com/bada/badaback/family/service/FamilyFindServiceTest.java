package com.bada.badaback.family.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("Family [Service Layer] -> FamilyFindService 테스트")
public class FamilyFindServiceTest extends ServiceTest {
    @Autowired
    private FamilyFindService familyFindService;

    private Member member;
    private Family family;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        family = familyRepository.save(FAMILY_0.toFamily(member.getFamilyCode()));
    }

    @Test
    @DisplayName("가족코드로 Family를 조회한다")
    void findByFamilyCode() {
        // when
        Family findFamily = familyRepository.findByFamilyCode(family.getFamilyCode()).orElseThrow();

        // then
        assertThatThrownBy(() -> familyFindService.findByFamilyCode(family.getFamilyCode() + 100L))
                .isInstanceOf(BaseException.class)
                .hasMessage(FamilyErrorCode.FAMILY_NOT_FOUND.getMessage());

        assertThat(findFamily).isEqualTo(family);
    }
}
