package com.bada.badaback.safefacility.controller;

import com.bada.badaback.common.ControllerTest;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.util.HashMap;
import java.util.Map;

import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static com.bada.badaback.feature.TokenFixture.REFRESH_TOKEN;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;

@DisplayName("SafeFacilityControllerTest 테스트")
class SafeFacilityControllerTest extends ControllerTest {

    @Test
    void getPath() throws Exception {
        //given
        Map<String, String> input = new HashMap<>();
        input.put("startX", "127.390075");
        input.put("startY", "36.421435");
        input.put("endX", "127.387519");
        input.put("endY", "36.423531");

        ObjectMapper objectMapper = new ObjectMapper();

        mockMvc.perform(
                MockMvcRequestBuilders.post("/api/path")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(input))
                        .header(AUTHORIZATION, BEARER_TOKEN + REFRESH_TOKEN))
//                .andDo(print())
                //then
                .andExpect(MockMvcResultMatchers.status().isOk());
//                .andExpect(jsonPath("$.startX").exists())
//                .andExpect(jsonPath("$.startX[0]").value("127.390075"))
////                .andExpect(jsonPath("$.pathList").exists())
//                .andExpect(jsonPath("$.pathList").value("127.390075"));

    }
}