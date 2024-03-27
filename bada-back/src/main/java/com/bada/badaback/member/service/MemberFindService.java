package com.bada.badaback.member.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.domain.SocialType;
import com.bada.badaback.member.exception.MemberErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberFindService {
    private final MemberRepository memberRepository;

    public Member findByEmailAndSocial(String email, SocialType social) {
        return memberRepository.findByEmailAndSocial(email, social)
                .orElseThrow(() -> BaseException.type(MemberErrorCode.MEMBER_NOT_FOUND));
    }

    public Member findById(Long id) {
        return memberRepository.findById(id)
                .orElseThrow(() -> BaseException.type(MemberErrorCode.MEMBER_NOT_FOUND));
    }

    public Member findByNameAndFamilyCodeAndIsParent(String name, String familyCode, int isParent) {
        return memberRepository.findByNameAndFamilyCodeAndIsParent(name, familyCode, isParent)
                .orElseThrow(() -> BaseException.type(MemberErrorCode.MEMBER_NOT_FOUND));
    }

}
