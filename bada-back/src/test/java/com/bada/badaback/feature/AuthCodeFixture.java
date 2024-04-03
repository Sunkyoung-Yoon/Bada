package com.bada.badaback.feature;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.member.domain.Member;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum AuthCodeFixture {
    AUTHCODE_0("AB1111"),
    AUTHCODE_1("AB2222")
    ;

    private final String code;

    public AuthCode toAuthCode(Member member) {
        return AuthCode.createAuthCode(member, code);
    }
}
