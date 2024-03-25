package com.bada.badaback.state.service;

import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.state.domain.State;
import com.bada.badaback.state.domain.StateRepository;
import com.bada.badaback.state.dto.StateResponseDto;
import com.bada.badaback.state.exception.StateErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class StateService {
    private final StateRepository stateRepository;
    private final MemberFindService memberFindService;
    private final StateFindService stateFindService;

    /**
     * 아이의 상태 정보를 생성한다.
     * @param startLat
     * @param startLong
     * @param endLat
     * @param endLong
     * @param nowLat
     * @param nowLong
     * @param childId
     */
    @Transactional
    public void createState(String startLat, String startLong, String endLat, String endLong, String nowLat, String nowLong, Long childId) {
        Member child = memberFindService.findById(childId);
        State state = State.createState(startLat, startLong, endLat, endLong, nowLat, nowLong, child);
        stateRepository.save(state);
    }

    /**
     * 부모가 아이의 상태 정보를 조회한다.
     * @param parentId
     * @param childId
     * @return
     */
    public StateResponseDto findStateByMemberId(Long parentId, Long childId) {
        // 부모가 있는지 확인
        Member parent = memberFindService.findById(parentId);
        // 자식이 있는지 확인
        Member child = memberFindService.findById(childId);
        if (parent.getFamilyCode().equals(child.getFamilyCode())) {
            //같은 가족일 때
            State childState = stateFindService.findByMember(child);
            return StateResponseDto.from(childState);
        } else {
            //같은 가족이 아닐 때
            throw BaseException.type(StateErrorCode.NOT_FAMILY);
        }
    }

    /**
     * 아이의 상태 정보를 현재 위치로 수정한다.
     * @param childId
     * @param nowLat
     * @param nowLong
     * @return
     */
    @Transactional
    public void modifyState(Long childId, String nowLat, String nowLong) {
        Member child = memberFindService.findById(childId);
        State state = stateFindService.findByMember(child);
        state.updateState(nowLat, nowLong);
    }

    /**
     * 아이의 정보로 아이의 상태 정보를 찾고 삭제한다.
     * @param childId
     */
    @Transactional
    public void deleteState(Long childId) {
        Member child = memberFindService.findById(childId);
        State state = stateFindService.findByMember(child);
        stateRepository.delete(state);
    }

}
