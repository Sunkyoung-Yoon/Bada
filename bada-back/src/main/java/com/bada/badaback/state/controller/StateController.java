package com.bada.badaback.state.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.state.dto.StateNowRequestDto;
import com.bada.badaback.state.dto.StateRequestDto;
import com.bada.badaback.state.dto.StateResponseDto;
import com.bada.badaback.state.service.StateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api/state")
public class StateController{
    private final StateService stateService;

    /**
     * 아이가 자신의 현재 상태를 만든다.
     * @param memberId
     * @param stateRequestDto
     * @return
     */
    @PostMapping
    public ResponseEntity<Void> createState(@ExtractPayload Long memberId, @RequestBody StateRequestDto stateRequestDto){
        stateService.createState(stateRequestDto.startLat(), stateRequestDto.startLong(), stateRequestDto.endLat(), stateRequestDto.endLong(),
                stateRequestDto.nowLat(), stateRequestDto.nowLong(), memberId);
        return ResponseEntity.ok().build();
    }

    /**
     * 부모의 멤버id를 받아서 현재 사용자와 아이의 멤버id가 같은 가족이라면 값을 보낸다.
     * @param memberId
     * @return
     */
    @GetMapping("/{childId}")
    public ResponseEntity<StateResponseDto> findState(@ExtractPayload Long memberId, @PathVariable(name = "childId") Long childId){
        StateResponseDto stateResponseDto = stateService.findStateByMemberId(memberId, childId);
        return ResponseEntity.ok(stateResponseDto);
    }


    /**
     * 아이가 자신의 현재 위치를 업데이트 한다.
     * @param memberId
     * @param stateNowRequestDto
     * @return
     */
    @PatchMapping
    public ResponseEntity<Void> modifyState(@ExtractPayload Long memberId, @RequestBody StateNowRequestDto stateNowRequestDto){
        stateService.modifyState(memberId,stateNowRequestDto.nowLat(),stateNowRequestDto.nowLong());
        return ResponseEntity.ok().build();
    }

    /**
     * 아이가 도착을 누르면 아이의 상태 정보를 삭제된다.
     * @param memberId
     * @return
     */
    @DeleteMapping
    public ResponseEntity<Void> deleteState(@ExtractPayload Long memberId){
        stateService.deleteState(memberId);
        return ResponseEntity.ok().build();
    }

}
