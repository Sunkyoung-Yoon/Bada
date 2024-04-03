package com.bada.badaback.family.service;

import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.domain.FamilyRepository;
import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.global.exception.BaseException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FamilyFindService {
    private final FamilyRepository familyRepository;

    public Family findByFamilyCode(String familyCode) {
        return familyRepository.findByFamilyCode(familyCode)
                .orElseThrow(() -> BaseException.type(FamilyErrorCode.FAMILY_NOT_FOUND));
    }
}
