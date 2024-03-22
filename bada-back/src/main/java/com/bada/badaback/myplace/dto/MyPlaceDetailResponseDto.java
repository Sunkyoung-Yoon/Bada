package com.bada.badaback.myplace.dto;

import com.bada.badaback.myplace.domain.MyPlace;
import lombok.Builder;

@Builder
public record MyPlaceDetailResponseDto(
        Long myPlaceId,
        String placeName,
        String placeLatitude,
        String placeLongitude,
        String placeCategoryCode,
        String placePhoneNumber,
        String icon,
        String familyCode,
        String addressName,
        String addressRoadName,
        String placeCode
) {
    public static MyPlaceDetailResponseDto from(MyPlace findMyPlace) {
        return MyPlaceDetailResponseDto.builder()
                .myPlaceId(findMyPlace.getId())
                .placeName(findMyPlace.getPlaceName())
                .placeLatitude(findMyPlace.getPlaceLatitude())
                .placeLongitude(findMyPlace.getPlaceLongitude())
                .placeCategoryCode(findMyPlace.getPlaceCategoryCode())
                .placePhoneNumber(findMyPlace.getPlacePhoneNumber())
                .icon(findMyPlace.getIcon())
                .familyCode(findMyPlace.getFamilyCode())
                .addressName(findMyPlace.getAddressName())
                .addressRoadName(findMyPlace.getAddressRoadName())
                .placeCode(findMyPlace.getPlaceCode())
                .build();
    }
}
