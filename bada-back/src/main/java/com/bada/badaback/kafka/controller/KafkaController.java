package com.bada.badaback.kafka.controller;

import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.kafka.service.KafkaProducerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/kafka")
@Slf4j
@RequiredArgsConstructor
public class KafkaController {

  private final KafkaProducerService kafkaProducerService;

  @PostMapping("/alarm")  // alarm 이용
  @ResponseBody
  public String sendAlarm(@RequestBody AlarmDto alarmDto) {
    log.info("################## send alarm - AlarmDto : {}", alarmDto.toString());

    kafkaProducerService.sendAlarm(alarmDto);
    return "success";
  }
}
