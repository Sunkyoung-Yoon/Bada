package com.bada.badaback.currentLocation.service;

import com.bada.badaback.currentLocation.domain.CurrentLocation;
import com.bada.badaback.currentLocation.domain.CurrentLocationRepository;
import com.bada.badaback.currentLocation.exception.CurrentLocationErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class CurrentLocationFindService {
    private final CurrentLocationRepository currentLocationRepository;

    public CurrentLocation findByMember(Member findMember) {
        return currentLocationRepository.findByMember(findMember)
                .orElseThrow(() -> BaseException.type(CurrentLocationErrorCode.CURRENT_LOCATION_NOT_FOUND));
    }
}
