package com.bada.badaback.route.domain;

import com.bada.badaback.member.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RouteRepository extends JpaRepository<Route,Long> {
    Optional<Route> findByMember(Member member);
    boolean existsRouteByMember(Member member);

}
