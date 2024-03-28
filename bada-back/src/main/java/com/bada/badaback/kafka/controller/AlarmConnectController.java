package com.bada.badaback.kafka.controller;


import com.bada.badaback.alarmlog.service.AlarmLogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
public class AlarmConnectController {

  private final AlarmLogService alarmLogService;
  public static final Long DEFAULT_TIMEOUT = 3600L * 1000;


}