package com.bada.badaback.myplace.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.domain.MyPlaceRepository;
import com.bada.badaback.myplace.exception.MyPlaceErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MyPlaceFindService {
    private final MyPlaceRepository myPlaceRepository;

    public MyPlace findById(Long id) {
        return myPlaceRepository.findById(id)
                .orElseThrow(() -> BaseException.type(MyPlaceErrorCode.MYPLACE_NOT_FOUND));
    }

    public List<MyPlace> findRoutePlace(String lat, String lng){
        return myPlaceRepository.findRoutePlace(lat, lng);
    }
}
