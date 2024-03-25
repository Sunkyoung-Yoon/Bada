package com.bada.badaback.safefacility.service;

import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.domain.SafeFacility;
import com.bada.badaback.safefacility.domain.SafeFacilityRepository;
import com.bada.badaback.safefacility.dto.SafeFacilityResponseDto;
import com.uber.h3core.H3Core;
import com.uber.h3core.util.LatLng;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class SafeFacilityService {
    private final SafeFacilityRepository safeFacilityRepository;

    //CCTV 출발 시작 좌표로 가져오기
    //두 지점의 거리를 구하고 그것의 반만큼의 거리를 구한다.
    //todo 경로찾기 알고리즘 구현
    public SafeFacilityResponseDto getCCTVs(String startX, String startY, String endX, String endY) throws IOException {
        Point start = Point.builder()
                .latitude(Double.parseDouble(startY))
                .longitude(Double.parseDouble(startX))
                .build();

        Point end = Point.builder()
                .latitude(Double.parseDouble(endY))
                .longitude(Double.parseDouble(endX))
                .build();

        Point mid = calculateMidpoint(start, end);

        //시작 ~ 도착 거리 계산
        double distance = distance(start.getLatitude(), start.getLongitude(), end.getLatitude(), end.getLongitude());


        List<SafeFacility> paths = safeFacilityRepository.getCCTVs(mid.getLatitude().toString(), mid.getLongitude().toString(),distance/2);

        Iterator<SafeFacility> pathIterator = paths.iterator();

        // String을 포인트 여러개로 만들기
        StringBuilder stringBuilder = new StringBuilder();
        int count = 0;
        while (pathIterator.hasNext()) {
            count++;
            SafeFacility next = pathIterator.next();
            stringBuilder.append(next.getFacilityLongitude()).append(", ").append(next.getFacilityLatitude());
            if (count == 3) {
                break;
            }
            if (pathIterator.hasNext()) {
                stringBuilder.append("_");
            }
        }

        List<String> hexagonsAddress = hexagonsAddress(start, mid);
        List<Point> hexagonsCoordinates = hexagonsCoordinates(hexagonsAddress);

        return SafeFacilityResponseDto.from(start, end, stringBuilder.toString());
    }

    private static Point calculateMidpoint(Point start, Point end) {
        // 위도와 경도의 평균값 계산
        double midLat = (start.getLatitude() + end.getLatitude()) / 2;
        double midLong = (start.getLongitude() + end.getLongitude()) / 2;

        // 중간 좌표 반환
        return Point.builder()
                .latitude(midLat)
                .longitude(midLong)
                .build();
    }

    private double distance(double lat1, double lon1, double lat2, double lon2) {
        int R = 6371; // 지구 반지름 (단위: km)
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
                        Math.sin(dLon/2) * Math.sin(dLon/2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }

    private double[] calc_offsets(double distance, double lat) {
        double[] offsets = new double[2];
        offsets[0] = 180*distance/6371/1000/Math.PI*1000; // lat
        offsets[1] = Math.abs(360*Math.asin(Math.sin(distance/6371/2/1000)/Math.cos(lat*Math.PI/180))/Math.PI)*1000; // lon
        return offsets;
    }

    private double[] coordinate_after_rotation(double lat, double lon, double degree, double[] offsets) {
        double[] coordinate = new double[2];
        coordinate[0] = lat + Math.sin(Math.toRadians(degree))*offsets[0];
        coordinate[1] = lon + Math.cos(Math.toRadians(degree))*offsets[1];
        return coordinate;
    }

    // [8b30e3634d61fff, 8b30e3634c20fff, 8b30e3634c12fff, ... ]
    private List<String> hexagonsAddress(Point start, Point mid) throws IOException {
        double radius = distance(start.getLatitude(), start.getLongitude(), mid.getLatitude(), mid.getLongitude());
        double[] offsets = calc_offsets(radius, mid.getLatitude());
        // 헥사곤 경계 좌표 리스트
        List<LatLng> polygon = new ArrayList<>();
        for(int d=0; d<=360; d+=45){
            double[] coordinate = coordinate_after_rotation(mid.getLatitude(), mid.getLongitude(), d, offsets);
            polygon.add(new LatLng(coordinate[0], coordinate[1])); // lat, lon
        }

        H3Core h3 = H3Core.newInstance();
        int res = 11;

        return h3.polygonToCellAddresses(polygon, null, res);
    }

    // [Point(longitude=127.38555434963529, latitude=36.41950933776037)...]
    private List<Point> hexagonsCoordinates(List<String> hexagons) throws IOException {
        H3Core h3 = H3Core.newInstance();
        List<List<List<LatLng>>> coordinates = h3.cellAddressesToMultiPolygon(hexagons, true);

        List<Point> list = new ArrayList<>();
        for(int i=0; i<coordinates.get(0).get(0).size(); i++){
            list.add(new Point(coordinates.get(0).get(0).get(0).lat, coordinates.get(0).get(0).get(0).lng));
        }
        return list;
    }
}
