package com.bada.badaback.currentLocation.dto;

import com.bada.badaback.currentLocation.domain.CurrentLocation;
import lombok.Builder;

@Builder
public record CurrentLocationResponseDto(
        double currentLatitude,
        double currentLongitude,
        Long childId,
        String name,
        String profileUrl

) {
    public static CurrentLocationResponseDto from(CurrentLocation currentLocation) {
        return CurrentLocationResponseDto.builder()
                .currentLatitude(Double.parseDouble(currentLocation.getCurrentLatitude()))
                .currentLongitude(Double.parseDouble(currentLocation.getCurrentLongitude()))
                .childId(currentLocation.getMember().getId())
                .name(currentLocation.getMember().getName())
                .profileUrl(currentLocation.getMember().getProfileUrl())
                .build();
    }
}
