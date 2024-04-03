package com.bada.badaback.currentLocation.service;

import com.bada.badaback.currentLocation.domain.CurrentLocation;
import com.bada.badaback.currentLocation.domain.CurrentLocationRepository;
import com.bada.badaback.currentLocation.dto.CurrentLocationResponseDto;
import com.bada.badaback.currentLocation.exception.CurrentLocationErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class CurrentLocationService {
    private final MemberFindService memberFindService;
    private final CurrentLocationRepository currentLocationRepository;
    private final CurrentLocationFindService currentLocationFindService;

    @Transactional
    public Long create(Long memberId, String currentLatitude, String currentLongitude) {
        Member findMember= memberFindService.findById(memberId);

        CurrentLocation currentLocation = CurrentLocation.createCurrentLocation(findMember, currentLatitude, currentLongitude);
        log.info(LocalDateTime.now() + " 현재 위치 생성");
        return currentLocationRepository.save(currentLocation).getId();
    }

    @Transactional
    public void update(Long memberId, String currentLatitude, String currentLongitude) {
        Member findMember= memberFindService.findById(memberId);
        CurrentLocation currentLocation = currentLocationFindService.findByMember(findMember);

        currentLocation.updateCurrentLocation(currentLatitude, currentLongitude);
        log.info(LocalDateTime.now() + " 현재 위치 업데이트");
    }

    @Transactional
    public void delete(Long memberId) {
        Member findMember= memberFindService.findById(memberId);
        CurrentLocation currentLocation = currentLocationFindService.findByMember(findMember);

        currentLocationRepository.delete(currentLocation);
        log.info(LocalDateTime.now() + " 현재 위치 삭제");
    }

    // 부모가 읽는 아이 위치 정보
    @Transactional
    public CurrentLocationResponseDto read(Long memberId, Long childId) {
        Member findMember= memberFindService.findById(memberId);
        Member childMember= memberFindService.findById(childId);
        checkParent(findMember.getFamilyCode(), childMember.getFamilyCode());

        CurrentLocation currentLocation = currentLocationFindService.findByMember(childMember);

        return CurrentLocationResponseDto.from(currentLocation);
    }

    private void checkParent (String memberFamilyCode, String childFamilyCode) {
        if(!memberFamilyCode.equals(childFamilyCode))
            throw BaseException.type(CurrentLocationErrorCode.MEMBER_IS_NOT_CHILD_PARENT);
    }

}
