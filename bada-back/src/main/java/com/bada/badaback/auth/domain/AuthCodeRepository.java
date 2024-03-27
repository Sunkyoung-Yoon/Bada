package com.bada.badaback.auth.domain;

import com.bada.badaback.member.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface AuthCodeRepository extends JpaRepository<AuthCode, Long> {
    boolean existsByMemberId(Long memberId);

    Optional<AuthCode> findByMemberId(Long memberId);

    @Query("select distinct m from AuthCode ac inner join Member m on ac.member.id = m.id where ac.code = :code")
    Optional<Member> findMemberByCode(@Param("code") String code);
}

