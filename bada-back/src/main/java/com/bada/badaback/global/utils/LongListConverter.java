package com.bada.badaback.global.utils;

import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.util.List;

@Converter
public class LongListConverter implements AttributeConverter<List<Long>, String> {

    private static final ObjectMapper mapper = new ObjectMapper();

    // DB에 저장 될 때 사용
    @Override
    public String convertToDatabaseColumn(List<Long> attribute) {
        if (ObjectUtils.isEmpty(attribute)) return null;
        try {
            return mapper.writeValueAsString(attribute);
        } catch (JsonProcessingException e) {
            throw BaseException.type(FamilyErrorCode.UNABLE_TO_CONVERT_LIST_TO_STRING);
        }
    }

    // DB의 데이터를 Object로 매핑할 때 사용
    @Override
    public List<Long> convertToEntityAttribute(String dbData) {
        if (!StringUtils.hasText(dbData)) {
            return null;
        }
        TypeReference<List<Long>> typeReference = new TypeReference<List<Long>>() {};
        try {
            return mapper.readValue(dbData, typeReference);
        } catch (JsonProcessingException e) {
            throw BaseException.type(FamilyErrorCode.UNABLE_TO_CONVERT_STRING_TO_LIST);
        }
    }
}