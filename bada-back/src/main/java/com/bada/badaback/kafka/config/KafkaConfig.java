package com.bada.badaback.kafka.config;

import com.bada.badaback.kafka.dto.AlarmDto;
import java.util.HashMap;
import java.util.Map;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonDeserializer;
import org.springframework.kafka.support.serializer.JsonSerializer;

@EnableKafka
@Configuration
public class KafkaConfig {
  @Value(value = "${spring.kafka.bootstrapAddress}")
  private String bootstrapAddress;

  // 원하는 모양의 kafka 템플릿을 만들기 위해서는 카프카 템플릿의 형태를 맞춰주어야한다.
  // 이번 프로젝트에서 알람을 json 객체 형식으로 전달해주기 위해서 <string, jsonDTO> 형식으로 만들어 보내주려고한다.

  @Bean
  public KafkaTemplate<String, AlarmDto> kafkaTemplate() {
    return new KafkaTemplate<>(producerFactory());
  }


  /** ############################ 카프카 PRODUCER 설정 ############################ **/
  @Bean
  public ProducerFactory<String, AlarmDto> producerFactory() {
    Map<String,Object> producerConfig = new HashMap<>();
    producerConfig.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapAddress);
    producerConfig.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
    producerConfig.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
    return new DefaultKafkaProducerFactory<>(producerConfig);
  }

  //  JsonDeserializer<AlarmDto> deserializer 와 deserializer.addTrustedPackages("com.bada.badaback.kafka");
  //  JsonDeserializer를 사용해 메세지 Value값 AlarmDto 객체로 변환하고, 해당 패키지에 속하는 클래스를 안전하게 역질렬화 할 수 있도록 허용하였다.
  //  이 addTrustedPackages로 실회할수있는 패키지를 추가하지 않으면 "신뢰할 수 없는 패키지.. 에러가 발생한다.


  /** ############################ 카프카 CONSUMER 설정 ############################ **/
  @Bean
  public ConsumerFactory<String, AlarmDto> consumerFactory() {
    Map<String, Object> consumerConfig = new HashMap<>();
    consumerConfig.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapAddress);
    consumerConfig.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);

    JsonDeserializer<AlarmDto> deserializer = new JsonDeserializer<>(AlarmDto.class);
    /// JSON 객체 역직렬화를 위해서는 JSON 객체를 생성하고 소비하는 producer, consumer와 만들어질 DTO가 같은 패키지 아래에 존재해야한다
    /// 객체를 역직렬화 할 수 있는 신뢰할 수 있는 패키기 설정 필수.
    deserializer.addTrustedPackages("com.bada.badaback.kafka");
    return new DefaultKafkaConsumerFactory<>(consumerConfig,
        new StringDeserializer(),
        deserializer);
  }

  @Bean
  public ConcurrentKafkaListenerContainerFactory<String, AlarmDto> kafkaListenerContainerFactory() {
    ConcurrentKafkaListenerContainerFactory<String, AlarmDto> kafkaFactory = new ConcurrentKafkaListenerContainerFactory<>();
    kafkaFactory.setConsumerFactory(consumerFactory());
    return kafkaFactory;
  }


  /**
   * application.yml 에서 설정할 수 있는 내용들 아직 적용안됨
   * broker 를 두개만 설정하였으므로 최소 Replication Factor로 2를 설정하고
   * Partition의 경우 Event 의 Consumer인 WAS를 2대까지만 실행되도록 해두었기 때문에 2로 설정함.
   * 이보다 Partition을 크게 설정한다고 해서 Consume 속도가 빨라지지 않기 때문이다.
   * @return
   */









}
