#!/bin/bash
python3 /home/martin/webcrawler/crawler2.py | sort -t. -k2,2 -k1,1 >> /home/martin/webcrawler/scriptconfig/ny2.txt

sqlite3 /home/martin/webcrawler/postliste_2 <<EOS
create table table1(dato varchar(20) NOT NULL, saksnr varchar(20) NOT NULL, avsender varchar(50) NOT NULL, saksbehandler varchar(50) NOT NULL, tema varchar(100) NOT NULL, hentet varchar(20) NOT NULL);
.separator "#"
.import /home/martin/webcrawler/scriptconfig/ny2.txt table1

create table if not exists avsender(avsender varchar(50),
PRIMARY KEY(avsender));

create table if not exists post(saksnr varchar(15), tema varchar(100), dato varchar(15), avsender varchar(50), saksbehandler varchar(50), hentet varchar(20),
PRIMARY KEY(saksnr, dato),
FOREIGN KEY(dato) references dato(dato) ON UPDATE CASCADE,
FOREIGN KEY(saksbehandler) references saksbehandler(saksbehandler) ON UPDATE CASCADE,
FOREIGN KEY(avsender) references avsender(avsender) ON UPDATE CASCADE);

create table if not exists saksbehandler(saksbehandler varchar(50),
PRIMARY KEY(saksbehandler));

create table if not exists dato(dato date,
PRIMARY KEY(dato));

INSERT OR IGNORE INTO avsender SELECT DISTINCT avsender from table1;
INSERT OR IGNORE INTO saksbehandler SELECT DISTINCT saksbehandler FROM table1;
INSERT OR IGNORE INTO dato SELECT DISTINCT substr(dato, 7,4) || '-' || substr(dato, 4, 2) || '-' || substr(dato, 1, 2) FROM table1;
INSERT OR IGNORE INTO post SELECT saksnr, tema, substr(dato, 7,4) || '-' || substr(dato, 4, 2) || '-' || substr(dato, 1, 2), avsender, saksbehandler, hentet from table1;

drop table table1;
EOS

/home/martin/webcrawler/check.sh
/home/martin/webcrawler/vipcheck.sh
/home/martin/webcrawler/ole_check.sh
