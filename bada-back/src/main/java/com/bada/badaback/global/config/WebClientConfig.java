package com.bada.badaback.global.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.ExchangeFilterFunction;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Configuration
@Slf4j
public class WebClientConfig {
    @Bean
    public WebClient webClient(){
        return WebClient.builder()
                .filter(
                        ExchangeFilterFunction.ofRequestProcessor(
                                clientRequest -> {
                                    log.info(">>>>>>>>> REQUEST <<<<<<<<<<");
                                    log.info("Request: {} {}", clientRequest.method(), clientRequest.url());
                                    return Mono.just(clientRequest);
                                }
                        )
                )
                //Response Header 로깅 필터
                .filter(
                        ExchangeFilterFunction.ofResponseProcessor(
                                clientResponse -> {
                                    log.info(">>>>>>>>>> RESPONSE <<<<<<<<<<");
                                    clientResponse.headers().asHttpHeaders().forEach(
                                            (name, values) -> values.forEach(value -> log.info("{} {}", name, value))
                                    );
                                    return Mono.just(clientResponse);
                                }
                        )
                )
                .build();
    }
}
