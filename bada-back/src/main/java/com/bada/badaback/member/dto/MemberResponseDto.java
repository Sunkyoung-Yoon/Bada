package com.bada.badaback.member.dto;

import com.bada.badaback.member.domain.Member;
import lombok.Builder;

@Builder
public record MemberResponseDto(
        Long memberId,
        String name,
        String phone,
        int isParent,
        String profileUrl,
        String familyCode,
        int movingState,
        String fcmToken
) {
    public static MemberResponseDto from(Member findMember) {
        return MemberResponseDto.builder()
                .memberId(findMember.getId())
                .name(findMember.getName())
                .isParent(findMember.getIsParent())
                .phone(findMember.getPhone())
                .profileUrl(findMember.getProfileUrl())
                .familyCode(findMember.getFamilyCode())
                .movingState(findMember.getMovingState())
                .fcmToken(findMember.getFcmToken())
                .build();
    }
}
