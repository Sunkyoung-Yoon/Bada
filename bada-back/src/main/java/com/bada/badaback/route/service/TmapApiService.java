package com.bada.badaback.route.service;

import com.bada.badaback.route.dto.TmapRequestDto;
import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.service.SafeFacilityService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class TmapApiService {
    @Value("${TMAP_APPKEY}")
    private String appKey;

    private final WebClient webClient;
    private final SafeFacilityService safeFacilityService;

    public List<Point> getPoint(String startLat, String startLng, String endLat, String endLng) throws IOException {

        //passList 얻어오기
        String getPassList = safeFacilityService.getCCTVs(startLng, startLat, endLng, endLat);

        String baseUrl = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result";

        TmapRequestDto tmapRequestDto = TmapRequestDto.builder()
                .startX(String.valueOf(startLng))
                .startY(String.valueOf(startLat))
                .endX(String.valueOf(endLng))
                .endY(String.valueOf(endLat))
                .reqCoordType("WGS84GEO")
                .resCoordType("WGS84GEO")
                .startName("출발지")
                .endName("도착지")
                .passList(getPassList)
                .build();

        ObjectMapper mapper = new ObjectMapper();
        String jsonString = mapper.writeValueAsString(tmapRequestDto);
        String response = webClient.post().uri(baseUrl)
                .header("appKey", appKey)
                .accept(MediaType.APPLICATION_JSON)
                .body(BodyInserters.fromValue(jsonString))
                .retrieve()
                .bodyToMono(String.class).block();
        JsonParser jsonParser = new JsonParser();
        JsonObject jsonObject1 = jsonParser.parse(response).getAsJsonObject();
        JsonArray jsonArray = (JsonArray) jsonParser.parse(jsonObject1.get("features").toString());

        List<Point> pointList = new ArrayList<>();

        for (int i = 0; i < jsonArray.size(); i++) {
            JsonObject jsonObject2 = jsonParser.parse(String.valueOf(jsonArray.get(i))).getAsJsonObject().get("geometry").getAsJsonObject();
            JsonObject jsonObject3 = jsonParser.parse(String.valueOf(jsonObject2)).getAsJsonObject();
            String type = jsonObject3.get("type").toString();
            if (type.equals("\"Point\"")) {
                JsonArray pointArray = (JsonArray) jsonParser.parse(jsonObject2.get("coordinates").toString());
                double Lng = Double.parseDouble(String.valueOf(pointArray.get(0)));
                double Lat = Double.parseDouble(String.valueOf(pointArray.get(1)));
                pointList.add(new Point(Lat, Lng));
            }
        }
        return pointList;
    }
}
