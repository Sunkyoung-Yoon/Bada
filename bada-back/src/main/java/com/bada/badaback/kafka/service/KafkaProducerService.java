package com.bada.badaback.kafka.service;

import com.bada.badaback.alarmtrigger.AlarmTriggerService;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.service.MyPlaceFindService;
import java.time.LocalDateTime;
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
  private final MyPlaceFindService myPlaceFindService;

  @Autowired
  private final KafkaTemplate<String, AlarmDto> kafkaTemplate;

  public String sendAlarm(AlarmDto alarmDto) {
    log.info("====================================== 아이 알림 요청. alarmDto.toString {}", alarmDto.toString());
    log.info("====================================== 아이 알림 생성 시각 {}", LocalDateTime.now());

    /** 출발과 도착 감지 **/
    if (alarmDto.getType().equals("DEPART")) {
      Member member = memberFindService.findById(alarmDto.getMemberId());
      MyPlace myPlace = myPlaceFindService.findById(alarmDto.getMyPlaceId());

      alarmDto.setContent(member.getName() + "님이 " + alarmDto.getDestinationName() + "로 출발했습니다.");
      alarmDto.setChildName(member.getName());

      String phoneString = alarmDto.getPhone() == null ? "" : alarmDto.getPhone();
      alarmDto.setPhone(phoneString);
      String profileUrlString = alarmDto.getProfileUrl() == null ? "" : alarmDto.getProfileUrl();
      alarmDto.setProfileUrl(profileUrlString);

      alarmDto.setDestinationName(myPlace.getPlaceName());
      alarmDto.setDestinationIcon(myPlace.getIcon());

      kafkaTemplate.send(topic, alarmDto);
      return "아이 목적지로 출발  : send alarm";

    } else if (alarmDto.getType().equals("ARRIVE")) {
      Member member = memberFindService.findById(alarmDto.getMemberId());
      MyPlace myPlace = myPlaceFindService.findById(alarmDto.getMyPlaceId());

      alarmDto.setContent(member.getName() + "님이 " + alarmDto.getDestinationName() + "에 도착하였습니다.");
      alarmDto.setChildName(member.getName());

      String phoneString = alarmDto.getPhone() == null ? "" : alarmDto.getPhone();
      alarmDto.setPhone(phoneString);
      String profileUrlString = alarmDto.getProfileUrl() == null ? "" : alarmDto.getProfileUrl();
      alarmDto.setProfileUrl(profileUrlString);

      alarmDto.setDestinationName(myPlace.getPlaceName());
      alarmDto.setDestinationIcon(myPlace.getIcon());

      kafkaTemplate.send(topic, alarmDto);
      return "아이 목적지에 도착 : send alarm";

    } else if (alarmDto.getType().equals("TOO FAST")) {
      Member member = memberFindService.findById(alarmDto.getMemberId());
      MyPlace myPlace = myPlaceFindService.findById(alarmDto.getMyPlaceId());

      alarmDto.setContent(member.getName() + "님에게서 비정상적인 속도가 감지되었습니다. 아이 확인이 필요합니다.");
      alarmDto.setChildName(member.getName());
      alarmDto.setPhone(member.getPhone());
      alarmDto.setProfileUrl(member.getProfileUrl());
      alarmDto.setDestinationName(myPlace.getPlaceName());
      alarmDto.setDestinationIcon(myPlace.getIcon());

      kafkaTemplate.send(topic, alarmDto);
      return "아이 비정상속도 감지 : send alarm";

    } else if (alarmDto.getType().equals("STAY")) {
      Member member = memberFindService.findById(alarmDto.getMemberId());
      MyPlace myPlace = myPlaceFindService.findById(alarmDto.getMyPlaceId());

      alarmDto.setContent(member.getName() + "님이 현재 5분이상 정지해있습니다. 아이 확인이 필요합니다.");
      alarmDto.setChildName(member.getName());
      alarmDto.setPhone(member.getPhone());
      alarmDto.setProfileUrl(member.getProfileUrl());
      alarmDto.setDestinationName(myPlace.getPlaceName());
      alarmDto.setDestinationIcon(myPlace.getIcon());

      kafkaTemplate.send(topic, alarmDto);
      return "아이 정지상태 감지 : send alarm";
    }

    /**
     * 범위 이탈 감지 로직
     * 현재 알림트리거 서비스 : 겅로 이탈여부 : 작동 불가 데이터베이스 데이터 없음 주석 수정 필요
     *  **/
    if (
        !alarmTriggerService.inPath(
            alarmDto.getMemberId(),
            Double.parseDouble(alarmDto.getLatitude()),
            Double.parseDouble(alarmDto.getLongitude())
        )
//        true
    ) {
      log.info("!!!!!!!!!! 아이 경로 이탈 감지 !!!!!!!!!");

      Member member = memberFindService.findById(alarmDto.getMemberId());
      MyPlace myPlace = myPlaceFindService.findById(alarmDto.getMyPlaceId());

      alarmDto.setType("OFF COURSE");
      alarmDto.setContent(member.getName() + "님이 경로를 이탈하였습니다!");
      alarmDto.setChildName(member.getName());

      String phoneString = alarmDto.getPhone() == null ? "" : alarmDto.getPhone();
      alarmDto.setPhone(phoneString);
      String profileUrlString = alarmDto.getProfileUrl() == null ? "" : alarmDto.getProfileUrl();
      alarmDto.setProfileUrl(profileUrlString);

      alarmDto.setDestinationName(myPlace.getPlaceName());
      alarmDto.setDestinationIcon(myPlace.getIcon());

      kafkaTemplate.send(topic, alarmDto);  // topic에 해당하는 이름 없으면 자동 생성됨
      log.info("====================================== DB 조회후 알림 토픽으로 메세지 전송 시각 {}", LocalDateTime.now());
      return "child is OFF_COURSE : send alarm";
    } else {
      return "child is ON_COURSE : not send alarm";
    }

  }
}