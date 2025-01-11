	## FTP

> enviar arquivo via FTP, 
scp <arquivo> <nome do usuario>@<ip>:

=======================================

	## MONTANDO UM NFS

# mount <servidor/caminho> <ponto de montagem local>

Exemplo:

# mount or-cemat-03:/dsk1/elucid/ue /elucid/ue
............................

## QUANDO O NFS NO MONTAR, PRA SABER O CAMINHO CORRETO A SEGUIR

# nfso -p -o nfs_use_reserved_ports=1

....................................................

## CONFIGURANDO UM FILESYSTEM COMO NFS E EXPORTANDO O MESMO A OUTRAS MQUINAS

1) Adicionar ao arquivo /etc/exports as informaes do filesystem a ser exportado:

# vi /etc/exports

/WEWITS -sec=sys:none,rw,access=cabrshorsap04_gb:cabrshorsap05_gb:cabrshorsap06_gb:cabrshorsap07_gb:cabrshorsap08_gb,root=cabrshorsap04_gb:cabrshor
sap05_gb:cabrshorsap06_gb:cabrshorsap07_gb:cabrshorsap08_gb

* Onde colocamos o nome do filesystem e aps os nomes dos servidores onde sero exportados.

2) Executar o comando exportfs para validar a modificao no arquivo /etc/exports:

# exportfs -a -v

root@cabrshorsap03:/# exportfs -a -v
exportfs: 1831-187 re-exported /DEGLIS
exportfs: 1831-187 re-exported /CARRIERARG
exportfs: 1831-187 re-exported /DEGNFA
exportfs: 1831-187 re-exported /DEGNFS
exportfs: 1831-187 re-exported /DEGPRD
exportfs: 1831-187 re-exported /RTOCOT
exportfs: 1831-187 re-exported /RYDERARG
exportfs: 1831-187 re-exported /interfaces
exportfs: 1831-187 re-exported /sapmnt/PRD
exportfs: 1831-187 re-exported /usr/sap/interfaces
exportfs: 1831-187 re-exported /WEWITS
root@cabrshorsap03:/#

3) Ir ao servidor onde o mesmo ser montado, criar o diretrio e dar as permisses iguais ao do servidor que est exportando:

Exemplo: montando o nfs /WEWITS que est vindo do servidor cabrshorsap03_gb

# mkdir /WEWITS 
# chmod 755  /WEWITS
# chown pradm:sapsys /WEWITS
chown oracle:dba /cifs/bartender
chown oracle:dba bartender

# mount cabrshorsap03_gb:/WEWITS /WEWITS

4) Ir ao arquivo /etc/filesystems e configurar o mesmo para quando o servidor bootar, montar automticamente o NFS:

# vi /etc/filesystems

Adicionar a linha abaixo ou copiar a ltima do prprio arquivo, alterando apenas o nome do filesystem e o servidor de onde vem:

/WEWITS:
        dev             = "/WEWITS"
        vfs             = nfs
        nodename        = cabrshorsap03_gb
        mount           = true
        options         = bg,soft,intr,sec=sys
        account         = false

