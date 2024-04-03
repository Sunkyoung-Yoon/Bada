package com.bada.badaback.family.domain;

import com.bada.badaback.global.BaseTimeEntity;
import com.bada.badaback.global.utils.LongListConverter;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Entity
@NoArgsConstructor
@Table(name="family")
public class Family extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "family_id")
    private Long id;

    @Column(nullable = false, length = 20)
    private String familyCode;

    @Column(nullable = false, length = 100)
    private String familyName;

    @Convert(converter = LongListConverter.class)
    private List<Long> placeList;

    @Builder
    private Family(String familyCode, String familyName) {
        this.familyCode = familyCode;
        this.familyName = familyName;
        this.placeList = null;
    }

    public static Family createFamily(String familyCode, String familyName) {
        return new Family(familyCode, familyName);
    }

    public void updatePlaceList(List<Long> placeList) {
        this.placeList = placeList;
    }
}
