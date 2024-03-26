package com.bada.badaback.feature;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.SocialType;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum MemberFixture {
    SUNKYOUNG("윤선경", "010-1111-1111","aaa@naver.com", SocialType.NAVER, 1,null, "AB1111", "fcmToken"),
    JIYEON("심지연", "010-2222-2222","bbb@naver.com", SocialType.KAKAO, 1,null, "AB1111", "fcmToken"),
    YONGJUN("이용준", "010-3333-3333","ccc@naver.com", SocialType.KAKAO, 0,null, "AB1111", "fcmToken"),
    HWIWON("정휘원", "010-4444-4444", "ddd@naver.com", SocialType.NAVER, 1, null, "AB2222", "fcmToken"),
    CHANGHEON("이창헌", "010-5555-5555", "eee@naver.com", SocialType.NAVER, 0, null, "AB2222", "fcmToken")
    ;

    private final String name;
    private final String phone;
    private final String email;
    private final SocialType social;
    private final int isParent;
    private final String profileUrl;
    private final String familyCode;
    private final String fcmToken;


    public Member toMember() {
        return Member.createMember(name, phone, email, social, isParent, profileUrl, familyCode, fcmToken);
    }
}
