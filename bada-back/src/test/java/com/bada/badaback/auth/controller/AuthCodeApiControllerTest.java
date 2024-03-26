package com.bada.badaback.auth.controller;

import com.bada.badaback.auth.dto.AuthCodeResponseDto;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ControllerTest;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static com.bada.badaback.feature.TokenFixture.REFRESH_TOKEN;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.BDDMockito.given;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@DisplayName("AuthCode [Controller Layer] -> AuthCodeApiController 테스트")
public class AuthCodeApiControllerTest extends ControllerTest {
    @Nested
    @DisplayName("인증코드 발급 API 테스트 [POST /api/auth/authcode]")
    class issueCode {
        private static final String BASE_URL = "/api/auth/authcode";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL);

            // then
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
        @DisplayName("인증코드 발급에 성공한다")
        void success() throws Exception {
            // given
            given(jwtProvider.getId(REFRESH_TOKEN)).willReturn(1L);
            given(authCodeService.issueCode(1L)).willReturn(anyLong());

            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .header(AUTHORIZATION, BEARER_TOKEN + REFRESH_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("인증코드 조회 API 테스트 [GET /api/auth/authcode]")
    class readCode {
        private static final String BASE_URL = "/api/auth/authcode";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL);

            // then
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
        @DisplayName("인증코드 발급에 성공한다")
        void success() throws Exception {
            // given
            given(jwtProvider.getId(REFRESH_TOKEN)).willReturn(1L);
            given(authCodeService.readCode(1L)).willReturn(readAuthCodeResponseDto());

            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL)
                    .header(AUTHORIZATION, BEARER_TOKEN + REFRESH_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    private AuthCodeResponseDto readAuthCodeResponseDto() {
        return new AuthCodeResponseDto("인증코드");
    }
}
