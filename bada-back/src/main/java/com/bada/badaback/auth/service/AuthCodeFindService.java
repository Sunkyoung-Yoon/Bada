package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.auth.domain.AuthCodeRepository;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthCodeFindService {
    private final AuthCodeRepository authCodeRepository;

    public AuthCode findByMemberId(Long memberId) {
        return authCodeRepository.findByMemberId(memberId)
                .orElseThrow(() -> BaseException.type(AuthErrorCode.AUTHCODE_NOT_FOUND));
    }

    public Member findMemberByCode(String code) {
        return authCodeRepository.findMemberByCode(code)
                .orElseThrow(() -> BaseException.type(AuthErrorCode.MEMBER_IS_NOT_AUTHCODE_MEMBER));
    }
}