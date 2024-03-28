package com.bada.badaback.safefacility.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class Tile{
    //해당 타일의 헥사곤 주소
    private String HexAddr;
    //안에 있는 cctv의 개수
    public int cctvCount;
    //주변 환경 변수
    public int envir;
    //출발지로부터의 거리
    public long dist;

    public Tile(String HexAddr) {
        this.HexAddr = HexAddr;
    }

}