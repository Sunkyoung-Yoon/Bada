package com.bada.badaback.state.dto;

import com.bada.badaback.state.domain.State;
import lombok.Builder;

@Builder
public record StateResponseDto(
        String startLat,
        String startLong,
        String endLat,
        String endLong,
        String nowLat,
        String nowLong,
        Long childId
) {
    public static StateResponseDto from (State state){
        return StateResponseDto.builder()
                .startLat(state.getStartLatitude())
                .startLong(state.getStartLongitude())
                .endLat(state.getEndLatitude())
                .endLong(state.getEndLongitude())
                .nowLat(state.getNowLatitude())
                .nowLong(state.getNowLongitude())
                .childId(state.getMember().getId())
                .build();
    }
}
