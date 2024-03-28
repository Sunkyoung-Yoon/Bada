package com.bada.badaback.kafka.service;

import com.bada.badaback.alarm.dto.AlarmLogRequestDto;
import com.bada.badaback.alarm.service.AlarmLogService;
import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.fcm.service.FcmService;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.kafka.exception.AlarmErrorCode;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import java.io.IOException;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class FcmKafkaConsumerService {

  private final FcmService fcmService;
  private final AlarmLogService alarmLogService;
  private final MemberRepository memberRepository;


  private static boolean isOffCourse(String latitude, String longitude){
    return true;
  }

  @KafkaListener(topics = "${spring.kafka.topics.now-topic}", groupId = "foo")
  public void alarmListenAndSend(AlarmDto alarmDto) throws IOException {
    log.info("################## 알림 수신 완료!!! alarmDto toString : {}", alarmDto);

    if ( !isOffCourse(alarmDto.getLatitude(), alarmDto.getLongitude()) ) { // 정상범위 내 존재
      log.info("################## 아이는 정상범위 내에 있습니다. ");
      throw new BaseException(AlarmErrorCode.IS_OK);
    }

    log.info("!!!!!!!!!! 아이 경로 이탈 감지 !!!!!!!!!");
    List<Member> memberList = memberRepository.familyList(alarmDto.getFamilyCode());  // 알림을 보낼 패밀리의 맴버들을 가져오기
    if (memberList.isEmpty()) {
      log.info("##################  조회되는 패밀리 코드가 없습니다."); // 패밀리 코드 없으면 안내려가고 거르기.
      throw new BaseException(FamilyErrorCode.FAMILY_NOT_FOUND);
    }
    log.info("##################  memberList toString : {}", memberList.toString());

//     보호자 핸드폰으로 알림 보내기
    for (Member member : memberList) {
      if (member.getIsParent() != 1) { continue; }
      log.info("##################  member.toString() : {}", member.toString());
      fcmService.sendMessageTo(alarmDto, member);

      AlarmLogRequestDto alarmLogRequestDto = AlarmLogRequestDto.builder()
          .memberId(member.getId())
          .type(alarmDto.getType())
          .build();
      log.info("################## alarmLogRequestDto : {} ", alarmLogRequestDto.toString() );
      // 알림 로그 기록
      alarmLogService.writeAlarmLog(alarmLogRequestDto);

    }

  }


}
