SELECT 
 '${platform}' as 'platform',
 r.call_id,
 r.id 'recording_id',
 ifnull(substring_index(r.agent,'@',1),'') 'agent_no',
 ifnull(substring_index(r.device_id,'@',1),'') 'extension_no',
 ifnull(r.start_time,'2000-01-01 00:00:00') 'rec_start_ts',
 ifnull(r.end_time,'2000-01-01 00:00:00') 'rec_end_ts',
 ifnull(r.call_length,-1) 'rec_length',
 r.filename 'rec_filename',
 now() as 'insert_ts'
FROM t_recording r
left join t_recording_repo rr on r.recording_repo_id=rr.id
WHERE r.tenant_id = '${welljointTenantId}'
AND r.start_time >= '${beginTime}'
AND r.start_time &lt; '${endTime}'
AND r.recording_repo_id is null

UNION

SELECT 
 '${platform}' as 'platform',
 r.call_id,
 r.id 'recording_id',
 ifnull(substring_index(r.agent,'@',1),'') 'agent_no',
 ifnull(substring_index(r.device_id,'@',1),'') 'extension_no',
 ifnull(r.start_time,'2000-01-01 00:00:00') 'rec_start_ts',
 ifnull(r.end_time,'2000-01-01 00:00:00') 'rec_end_ts',
 ifnull(r.call_length,-1) 'rec_length',
 concat(rr.url,r.filename) 'rec_filename',
 now() as 'insert_ts'
FROM t_recording r
left join t_recording_repo rr on r.recording_repo_id=rr.id
WHERE r.tenant_id = '${welljointTenantId}'
AND r.start_time >= '${beginTime}'
AND r.start_time &lt; '${endTime}'
AND r.recording_repo_id is not null