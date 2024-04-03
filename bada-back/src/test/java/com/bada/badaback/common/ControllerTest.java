package com.bada.badaback.common;

import com.bada.badaback.auth.controller.AuthApiController;
import com.bada.badaback.auth.controller.AuthCodeApiController;
import com.bada.badaback.auth.controller.TokenReissueApiController;
import com.bada.badaback.auth.service.AuthCodeFindService;
import com.bada.badaback.auth.service.AuthCodeService;
import com.bada.badaback.auth.service.AuthService;
import com.bada.badaback.auth.service.TokenReissueService;
import com.bada.badaback.currentLocation.controller.CurrentLocationApiController;
import com.bada.badaback.currentLocation.service.CurrentLocationFindService;
import com.bada.badaback.currentLocation.service.CurrentLocationService;
import com.bada.badaback.family.service.FamilyFindService;
import com.bada.badaback.family.service.FamilyService;
import com.bada.badaback.global.config.SecurityConfig;
import com.bada.badaback.global.security.JwtAccessDeniedHandler;
import com.bada.badaback.global.security.JwtAuthenticationEntryPoint;
import com.bada.badaback.global.security.JwtProvider;
import com.bada.badaback.member.controller.MemberApiController;
import com.bada.badaback.member.controller.MemberListApiController;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.route.controller.RouteController;
import com.bada.badaback.route.controller.RouteSearchController;
import com.bada.badaback.route.service.RouteFindService;
import com.bada.badaback.route.service.RouteSearchService;
import com.bada.badaback.route.service.RouteService;
import com.bada.badaback.safefacility.service.SafeFacilityService;
import com.bada.badaback.member.service.MemberListService;
import com.bada.badaback.member.service.MemberService;
import com.bada.badaback.myplace.controller.MyPlaceApiController;
import com.bada.badaback.myplace.controller.MyPlaceListApiController;
import com.bada.badaback.myplace.service.MyPlaceFindService;
import com.bada.badaback.myplace.service.MyPlaceListService;
import com.bada.badaback.myplace.service.MyPlaceService;
import com.bada.badaback.state.controller.StateController;
import com.bada.badaback.state.service.StateFindService;
import com.bada.badaback.state.service.StateService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.ImportAutoConfiguration;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;

import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;

@ImportAutoConfiguration(SecurityConfig.class)
@WebMvcTest({
        AuthApiController.class,
        TokenReissueApiController.class,
        AuthCodeApiController.class,
        MemberListApiController.class,
        MemberApiController.class,
        MyPlaceApiController.class,
        MyPlaceListApiController.class,
        StateController.class,
        RouteController.class,
        CurrentLocationApiController.class,
        RouteSearchController.class
})
@WithMockUser("test")
public abstract class ControllerTest {
    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    protected MockMvc mockMvc;

    @Autowired
    protected ObjectMapper objectMapper;

    @BeforeEach
    public void setUp() {
        mockMvc = MockMvcBuilders
                .webAppContextSetup(webApplicationContext)
                .apply(springSecurity())
                .addFilter(new CharacterEncodingFilter("UTF-8", true))
                .build();
    }

    @MockBean
    protected AuthService authService;

    @MockBean
    protected JwtProvider jwtProvider;

    @MockBean
    protected TokenReissueService tokenReissueService;

    @MockBean
    protected MemberFindService memberFindService;

    @MockBean
    protected JwtAccessDeniedHandler jwtAccessDeniedHandler;

    @MockBean
    protected JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

    @MockBean
    protected AuthCodeService authCodeService;

    @MockBean
    protected AuthCodeFindService authCodeFindService;

    @MockBean
    protected FamilyService familyService;

    @MockBean
    protected FamilyFindService familyFindService;

    @MockBean
    protected MemberListService memberListService;

    @MockBean
    protected MemberService memberService;

    @MockBean
    protected MyPlaceFindService myPlaceFindService;

    @MockBean
    protected MyPlaceService myPlaceService;

    @MockBean
    protected MyPlaceListService myPlaceListService;

    @MockBean
    protected SafeFacilityService safeFacilityService;

    @MockBean
    protected StateService stateService;

    @MockBean
    protected StateFindService stateFindService;

    @MockBean
    protected RouteService routeService;

    @MockBean
    protected RouteFindService routeFindService;

    @MockBean
    protected CurrentLocationService currentLocationService;

    @MockBean
    protected CurrentLocationFindService currentLocationFindService;

    @MockBean
    protected RouteSearchService routeSearchService;

    protected String convertObjectToJson(Object data) throws JsonProcessingException {
        return objectMapper.writeValueAsString(data);
    }
}
