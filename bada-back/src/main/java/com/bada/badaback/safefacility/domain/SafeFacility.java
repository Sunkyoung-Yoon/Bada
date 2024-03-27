package com.bada.badaback.safefacility.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "safe_facility")
public class SafeFacility {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 50, nullable = false)
    private String facilityLatitude;

    @Column(length = 50, nullable = false)
    private String facilityLongitude;

    @Convert(converter = Type.TypeConverter.class)
    @Column(length = 15, nullable = false)
    private Type type;

    public static SafeFacility createSafeFaciclity(String facilityLatitude, String facilityLongitude, Type type){
        SafeFacility sf = new SafeFacility();
        sf.facilityLatitude = facilityLatitude;
        sf.facilityLongitude = facilityLongitude;
        sf.type = type;
        return sf;
    }

}
