package com.bada.badaback.global.utils;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.Objects;

@Converter
public class EnumConverter<T extends EnumStandard> implements AttributeConverter<T , String> {

    private final Class<T> enumClass;

    public EnumConverter(Class<T> enumClass) {
        this.enumClass = enumClass;
    }

    @Override
    public String convertToDatabaseColumn(T attribute) {
        if (attribute == null) return null;
        return attribute.getValue();
    }

    @Override
    public T convertToEntityAttribute(String dbData) {
        if (dbData == null) return null;
        T[] enumConstants = enumClass.getEnumConstants();
        for (T constant : enumConstants) {
            if (Objects.equals(constant.getValue(), dbData))
                return constant;
        }
        return null;
    }
}

