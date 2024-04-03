package com.bada.badaback.myplace.service;

import com.bada.badaback.family.service.FamilyFindService;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.domain.MyPlaceRepository;
import com.bada.badaback.myplace.dto.MyPlaceDetailResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
public class MyPlaceService {
    private final MemberFindService memberFindService;
    private final FamilyFindService familyFindService;
    private final MyPlaceFindService myPlaceFindService;
    private final MyPlaceRepository myPlaceRepository;

    @Transactional
    public Long create(Long memberId, String placeName, String placeLatitude, String placeLongitude, String placeCategoryCode, String placeCategoryName,
                       String placePhoneNumber, String icon, String addressName, String addressRoadName, String placeCode) {
        Member findMember = memberFindService.findById(memberId);

        MyPlace myPlace = MyPlace.createMyPlace(placeName, placeLatitude, placeLongitude, placeCategoryCode, placeCategoryName,
                placePhoneNumber, icon, findMember.getFamilyCode(), addressName, addressRoadName, placeCode);

        return myPlaceRepository.save(myPlace).getId();
    }

    @Transactional
    public void update(Long memberId, Long myPlaceId, String placeName, String icon) {
        Member findMember = memberFindService.findById(memberId);
        MyPlace findMyPlace = myPlaceFindService.findById(myPlaceId);
        findMyPlace.updateMyPlace(placeName, icon);
    }

    @Transactional
    public void delete(Long memberId, Long myPlaceId) {
        Member findMember = memberFindService.findById(memberId);
        MyPlace findMyPlace = myPlaceFindService.findById(myPlaceId);

        myPlaceRepository.delete(findMyPlace);
    }

    @Transactional
    public MyPlaceDetailResponseDto read(Long memberId, Long myPlaceId) {
        Member findMember = memberFindService.findById(memberId);
        MyPlace findMyPlace = myPlaceFindService.findById(myPlaceId);

        return MyPlaceDetailResponseDto.from(findMyPlace);
    }
}