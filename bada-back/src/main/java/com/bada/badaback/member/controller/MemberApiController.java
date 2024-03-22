package com.bada.badaback.member.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.dto.MemberDetailResponseDto;
import com.bada.badaback.member.dto.MemberUpdateRequestDto;
import com.bada.badaback.member.service.MemberService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Tag(name = "Member", description = "MemberApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/members")
public class MemberApiController {
    private final MemberService memberService;

    @GetMapping
    public ResponseEntity<MemberDetailResponseDto> readMember (@ExtractPayload Long memberId) {
        return ResponseEntity.ok(memberService.read(memberId));
    }

    @PatchMapping
    public ResponseEntity<Void> update (@ExtractPayload Long memberId,
                                       @RequestPart(value = "request") MemberUpdateRequestDto requestDto,
                                       @RequestPart(value = "file", required = false) MultipartFile multipartFile) {
        memberService.update(memberId, requestDto.name(), multipartFile);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> delete (@ExtractPayload Long memberId) {
        memberService.delete(memberId);
        return ResponseEntity.ok().build();
    }
}
