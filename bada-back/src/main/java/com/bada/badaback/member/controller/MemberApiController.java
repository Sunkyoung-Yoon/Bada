package com.bada.badaback.member.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.dto.MemberDetailResponseDto;
import com.bada.badaback.member.service.MemberService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotBlank;
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
                                        @RequestParam(value = "name") @NotBlank(message = "이름은 필수입니다.") String name,
                                        @RequestParam(value = "childId", required = false) String childId,
                                        @RequestParam(value = "file", required = false) MultipartFile multipartFile) {
        memberService.update(memberId, childId, name, multipartFile);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> delete (@ExtractPayload Long memberId) {
        memberService.delete(memberId);
        return ResponseEntity.ok().build();
    }
}
