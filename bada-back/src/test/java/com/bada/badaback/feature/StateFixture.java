package com.bada.badaback.feature;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.state.domain.State;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum StateFixture {
    STATE1("36.421518","127.391538","36.421914","127.38412","36.421518","127.391538");

    private final String startLatitude;
    private final String startLongitude;

    private final String endLatitude;
    private final String endLongitude;

    private final String nowLatitude;
    private final String nowLongitude;

    public State toState(Member child){
        return State.createState(startLatitude,startLongitude,endLatitude,endLongitude,nowLatitude,nowLongitude,child);
    }
}
