package com.bada.badaback.kafka.service;

import com.bada.badaback.alarmlog.dto.AlarmLogRequestDto;
import com.bada.badaback.alarmlog.service.AlarmLogService;
import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.fcm.service.FcmService;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.kafka.exception.AlarmErrorCode;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import java.io.IOException;
import java.time.LocalDateTime;
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

  @KafkaListener(topics = "${spring.kafka.topics.now-topic}", groupId = "foo")
  public void alarmListenAndSend(AlarmDto alarmDto) throws IOException {
    log.info("====================================== 알림 수신 완료!!! alarmDto toString : {}", alarmDto);

    log.info("====================================== 부모 리스트 조회 전 시각 {}", LocalDateTime.now());
    List<Member> memberList = memberRepository.familyList(alarmDto.getFamilyCode());  // 알림을 보낼 패밀리의 맴버들을 가져오기
    if (memberList.isEmpty()) {
      log.info("##################  조회되는 패밀리 코드가 없습니다."); // 패밀리 코드 없으면 안내려가고 거르기.
      throw new BaseException(FamilyErrorCode.FAMILY_NOT_FOUND);
    }
    log.info("##################  memberList toString : {}", memberList.toString());
    log.info("====================================== 부모 리스트 조회 후 시각  {}", LocalDateTime.now());

//     보호자 핸드폰으로 알림 보내기
    for (Member member : memberList) {
      if (member.getIsParent() != 1) { continue; }
      log.info("====================================== member.toString() : {}", member.getName());
      log.info("====================================== 알림 보내기 이전 시각 {}", LocalDateTime.now());
      fcmService.sendMessageTo(alarmDto, member);
      log.info("====================================== 알림 보낸 이후 시각 {}",  LocalDateTime.now());
      // 알림 로그 기록 /** 알림 전송 확인까지 보류 */
      AlarmLogRequestDto alarmLogRequestDto = AlarmLogRequestDto.builder()
          .memberId(member.getId())
          .type(alarmDto.getType())
          .childId(alarmDto.getMemberId())  // alarmDTO의 memberId는 전송받은 childID
          .build();
      log.info("################## alarmLogRequestDto : {} ", alarmLogRequestDto.toString() );
      alarmLogService.writeAlarmLog(alarmLogRequestDto);

    }
  }
}
