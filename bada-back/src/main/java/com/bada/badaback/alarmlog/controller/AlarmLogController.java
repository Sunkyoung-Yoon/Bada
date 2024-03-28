package com.bada.badaback.alarmlog.controller;

import com.bada.badaback.alarmlog.dto.AlarmLogResponseDto;
import com.bada.badaback.alarmlog.service.AlarmLogService;
import com.bada.badaback.global.annotation.ExtractPayload;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/alarmLog")
@Slf4j
@RequiredArgsConstructor
public class AlarmLogController {

  private final AlarmLogService alarmLogService;

  @GetMapping  // alarm 이용
  @ResponseBody
  public ResponseEntity<List<AlarmLogResponseDto>> sendAlarm(@ExtractPayload Long memberId, @ExtractPayload Long childId) {
    return ResponseEntity.ok().body(alarmLogService.getAllAlarmLogs(memberId, childId));
  }

}
