package com.bada.badaback.family.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FamilyRepository extends JpaRepository<Family, Long> {
    boolean existsByFamilyCode(String familyCode);

    Optional<Family> findByFamilyCode(String familyCode);
}
