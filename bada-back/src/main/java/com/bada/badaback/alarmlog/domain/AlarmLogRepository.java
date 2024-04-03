package com.bada.badaback.alarmlog.domain;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AlarmLogRepository extends JpaRepository<AlarmLog, Long> {

//  @Query(nativeQuery = true, value = "select * from alarm_log a where a.member_id = :memberId")
//  List<AlarmLog> findAllAlarmLogsByMemberId(@Param("memberId") Long memberId, @Param("childId") Long childId);

  @Query(nativeQuery = true, value = "SELECT * FROM alarm_log a WHERE a.member_id = :memberId AND a.child_id = :childId")
  List<AlarmLog> findAllAlarmLogsByMemberIdAndChildId(@Param("memberId") Long memberId, @Param("childId") Long childId);

  @Query(nativeQuery = true, value = "SELECT count(*) FROM alarm_log a WHERE a.member_id = :memberId AND a.is_read = b'0'")
  Long getUnreadAlarmCount(Long memberId);
}
