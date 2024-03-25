package com.bada.badaback.common;

import com.bada.badaback.auth.domain.AuthCodeRepository;
import com.bada.badaback.auth.domain.TokenRepository;
import com.bada.badaback.family.domain.FamilyRepository;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.myplace.domain.MyPlaceRepository;
import com.bada.badaback.safefacility.domain.SafeFacilityRepository;
import com.bada.badaback.state.domain.StateRepository;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.AfterEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@Transactional
public class ServiceTest {
    @Autowired
    private DatabaseCleaner databaseCleaner;

    @Autowired
    protected MemberRepository memberRepository;

    @Autowired
    protected TokenRepository tokenRepository;

    @Autowired
    protected AuthCodeRepository authCodeRepository;

    @Autowired
    protected FamilyRepository familyRepository;

    @Autowired
    protected MyPlaceRepository myPlaceRepository;

    @Autowired
    protected SafeFacilityRepository safeFacilityRepository;

    @Autowired
    protected StateRepository stateRepository;

    @AfterEach
    void clearDatabase() {
        databaseCleaner.cleanUpDatabase();
    }

    public void flushAndClear() {
        databaseCleaner.flushAndClear();
    }
}

