package com.bada.badaback.myplace.controller;

import com.bada.badaback.common.ControllerTest;
import com.bada.badaback.family.dto.FamilyPlaceListResponseDto;
import com.bada.badaback.myplace.dto.MyPlaceListResponseDto;
import com.bada.badaback.myplace.dto.MyPlaceResponseDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.util.ArrayList;
import java.util.List;

import static com.bada.badaback.feature.MyPlaceFixture.*;
import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static com.bada.badaback.feature.TokenFixture.REFRESH_TOKEN;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@DisplayName("MyPlaceList [Controller Layer] -> MyPlaceListApiController 테스트")
public class MyPlaceListApiControllerTest extends ControllerTest {
    @Nested
    @DisplayName("마이 플레이스 목록 조회 API [GET /api/myplace]")
    class signup {
        private static final String BASE_URL = "/api/myplace";

        @Test
        @DisplayName("마이 플레이스 목록 조회에 성공한다")
        void success() throws Exception {
            // given
            doReturn(createFamilyPlaceListResponseDto())
                    .when(familyService)
                    .myPlaceIdList(anyLong());
            doReturn(createMyPlaceListResponseDto())
                    .when(myPlaceListService)
                    .myPlaceList(anyList());

            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL)
                    .header(AUTHORIZATION, BEARER_TOKEN + REFRESH_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpect(status().isOk());
        }
    }

    private MyPlaceListResponseDto createMyPlaceListResponseDto() {
        List<MyPlaceResponseDto> myPlaceList = new ArrayList<>();
        myPlaceList.add(new MyPlaceResponseDto(1L, MYPLACE_0.getPlaceName(), MYPLACE_0.getPlaceLongitude(), MYPLACE_0.getPlaceLatitude(), MYPLACE_0.getPlaceCategoryCode(), MYPLACE_0.getPlaceCategoryName(), MYPLACE_0.getPlacePhoneNumber(),
                MYPLACE_0.getIcon(), MYPLACE_0.getAddressName(), MYPLACE_0.getAddressRoadName(), MYPLACE_0.getPlaceCode()));
        myPlaceList.add(new MyPlaceResponseDto(2L, MYPLACE_1.getPlaceName(), MYPLACE_1.getPlaceLongitude(), MYPLACE_1.getPlaceLatitude(), MYPLACE_1.getPlaceCategoryCode(), MYPLACE_1.getPlaceCategoryName(), MYPLACE_1.getPlacePhoneNumber(),
                MYPLACE_1.getIcon(), MYPLACE_1.getAddressName(), MYPLACE_1.getAddressRoadName(), MYPLACE_1.getPlaceCode()));
        myPlaceList.add(new MyPlaceResponseDto(3L, MYPLACE_2.getPlaceName(), MYPLACE_2.getPlaceLongitude(), MYPLACE_2.getPlaceLatitude(), MYPLACE_2.getPlaceCategoryCode(), MYPLACE_2.getPlaceCategoryName(), MYPLACE_2.getPlacePhoneNumber(),
                MYPLACE_2.getIcon(), MYPLACE_2.getAddressName(), MYPLACE_2.getAddressRoadName(), MYPLACE_2.getPlaceCode()));
        return new MyPlaceListResponseDto(myPlaceList);
    }

    private FamilyPlaceListResponseDto createFamilyPlaceListResponseDto() {
        List<Long> myPlaceIdList = new ArrayList<>();
        myPlaceIdList.add(1L);
        myPlaceIdList.add(2L);
        myPlaceIdList.add(3L);
        return new FamilyPlaceListResponseDto(myPlaceIdList);
    }
}
