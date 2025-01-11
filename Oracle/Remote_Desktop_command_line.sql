set ORACLE_SID=<instancia>

#Remote Desktop

rdesktop -d NA -u JUNIOJR -p "Rfv5tgbn2" -g 1366x768 -P -T 159.155.60.73 -r sound:local 159.155.60.73 & 

ACESSO REMOTE DESKTOP PARA TODAS AS CONTAS COM WINDOWS 7.

1.	Browse to %SystemRoot%\System32
2.	Right click mstsc.exe and choose Properties
3.	Go to the Security tab
4.	Click Advanced
5.	Go to the Owner tab
6.	Click Edit
7.	From the Change owner to: list, choose your user name
8.	Click OK
9.	Go to the Permissions tab
10.	Click Change Permissions
11.	Click Add
12.	Enter your user name and click OK
13.	Tick the box in the Allow column for Full control
14.	Click OK
15.	Click OK
16.	A Windows Security warning will come up; click Yes to proceed
17.	Click OK

- Renomeie o arquivo mstsc.exe dentro do diretrio %SystemRoot%\System32 para mstsc.exe.bak.
- Sempre que precisar acessar servidores windows, basta acessar o executvel do mstsc no caminho %SystemRoot%\SysWOW64\mstsc.exe para ficar mais fcil, crie um atalho em seu desktop.

Explicao.: O windows 7 64bits tem as duas verses de MSTSC.exe instalados (32bits %SystemRoot%\SysWOW64\mstsc.exe  e 64bits%SystemRoot%\System32\mstsc.exe), porm sempre que chamar o remote desktop, seja atravs do icone padro ou at mesmo pelo executvel do 32bits localizado na pasta SysWOW64, o windows sempre vai redirecionar automaticamente e abrir o MSTSC 64bits que no vai funcionar com o socks. Renomendo dessa forma, eliminamos o remote desktop 64bits do sistema e o socks funciona corretamente com o mstsc 32 bits.

