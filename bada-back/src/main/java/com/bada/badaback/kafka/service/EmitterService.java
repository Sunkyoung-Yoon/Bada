package com.bada.badaback.kafka.service;

import static com.bada.badaback.kafka.controller.AlarmConnectController.DEFAULT_TIMEOUT;

import com.bada.badaback.alarmlog.service.AlarmLogService;
import com.bada.badaback.kafka.repository.EmitterRepository;
import java.io.IOException;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
@Slf4j
@RequiredArgsConstructor
public class EmitterService {   // ConsumerService를 대체할 SERVICE 단..

  // 알림 로그 남길 AlarService 작성하고 적용시키기
  private final AlarmLogService alarmLogService; // 알림 서비스 사용 DB 테이블 저장을 위한 service 사용
  private final EmitterRepository emitterRepository;          // 알림 저장 레포지토리

//  @KafkaListener(topics = "${spring.kafka.topics.alarm-topic}", groupId = "foo")
//  public void alarmListen(AlarmDto alarmDto) {
//    log.info("################## Consumed AlarmDto : {}", alarmDto.toString());
//
//    String memberId = alarmDto.getMemberId();
////    // 이탈알림 전용 DTO 만들기
////    AlarmDtos alarmDtos = AlarmDtos.builder()
////        .userIdNo(Long.valueOf(memberId))
////        .message(alarmDto.getContent())
////        .type("이탈알림").build();
//
//    alarmLogService.writeAlarmLog(alarmDto);
//
////    int curCnt = notificationsService.countNotificationsByUserId(Long.valueOf(memberId));
////    if (curCnt > MAX_NOTIFICATIONS_COUNT) {
////      int delCount = curCnt - MAX_NOTIFICATIONS_COUNT;
////      notificationsService.deleteOldestNotificationsByUserId(Long.valueOf(memberId), delCount);
////    }
//
//
//    Map<String, SseEmitter> sseEmitters = emitterRepository.findAllEmitterStartWithById(memberId);
//    sseEmitters.forEach(
//        (key, emitter) -> {
//          emitterRepository.saveEventCache(key, alarmDto);
//          sendToClient(emitter, key, alarmDto);            // 클라이언트에게 알림 전송
//        }
//    );
//
//  }


  private void sendToClient(SseEmitter emitter, String emitterId, Object data) {
    try {
      emitter.send(SseEmitter.event()
          .id(emitterId)
          .data(data));
      log.info("Kafka로 부터 전달 받은 메세지 전송. emitterId : {}, message : {}", emitterId, data);
    } catch (IOException e) {
      emitterRepository.deleteById(emitterId);
      log.error("메시지 전송 에러 : {}", e);
    }
  }


  public SseEmitter addEmitter(String memberId, String lastEventId) {
    String emitterId = memberId + "_" + System.currentTimeMillis();
    SseEmitter emitter = emitterRepository.save(emitterId, new SseEmitter(DEFAULT_TIMEOUT));
    log.info("emitterId : {} 사용자 emitter 연결 ", emitterId);

    emitter.onCompletion(() -> {
      log.info("onCompletion callback");
      emitterRepository.deleteById(emitterId);
    });
    emitter.onTimeout(() -> {
      log.info("onTimeout callback");
      emitterRepository.deleteById(emitterId);
    });

    sendToClient(emitter, emitterId, "connected!"); // 503 에러방지 더미 데이터

    if (!lastEventId.isEmpty()) {
      Map<String, Object> events = emitterRepository.findAllEventCacheStartWithById(memberId);
      events.entrySet().stream()
          .filter(entry -> lastEventId.compareTo(entry.getKey()) < 0)
          .forEach(entry -> sendToClient(emitter, entry.getKey(), entry.getValue()));
    }
    return emitter;
  }

//  @Scheduled(fixedRate = 180000) // 3분마다 heartbeat 메세지 전달.
//  public void sendHeartbeat() {
//    Map<String, SseEmitter> sseEmitters = emitterRepository.findAllEmitters();
//    sseEmitters.forEach((key, emitter) -> {
//      try {
//        emitter.send(SseEmitter.event().id(key).name("heartbeat").data(""));
//        log.info("하트비트 메세지 전송");
//      } catch (IOException e) {
//        emitterRepository.deleteById(key);
//        log.error("하트비트 전송 실패: {}", e.getMessage());
//      }
//    });
//  }
//  위 메서드에 붙은 @Scheduled 어노테이션을 사용하기 위해서는 애플리케이션 클래스에 아래처럼 @EnableScheduling 어노테이션을 붙여줘야한다.


}
