package com.bada.badaback.fcm.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FcmMessageDto {
  private boolean validateOnly;
  private FcmMessageDto.Message message;

  @Builder
  @AllArgsConstructor
  @Getter
  public static class Message {
    private FcmMessageDto.Notification notification;
    private String token;
    private FcmMessageDto.Data data;
  }

  @Builder
  @AllArgsConstructor
  @Getter
  public static class Notification {
    private String title;
    private String body;
    private String image;
  }

  @Builder
  @AllArgsConstructor
  @Getter
  public static class Data {
    private String childName;
    private String phone;
    private String profileUrl;
    private String destinationName;
    private String destinationIcon;
  }
}