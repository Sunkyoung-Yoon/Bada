package com.bada.badaback.feature;

import com.bada.badaback.safefacility.domain.Type;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum SafeFacilityFixture {
    START("36.421518","127.391538",Type.CCTV),
    END("36.421914","127.384120",Type.CCTV),
    CCTV1("36.4239243","127.3912025",Type.CCTV),
    CCTV2("36.4211696","127.3894907",Type.CCTV),
    CCTV3("36.4216841","127.3842417",Type.CCTV),
    CCTV4("36.4229545","127.3896168",Type.CCTV),
    CCTV5("36.4238121","127.3865354",Type.CCTV);




//    private final Long id;

    private final String facilityLatitude;

    private final String facilityLongitude;

    private final Type type;
}
