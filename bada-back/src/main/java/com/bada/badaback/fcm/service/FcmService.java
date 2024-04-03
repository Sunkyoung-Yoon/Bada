package com.bada.badaback.fcm.service;


import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.fcm.dto.FcmMessageDto;
import com.bada.badaback.member.domain.Member;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import java.io.IOException;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class FcmService   {
  private final static String FCM_API_URL = "https://fcm.googleapis.com/v1/projects/bada-1c6f7/messages:send";

  public void sendMessageTo(AlarmDto alarmDto, Member member) throws IOException {
    String message = makeMessage(alarmDto, member);
    log.info("################## 작성된 message 내용 출력 : {}", message);
    OkHttpClient client = new OkHttpClient();

    RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
    log.info("################## requestBody.toString() : {}", requestBody.toString());

    Request request = new Request.Builder()
        .url(FCM_API_URL)
        .post(requestBody)
        .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
        .addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
        .build();

    // Response response = client.newCall(request).execute();
    try (Response response = client.newCall(request).execute()) {
      log.info("##################  response.body().string() : {}", response.body().string());
    }

  }

  private String makeMessage(AlarmDto alarmDto, Member member) throws JsonProcessingException {
    ObjectMapper om = new ObjectMapper();
    FcmMessageDto fcmMessageDto = FcmMessageDto.builder()
        .message(FcmMessageDto.Message.builder()
            .token(member.getFcmToken())
            .notification(FcmMessageDto.Notification.builder()
                .title(alarmDto.getType())
                .body(alarmDto.getContent())
                .image(null)
                .build()
            )
            .data(FcmMessageDto.Data.builder()
                .childName(alarmDto.getChildName())
                .phone(alarmDto.getPhone())
                .profileUrl(alarmDto.getProfileUrl())
                .destinationName(alarmDto.getDestinationName())
                .destinationIcon(alarmDto.getDestinationIcon())
                .build()
            )
            .build()).validateOnly(false).build();

    return om.writeValueAsString(fcmMessageDto);
  }

  private String getAccessToken() throws IOException {
    String firebaseConfigPath = "firebase/firebase_service_key.json";

    GoogleCredentials googleCredentials = GoogleCredentials
        .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
        .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

    googleCredentials.refreshIfExpired();
    return googleCredentials.getAccessToken().getTokenValue();
  }

}
