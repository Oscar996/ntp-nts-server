#!/bin/bash
#Script gerado por Oscar Santos em nome da K3G Solutions.
#Instalar ntpsec
apt update
apt install ntpsec -y
echo "ntpsec instalado com sucesso" || echo "Deu ruim na instalacao do ntpsec ¯\_(ツ)_/¯"

#Copiar as configuracoes padrao 
cp /etc/ntpsec/ntp.conf /etc/ntpsec/ntp.conf.default
echo "Copy ok" || echo "Deu ruim no copy ¯\_(ツ)_/¯"

#Remove o arquivo de configuracao (Relaxa, vai ter um novo)
rm /etc/ntpsec/ntp.conf
echo "RM ok" || echo "Deu ruim no RM ¯\_(ツ)_/¯"

#Criar um novo arquivo de configuracao
mkdir /var/log/ntpsec
echo "Diretorio de logs OK" || echo "Deu ruim na criacao do diretorio de logs ¯\_(ツ)_/¯"

#Configuraoes do ntpsec
tee /etc/ntpsec/ntp.conf <<EOF
# /etc/ntpsec/ntp.conf, configuration for ntpd; see ntp.conf(5) for help
driftfile /var/lib/ntpsec/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
# To enable Network Time Security support as a server, obtain a certificate
# (e.g. with Let's Encrypt), configure the paths below, and uncomment:
# nts cert CERT_FILE
# nts key KEY_FILE
# nts enable
# You must create /var/log/ntpsec (owned by ntpsec:ntpsec) to enable logging.
statsdir /var/log/ntpsec/
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
# This should be maxclock 7, but the pool entries count towards maxclock.
tos maxclock 11
# Comment this out if you have a refclock and want it to be able to discipline
# the clock by itself (e.g. if the system is not connected to the network).
tos minclock 4 minsane 3
# Specify one or more NTP servers.
server a.st1.ntp.br iburst nts
server b.st1.ntp.br iburst nts
server c.st1.ntp.br iburst nts
server d.st1.ntp.br iburst nts
server gps.ntp.br iburst nts
# Public NTP servers supporting Network Time Security:
server time.cloudflare.com nts
server nts.netnod.se iburst nts
# pool.ntp.org maps to about 1000 low-stratum NTP servers.  Your server will
# pick a different set every time it starts up.  Please consider joining the
# pool: <https://www.pool.ntp.org/join.html>
#pool 0.debian.pool.ntp.org iburst
#pool 1.debian.pool.ntp.org iburst
#pool 2.debian.pool.ntp.org iburst
#pool 3.debian.pool.ntp.org iburst
# Access control configuration; see /usr/share/doc/ntpsec-doc/html/accopt.html
# for details.
#
# Note that "restrict" applies to both servers and clients, so a configuration
# that might be intended to block requests from certain clients could also end
# up blocking replies from your own upstream servers.
# By default, exchange time with everybody, but don't allow configuration.
restrict default kod nomodify nopeer noquery limited
# Local users may interrogate the ntp server more closely.
restrict default kod nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
EOF

echo "Tee OK" || echo "Deu ruim no Tee ¯\_(ツ)_/¯"

#Reinicar serviço NTP
systemctl restart ntpsec
echo "ntpsec reiniciado" || echo "falha ao reiniciar ntpsec ¯\_(ツ)_/¯"
sleep 2

#Verificar status dos servers NTP
ntpq -c rl
echo "NTP/NTS Servers OK" || echo "Deu ruim ao consultar os ntp servers ¯\_(ツ)_/¯"
echo "------------"
echo "So far so good!"
echo "Wait for it"
sleep 6
echo "Wait for it!"
sleep 6
echo "Check this out!"
sleep 1
#Exibir sincronizacao dos ntp servers
ntpq -p

echo "Rodando liso" || echo "Deu ruim ao sincronizar com os ntp servers ¯\_(ツ)_/¯"
echo "Tudo certo meu patrão. Pode rodar na rede que deu bom."
echo "<(￣︶￣)>"
