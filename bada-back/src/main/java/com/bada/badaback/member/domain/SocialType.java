package com.bada.badaback.member.domain;

import com.bada.badaback.global.utils.EnumConverter;
import com.bada.badaback.global.utils.EnumStandard;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum SocialType implements EnumStandard {
    NAVER("NAVER"),
    KAKAO("KAKAO"),
    CHILD("CHILD")
    ;

    private final String socialType;

    @Override
    public String getValue() {
        return socialType;
    }

    @jakarta.persistence.Converter
    public static class SocialTypeConverter extends EnumConverter<SocialType> {
        public SocialTypeConverter() {
            super(SocialType.class);
        }
    }
}


