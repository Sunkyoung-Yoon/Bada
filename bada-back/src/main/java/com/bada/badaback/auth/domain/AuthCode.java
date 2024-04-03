package com.bada.badaback.auth.domain;

import com.bada.badaback.global.BaseTimeEntity;
import com.bada.badaback.member.domain.Member;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
@Table(name="auth_code")
public class AuthCode extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long id;

    @Column(nullable = false)
    private String code;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", referencedColumnName = "member_id")
    private Member member;

    private AuthCode(Member member, String code) {
        this.member = member;
        this.code = code;
    }

    public static AuthCode createAuthCode(Member member, String code) {
        return new AuthCode(member, code);
    }

    public void updateAuthCode(String code) {
        this.code = code;
    }
}
