package com.bada.badaback.myplace.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MyPlaceRepository extends JpaRepository<MyPlace, Long> {
    @Query("select distinct mp from MyPlace mp where mp.id in :placeIdList order by mp.createdAt desc")
    List<MyPlace> myPlaceList(@Param("placeIdList") List<Long> placeIdList);

    @Query("select mp from MyPlace mp where mp.placeLatitude = :placeLat and mp.placeLongitude = :placeLng")
    List<MyPlace> findRoutePlace(@Param("placeLat") String placeLat, @Param("placeLng") String placeLng);
}
