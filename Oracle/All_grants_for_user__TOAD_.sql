
select tpm.name privilege,
       decode(mod(oa.option$,2), 1, 'YES', 'NO') grantable,
       ue.name grantee,
       ur.name grantor,
       u.name owner,
       decode(o.TYPE#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                       4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                       7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                       11, 'PACKAGE BODY', 12, 'TRIGGER',
                       13, 'TYPE', 14, 'TYPE BODY',
                       19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                       22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                       28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                       32, 'INDEXTYPE', 33, 'OPERATOR',
                       34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                       40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                       42, 'MATERIALIZED VIEW',
                       43, 'DIMENSION',
                       44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                       66, 'JOB', 67, 'PROGRAM', 74, 'SCHEDULE',
                       48, 'CONSUMER GROUP',
                       51, 'SUBSCRIPTION', 52, 'LOCATION',
                       55, 'XML SCHEMA', 56, 'JAVA DATA',
                       57, 'EDITION', 59, 'RULE',
                       62, 'EVALUATION CONTEXT',
                       'UNDEFINED') object_type,
       o.name object_name,
       '' column_name
        from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
             table_privilege_map tpm
        where oa.obj# = o.obj#
          and oa.grantor# = ur.user#
          and oa.grantee# = ue.user#
          and oa.col# is null
          and oa.privilege# = tpm.privilege
          and u.user# = o.owner#
          and o.TYPE# in (2, 4, 6, 9, 7, 8, 42, 23, 22, 13, 33, 32, 66, 67, 74, 57)
  and ue.name = 'MONIT'
  and bitand (o.flags, 128) = 0
union all -- column level grants
select tpm.name privilege,
       decode(mod(oa.option$,2), 1, 'YES', 'NO') grantable,
       ue.name grantee,
       ur.name grantor,
       u.name owner,
       decode(o.TYPE#, 2, 'TABLE', 4, 'VIEW', 42, 'MATERIALIZED VIEW') object_type,
       o.name object_name,
       c.name column_name
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and bitand(c.property, 32) = 0 /* not hidden column */
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and u.user# = o.owner#
  and o.TYPE# in (2, 4, 42)
  and ue.name = '&USER'
  and bitand (o.flags, 128) = 0;