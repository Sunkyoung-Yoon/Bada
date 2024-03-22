package com.bada.badaback.family.service;

import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.domain.FamilyRepository;
import com.bada.badaback.family.dto.FamilyPlaceListResponseDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.myplace.service.MyPlaceService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FamilyService {
    private final FamilyRepository familyRepository;
    private final FamilyFindService familyFindService;
    private final MyPlaceService myPlaceService;
    private final MemberFindService memberFindService;

    @Transactional
    public String create(String familyName) {
        String familyCode = createRandomCode();

        while(familyRepository.existsByFamilyCode(familyCode)){
            familyCode = createRandomCode();
        }

        Family family = Family.createFamily(familyCode, familyName);
        return familyRepository.save(family).getFamilyCode();
    }

    @Transactional
    public void update(Long memberId, Long myPlaceId) {
        Member findMember= memberFindService.findById(memberId);
        Family findFamily = familyFindService.findByFamilyCode(findMember.getFamilyCode());
        List<Long> placeList = findFamily.getPlaceList();
        if(placeList != null) {
            placeList.add(myPlaceId);
        }
        else {
            placeList = new ArrayList<>();
        }
        findFamily.updatePlaceList(placeList);
    }

    @Transactional
    public void delete(Long memberId) {
        Member findMember= memberFindService.findById(memberId);
        Family findFamily = familyFindService.findByFamilyCode(findMember.getFamilyCode());
        List<Long> placeList = findFamily.getPlaceList();

        if(placeList != null) {
            for(Long placeId : placeList){
                myPlaceService.delete(findMember.getId(), placeId);
            }
        }

        familyRepository.delete(findFamily);
    }

    @Transactional
    public FamilyPlaceListResponseDto myPlaceIdList(Long memberId) {
        Member findMember= memberFindService.findById(memberId);
        Family findFamily = familyFindService.findByFamilyCode(findMember.getFamilyCode());
        return FamilyPlaceListResponseDto.builder()
                .placeList(findFamily.getPlaceList())
                .build();
    }

    private String createRandomCode() {
        int certCharLength = 5;
        final char[] characterTable = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };

        Random random = new Random(System.currentTimeMillis());
        int tablelength = characterTable.length;
        StringBuffer buf = new StringBuffer();

        for(int i = 0; i < certCharLength; i++) {
            buf.append(characterTable[random.nextInt(tablelength)]);
        }
        return buf.toString();
    }
}
