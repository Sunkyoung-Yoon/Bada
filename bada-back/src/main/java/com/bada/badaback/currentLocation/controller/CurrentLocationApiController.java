package com.bada.badaback.currentLocation.controller;

import com.bada.badaback.currentLocation.dto.CurrentLocationRequestDto;
import com.bada.badaback.currentLocation.dto.CurrentLocationResponseDto;
import com.bada.badaback.currentLocation.service.CurrentLocationService;
import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.service.MemberService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "최근 위치", description = "CurrentLocationApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/currentLocation")
public class CurrentLocationApiController {
    private final CurrentLocationService currentLocationService;
    private final MemberService memberService;

    @PostMapping
    public ResponseEntity<Void> create(@ExtractPayload Long memberId, @RequestBody @Valid CurrentLocationRequestDto requestDto) {
        currentLocationService.create(memberId, requestDto.currentLatitude(), requestDto.currentLongitude());
        memberService.updateMovingState(memberId);
        return ResponseEntity.ok().build();
    }

    @PatchMapping
    public ResponseEntity<Void> update(@ExtractPayload Long memberId, @RequestBody @Valid CurrentLocationRequestDto requestDto) {
        currentLocationService.update(memberId, requestDto.currentLatitude(), requestDto.currentLongitude());
        return ResponseEntity.ok().build();
    }

    @DeleteMapping
    public ResponseEntity<Void> delete(@ExtractPayload Long memberId) {
        currentLocationService.delete(memberId);
        memberService.updateMovingState(memberId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{childId}")
    public ResponseEntity<CurrentLocationResponseDto> readCurrentLocation(@ExtractPayload Long memberId, @PathVariable("childId") Long childId) {
        return ResponseEntity.ok(currentLocationService.read(memberId, childId));
    }
}
