package com.bada.badaback.myplace.controller;

import com.bada.badaback.family.dto.FamilyPlaceListResponseDto;
import com.bada.badaback.family.service.FamilyService;
import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.myplace.dto.MyPlaceListResponseDto;
import com.bada.badaback.myplace.service.MyPlaceListService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "MyPlaceList", description = "MyPlaceListApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/myplace")
public class MyPlaceListApiController {
    private final MyPlaceListService myPlaceListService;
    private final FamilyService familyService;

    @GetMapping
    public ResponseEntity<MyPlaceListResponseDto> myPlaceList(@ExtractPayload Long memberId) {
        FamilyPlaceListResponseDto responseDto = familyService.myPlaceIdList(memberId);
        return ResponseEntity.ok(myPlaceListService.myPlaceList(responseDto.placeList()));
    }
}
