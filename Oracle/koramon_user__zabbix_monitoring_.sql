
CREATE USER "KORAMON" IDENTIFIED BY VALUES 'S:F49DD879CF4219208FA2FA3A93C98E2F1604C9CB1302AE1BEE0D292709BE;T:7848A60399D8B259C1F2DDCA40A4F19096303652D431B402D9AD0DA432F83840EC608AECD067166CD1EA8DFA2BBFFCB3576EFCA0D77021EAAAB4BBDA769FC208CCD21879E8598370D9C04EF4967A617B'
      DEFAULT TABLESPACE "SYSAUX"
      TEMPORARY TABLESPACE "TEMP"
      PROFILE "MONITORING_PROFILE"
  GRANT SELECT ANY DICTIONARY TO "KORAMON"                              ;
  GRANT CREATE SESSION TO "KORAMON"                                     ;
  GRANT SELECT ON "SYS"."UNDO$" TO "KORAMON"                            ;
  GRANT SELECT ON "SYS"."TS$" TO "KORAMON"                              ;
  GRANT SELECT ON "SYS"."V_$LOG" TO "KORAMON"                           ;
  GRANT SELECT ON "SYS"."V_$STANDBY_LOG" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."V_$DATAGUARD_STATUS" TO "KORAMON"              ;
  GRANT SELECT ON "SYS"."V_$BGPROCESS" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."V_$LOGFILE" TO "KORAMON"                       ;
  GRANT SELECT ON "SYS"."V_$PARAMETER" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."V_$SPPARAMETER" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."V_$DATABASE" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."V_$INSTANCE" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."V_$VERSION" TO "KORAMON"                       ;
  GRANT SELECT ON "SYS"."V_$ARCHIVED_LOG" TO "KORAMON"                  ;
  GRANT SELECT ON "SYS"."V_$LOG_HISTORY" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."V_$ARCHIVE_GAP" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."V_$DATAFILE_HEADER" TO "KORAMON"               ;
  GRANT SELECT ON "SYS"."V_$DATAFILE" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."V_$TEMPFILE" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."V_$TABLESPACE" TO "KORAMON"                    ;
  GRANT SELECT ON "SYS"."V_$MANAGED_STANDBY" TO "KORAMON"               ;
  GRANT SELECT ON "SYS"."V_$DATAGUARD_STATS" TO "KORAMON"               ;
  GRANT SELECT ON "SYS"."V_$RECOVERY_PROGRESS" TO "KORAMON"             ;
  GRANT SELECT ON "SYS"."V_$ACTIVE_INSTANCES" TO "KORAMON"              ;
  GRANT SELECT ON "SYS"."V_$ARCHIVE_DEST_STATUS" TO "KORAMON"           ;
  GRANT SELECT ON "SYS"."V_$LOCK_TYPE" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$RESOURCE_LIMIT" TO "KORAMON"               ;
  GRANT SELECT ON "SYS"."GV_$PGA_TARGET_ADVICE" TO "KORAMON"            ;
  GRANT SELECT ON "SYS"."GV_$PGASTAT" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$DLM_MISC" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$GES_BLOCKING_ENQUEUE" TO "KORAMON"         ;
  GRANT SELECT ON "SYS"."GV_$BUFFER_POOL_STATISTICS" TO "KORAMON"       ;
  GRANT SELECT ON "SYS"."GV_$LOG" TO "KORAMON"                          ;
  GRANT SELECT ON "SYS"."GV_$PROCESS" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$SESSION" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$LOCKED_OBJECT" TO "KORAMON"                ;
  GRANT SELECT ON "SYS"."GV_$LATCH" TO "KORAMON"                        ;
  GRANT SELECT ON "SYS"."GV_$LATCH_CHILDREN" TO "KORAMON"               ;
  GRANT SELECT ON "SYS"."GV_$LOCK" TO "KORAMON"                         ;
  GRANT SELECT ON "SYS"."GV_$SYSSTAT" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$OSSTAT" TO "KORAMON"                       ;
  GRANT SELECT ON "SYS"."GV_$FILESTAT" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$FLASHBACK_DATABASE_LOGFILE" TO "KORAMON"   ;
  GRANT SELECT ON "SYS"."GV_$FLASHBACK_DATABASE_LOG" TO "KORAMON"       ;
  GRANT SELECT ON "SYS"."GV_$ROLLSTAT" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$UNDOSTAT" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$SGA" TO "KORAMON"                          ;
  GRANT SELECT ON "SYS"."GV_$CLUSTER_INTERCONNECTS" TO "KORAMON"        ;
  GRANT SELECT ON "SYS"."GV_$PARAMETER" TO "KORAMON"                    ;
  GRANT SELECT ON "SYS"."GV_$SYSTEM_PARAMETER" TO "KORAMON"             ;
  GRANT SELECT ON "SYS"."GV_$LIBRARYCACHE" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."GV_$INSTANCE" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$SQL" TO "KORAMON"                          ;
  GRANT SELECT ON "SYS"."GV_$OPTION" TO "KORAMON"                       ;
  GRANT SELECT ON "SYS"."GV_$SGASTAT" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$SGAINFO" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$DATAFILE_HEADER" TO "KORAMON"              ;
  GRANT SELECT ON "SYS"."GV_$ARCHIVE_DEST" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."GV_$SESSION_WAIT" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."GV_$SESS_IO" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."GV_$SORT_SEGMENT" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."GV_$ARCHIVE_DEST_STATUS" TO "KORAMON"          ;
  GRANT SELECT ON "SYS"."GV_$SEGMENT_STATISTICS" TO "KORAMON"           ;
  GRANT SELECT ON "SYS"."GV_$ENQUEUE_STAT" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."GV_$ASM_TEMPLATE" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."V_$ASM_DISKGROUP" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."GV_$ASM_DISK_STAT" TO "KORAMON"                ;
  GRANT SELECT ON "SYS"."GV_$ASM_CLIENT" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."V_$RECOVERY_FILE_DEST" TO "KORAMON"            ;
  GRANT SELECT ON "SYS"."GV_$SYSMETRIC" TO "KORAMON"                    ;
  GRANT SELECT ON "SYS"."GV_$SYSMETRIC_HISTORY" TO "KORAMON"            ;
  GRANT SELECT ON "SYS"."V_$ACTIVE_SESSION_HISTORY" TO "KORAMON"        ;
  GRANT SELECT ON "SYS"."GV_$SERVICES" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."GV_$SYSMETRIC_SUMMARY" TO "KORAMON"            ;
  GRANT SELECT ON "SYS"."GV_$FILEMETRIC" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."DBA_CLUSTERS" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."DBA_INDEXES" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."DBA_OBJECTS" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."DBA_TABLES" TO "KORAMON"                       ;
  GRANT SELECT ON "SYS"."DBA_EXTENTS" TO "KORAMON"                      ;
  GRANT SELECT ON "SYS"."DBA_UNDO_EXTENTS" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."DBA_FREE_SPACE" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."DBA_DATA_FILES" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."DBA_TABLESPACES" TO "KORAMON"                  ;
  GRANT SELECT ON "SYS"."DBA_TEMP_FILES" TO "KORAMON"                   ;
  GRANT SELECT ON "SYS"."DBA_TABLESPACE_USAGE_METRICS" TO "KORAMON"     ;
  GRANT SELECT ON "SYS"."V_$LOGSTDBY_STATS" TO "KORAMON"                ;
  GRANT SELECT ON "SYS"."V_$LOGSTDBY_PROGRESS" TO "KORAMON"             ;
  GRANT SELECT ON "SYS"."V_$LOGSTDBY_STATE" TO "KORAMON"                ;
  GRANT SELECT ON "SYS"."DBA_HIST_SNAPSHOT" TO "KORAMON"                ;
  GRANT SELECT ON "SYS"."DBA_HIST_SQLSTAT" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."DBA_HIST_SQLTEXT" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."DBA_HIST_SQL_PLAN" TO "KORAMON"                ;
  GRANT SELECT ON "SYS"."DBA_HIST_SYSMETRIC_SUMMARY" TO "KORAMON"       ;
  GRANT SELECT ON "SYS"."GV_$BGPROCESS" TO "KORAMON"                    ;
  GRANT SELECT ON "SYS"."GV_$ASM_DISKGROUP_STAT" TO "KORAMON"           ;
  GRANT SELECT ON "SYS"."V_$LOGSTDBY_PROCESS" TO "KORAMON"              ;
  GRANT SELECT ON "SYS"."V_$RESTORE_POINT" TO "KORAMON"                 ;
  GRANT SELECT ON "SYS"."DBA_LIBRARIES" TO "KORAMON"                    ;
  GRANT SELECT ON "SYS"."OBJ$" TO "KORAMON"                             ;
  GRANT SELECT ON "SYS"."DBA_SEGMENTS" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."DBA_USERS" TO "KORAMON"                        ;
  GRANT SELECT ON "SYS"."V_$ARCHIVE_DEST" TO "KORAMON"                  ;
  GRANT SELECT ON "SYS"."GV_$ROWCACHE" TO "KORAMON"                     ;
  GRANT SELECT ON "SYS"."V_$FLASH_RECOVERY_AREA_USAGE" TO "KORAMON"     ;

