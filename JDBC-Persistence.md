## Generic JDBC Persistence Service

### 1. Introduction

This service allows you to persist state updates using several databases. 
The *JDBC Persistence Service* is designed for a maximum of scalability. It is designed to store very large amounts of data and still over the years not to lose its speed.
The generic design allows developers relatively easy to integrate other databases.
It can act as a a replacement for the [MySQL-Persistence](https://github.com/openhab/openhab/wiki/MySQL-Persistence).

Currently the following databases are supported:
 - derby
 - h2
 - hsqldb
 - mariadb
 - mysql
 - postgresql
 - Sqlite

### 2. Features

General:
- Writing/reading information to relational database systems.
- Database Table Name Schema can be reconfigured after creation.
- Driver files do not increase the main JDBC Service Bundles file size. JDBC drivers are not compiled with into the bundle.
 
For Developers:
- Clearly separated Source for the database-specific part of OpenHab logic.
- Code duplication by similar services can be prevented.
- To integrate a new (SQL/JDBC enabled) database is fairly simple.


### 3. Installation

New Installation:
  1. For installation of this persistence bundle please follow the same steps as if you would [install a binding](Bindings).
  2. Copy the Database driver file to *${openhab.home}/addons* folder. 
  3. Place a persistence file called *jdbc.persist* into the *${openhab.home}/configuration/persistence* folder. This has the standard format as described in [[Persistence]].
  4. In openhab.cfg change *persistence: default* parameter from 'mysql' to 'jdbc'.

The JDBC bundle the tables schema, generated MYSQL bundle.
If you migrate from MYSQL bundle to JDBC bundle additionally do:
  1. Set *jdbc:tableNamePrefix=Item*
  2. Set *jdbc:tableUseRealItemNames=false* or comment it.
  3. Set *jdbc:tableIdDigitCount=0*

JDBC driver files can be found here:

DATABASE | TESTET FILE/VERSION | LINK
------------- | ------------- | -------------
Derby | derby-10.11.1.1.jar | http://mvnrepository.com/artifact/org.apache.derby/derby
H2 | h2-1.4.189.jar | http://mvnrepository.com/artifact/com.h2database/h2
HSQLDB | hsqldb-2.3.3.jar | http://mvnrepository.com/artifact/org.hsqldb/hsqldb
MariaDB | mariadb-java-client-1.2.0.jar | http://mvnrepository.com/artifact/org.mariadb.jdbc/mariadb-java-client
MySQL | mysql-connector-java-5.1.36.jar | http://mvnrepository.com/artifact/mysql/mysql-connector-java
PostgreSQL | postgresql-9.4-1201-jdbc41.jar | http://mvnrepository.com/artifact/org.postgresql/postgresql
SQLite | sqlite-jdbc-3.8.11.1.jar | http://mvnrepository.com/artifact/org.xerial/sqlite-jdbc

  
### 4. Configuration

Configure persistence service in *JDBC Persistence Service* section in openhab.cfg.

Minimal Configuration Parameters:
```
############################ JDBC Persistence Service ##################################
#
# required database url like 'jdbc:<service>:<host>[:<port>;<attributes>]'
jdbc:url=jdbc:postgresql://192.168.0.1:5432/testPostgresql
#
# required database user
jdbc:user=test
#
# required database password
jdbc:password=test
#
```


Migration Configuration from MYSQL bundle to JDBC bundle:
```
############################ JDBC Persistence Service ##################################
#
# required database url like 'jdbc:<service>:<host>[:<port>;<attributes>]'
jdbc:url=jdbc:postgresql://192.168.0.1:5432/testPostgresql
#
# required database user
jdbc:user=test
#
# required database password
jdbc:password=test
#
# for Migration from MYSQL-Bundle set to 'Item'.
jdbc:tableNamePrefix=Item
#
# for Migration from MYSQL-Bundle do not use real names.
jdbc:tableUseRealItemNames=false
#
# for Migration from MYSQL-Bundle set to 0.
jdbc:tableIdDigitCount=0

```

Full configuration:
```
############################ JDBC Persistence Service ##################################
# I N S T A L L   J D B C   P E R S I S T E N C E   S E R V I C E 
# To use this JDBC-service-bundle (org.openhab.persistence.jdbc-X.X.X.jar),
# a appropriate JDBC database-driver is needed in OpenHab addons Folder.
# Copy both (JDBC-service-bundle and a JDBC database-driver) to your OpenHab '[OpenHab]/addons' Folder to make it work. 
#
# Driver jars:
# Derby:     derby-10.11.1.1.jar               http://mvnrepository.com/artifact/org.apache.derby/derby
# H2:        h2-1.4.189.jar                    http://mvnrepository.com/artifact/com.h2database/h2
# HSQLDB:    hsqldb-2.3.3.jar                  http://mvnrepository.com/artifact/org.hsqldb/hsqldb
# MariaDB:   mariadb-java-client-1.2.0.jar     http://mvnrepository.com/artifact/org.mariadb.jdbc/mariadb-java-client
# MySQL      mysql-connector-java-5.1.36.jar   http://mvnrepository.com/artifact/mysql/mysql-connector-java
# PostgreSQL:postgresql-9.4-1201-jdbc41.jar    http://mvnrepository.com/artifact/org.postgresql/postgresql
# SQLite:    sqlite-jdbc-3.8.11.1.jar          http://mvnrepository.com/artifact/org.xerial/sqlite-jdbc
#
# Tested databases/url-prefix: jdbc:derby, jdbc:h2, jdbc:hsqldb, jdbc:mariadb, jdbc:mysql, jdbc:postgresql, jdbc:sqlite
# 
# derby, h2, hsqldb, sqlite can be embedded, 
# If no database is available it will be created, for example the url 'jdbc:h2:./testH2' creates a new DB in OpenHab Folder. 
#
# Create new database, for example on a MySQL-Server use: 
# CREATE DATABASE 'yourDB' CHARACTER SET utf8 COLLATE utf8_general_ci;

# D A T A B A S E  C O N F I G
# Some URL-Examples, 'service' identifies and activates internally the correct jdbc driver.
# required database url like 'jdbc:<service>:<host>[:<port>;<attributes>]'
# jdbc:url=jdbc:derby:./testDerby;create=true
# jdbc:url=jdbc:h2:./testH2
# jdbc:url=jdbc:hsqldb:./testHsqlDb
# jdbc:url=jdbc:mariadb://192.168.0.1:3306/testMariadb
# jdbc:url=jdbc:mysql://192.168.0.1:3306/testMysql
# jdbc:url=jdbc:postgresql://192.168.0.1:5432/testPostgresql
# jdbc:url=jdbc:sqlite:./testSqlite.db

# required database user
#jdbc:user=
jdbc:user=test

# required database password
#jdbc:password=
jdbc:password=test

# E R R O R   H A N D L I N G
# optional when Service is deactivated (optional, default: 0 -> ignore) 
#jdbc:errReconnectThreshold=

# I T E M   O P E R A T I O N S
# optional tweaking SQL datatypes
# see: https://mybatis.github.io/mybatis-3/apidocs/reference/org/apache/ibatis/type/JdbcType.html	
# see: http://www.h2database.com/html/datatypes.html
# see: http://www.postgresql.org/docs/9.3/static/datatype.html
# defaults:
#jdbc:sqltype.CALL			=	VARCHAR(200)
#jdbc:sqltype.COLOR			=	VARCHAR(70)
#jdbc:sqltype.CONTACT		=	VARCHAR(6)
#jdbc:sqltype.DATETIME		=	DATETIME
#jdbc:sqltype.DIMMER		=	TINYINT
#jdbc:sqltype.LOCATION		=	VARCHAR(30)
#jdbc:sqltype.NUMBER		=	DOUBLE
#jdbc:sqltype.ROLLERSHUTTER	=	TINYINT
#jdbc:sqltype.STRING		=	VARCHAR(65500)
#jdbc:sqltype.SWITCH		=	VARCHAR(6)

# For Itemtype "Number" default decimal digit count (optional, default: 3) 
#jdbc:numberDecimalcount=

# T A B L E   O P E R A T I O N S
# Tablename Prefix String (optional, default: "item") 
# for Migration from MYSQL-Bundle set to 'Item'.
#jdbc:tableNamePrefix=Item

# Tablename Prefix generation, using Item real names or "item" (optional, default: false -> "item") 
# If true, 'tableNamePrefix' is ignored.
#jdbc:tableUseRealItemNames=
jdbc:tableUseRealItemNames=true

# Tablename Suffix length (optional, default: 4 -> 0001-9999) 
# for Migration from MYSQL-Bundle set to 0.
#jdbc:tableIdDigitCount=

# Rename existing Tables using tableUseRealItemNames and tableIdDigitCount (optional, default: false) 
# USE WITH CARE! Deactivate after Renaming is done!
#jdbc:rebuildTableNames=true

# D A T A B A S E  C O N N E C T I O N S
# Some embeded Databases can handle only one Connection (optional, default: configured per database in packet org.openhab.persistence.jdbc.db.* )
# see: https://github.com/brettwooldridge/HikariCP/issues/256
# jdbc.maximumPoolSize = 1
# jdbc.minimumIdle = 1

# T I M E K E E P I N G
# (optional, default: false) 
#jdbc:enableLogTime=true

```
### [5]: 5. Database Table Schema
The service will create a mapping table to link each item to a table, and a separate table is generated for each item.
The item data tables includes time and data values - the data type dependents on the OpenHab item type and allows the item state to be recovered back into openHAB in the same way it was stored.
With this *per Item* layout, the scalability and easy maintenance of the database is ensured, even if large amounts of data must be managed.

 
 