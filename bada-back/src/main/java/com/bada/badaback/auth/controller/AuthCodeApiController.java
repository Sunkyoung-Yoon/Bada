package com.bada.badaback.auth.controller;

import com.bada.badaback.auth.service.AuthCodeService;
import com.bada.badaback.global.annotation.ExtractPayload;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "인증코드", description = "AuthCodeApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthCodeApiController {
    private final AuthCodeService authCodeService;

    @PostMapping("/authcode")
    public ResponseEntity<Void> issueCode(@ExtractPayload Long memberId) {
        authCodeService.issueCode(memberId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/authcode")
    public ResponseEntity<String> readCode(@ExtractPayload Long memberId) {
        String code = authCodeService.readCode(memberId);
        return new ResponseEntity<>(code, HttpStatus.OK);
    }
}
