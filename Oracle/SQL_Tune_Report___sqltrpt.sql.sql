
@?/rdbms/admin/sqltrpt.sql
15 Most expensive SQL in the cursor cache
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     
SQL_ID ELAPSED SQL_TEXT_FRAGMENT
------------- ---------- -------------------------------------------------------
12u9ywbc8bav4 92,753.58 BEGIN IFSCPSA.FN_CALCULATE_UTIL_API.Confirm(:a,
4qrnht261tyz7 84,485.09 BEGIN IFSCPSA.PRINT_QUEUE_API.GET_JOB (:1,:2,:3,:4,:5);
0a6b85dfpsazp 70,629.93 BEGIN :1 := IFSCPSA.Print_Queue_Api.Get_Job_Count(:2);E
7s9869f98vv9p 61,808.56 BEGIN Transaction_SYS.Process_All_Pending__(0,Fila Pad
gtn5ca2ddwu4u 51,818.23 DECLARE job BINARY_INTEGER := :job; next_date DATE := :
f16z0xbqps4u2 47,480.99 BEGIN IFSCPSA.Archive_API.New_Client_Report( :a, :
aza9a5vw8wbp6 32,919.00 DECLARE activity_info
d15cdr0zt3vtp 28,085.33 SELECT TO_CHAR(current_timestamp AT TIME ZONE GMT', 'Y
2uapsvuhsy8gz 23,506.88 BEGIN :1 := IFSCPSA.Login_SYS.Init_Fnd_Session_(:2,:3,:
ghskqf9p1q18r 23,192.74 SELECT PCT.ACTIVITY_SEQ, PROJ_LU_NAME_API.ENCODE(PCT.PR
08867nk50xwq2 12,805.82 BEGIN IFSCPSA.General_SYS.Init_Centura_Session__( :a, :
75wkg8n7w5kq8 7,961.63 BEGIN IFSCPSA.SUB_CON_AFP_VALUATION_ITEM_API.Get_Certif
ggxghqxc1rutz 7,077.76 BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(method_opt=>for a
dq2nf6w908668 6,920.79 BEGIN IFSCPSA.SUB_CON_AFP_VALUATION_API.Receive_Applica
294d759j31spg 6,820.41 BEGIN IFSCPSA.C_SUB_CON_AFP_VAL_ITEM_API.C_Create_PO(:
     
15 Most expensive SQL in the workload repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     
SQL_ID ELAPSED SQL_TEXT_FRAGMENT
------------- ---------- -------------------------------------------------------
d15cdr0zt3vtp ########## SELECT TO_CHAR(current_timestamp AT TIME ZONE GMT', 'Y
ggxghqxc1rutz 56,962.27 BEGIN DBMS_STATS.GATHER_SCHEMA_STATS(method_opt=>for a
4qrnht261tyz7 39,923.51 BEGIN IFSCPSA.PRINT_QUEUE_API.GET_JOB (:1,:2,:3,:4,:5);
7bms1cxt05sgq 37,893.08 SELECT P.ROWID, P.PRINT_JOB_ID, P.PERFORM_PRINTER_ID, P
ghskqf9p1q18r 32,440.79 SELECT PCT.ACTIVITY_SEQ, PROJ_LU_NAME_API.ENCODE(PCT.PR
0a6b85dfpsazp 31,739.53 BEGIN :1 := IFSCPSA.Print_Queue_Api.Get_Job_Count(:2);E
12u9ywbc8bav4 31,476.15 BEGIN IFSCPSA.FN_CALCULATE_UTIL_API.Confirm(:a,
aza9a5vw8wbp6 30,957.19 DECLARE activity_info
gtn5ca2ddwu4u 30,022.45 DECLARE job BINARY_INTEGER := :job; next_date DATE := :
7s9869f98vv9p 30,004.68 BEGIN Transaction_SYS.Process_All_Pending__(0,Fila Pad
9qrdq4t66vadb 26,543.84 BEGIN Sub_Con_Item_API.Update_Data_Sub_Con_Summary; END
d6afxhmz4k82h 22,936.24 SELECT P.PERFORM_PRINTER_ID FROM PRINT_QUEUE_TAB P, PRI
f16z0xbqps4u2 21,174.17 BEGIN IFSCPSA.Archive_API.New_Client_Report( :a, :
ct2j94g7jnnw4 17,965.35 SELECT DISTINCT "CRYSTAL_DEMONSTRATIVO_PAG_"."CODIGO_G
b6usrg82hwsa3 17,529.75 call dbms_stats.gather_database_stats_job_proc ( )
     
Specify the Sql id
~~~~~~~~~~~~~~~~~~
Enter value for sqlid: ct2j94g7jnnw4
Sql Id specified: ct2j94g7jnnw4