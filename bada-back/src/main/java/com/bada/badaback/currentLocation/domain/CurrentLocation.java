package com.bada.badaback.currentLocation.domain;

import com.bada.badaback.member.domain.Member;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
@Table(name="current_location")
public class CurrentLocation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "current_location_id")
    private Long id;

    @Column(nullable = false, length = 50)
    private String currentLatitude;

    @Column(nullable = false, length = 50)
    private String currentLongitude;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", referencedColumnName = "member_id")
    private Member member;

    private CurrentLocation(Member member, String currentLatitude, String currentLongitude) {
        this.member = member;
        this.currentLatitude = currentLatitude;
        this.currentLongitude = currentLongitude;
    }

    public static CurrentLocation createCurrentLocation(Member member, String currentLatitude, String currentLongitude) {
        return new CurrentLocation(member, currentLatitude, currentLongitude);
    }

    public void updateCurrentLocation(String currentLatitude, String currentLongitude) {
        this.currentLatitude = currentLatitude;
        this.currentLongitude = currentLongitude;
    }
}
