package com.bada.badaback.kafka.service;

import com.bada.badaback.alarmtrigger.AlarmTriggerService;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
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

  private final AlarmTriggerService alarmTriggerService;
  private final MemberFindService memberFindService;

  @Autowired
  private final KafkaTemplate<String, AlarmDto> kafkaTemplate;

  public String sendAlarm(AlarmDto alarmDto) {
    log.info("################## 아이 알림 발생. alarmDto.toString {}", alarmDto.toString());

    /**
     * 범위 이탈 로직 부분
     * 현재 알림트리거 서비스 : 겅로 이탈여부 : 작동 불가 데이터베이스 데이터 없음 주석 수정 필요
     *  **/
    if (
//        !alarmTriggerService.inPath(
//            alarmDto.getMemberId(),
//            Double.parseDouble(alarmDto.getLatitude()),
//            Double.parseDouble(alarmDto.getLongitude())
//        )
        true
    ) {
      log.info("!!!!!!!!!! 아이 경로 이탈 감지 !!!!!!!!!");

      Member member = memberFindService.findById(alarmDto.getMemberId());
      alarmDto.setType("OFF COURSE");
      alarmDto.setContent(member.getName() + "(이)가 경로를 이탈하였습니다!");

      kafkaTemplate.send(topic, alarmDto);  // topic에 해당하는 이름 없으면 자동 생성됨
      return "child is OFF_COURSE : send alarm";
    } else {
      return "child is ON_COURSE : not send alarm";
    }

  }
}