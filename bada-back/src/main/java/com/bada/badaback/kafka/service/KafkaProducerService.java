package com.bada.badaback.kafka.service;

import com.bada.badaback.kafka.dto.AlarmDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class KafkaProducerService {
  @Value(value = "${spring.kafka.topics.now-topic}")
  private String topic;   // 전달되는 토픽의 이름

  @Autowired
  private final KafkaTemplate<String, AlarmDto> kafkaTemplate;

  public void sendAlarm(AlarmDto alarmDto) {
    log.info("################## 아이 알림 발생. alarmDto.toString {}", alarmDto.toString());
    // 좌표를 읽으면 이 부분을 가지고 좌표에대해서 검사를 하는 로직이 필요하다.
    // 최우선 - 좌표의 이탈 여부 검사 로직
    /**
     * 범위 이탈 로직 부분 후보 1.
     * **/
//    kafkaTemplate.send(alarmTopic, alarmDto);  // alarm : topic에 해당하는 이름 없으면 자동 생성됨
    kafkaTemplate.send(topic, alarmDto);  // topic에 해당하는 이름 없으면 자동 생성됨
  }
}