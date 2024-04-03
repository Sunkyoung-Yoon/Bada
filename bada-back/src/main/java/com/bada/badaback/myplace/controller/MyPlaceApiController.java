package com.bada.badaback.myplace.controller;

import com.bada.badaback.family.service.FamilyService;
import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.myplace.dto.MyPlaceDetailResponseDto;
import com.bada.badaback.myplace.dto.MyPlaceRequestDto;
import com.bada.badaback.myplace.dto.MyPlaceUpdateRequestDto;
import com.bada.badaback.myplace.service.MyPlaceService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "MyPlace", description = "MyPlaceApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/myplace")
public class MyPlaceApiController {
    private final MyPlaceService myPlaceService;
    private final FamilyService familyService;

    @PostMapping
    public ResponseEntity<Void> create(@ExtractPayload Long memberId, @RequestBody @Valid MyPlaceRequestDto requestDto) {
        Long myPlaceId = myPlaceService.create(memberId, requestDto.placeName(), requestDto.placeLatitude(), requestDto.placeLongitude(), requestDto.placeCategoryCode(),
                requestDto.placeCategoryName() ,requestDto.placePhoneNumber(), requestDto.icon(), requestDto.addressName(), requestDto.addressRoadName(), requestDto.placeCode());
        familyService.updateAdd(memberId, myPlaceId);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{myPlaceId}")
    public ResponseEntity<Void> update (@ExtractPayload Long memberId, @PathVariable("myPlaceId") Long myPlaceId, @RequestBody MyPlaceUpdateRequestDto requestDto) {
        myPlaceService.update(memberId, myPlaceId, requestDto.placeName(), requestDto.icon());
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{myPlaceId}")
    public ResponseEntity<Void> delete (@ExtractPayload Long memberId, @PathVariable("myPlaceId") Long myPlaceId) {
        myPlaceService.delete(memberId, myPlaceId);
        familyService.updateRemove(memberId, myPlaceId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{myPlaceId}")
    public ResponseEntity<MyPlaceDetailResponseDto> readMyPlace(@ExtractPayload Long memberId, @PathVariable("myPlaceId") Long myPlaceId) {
        return ResponseEntity.ok(myPlaceService.read(memberId, myPlaceId));
    }

}
