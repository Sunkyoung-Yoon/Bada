package com.bada.badaback.safefacility.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.safefacility.dto.SafeFacilityRequestDto;
import com.bada.badaback.safefacility.dto.SafeFacilityResponseDto;
import com.bada.badaback.safefacility.service.SafeFacilityService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.IOException;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api/path")
public class SafeFacilityController {

    private final SafeFacilityService safeFacilityService;
    private final MemberFindService memberFindService;

    @GetMapping
    public ResponseEntity<SafeFacilityResponseDto> getPath(@ExtractPayload Long memberId, @RequestBody @Valid SafeFacilityRequestDto safeFacilityRequestDto) throws IOException {
        //회원가입되어 있는 멤버인지 확인
        Member member = memberFindService.findById(memberId);
        //에러가 나지 않으면 경로 추천 로직 실행
        SafeFacilityResponseDto safeFacilityResponseDto = safeFacilityService.getCCTVs(safeFacilityRequestDto.startX(),
                safeFacilityRequestDto.startY(), safeFacilityRequestDto.endX(), safeFacilityRequestDto.endY());
        return ResponseEntity.ok(safeFacilityResponseDto);
    }
}
