package com.bada.badaback.myplace.dto;

import java.util.List;

public record MyPlaceListResponseDto(
        List<MyPlaceResponseDto> MyPlaceList
) {
}
