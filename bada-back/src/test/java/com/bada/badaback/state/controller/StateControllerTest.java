package com.bada.badaback.state.controller;

import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ControllerTest;
import com.bada.badaback.state.dto.StateNowRequestDto;
import com.bada.badaback.state.dto.StateRequestDto;
import com.bada.badaback.state.dto.StateResponseDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import static com.bada.badaback.feature.TokenFixture.ACCESS_TOKEN;
import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class StateControllerTest extends ControllerTest {

    @Nested
    @DisplayName("상태코드 등록 API 테스트 [POST /api/state]")
    class createState{
        private static final String BASE_URL ="/api/state";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception{
            //when
            final StateRequestDto requestDto = createStateRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        @DisplayName("상태 정보 등록에 성공한다.")
        void createState() throws Exception {
            //given
            doNothing()
                    .when(stateService)
                    .createState(any(),any(),any(),any(),any(),any(),anyLong());

            //when
            final StateRequestDto requestDto = createStateRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON)
                    .header(AUTHORIZATION,BEARER_TOKEN+ACCESS_TOKEN);

            //Then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            MockMvcResultMatchers.status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("상태코드 조회 API 테스트 [GET /api/state/{childId}]")
    class findState{
        private static final String BASE_URL ="/api/state/{childId}";
        private static final Long CHILD_ID = 1L;

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception{
            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL,CHILD_ID);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        @DisplayName("상태를 조회한다.")
        void findState() throws Exception {
            //given
            doReturn(createStateResponseDto())
                    .when(stateService)
                    .findStateByMemberId(anyLong(),anyLong());

            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL,CHILD_ID)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            //then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            status().isOk()
                    );

        }

    }

    @Nested
    @DisplayName("현재 상태 수정 API 테스트 [PATCH /api/state]")
    class modifyState{
        private static final String BASE_URL ="/api/state";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception{
            //when
            final StateRequestDto requestDto = createStateRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .patch(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        @DisplayName("현재 위치를 기반으로 상태를 수정한다")
        void modifyState() throws Exception {
            //given
            doNothing()
                    .when(stateService)
                    .modifyState(anyLong(),any(),any());
            //when
            StateNowRequestDto requestDto = createStateNowRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .patch(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            //then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            status().isOk()
                    );
        }
    }


    @Nested
    @DisplayName("상태 삭제 API 테스트 [DELETE /api/state]")
    class deleteState{
        private static final String BASE_URL ="/api/state";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception{
            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .delete(BASE_URL);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        void deleteState() throws Exception {
            //given
            doNothing()
                    .when(stateService)
                    .deleteState(anyLong());
            //when
            MockHttpServletRequestBuilder requestBuilders = MockMvcRequestBuilders
                    .delete(BASE_URL)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            //then
            mockMvc.perform(requestBuilders)
                    .andExpect(
                            status().isOk()
                    );
        }
    }


    private StateRequestDto createStateRequestDto(){
        return new StateRequestDto("36.421518","127.391538","36.421914","127.38412","36.421518","127.391538");
    }
    private StateNowRequestDto createStateNowRequestDto(){
        return new StateNowRequestDto("36.421716","127.387829");
    }

    private StateResponseDto createStateResponseDto(){
        return new StateResponseDto("36.421518","127.391538","36.421914","127.38412","36.421518","127.391538",1L);
    }
}