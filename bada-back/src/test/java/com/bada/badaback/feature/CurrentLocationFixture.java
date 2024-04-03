package com.bada.badaback.feature;

import com.bada.badaback.currentLocation.domain.CurrentLocation;
import com.bada.badaback.member.domain.Member;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CurrentLocationFixture {
    CURRENT_LOCATION_0("36.421518", "127.391538"),
    CURRENT_LOCATION_1("36.4211696", "127.3894907")
    ;

    private final String currentLatitude;
    private final String currentLongitude;

    public CurrentLocation toCurrentLocation(Member member) {
        return CurrentLocation.createCurrentLocation(member, currentLatitude, currentLongitude);
    }
}
