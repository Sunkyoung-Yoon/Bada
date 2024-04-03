package com.bada.badaback.auth.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface TokenRepository extends JpaRepository<Token, Long> {
    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("UPDATE Token t" +
            " SET t.refreshToken = :refreshToken" +
            " WHERE t.memberId = :memberId")
    void reissueRefreshTokenByRtrPolicy(@Param("memberId") Long memberId, @Param("refreshToken") String newRefreshToken);

    Optional<Token> findByMemberId(Long memberId);
    boolean existsByMemberIdAndRefreshToken(Long memberId, String refreshToken);
    void deleteByMemberId(Long memberId);
}

