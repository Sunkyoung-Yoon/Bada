package com.bada.badaback.auth.controller;

import com.bada.badaback.auth.dto.AuthAlreadyRequestDto;
import com.bada.badaback.auth.dto.AuthJoinRequestDto;
import com.bada.badaback.auth.dto.AuthSignUpRequestDto;
import com.bada.badaback.auth.dto.LoginResponseDto;
import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ControllerTest;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static com.bada.badaback.feature.TokenFixture.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@DisplayName("Auth [Controller Layer] -> AuthApiController 테스트")
class AuthApiControllerTest extends ControllerTest {
    @Nested
    @DisplayName("회원가입(새로운 가족 그룹 생성) API [POST /api/auth/signup]")
    class signup {
        private static final String BASE_URL = "/api/auth/signup";

        @Test
        @DisplayName("회원가입에 성공한다")
        void success() throws Exception {
            // given
            LoginResponseDto loginResponseDto = createLoginResponseDto();
            doReturn(1L)
                    .when(authService)
                    .signup(any(), any(), any(), any(), any(), any(), any());
            doReturn(loginResponseDto)
                    .when(authService)
                    .login(anyLong(), any());

            // when
            final AuthSignUpRequestDto request = createAuthSignUpRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .contentType(APPLICATION_JSON)
                    .content(convertObjectToJson(request));

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("회원가입(기존 가족 그룹 가입) API [POST /api/auth/join]")
    class join {
        private static final String BASE_URL = "/api/auth/join";

        @Test
        @DisplayName("회원가입에 성공한다")
        void success() throws Exception {
            // given
            LoginResponseDto loginResponseDto = createLoginResponseDto();
            doReturn(1L)
                    .when(authService)
                    .join(any(), any(), any(), any(), any(), any(), any());
            doReturn(loginResponseDto)
                    .when(authService)
                    .login(anyLong(), any());

            // when
            final AuthJoinRequestDto request = createAuthJoinRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .contentType(APPLICATION_JSON)
                    .content(convertObjectToJson(request));

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("아이 회원가입(기존 가족 그룹 가입) API [POST /api/auth/joinChild]")
    class joinChild {
        private static final String BASE_URL = "/api/auth/joinChild";

        @Test
        @DisplayName("회원가입에 성공한다")
        void success() throws Exception {
            // given
            LoginResponseDto loginResponseDto = createLoginResponseDto();
            doReturn(1L)
                    .when(authService)
                    .joinChild(any(), any(), any(), any(), any());
            doReturn(loginResponseDto)
                    .when(authService)
                    .login(anyLong(), any());

            // when
            final AuthJoinRequestDto request = createAuthJoinRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .contentType(APPLICATION_JSON)
                    .content(convertObjectToJson(request));

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("기존 회원 여부 판단 API [POST /api/auth]")
    class alreadyMember {
        private static final String BASE_URL = "/api/auth";

        @Test
        @DisplayName("기존 회원이 아니라면 아무것도 보내지 않는다")
        void notAlreadyMember() throws Exception {
            // given
            doReturn(null)
                    .when(authService)
                    .AlreadyMember(any(), any());

            // when
            final AuthAlreadyRequestDto request = createAuthAlreadyRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .contentType(APPLICATION_JSON)
                    .content(convertObjectToJson(request));

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isNoContent()
                    );
        }

        @Test
        @DisplayName("기존 회원이라면 조회에 성공한다")
        void AlreadyMember() throws Exception {
            // given
            doReturn(1L)
                    .when(authService)
                    .AlreadyMember(any(), any());
            doReturn(createLoginResponseDto())
                    .when(authService)
                    .login(anyLong(), any());

            // when
            final AuthAlreadyRequestDto request = createAuthAlreadyRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .contentType(APPLICATION_JSON)
                    .content(convertObjectToJson(request));

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("로그아웃 API 테스트 [GET /api/auth/logout]")
    class logout {
        private static final String BASE_URL = "/api/auth/logout";

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
        @DisplayName("로그아웃에 성공한다")
        void success() throws Exception {
            // given
            doNothing()
                    .when(authService)
                    .logout(anyLong());

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

    private AuthSignUpRequestDto createAuthSignUpRequestDto() {
        return new AuthSignUpRequestDto(SUNKYOUNG.getName(), SUNKYOUNG.getPhone(), SUNKYOUNG.getEmail(), "NAVER",
                SUNKYOUNG.getProfileUrl(), "우리가족", SUNKYOUNG.getFcmToken());
    }

    private AuthJoinRequestDto createAuthJoinRequestDto() {
        return new AuthJoinRequestDto(SUNKYOUNG.getName(), SUNKYOUNG.getPhone(), SUNKYOUNG.getEmail(), "NAVER",
                SUNKYOUNG.getProfileUrl(), "인증코드", SUNKYOUNG.getFcmToken());
    }

    private LoginResponseDto createLoginResponseDto() {
        return new LoginResponseDto(1L, SUNKYOUNG.getName(), SUNKYOUNG.getFamilyCode(), "우리 가족", ACCESS_TOKEN, REFRESH_TOKEN, SUNKYOUNG.getFcmToken());
    }

    private AuthAlreadyRequestDto createAuthAlreadyRequestDto() {
        return new AuthAlreadyRequestDto("abc@naver.com", "KAKAO", "fcmToken");
    }
}


