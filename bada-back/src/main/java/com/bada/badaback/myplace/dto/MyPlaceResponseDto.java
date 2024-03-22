package com.bada.badaback.myplace.dto;

import com.bada.badaback.myplace.domain.MyPlace;
import lombok.Builder;

@Builder
public record MyPlaceResponseDto(
        Long myPlaceId,
        String placeName,
        String icon,
        String addressName,
        String addressRoadName,
        String placeCode
) {
    public static MyPlaceResponseDto from(MyPlace findMyplace) {
        return MyPlaceResponseDto.builder()
                .myPlaceId(findMyplace.getId())
                .placeName(findMyplace.getPlaceName())
                .icon(findMyplace.getIcon())
                .addressName(findMyplace.getAddressName())
                .addressRoadName(findMyplace.getAddressRoadName())
                .placeCode(findMyplace.getPlaceCode())
                .build();
    }
}
