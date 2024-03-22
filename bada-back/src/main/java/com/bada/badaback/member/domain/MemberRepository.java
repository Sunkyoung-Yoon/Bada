package com.bada.badaback.member.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByEmailAndSocial(String email, SocialType social);

    boolean existsByEmailAndSocial(String email, SocialType social);

    Optional<Member> findByEmail(String email);

    @Query("select distinct m from Member m where m.familyCode = :familyCode order by m.createdAt desc")
    List<Member> familyList(@Param("familyCode") String familyCode);
}
