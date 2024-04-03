package com.bada.badaback.myplace.service;

import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.service.FamilyFindService;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.domain.MyPlaceRepository;
import com.bada.badaback.myplace.dto.MyPlaceListResponseDto;
import com.bada.badaback.myplace.dto.MyPlaceResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MyPlaceListService {
    private final MyPlaceRepository myPlaceRepository;

    @Transactional
    public MyPlaceListResponseDto myPlaceList(List<Long> myPlaceIdList) {
        List<MyPlace> myPlaceList = myPlaceRepository.myPlaceList(myPlaceIdList);

        List<MyPlaceResponseDto> placeList = new ArrayList<>();
        for (MyPlace myPlace : myPlaceList) {
            MyPlaceResponseDto myPlaceResponseDto = MyPlaceResponseDto.from(myPlace);
            placeList.add(myPlaceResponseDto);
        }
        return new MyPlaceListResponseDto(placeList);
    }
}
