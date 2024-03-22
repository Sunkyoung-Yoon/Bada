package com.bada.badaback.safefacility.domain;

import com.bada.badaback.global.utils.EnumConverter;
import com.bada.badaback.global.utils.EnumStandard;
import jakarta.persistence.Converter;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Type implements EnumStandard {
    CCTV("cctv"),
    POLICE("police"),
    GUARD("guard");

private final String type;

    @Override
    public String getValue() {
        return type;
    }

    @Converter
    public static class TypeConverter extends EnumConverter<Type>{
        public TypeConverter(){super(Type.class);}
    }
}
