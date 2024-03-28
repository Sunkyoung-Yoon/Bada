package com.bada.badaback.currentLocation.domain;

import com.bada.badaback.member.domain.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CurrentLocationRepository extends JpaRepository<CurrentLocation, Long> {
    Optional<CurrentLocation> findByMember(Member member);
}
