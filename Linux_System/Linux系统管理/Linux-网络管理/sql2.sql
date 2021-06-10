SELECT
 count(1)
FROM
 t_recording r
WHERE
 r.start_time BETWEEN '2020-07-01 00:00:00' AND '2020-07-04 00:00:00';




SELECT
 count(1)
FROM
 fact_call f
WHERE
f.tenant_id = 'fecfe480-999d-44ba-a0e9-1f4f560253b9' and
 f.begin_time BETWEEN '2020-07-01 00:00:00' AND '2020-07-04 00:00:00'
AND f.first_answer_time IS NOT NULL;