package com.bada.badaback.feature;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum AlarmTriggerFixture {
    OUT_OF_PATH(35.111,127.666),
    IN_PATH(36.420552649750135,127.39078782797036);
    private final double Lat;
    private final double Lng;
}
