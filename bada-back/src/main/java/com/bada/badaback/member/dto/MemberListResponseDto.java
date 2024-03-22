package com.bada.badaback.member.dto;

import java.util.List;

public record MemberListResponseDto(
        List<MemberResponseDto> familyList
) {
}
