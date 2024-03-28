package com.bada.badaback.alarmlog.domain;


import com.bada.badaback.global.BaseTimeEntity;
import com.bada.badaback.member.domain.Member;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
@Table(name = "alarm_log")
public class AlarmLog extends BaseTimeEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "alarm_id")
  private Long id;


  @Column(nullable = false)
  private String type;

  @Column(name = "child_id", nullable = false)
  private Long childId;


  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "member_id", referencedColumnName = "member_id", nullable = false)
  private Member member;

  private AlarmLog(String type, Member member, Long childId) {
    this.type = type;
    this.member = member;
    this.childId = childId;
  }

  public static AlarmLog createAlarmLog(String type, Member member, Long childId) {
    return new AlarmLog(type, member, childId);
  }

}
