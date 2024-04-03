package com.bada.badaback.kafka.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class AlarmDto {
  private String type;              // 알림 타입

  private Long memberId;            // 전달되는 항목
  private String familyCode;
  private Long myPlaceId;
  private String latitude;
  private String longitude;

  private String content;
  private String childName;
  private String phone;
  private String profileUrl;
  private String destinationName;   // 변경되는 항목
  private String destinationIcon;

}
