package com.bada.badaback.feature;

import com.bada.badaback.myplace.domain.MyPlace;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum MyPlaceFixture {
    MYPLACE_0("집", "35.111111", "127.111111", "SC4", "아파트", "042-1111-1111", "icon0", "지번 주소", "도로명 주소", "11111111"),
    MYPLACE_1("학교", "35.222222", "127.222222", "SC4", "학교","042-2222-2222", "icon1", "지번 주소", "도로명 주소", "22222222"),
    MYPLACE_2("집", "35.333333", "127.333333", "SC4", "아파트","042-3333-3333", "icon2", "지번 주소", "도로명 주소", "33333333"),
    MYPLACE_3("학교", "35.444444", "127.444444", "SC4", "학교","042-4444-4444", "icon3", "지번 주소", "도로명 주소", "44444444");

    private final String placeName;
    private final String placeLatitude;
    private final String placeLongitude;
    private final String placeCategoryCode;
    private final String placeCategoryName;
    private final String placePhoneNumber;
    private final String icon;
    private final String addressName;
    private final String addressRoadName;
    private final String placeCode;

    public MyPlace toMyPlace(String familyCode) {
        return MyPlace.createMyPlace(placeName, placeLatitude, placeLongitude, placeCategoryCode, placeCategoryName,
                placePhoneNumber, icon, familyCode, addressName, addressRoadName, placeCode);
    }
}
