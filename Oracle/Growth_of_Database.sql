Average growth? I would try something like this:
 
 with TSIZES AS (
     select ts.tsname,tu.tablespace_size,
         lag(tu.tablespace_size) over
            (partition by tu.tablespace_id order by tu.snap_id) as prev_size
 from dba_hist_tablespace ts,DBA_HIST_TBSPC_SPACE_USAGE tu
 where ts.ts#=tu.TABLESPACE_ID and
       ts.contents='PERMANENT')
 select tsname,avg(tablespace_size - prev_size)
 from TSIZES
 group by tsname
 /
 
 The problem with that is the fact that the snapshot is taken whenever  AWR snapshot is taken, which makes the snapshots very frequent and the  average meaningless. If I were you, I would create my own snapshot  mechanism. As a matter of fact, I did just that for one of my previous  employers. Snapshots were taken weekly, because the employer was  interested in weekly growth. You can also create daily snapshots and  create a cosy little MVIEW which will be populated every Sunday. This is  not a hard exercise. 
 
 ==================================================================================
 
 SELECT 
   c.name, 
   ROUND(a.tablespace_USEDsize*8192/(1024*1024*1024)) size_last_week_gb, 
   ROUND(b.tablespace_USEDsize*8192/(1024*1024*1024)) size_current_gb 
 FROM 
   dba_hist_tbspc_space_usage a, 
   dba_hist_tbspc_space_usage b, 
   v$tablespace c 
 WHERE 
   a.tablespace_id  =b.tablespace_id 
 AND b.tablespace_id=c.ts# 
 AND a.rtime        = 
   ( 
     SELECT 
       MIN(rtime) 
     FROM 
       dba_hist_tbspc_space_usage 
     WHERE 
       to_date(rtime,'mm/dd/yyyy hh24:mi:ss')>=sysdate-7 
   ) 
 AND b.rtime= 
   ( 
     SELECT 
       MAX(rtime) 
     FROM 
       dba_hist_tbspc_space_usage 
     WHERE 
       to_date(rtime,'mm/dd/yyyy hH24:mi:ss')>=sysdate-7 
   ) 
 AND a.tablespace_id IN 
   ( 
     SELECT 
       ts# 
     FROM 
       v$tablespace 
     WHERE 
       name IN ('TSNAME') 
   )                                           
   
   =========================================================================================
   
                           
Growth of a Database                 
 Hi all, I was intrested to find the growth of the db and  framed the following query...
 SELECT b.snap_id,
   A.TSNAME,
   ROUND((TABLESPACE_SIZE*8*1024)/1024/1024,2) SIZE_MB,
 ROUND((TABLESPACE_MAXSIZE*8*1024)/1024/1024,2) MAXSIZE_MB,
 ROUND((TABLESPACE_USEDSIZE*8*1024)/1024/1024,2) USEDSIZE_MB
 FROM DBA_HIST_TABLESPACE A,
   DBA_HIST_TBSPC_SPACE_USAGE B
 WHERE A.TS#=B.TABLESPACE_ID 
 --and a.snap_id=b.snap_id
 and a.tsname='TS_OGRDS';
 
 
 But the output of this query is not matching with the 
 select maxbytes/1024/1024,user_bytes/1024/1024/1024,bytes/1024/1024 from dba_data_files where tablespace_name='TS_OGRDS';  
 
 query for the last snapshot. 
 
 Is there any way other than this to find the avergae growth of database.  if not can someone help in identifying the issue in the first query.  thanks in advance....
            