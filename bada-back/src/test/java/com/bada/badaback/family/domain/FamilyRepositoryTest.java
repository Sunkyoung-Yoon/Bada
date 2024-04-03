package com.bada.badaback.family.domain;

import com.bada.badaback.common.RepositoryTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Family [Repository Test] -> FamilyRepository 테스트")
public class FamilyRepositoryTest extends RepositoryTest {

    @Autowired
    private FamilyRepository familyRepository;

    private Family family;

    @BeforeEach
    void setup() {
        family = familyRepository.save(FAMILY_0.toFamily("AB1111"));
    }

    @Test
    @DisplayName("생성한 가족코드가 이미 존재하는 코드인 지 확인한다")
    void existsByFamilyCode() {
        // when
        boolean actual1 = familyRepository.existsByFamilyCode(family.getFamilyCode());
        boolean actual2 = familyRepository.existsByFamilyCode(family.getFamilyCode() + "aaa");

        // then
        assertAll(
                () -> assertThat(actual1).isTrue(),
                () -> assertThat(actual2).isFalse()
        );
    }

    @Test
    @DisplayName("가족코드를 통해서 Family를 조회한다")
    void findByFamilyCode() {
        // when
        Family findFamily = familyRepository.findByFamilyCode(family.getFamilyCode()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findFamily.getFamilyCode()).isEqualTo(family.getFamilyCode()),
                () -> assertThat(findFamily.getFamilyName()).isEqualTo(family.getFamilyName()),
                () -> assertThat(findFamily.getPlaceList()).isEqualTo(family.getPlaceList())
        );
    }
}
