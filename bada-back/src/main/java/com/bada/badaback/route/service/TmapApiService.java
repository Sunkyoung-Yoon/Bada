package com.bada.badaback.route.service;

import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.service.SafeFacilityService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class TmapApiService {
    @Value("${TMAP_APPKEY}")
    private String appKey;

    private final WebClient webClient;
    private final SafeFacilityService safeFacilityService;

    public List<Point> getPoint(String startLat, String startLng, String endLat, String endLng) throws IOException {
        String baseUrl = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result";

        int layer = 6;
        List<Point> pointList = new ArrayList<>();
        while (true) {
            //passList 얻어오기
            String getPassList = safeFacilityService.getCCTVs(layer, startLng, startLat, endLng, endLat);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("startX", startLng);
            requestBody.put("startY", startLat);
            requestBody.put("endX", endLng);
            requestBody.put("endY", endLat);
            requestBody.put("reqCoordType", "WGS84GEO");
            requestBody.put("resCoordType", "WGS84GEO");
            requestBody.put("startName", "출발지");
            requestBody.put("endName", "도착지");
            if (!getPassList.isEmpty()) {
                requestBody.put("passList", getPassList);
            }

            ObjectMapper mapper = new ObjectMapper();
            String jsonString = mapper.writeValueAsString(requestBody);
            //passList가 있다면 apssList 추가


            String response = webClient.post().uri(baseUrl)
                    .header("appKey", appKey)
                    .accept(MediaType.APPLICATION_JSON)
                    .body(BodyInserters.fromValue(jsonString))
                    .retrieve()
                    .bodyToMono(String.class).block();
//            log.info("=========데이터 찾기=========");
//            log.info(response);
            JsonParser jsonParser = new JsonParser();
            JsonObject jsonObject1 = jsonParser.parse(response).getAsJsonObject();
//            log.info("===response 결과======");
//            log.info("결과 {}", jsonObject1.toString());
            JsonArray jsonArray = (JsonArray) jsonParser.parse(jsonObject1.get("features").toString());
//            log.info("결과1 {}", jsonArray.get(0).toString());
            JsonObject jsonProperites = (JsonObject) jsonParser.parse(jsonArray.get(0).toString());
//            log.info("결과2 {}", jsonProperites.get("properties").toString());

            String totalDistance = jsonProperites.get("properties").getAsJsonObject().get("totalDistance").toString();
//            log.info("결과3 {}", totalDistance);

//       String totalDistance =
            log.info("=============길이를 구한다===============");
            log.info("layer: {}", layer);
            log.info("길이 : {} km", Double.parseDouble(totalDistance) / 1000);

            for (int i = 0; i < jsonArray.size(); i++) {
                JsonObject jsonObject2 = jsonParser.parse(String.valueOf(jsonArray.get(i))).getAsJsonObject().get("geometry").getAsJsonObject();
                JsonObject jsonObject3 = jsonParser.parse(String.valueOf(jsonObject2)).getAsJsonObject();
                String type = jsonObject3.get("type").toString();
                if (type.equals("\"Point\"")) {
                    JsonArray pointArray = (JsonArray) jsonParser.parse(jsonObject2.get("coordinates").toString());
                    double Lng = Double.parseDouble(String.valueOf(pointArray.get(0)));
                    double Lat = Double.parseDouble(String.valueOf(pointArray.get(1)));
                    pointList.add(new Point(Lat, Lng));
                } else {
                    JsonArray pointArray = (JsonArray) jsonParser.parse(jsonObject2.get("coordinates").toString());
                    for (int k = 0; k < pointArray.size(); k++) {
                        JsonArray jsonArray2 = (JsonArray) jsonParser.parse(pointArray.get(k).toString());
                        double Lng = Double.parseDouble(String.valueOf(jsonArray2.get(0)));
                        double Lat = Double.parseDouble(String.valueOf(jsonArray2.get(1)));
                        pointList.add(new Point(Lat, Lng));
                    }
                }
            }

            if (Double.parseDouble(totalDistance) > 1000 && layer > 3) {
                layer--;
                pointList = new ArrayList<>();
            } else {
                break;
            }

        }//while

//        log.info("=============pointList===============");
//        log.info("경로리스트: {}",pointList);
//        log.info("경로리스트 길이: {}",pointList.toString().length());
        return pointList;
    }
}
