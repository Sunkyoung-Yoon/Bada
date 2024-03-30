package com.bada.badaback.alarmlog.controller;

import com.bada.badaback.alarmlog.dto.AlarmLogResponseDto;
import com.bada.badaback.alarmlog.service.AlarmLogService;
import com.bada.badaback.global.annotation.ExtractPayload;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/alarmLog/list")
@Slf4j
@RequiredArgsConstructor
public class AlarmLogController {

  private final AlarmLogService alarmLogService;

  // 아이 알림 기록 조회
  @GetMapping("/{childId}")  // alarm 이용
  @ResponseBody
  public ResponseEntity<List<AlarmLogResponseDto>> getAlarmLogsByMemberIdAndChildId(@ExtractPayload Long memberId, @PathVariable Long childId) {
    return ResponseEntity.ok().body(alarmLogService.getAlarmLogsByMemberIdAndChildId(memberId, childId));
  }

  // 안읽은 아이 알림 개수 조회



  // 알림 읽음 처리 - 동시에 쿼리가 진행되어야하지않나? - 무조건 동시에 처리되어야한다. 하나의 API요청으로 조회하면서 가져오고 쿼리가 나가야한다.





}
