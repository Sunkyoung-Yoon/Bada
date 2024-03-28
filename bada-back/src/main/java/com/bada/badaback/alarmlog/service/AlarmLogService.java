package com.bada.badaback.alarmlog.service;

import com.bada.badaback.alarmlog.domain.AlarmLog;
import com.bada.badaback.alarmlog.domain.AlarmRepository;
import com.bada.badaback.alarmlog.dto.AlarmLogRequestDto;
import com.bada.badaback.alarmlog.dto.AlarmLogResponseDto;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.exception.MemberErrorCode;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AlarmLogService {

  private final AlarmRepository alarmRepository;
  private final MemberRepository memberRepository;

  public List<AlarmLogResponseDto> getAllAlarmLogs(Long memberId, Long childId) {
    Optional<Member> member = memberRepository.findById(memberId);
    if (member.isEmpty()) { // 찾는 회원 없다면 에러발생
      throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }
    Optional<Member> child = memberRepository.findById(childId);
    if (child.isEmpty()) { // 찾는 회원 없다면 에러발생
      throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }

    List<AlarmLogResponseDto> alarmLogResponseDtoList = new ArrayList<>();
    List<AlarmLog> alarmLogs = alarmRepository.findAllAlarmLogsByMemberIdAndChildId(memberId, childId);

    for (AlarmLog alarmLog : alarmLogs) {
      AlarmLogResponseDto alarmLogResponseDto = AlarmLogResponseDto.builder()
          .type(alarmLog.getType())
          .memberId(alarmLog.getId())
          .childId(alarmLog.getChildId())
          .build();
      alarmLogResponseDtoList.add(alarmLogResponseDto);
    }

    return alarmLogResponseDtoList;
  }

  @Transactional
  public void writeAlarmLog(AlarmLogRequestDto alarmLogRequestDto) {
    Optional<Member> optMember = memberRepository.findById(alarmLogRequestDto.getMemberId());
    if (optMember.isEmpty()) { // 찾는 회원 없다면 에러발생
       throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }
    AlarmLog alarmLog = AlarmLog.createAlarmLog(alarmLogRequestDto.getType(), optMember.get(), alarmLogRequestDto.getChildId());

    alarmRepository.save(alarmLog);
  }


}
