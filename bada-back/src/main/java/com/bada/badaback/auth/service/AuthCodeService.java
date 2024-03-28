package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.auth.domain.AuthCodeRepository;
import com.bada.badaback.auth.dto.AuthCodeResponseDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Random;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthCodeService {
    private final MemberFindService memberFindService;
    private final AuthCodeRepository authCodeRepository;
    private final AuthCodeFindService authCodeFindService;

    @Transactional
    public Long issueCode(Long memberId){
        Member findMember = memberFindService.findById(memberId);

        // 인증 코드 발급
        String code = createRandomCode();

        AuthCode authCode;
        if(authCodeRepository.existsByMemberId(memberId)){
            authCode = authCodeFindService.findByMemberId(memberId);
            authCode.updateAuthCode(code);
        }
        else{
            authCode = AuthCode.createAuthCode(findMember, code);
        }

        return authCodeRepository.save(authCode).getId();
    }

    @Transactional
    public AuthCodeResponseDto readCode(Long memberId) {
        Member findMember = memberFindService.findById(memberId);
        AuthCode findAuthCode = authCodeFindService.findByMemberId(findMember.getId());

        return AuthCodeResponseDto.from(findAuthCode);
    }

    @Transactional
    public void delete(Long memberId) {
        Member findMember = memberFindService.findById(memberId);
        AuthCode findAuthCode = authCodeFindService.findByMemberId(findMember.getId());

        authCodeRepository.delete(findAuthCode);
    }

    private String createRandomCode() {
        int certCharLength = 5;
        final char[] characterTable = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };

        Random random = new Random(System.currentTimeMillis());
        int tablelength = characterTable.length;
        StringBuffer buf = new StringBuffer();

        for(int i = 0; i < certCharLength; i++) {
            buf.append(characterTable[random.nextInt(tablelength)]);
        }
        return buf.toString();
    }
}

