SELECT DISTINCT
 r.call_id,
 r.ani,
 ifnull(TIMESTAMPDIFF(SECOND,r.start_time,r.end_time),0) as answer_length,
 r.start_time as begin_time,
 case when r.call_direction='Inbound' then 0
       when r.call_direction='Outbound' then 1
    when r.call_direction='Internal' then 2
    when r.call_direction='PreOccupied' then 4
    when r.call_direction='PreDictive' then 5
       else '' 
  end as call_type,
 case when r.call_direction='Inbound' then '呼入'
       when r.call_direction='Outbound' then '呼出'
    when r.call_direction='Internal' then '内线'
    when r.call_direction='PreOccupied' then '预占'
    when r.call_direction='PreDictive' then '预测'
       else '' 
  end as call_type_name,
 0 as conference,
 r.dnis,
 r.end_time,
 1 as end_type,
 '用户挂断' as end_type_name,
 0 as fee,
 r.agent as first_agent_no,
 0 as first_alert_length,
 r.start_time as first_answer_time,
 0 as first_queue_length,
 r.queue as first_queue_no,
 '' as first_rp_no,
 r.device_id as first_station_no,
 0 as internal_transferred,
 r.call_length as length,
 u.org_id,
 '' as relate_call,
 r.end_time as report_time,
 '' as satisfaction,
 ifnull(TIMESTAMPDIFF(SECOND,r.start_time,r.end_time),0) as talk_length,
 r.tenant_id,
 CONCAT(DATE_FORMAT(r.end_time,'%Y%m%d%H'),RIGHT((100+FLOOR(DATE_FORMAT(NOW(),'%i')/15)*15),2)) as time_id,
 0 as total_score,
 '' as trunk_group_no,
 '' as trunk_no,
 u.id as user_id,
 u.user_name
FROM
  t_recording r,
  t_agent a,
  t_user u
WHERE
 a.id=u.id
and r.agent = CONCAT(a.`code`, '@', u.namespace)
and r.call_id NOT IN (
SELECT f.call_id FROM fact_call f WHERE f.begin_time BETWEEN '2020-07-01 00:00:00' and '2020-07-03 23:00:00'
)
and r.start_time BETWEEN '2020-07-01 00:00:00' and '2020-07-03 23:00:00'