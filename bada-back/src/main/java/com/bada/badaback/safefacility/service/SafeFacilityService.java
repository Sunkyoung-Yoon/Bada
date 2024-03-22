package com.bada.badaback.safefacility.service;

import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.domain.SafeFacility;
import com.bada.badaback.safefacility.domain.SafeFacilityRepository;
import com.bada.badaback.safefacility.dto.SafeFacilityResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    public SafeFacilityResponseDto getCCTVs(String startX, String startY, String endX, String endY) {
        Point start = Point.builder()
                .longitude(Double.parseDouble(startX))
                .latitude(Double.parseDouble(startY))
                .build();

//                new Point(Double.parseDouble(startY), Double.parseDouble(startX));
        Point end = Point.builder()
                .latitude(Double.parseDouble(endY))
                .longitude(Double.parseDouble(endX))
                .build();

        //도착지와 출발지의 h3값 찾기
//        H3Core h3 = H3Core.newInstance();
//        int res = 14;
//        String startHexAddr = h3.latLngToCellAddress(s0tart.getLatitude(), start.getLongitude(), res);
//        String endHexAddr = h3.latLngToCellAddress(end.getLatitude(), end.getLongitude(), res);
//
//        System.out.println("출발지 헥사곤 주소: " + startHexAddr);
//        System.out.println("도착지 헥사곤 주소: " + endHexAddr);
//
//        System.out.println("출발지와 도착지 거리: " + h3.gridDistance(startHexAddr, endHexAddr));
        //범위안의 그리드 다 가져오기
//        h3.polygonToCellAddresses();

        //가운데 좌표 가져와서 그곳을 기준으로 300m거리안에 있는 cctv 데이터를 가져오고 안에서 순서대로 최대 3개만 골라서 넘긴다


        Point mid = calculateMidpoint(start, end);
//        System.out.println("start: " + start);
//        System.out.println("end: " + end);
//        System.out.println("mid: " + mid);
        Double sLatRad = Math.toRadians(90 - start.getLatitude());
        Double seLongRad = Math.toRadians(start.getLongitude()-end.getLongitude());
        Double eLatRad = Math.toRadians(90 - end.getLatitude());

        //시작 ~ 도착 거리 계산
        Double distance = 6371 * Math.acos(Math.cos(sLatRad)*Math.cos(eLatRad)+Math.sin(sLatRad)*Math.sin(eLatRad)*Math.cos(seLongRad));
//        System.out.println("start ~ end distance: " + distance/2);
//                ACOS(COS()*COS()+SIN()*SIN()*COS())

        List<SafeFacility> paths = safeFacilityRepository.getCCTVs(mid.getLatitude().toString(), mid.getLongitude().toString(),distance/2);

//        System.out.println("중간 cctv 개수: " + paths.size());
        Iterator<SafeFacility> pathIterator = paths.iterator();

        //String을 포인트 여러개로 만들기
        StringBuilder stringBuilder = new StringBuilder();
        int count = 0;
        while (pathIterator.hasNext()) {
            count++;
            SafeFacility next = pathIterator.next();
            stringBuilder.append(next.getFacilityLongitude() + ", " + next.getFacilityLatitude());
            if (count == 3) {
                break;
            }
            if (pathIterator.hasNext()) {
                stringBuilder.append("_");
            }
        }
//        System.out.println(stringBuilder);

        SafeFacilityResponseDto safeFacilityResponseDto = SafeFacilityResponseDto.from(start, end, stringBuilder.toString());

        return safeFacilityResponseDto;
    }

    public static Point calculateMidpoint(Point start, Point end) {
        // 위도와 경도의 평균값 계산
        double midLat = (start.getLatitude() + end.getLatitude()) / 2;
        double midLong = (start.getLongitude() + end.getLongitude()) / 2;

        // 중간 좌표 반환
        return Point.builder()
                .latitude(midLat)
                .longitude(midLong)
                .build();
    }

}
