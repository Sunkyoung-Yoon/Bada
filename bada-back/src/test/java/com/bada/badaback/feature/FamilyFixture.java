package com.bada.badaback.feature;

import com.bada.badaback.family.domain.Family;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum FamilyFixture {
    FAMILY_0("우리 가족"),
    FAMILY_1("우리 가족")
    ;

    private final String familyName;

    public Family toFamily(String familyCode) {
        return Family.createFamily(familyCode, familyName);
    }
}