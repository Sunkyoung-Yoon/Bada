package com.bada.badaback.safefacility.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SafeFacilityRepository extends JpaRepository<SafeFacility, Long> {
    //    @Query(value = "SELECT sf FROM SafeFacility sf WHERE sf.type = 'cctv'")

//    @Query(value ="select * from safe_facility sf where sf.type ='cctv'",nativeQuery = true)

//    @Query(value ="SELECT sf FROM SafeFacility sf WHERE sf.type = 'cctv'"+
//            "AND ST_Distance_Sphere(Point(:middleLong,:middleLat),POINT(sf.facilityLongitude, sf.facilityLatitude)) <= 0.3")

        @Query(value ="select * from safe_facility sf where sf.type ='cctv' and" +
            "( 6371 * acos (" +
            "cos ( radians(sf.facility_latitude) )" +
            "* cos( radians(:middleLat) )" +
            "* cos( radians(sf.facility_longitude) - radians(:middleLong) )" +
            "+ sin ( radians(sf.facility_latitude) )" +
            "* sin( radians(:middleLat) ))) <= :distance",nativeQuery = true)
    List<SafeFacility> getCCTVs(@Param("middleLat") String middleLat, @Param("middleLong") String middleLong,@Param("distance") Double distance);
}