package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.auth.dto.LoginResponseDto;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.family.service.FamilyService;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.global.security.JwtProvider;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.domain.SocialType;
import com.bada.badaback.member.service.MemberFindService;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthService {

    private final MemberRepository memberRepository;
    private final MemberFindService memberFindService;
    private final JwtProvider jwtProvider;
    private final TokenService tokenService;
    private final AuthCodeFindService authCodeFindService;
    private final FamilyService familyService;

    @Transactional
    public Long signup(String name, String phone, String email, String social, String profileUrl,
                       String familyName, String fcmToken){
        Long memberId = AlreadyMember(email, social);

        if(memberId == null) {
            String familyCode = familyService.create(familyName);

            Member member = Member.createMember(name, phone, email, SocialType.valueOf(social), 1, profileUrl, familyCode, fcmToken);
            memberId = memberRepository.save(member).getId();
        }

        return memberId;
    }

    @Transactional
    public Long join(String name, String phone, String email, String social, String profileUrl,
                     String code, String fcmToken){
        // 인증 코드 유효성 체크
        validateAuthCode(code, LocalDateTime.now());
        String findFamilyCode = authCodeFindService.findMemberByCode(code).getFamilyCode();

        Long memberId = AlreadyMember(email, social);

        if(memberId == null) {

            Member member = Member.createMember(name, phone, email, SocialType.valueOf(social), 1, profileUrl, findFamilyCode, fcmToken);
            memberId = memberRepository.save(member).getId();
        }

        return memberId;
    }

    @Transactional
    public Long joinChild(String name, String phone, String profileUrl, String code, String fcmToken){
        // 인증 코드 유효성 체크
        validateAuthCode(code, LocalDateTime.now());
        String findFamilyCode = authCodeFindService.findMemberByCode(code).getFamilyCode();
        Member member = Member.createMember(name, phone, "", SocialType.valueOf("CHILD"), 0, profileUrl, findFamilyCode, fcmToken);

        return memberRepository.save(member).getId();
    }


    @Transactional
    public LoginResponseDto login(Long memberId) {
        Member member = memberFindService.findById(memberId);

        if(member.getIsParent() == 0){
            member.updateChildEmail(childEmail(memberId));
        }

        String accessToken = jwtProvider.createAccessToken(member.getId(), member.getRole());
        String refreshToken = jwtProvider.createRefreshToken(member.getId(), member.getRole());
        tokenService.synchronizeRefreshToken(member.getId(), refreshToken);

        return LoginResponseDto.builder()
                .memberId(member.getId())
                .name(member.getName())
                .familyCode(member.getFamilyCode())
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .fcmToken(member.getFcmToken())
                .build();
    }

    @Transactional
    public Long AlreadyMember(String email, String social) {
        if(memberRepository.existsByEmailAndSocial(email, SocialType.valueOf(social))){
            return memberFindService.findByEmailAndSocial(email, SocialType.valueOf(social)).getId();
        }
        return null;
    }

    @Transactional
    public void logout(Long memberId) {
        Member findMember = memberFindService.findById(memberId);
        tokenService.deleteRefreshTokenByMemberId(findMember.getId());
    }

    private String childEmail(Long memberId) {
        String number = String.valueOf((int)(Math.random() * 99) + 10);
        return "bada"+number+String.valueOf(memberId)+"@bada.com";
    }

    public void validateAuthCode(String code, LocalDateTime nowTime) {
        Member oldMember = authCodeFindService.findMemberByCode(code);
        AuthCode authCode = authCodeFindService.findByMemberId(oldMember.getId());
        LocalDateTime authCodeTime = authCode.getModifiedAt().plusMinutes(10);

        if(nowTime.isAfter(authCodeTime)) { // 발급 후 10분이상 지남
            throw BaseException.type(AuthErrorCode.AUTH_EXPIRED_AUTHCODE);
        }
    }
}
