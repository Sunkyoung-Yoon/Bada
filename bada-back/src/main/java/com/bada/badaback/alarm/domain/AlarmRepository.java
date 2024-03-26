package com.bada.badaback.alarm.domain;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface AlarmRepository extends JpaRepository<AlarmLog, Long> {

  @Query(nativeQuery = true, value = "select * from alarm_log a where a.member_id = :memberId")
  List<AlarmLog> findAllAlarmLogsbyMemberId(@Param("memberId") Long memberId);

}
