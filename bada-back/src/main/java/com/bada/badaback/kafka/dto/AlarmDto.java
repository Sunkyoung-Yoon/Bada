package com.bada.badaback.kafka.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


// 임시 알람 DTO
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class AlarmDto {

  private String type;    // 알람 종류 : enum으로 생성하기
  private Long memberId;  //
  private String familyCode;
  private String content;

  private String latitude;
  private String longitude;

}
