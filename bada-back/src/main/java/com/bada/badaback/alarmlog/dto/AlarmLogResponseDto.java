package com.bada.badaback.alarmlog.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@Builder
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class AlarmLogResponseDto {
  private String type;
  private Long memberId;
  private Long childId;
  private Long isRead;
  private LocalDateTime createAt;
}
