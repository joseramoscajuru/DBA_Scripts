

select name from v$datafile;
union all
select name from v$tempfile;
union all
select member from v$logfile;
union all
select name from v$controlfile;

