package com.bada.badaback.alarmlog.service;

import com.bada.badaback.alarmlog.domain.AlarmLog;
import com.bada.badaback.alarmlog.domain.AlarmLogRepository;
import com.bada.badaback.alarmlog.dto.AlarmLogRequestDto;
import com.bada.badaback.alarmlog.dto.AlarmLogResponseDto;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.exception.MemberErrorCode;
import com.bada.badaback.member.service.MemberFindService;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Slf4j
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AlarmLogService {

  private final AlarmLogRepository alarmLogRepository;
  private final MemberRepository memberRepository;
  private final MemberFindService memberFindService;

  @Transactional
  public List<AlarmLogResponseDto> getAlarmLogsByMemberIdAndChildId(Long memberId, Long childId) {
    Optional<Member> member = memberRepository.findById(memberId);
    if (member.isEmpty()) { // 찾는 회원 없다면 에러발생
      throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }
    Optional<Member> child = memberRepository.findById(childId);
    if (child.isEmpty()) { // 찾는 회원 없다면 에러발생
      throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }

    List<AlarmLogResponseDto> alarmLogResponseDtoList = new ArrayList<>();
    List<AlarmLog> alarmLogs = alarmLogRepository.findAllAlarmLogsByMemberIdAndChildId(memberId, childId);

    for (AlarmLog alarmLog : alarmLogs) {
      alarmLog.setRead(true);   // alarmLog isRead 읽음으로 수정

      AlarmLogResponseDto alarmLogResponseDto = AlarmLogResponseDto.builder()
          .type(alarmLog.getType())
          .alarmId(alarmLog.getId())
          .childId(alarmLog.getChildId())
          .createAt(alarmLog.getCreatedAt())
          .isRead(alarmLog.isRead())
          .build();
      alarmLogResponseDtoList.add(alarmLogResponseDto);
    }

    /** 가지고 온경우는 모두 알림 읽음 처리를 진행한다. **/
    alarmLogRepository.saveAllAndFlush(alarmLogs); // alarmLog isRead 전부 update 하는 쿼리 발생
    return alarmLogResponseDtoList;
  }

  @Transactional
  public void writeAlarmLog(AlarmLogRequestDto alarmLogRequestDto) {
    Optional<Member> optMember = memberRepository.findById(alarmLogRequestDto.getMemberId());
    if (optMember.isEmpty()) { // 찾는 회원 없다면 에러발생
       throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }
    AlarmLog alarmLog = AlarmLog.createAlarmLog(alarmLogRequestDto.getType(), optMember.get(), alarmLogRequestDto.getChildId());

    alarmLogRepository.save(alarmLog);
  }

  public Long getUnreadAlarmCount(Long memberId) {
    Member member = memberFindService.findById(memberId);

    Long cnt = alarmLogRepository.getUnreadAlarmCount(member.getId());

    log.info("################## 안읽은 아이 알림 개수 {}", cnt);
    return cnt;
  }

}
