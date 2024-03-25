package com.bada.badaback.state.domain;

import com.bada.badaback.member.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StateRepository extends JpaRepository<State,Long> {
    Optional<State> findByMember(Member member);

    boolean existsByMember(Member member);
}
