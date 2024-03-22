package com.bada.badaback.safefacility.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class Point {
    private Double longitude;
    private Double latitude;

}
