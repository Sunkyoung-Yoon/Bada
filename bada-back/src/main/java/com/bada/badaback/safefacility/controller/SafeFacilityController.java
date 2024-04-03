package com.bada.badaback.safefacility.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.dto.SafeFacilityRequestDto;
import com.bada.badaback.safefacility.dto.SafeFacilityTestResponseDto;
import com.bada.badaback.safefacility.service.SafeFacilityService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/pass")
public class SafeFacilityController {
    private final SafeFacilityService safeFacilityService;
    private final MemberFindService memberFindService;

    @PostMapping("/{layer}")
    public ResponseEntity<SafeFacilityTestResponseDto> getPassList(@ExtractPayload Long memberId, @PathVariable("layer") int layerDepth, @RequestBody @Valid SafeFacilityRequestDto safeFacilityRequestDto) throws IOException {
        memberFindService.findById(memberId);
        String passList = safeFacilityService.getCCTVs(layerDepth, safeFacilityRequestDto.startX(), safeFacilityRequestDto.startY(), safeFacilityRequestDto.endX(), safeFacilityRequestDto.endY());
        Point start = new Point(Double.parseDouble((safeFacilityRequestDto.startY())), Double.parseDouble(safeFacilityRequestDto.startX()));
        Point end = new Point(Double.parseDouble(safeFacilityRequestDto.endY()),Double.parseDouble(safeFacilityRequestDto.endX()));
        SafeFacilityTestResponseDto responseDto = SafeFacilityTestResponseDto.from(start,end,passList);
        return ResponseEntity.ok(responseDto);
    }
}
