package com.bada.badaback.state.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.state.domain.State;
import com.bada.badaback.state.domain.StateRepository;
import com.bada.badaback.state.exception.StateErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StateFindService {
    private final StateRepository stateRepository;
    public State findByMember(Member child){
        return stateRepository.findByMember(child).orElseThrow(()->BaseException.type(StateErrorCode.STATE_NOT_FOUND));
    }

}
