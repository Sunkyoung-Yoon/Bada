package com.bada.badaback.kafka.repository;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Repository
public class EmitterRepository {
  private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();
  private final Map<String, Object> eventCache = new ConcurrentHashMap<>();

  public SseEmitter save(String emitterId, SseEmitter sseEmitter) {
    emitters.put(emitterId, sseEmitter);
    return sseEmitter;
  }

  public void saveEventCache(String emitterId, Object event) {
    eventCache.put(emitterId,event);
  }

  public Map<String, SseEmitter> findAllEmitters() {
    return new HashMap<>(emitters);
  }

  public void deleteById(String emitterId) {
    emitters.remove(emitterId);
  }





  /** 사용자의 패밀리 코드를 이용한 SseEmitter(서버샌드이벤트발생객체) 검색 **/
  public Map<String, SseEmitter> findAllEmitterStartWithById(String familyCode) {
    return emitters.entrySet().stream()
        .filter(entry -> entry.getKey().startsWith(familyCode))
        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
  }

  public Map<String, Object> findAllEventCacheStartWithById(String familyCode) {
    return eventCache.entrySet().stream()
        .filter(entry -> entry.getKey().startsWith(familyCode))
        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
  }


  /** ############################ 원본코드 ############################ **/
//  private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();
//  private final Map<String, Object> eventCache = new ConcurrentHashMap<>();
//
//  public SseEmitter save(String emitterId, SseEmitter sseEmitter) {
//    emitters.put(emitterId, sseEmitter);
//    return sseEmitter;
//  }
//
//  public void saveEventCache(String emitterId, Object event) {
//    eventCache.put(emitterId,event);
//  }
//
//  public Map<String, SseEmitter> findAllEmitters() {
//    return new HashMap<>(emitters);
//  }
//
//  public Map<String, SseEmitter> findAllEmitterStartWithById(String memberId) {
//    return emitters.entrySet().stream()
//        .filter(entry -> entry.getKey().startsWith(memberId))
//        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
//  }
//
//  public Map<String, Object> findAllEventCacheStartWithById(String memberId) {
//    return eventCache.entrySet().stream()
//        .filter(entry -> entry.getKey().startsWith(memberId))
//        .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
//  }
//
//  public void deleteById(String emitterId) {
//    emitters.remove(emitterId);
//  }


}
