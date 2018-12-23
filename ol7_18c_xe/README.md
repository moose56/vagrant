# Oracle 18c XE

## Pre-requisites 

Get Oracle Enterprise Linux Vagrant box:

```bash
$ vagrant box add --name ol76 https://yum.oracle.com/boxes/oraclelinux/ol76/ol76.box
```

Get Oracle Database XE Quick Start:

```bash
$ cd artifacts
$ wget https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html
```

Get Sample Schemas:

```bash
$ cd artifacts
$ wget https://github.com/oracle/db-sample-schemas/releases
```

### Create VM and install database software

```bash
$ vagrant up
$ vagrant ssh
$
$ sudo /etc/init.d/oracle-xe-18c configure
# when prompted set password to be oracle
$
$ . oraenv
$ ORACLE_SID = [vagrant] ? XE
$
$ sudo echo 'USE_SID_AS_SERVICE_listener=on' >> $ORACLE_HOME/network/admin/listener.ora
$ sudo /opt/oracle/product/18c/dbhomeXE/bin/lsnrctl relead
```

Install sample schemas

```bash
$ sudo yum install perl
$
$ cd /vagrant/artifacts/db-sample-schemas-18c
$
$ perl -p -i.bak -e 's#__SUB__CWD__#'$(pwd)'#g' *.sql */*.sql */*.dat
$
$ sqlplus system/oracle@XEPDB1
$ @mksample oracle oracle hrpw oepw pmpw ixpw shpw bipw users temp /vagrant/artifacts/db-sample-schemas-18c/log/ localhost:1521/XEPDB1
```

### Useful links
- https://www.oracle.com/database/technologies/appdev/xe/quickstart.html
- https://yum.oracle.com/boxes
- https://github.com/oracle/db-sample-schemas/releases
- https://oracle-base.com/articles/18c/oracle-db-18c-xe-rpm-installation-on-oracle-linux-6-and-7
- https://oracle-base.com/articles/misc/install-sample-schemas
- https://oracle-base.com/articles/12c/multitenant-connecting-to-cdb-and-pdb-12cr1#pdb
- https://geraldonit.com/2018/10/23/how-to-install-oracle-database-18c-xe-on-linux/
