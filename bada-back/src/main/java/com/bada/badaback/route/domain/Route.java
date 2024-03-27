package com.bada.badaback.route.domain;

import com.bada.badaback.member.domain.Member;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "route")
public class Route {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String startLatitude;

    @Column(nullable = false, length = 100)
    private String startLongitude;

    @Column(nullable = false, length = 100)
    private String endLatitude;

    @Column(nullable = false, length = 100)
    private String endLongitude;

    @Column(nullable = false, length = 5000)
    private String pointList;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", referencedColumnName = "member_id")
    private Member member;

    private Route(String startLatitude, String startLongitude,
                  String endLatitude, String endLongitude, String pointList, Member member) {
        this.startLatitude = startLatitude;
        this.startLongitude = startLongitude;
        this.endLatitude = endLatitude;
        this.endLongitude = endLongitude;
        this.pointList = pointList;
        this.member = member;
    }

    public static Route createRoute(String startLatitude, String startLongitude,
                                    String endLatitude, String endLongitude, String pointList, Member member) {
        return new Route(startLatitude, startLongitude, endLatitude, endLongitude, pointList, member);
    }
}
