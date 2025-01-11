O crontab funciona assim:

minuto ........	0-59
hora ..........	0-23
dia do mes ....	1-31
mes ...........	1-12
dia da semana..	0-7 ( 0 ou 7  domingo ou use nomes)

Por exemplo:

00 23 * * 1-6 /usr/local/sbin/scrip.sh

Vai executar o scrip em /usr/local/sbin/, todos dias, em todos os meses,
s 23 00 horas da noite, somente de segunda s sbado (1-6)

===============================================================

## Remember...
# field 1    minutes 0-59
# field 2    hours   0-23
# field 3    day     1-31
# field 4    month   1-12
# field 5    weekday 0=Sunday - 6=Saturday
#
# Sections:
# 1) LJHH Scripts and Tools
# 2) Nightly Exports
# 3) Statspack
# 4) File Maintenance
# 5) Application Specific
# 6) RMAN Scripts
#
#
# 4) File Maintenance       ========================================
#
# Remove old trace files
15 21 * * * find /oradata/*/admin/trace -name '*.trc' -mtime +10 -exec rm {} \; >/dev/null 2>&1
30 21 * * * find /oradata/*/admin/trace/cdump/* -mtime +10 -exec rm -rf {} \; >/dev/null 2>&1
#
# Remove oracle mail messages
30 05 * * 6 > /var/mail/orar3 > /dev/null 2>&1
#

