--
-- Create Schema Script 
--   Database Version   : 10.2.0.4.0 
--   TOAD Version       : 9.6.0.27 
--   DB Connect String  : PRODUCAO_ORAPVT001.CVRD.BR 
--   Schema             : PCSOX 
--   Script Created by  : C0135418 
--   Script Created at  : 31/10/2011 14:50:55 
--   Physical Location  :  
--   Notes              :  
--

-- Object Counts: 
--   Roles: 4           Sys Privs: 16       Roles: 1            Obj Privs: 0 
--   Users: 1           Sys Privs: 9        Roles: 4            Tablespace Quotas: 2 
--   Tablespaces: 2     DataFiles: 2         
-- 
--   Database Links: 22 
--   Functions: 4       Lines of Code: 154 
--   Indexes: 48        Columns: 118        
--   Object Privileges: 69 
--   Packages: 2        Lines of Code: 29 
--   Package Bodies: 2  Lines of Code: 59 
--   Policies: 25 
--   Procedures: 9      Lines of Code: 1557 
--   Synonyms: 73 
--   Tables: 92         Columns: 965        Lob Segments: 2     Constraints: 40     
--   Triggers: 9 
--   Views: 22          


CREATE TABLESPACE D3SOX01T DATAFILE 
  '/usr/oradata/orapvt001/tbd1/D3SOX01T.D001' SIZE 17435M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 5M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE D4TRAM1T DATAFILE 
  '/usr/oradata/orapvt001/tbd1/D4TRAM1T.D001' SIZE 3280M AUTOEXTEND OFF
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 5M
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE ROLE CTRACE NOT IDENTIFIED;



CREATE ROLE SELECT_CATALOG_ROLE NOT IDENTIFIED;

GRANT HS_ADMIN_ROLE TO SELECT_CATALOG_ROLE;


CREATE ROLE CONNECT NOT IDENTIFIED;

GRANT CREATE SESSION TO CONNECT;
GRANT CREATE DATABASE LINK TO CONNECT;
GRANT CREATE TABLE TO CONNECT;
GRANT CREATE SEQUENCE TO CONNECT;
GRANT CREATE SYNONYM TO CONNECT;
GRANT CREATE VIEW TO CONNECT;
GRANT CREATE CLUSTER TO CONNECT;
GRANT ALTER SESSION TO CONNECT;


CREATE ROLE RESOURCE NOT IDENTIFIED;

GRANT CREATE CLUSTER TO RESOURCE;
GRANT CREATE SEQUENCE TO RESOURCE;
GRANT CREATE TRIGGER TO RESOURCE;
GRANT CREATE TABLE TO RESOURCE;
GRANT CREATE PROCEDURE TO RESOURCE;
GRANT CREATE TYPE TO RESOURCE;
GRANT CREATE OPERATOR TO RESOURCE;
GRANT CREATE INDEXTYPE TO RESOURCE;


CREATE USER PCSOX
  IDENTIFIED BY VALUES '021333F87C9F46C4'
  DEFAULT TABLESPACE D3SOX01T
  TEMPORARY TABLESPACE D3SOX01G
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 4 Roles for PCSOX 
  GRANT CONNECT TO PCSOX;
  GRANT SELECT_CATALOG_ROLE TO PCSOX;
  GRANT RESOURCE TO PCSOX;
  GRANT CTRACE TO PCSOX;
  ALTER USER PCSOX DEFAULT ROLE ALL;
  -- 9 System Privileges for PCSOX 
  GRANT SELECT ANY TABLE TO PCSOX;
  GRANT CREATE USER TO PCSOX;
  GRANT CREATE TABLE TO PCSOX;
  GRANT DROP USER TO PCSOX;
  GRANT CREATE DATABASE LINK TO PCSOX;
  GRANT ALTER USER TO PCSOX;
  GRANT CREATE PROCEDURE TO PCSOX;
  GRANT RESTRICTED SESSION TO PCSOX;
  GRANT CREATE SESSION TO PCSOX;
  -- 2 Tablespace Quotas for PCSOX 
  ALTER USER PCSOX QUOTA UNLIMITED ON D4TRAM1T;
  ALTER USER PCSOX QUOTA UNLIMITED ON D3SOX01T;
  -- 3 Java Privileges for PCSOX 
DECLARE
 KEYNUM NUMBER;
BEGIN
  SYS.DBMS_JAVA.GRANT_PERMISSION(
     grantee           => 'PCSOX'
    ,permission_type   => 'SYS:java.io.FilePermission'
    ,permission_name   => '/bin/sh'
    ,permission_action => 'execute'
    ,key               => KEYNUM
    );
END;
/
DECLARE
 KEYNUM NUMBER;
BEGIN
  SYS.DBMS_JAVA.GRANT_PERMISSION(
     grantee           => 'PCSOX'
    ,permission_type   => 'SYS:java.lang.RuntimePermission'
    ,permission_name   => 'writeFileDescriptor'
    ,permission_action => ''
    ,key               => KEYNUM
    );
END;
/
DECLARE
 KEYNUM NUMBER;
BEGIN
  SYS.DBMS_JAVA.GRANT_PERMISSION(
     grantee           => 'PCSOX'
    ,permission_type   => 'SYS:java.lang.RuntimePermission'
    ,permission_name   => 'readFileDescriptor'
    ,permission_action => ''
    ,key               => KEYNUM
    );
END;
/


CREATE TABLE PCSOX.SARBOX_INSTANCE_TABLESPACE
(
  INSTANCE           VARCHAR2(16 BYTE)          NOT NULL,
  TABLESPACE_NAME    VARCHAR2(30 BYTE)          NOT NULL,
  DTCOLLECT          DATE                       NOT NULL,
  CONTENTS           VARCHAR2(20 BYTE),
  ALLOCATION_TYPE    VARCHAR2(100 BYTE),
  EXTENT_MANAGEMENT  VARCHAR2(100 BYTE),
  BYTES_ALOC         NUMBER,
  BYTES_USED         NUMBER,
  DTDISABLE          DATE,
  DISABLE            VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_DE_PARA_ACN
(
  CHAVE_ACB  VARCHAR2(15 BYTE),
  CHAVE_C00  VARCHAR2(15 BYTE),
  NOME       VARCHAR2(100 BYTE),
  AF_VALE    VARCHAR2(50 BYTE),
  AF_ACN     VARCHAR2(50 BYTE),
  AF_ACN2    VARCHAR2(15 BYTE),
  EMPRESA    VARCHAR2(15 BYTE),
  MATRICULA  VARCHAR2(15 BYTE),
  CHAVE_TSO  VARCHAR2(15 BYTE),
  IMAC       VARCHAR2(30 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_FS
(
  HOSTNAME    VARCHAR2(64 BYTE),
  FILESYSTEM  VARCHAR2(150 BYTE),
  MOUNTPOINT  VARCHAR2(150 BYTE),
  SIZEB       NUMBER,
  USEDB       NUMBER,
  FREEB       NUMBER,
  PCTUSE      NUMBER,
  DTINSERT    DATE,
  DTDROPPED   DATE,
  DROPPED     VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.USER_FOR_DROP_108
(
  USERNAME     VARCHAR2(30 BYTE)                NOT NULL,
  DTATENDI     DATE                             DEFAULT sysdate               NOT NULL,
  DTCRIMAC     VARCHAR2(20 BYTE),
  NUMEIMAC     VARCHAR2(20 BYTE)                DEFAULT 'OUTSOURCING'         NOT NULL,
  GRANTDB2PVT  NUMBER                           DEFAULT 1                     NOT NULL,
  GRANTDB2PSL  NUMBER                           DEFAULT 1                     NOT NULL,
  GRANTDB2TVT  NUMBER                           DEFAULT 1                     NOT NULL,
  GRANTDB2TSL  NUMBER                           DEFAULT 1                     NOT NULL,
  CHAVETSO     CHAR(8 BYTE),
  CHAVESYB     VARCHAR2(30 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_SEC_LOG
(
  PROC_CALL      VARCHAR2(60 BYTE),
  DATELOG        DATE,
  USERNAME_CALL  VARCHAR2(30 BYTE),
  OSUSER         VARCHAR2(30 BYTE),
  MACHINE        VARCHAR2(100 BYTE),
  PROGRAM        VARCHAR2(100 BYTE),
  USERNAME       VARCHAR2(30 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.ACB299_SYSTABLE
(
  NAME             VARCHAR2(18 BYTE)            NOT NULL,
  CREATOR          CHAR(8 BYTE)                 NOT NULL,
  TYPE             CHAR(1 BYTE)                 NOT NULL,
  DBNAME           CHAR(8 BYTE)                 NOT NULL,
  TSNAME           CHAR(8 BYTE)                 NOT NULL,
  DBID             NUMBER(5)                    NOT NULL,
  OBID             NUMBER(5)                    NOT NULL,
  COLCOUNT         NUMBER(5)                    NOT NULL,
  EDPROC           CHAR(8 BYTE)                 NOT NULL,
  VALPROC          CHAR(8 BYTE)                 NOT NULL,
  CLUSTERTYPE      CHAR(1 BYTE)                 NOT NULL,
  CLUSTERRID       NUMBER(10)                   NOT NULL,
  CARD             NUMBER(10)                   NOT NULL,
  NPAGES           NUMBER(10)                   NOT NULL,
  PCTPAGES         NUMBER(5)                    NOT NULL,
  IBMREQD          CHAR(1 BYTE)                 NOT NULL,
  REMARKS          VARCHAR2(254 BYTE)           NOT NULL,
  PARENTS          NUMBER(5)                    NOT NULL,
  CHILDREN         NUMBER(5)                    NOT NULL,
  KEYCOLUMNS       NUMBER(5)                    NOT NULL,
  RECLENGTH        NUMBER(5)                    NOT NULL,
  STATUS           CHAR(1 BYTE)                 NOT NULL,
  KEYOBID          NUMBER(5)                    NOT NULL,
  LABEL            VARCHAR2(30 BYTE)            NOT NULL,
  CHECKFLAG        CHAR(1 BYTE)                 NOT NULL,
  CHECKRID         RAW(4)                       NOT NULL,
  AUDITING         CHAR(1 BYTE)                 NOT NULL,
  CREATEDBY        CHAR(8 BYTE)                 NOT NULL,
  LOCATION         CHAR(16 BYTE)                NOT NULL,
  TBCREATOR        CHAR(8 BYTE)                 NOT NULL,
  TBNAME           VARCHAR2(18 BYTE)            NOT NULL,
  CREATEDTS        CHAR(26 BYTE)                NOT NULL,
  ALTEREDTS        CHAR(26 BYTE)                NOT NULL,
  DATACAPTURE      CHAR(1 BYTE)                 NOT NULL,
  RBA1             RAW(6)                       NOT NULL,
  RBA2             RAW(6)                       NOT NULL,
  PCTROWCOMP       NUMBER(5)                    NOT NULL,
  STATSTIME        CHAR(26 BYTE)                NOT NULL,
  CHECKS           NUMBER(5)                    NOT NULL,
  CARDF            FLOAT(53)                    NOT NULL,
  CHECKRID5B       CHAR(5 BYTE)                 NOT NULL,
  ENCODING_SCHEME  CHAR(1 BYTE)                 NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.ACB299_SYSTABLEPART
(
  PARTITION   NUMBER(5)                         NOT NULL,
  TSNAME      CHAR(8 BYTE)                      NOT NULL,
  DBNAME      CHAR(8 BYTE)                      NOT NULL,
  IXNAME      VARCHAR2(18 BYTE)                 NOT NULL,
  IXCREATOR   CHAR(8 BYTE)                      NOT NULL,
  PQTY        NUMBER(10)                        NOT NULL,
  SQTY        NUMBER(5)                         NOT NULL,
  STORTYPE    CHAR(1 BYTE)                      NOT NULL,
  STORNAME    CHAR(8 BYTE)                      NOT NULL,
  VCATNAME    CHAR(8 BYTE)                      NOT NULL,
  CARD        NUMBER(10)                        NOT NULL,
  FARINDREF   NUMBER(10)                        NOT NULL,
  NEARINDREF  NUMBER(10)                        NOT NULL,
  PERCACTIVE  NUMBER(5)                         NOT NULL,
  PERCDROP    NUMBER(5)                         NOT NULL,
  IBMREQD     CHAR(1 BYTE)                      NOT NULL,
  LIMITKEY    VARCHAR2(512 BYTE)                NOT NULL,
  FREEPAGE    NUMBER(5)                         NOT NULL,
  "PCTFREE"   NUMBER(5)                         NOT NULL,
  CHECKFLAG   CHAR(1 BYTE)                      NOT NULL,
  CHECKRID    RAW(4)                            NOT NULL,
  SPACE       NUMBER(10)                        NOT NULL,
  "COMPRESS"  CHAR(1 BYTE)                      NOT NULL,
  PAGESAVE    NUMBER(5)                         NOT NULL,
  STATSTIME   CHAR(26 BYTE)                     NOT NULL,
  GBPCACHE    CHAR(1 BYTE)                      NOT NULL,
  CHECKRID5B  CHAR(5 BYTE)                      NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_LOG
(
  INSTANCE  VARCHAR2(16 BYTE)                   NOT NULL,
  DTLOG     DATE,
  VERRORM   VARCHAR2(400 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_IDM
(
  INSTANCE         VARCHAR2(16 BYTE)            NOT NULL,
  INSTANCE_SOURCE  VARCHAR2(16 BYTE)            NOT NULL,
  CONNECT_STRING   VARCHAR2(2000 BYTE),
  PRIORITY         NUMBER(3),
  CREATEUSER       CHAR(1 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_JOB
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  JOB          NUMBER                           NOT NULL,
  LOG_USER     VARCHAR2(30 BYTE)                NOT NULL,
  PRIV_USER    VARCHAR2(30 BYTE)                NOT NULL,
  SCHEMA_USER  VARCHAR2(30 BYTE)                NOT NULL,
  LAST_DATE    DATE,
  LAST_SEC     VARCHAR2(8 BYTE),
  THIS_DATE    DATE,
  THIS_SEC     VARCHAR2(8 BYTE),
  NEXT_DATE    DATE,
  NEXT_SEC     VARCHAR2(8 BYTE),
  TOTAL_TIME   NUMBER,
  BROKEN       VARCHAR2(1 BYTE),
  INTERVAL     VARCHAR2(200 BYTE),
  FAILURES     NUMBER,
  WHAT         VARCHAR2(4000 BYTE),
  NLS_ENV      VARCHAR2(4000 BYTE),
  MISC_ENV     RAW(32),
  INSTANCE_ID  NUMBER,
  DTDROPPED    DATE,
  DROPPED      VARCHAR2(10 BYTE),
  DTINSERT     DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_TEMP_MF_SEGS
(
  VOL_ID      VARCHAR2(50 BYTE),
  DSN_NAME    VARCHAR2(50 BYTE),
  DS_AUX1     VARCHAR2(50 BYTE),
  DS_DBNAME   VARCHAR2(50 BYTE),
  DS_TBSNAME  VARCHAR2(50 BYTE),
  DS_AUX2     VARCHAR2(50 BYTE),
  DS_PNAME    VARCHAR2(50 BYTE),
  TBS_NUMTRK  NUMBER,
  EXT_SEQ     NUMBER,
  READ_ORDER  NUMBER,
  PERC_USED   NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_MF_VOLS
(
  VOL_ID        VARCHAR2(50 BYTE),
  TRK_TOT       NUMBER,
  TRK_AVAIL     NUMBER,
  TRK_USED      NUMBER,
  KBYTES_TOT    NUMBER,
  KBYTES_AVAIL  NUMBER,
  KBYTES_USED   NUMBER,
  PCT_USED      NUMBER,
  DTDROPPED     DATE,
  DROPPED       VARCHAR2(10 BYTE),
  DTINSERT      DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_MF_VOLS_FREESEGS
(
  VOL_ID        VARCHAR2(50 BYTE),
  SEG_ID        NUMBER,
  TRK_AVAIL     NUMBER,
  KBYTES_AVAIL  NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_REGISTRY
(
  INSTANCE       VARCHAR2(16 BYTE)              NOT NULL,
  COMP_ID        VARCHAR2(30 BYTE)              NOT NULL,
  COMP_NAME      VARCHAR2(255 BYTE),
  VERSION        VARCHAR2(30 BYTE),
  STATUS         VARCHAR2(11 BYTE),
  MODIFIED       VARCHAR2(20 BYTE),
  NAMESPACE      VARCHAR2(30 BYTE),
  CONTROL        VARCHAR2(30 BYTE),
  "SCHEMA"       VARCHAR2(30 BYTE),
  STARTUP        VARCHAR2(8 BYTE),
  PARENT_ID      VARCHAR2(30 BYTE),
  OTHER_SCHEMAS  VARCHAR2(4000 BYTE),
  PROC           VARCHAR2(61 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.LOCK_20090122
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_STORAGE
(
  INSTANCE             VARCHAR2(16 BYTE)        NOT NULL,
  FILESYSTEM           VARCHAR2(100 BYTE)       NOT NULL,
  DTCOLLECT            DATE                     NOT NULL,
  MOUNTPOINT           VARCHAR2(100 BYTE)       NOT NULL,
  ALOCATION_TYPE       VARCHAR2(30 BYTE)        NOT NULL,
  STORAGE_MODE         VARCHAR2(20 BYTE)        NOT NULL,
  BYTES_ALOC           NUMBER,
  BYTES_USED           NUMBER,
  BYTES_INSTANCE_USED  NUMBER,
  DTDISABLE            DATE,
  DISABLE              VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_USER$
(
  INSTANCE      VARCHAR2(16 BYTE)               NOT NULL,
  USER#         NUMBER                          NOT NULL,
  NAME          VARCHAR2(30 BYTE)               NOT NULL,
  TYPE#         NUMBER                          NOT NULL,
  PASSWORD      VARCHAR2(30 BYTE),
  DATATS#       NUMBER                          NOT NULL,
  TEMPTS#       NUMBER                          NOT NULL,
  CTIME         DATE                            NOT NULL,
  PTIME         DATE,
  EXPTIME       DATE,
  LTIME         DATE,
  RESOURCE$     NUMBER                          NOT NULL,
  AUDIT$        VARCHAR2(38 BYTE),
  DEFROLE       NUMBER                          NOT NULL,
  DEFGRP#       NUMBER,
  DEFGRP_SEQ#   NUMBER,
  ASTATUS       NUMBER                          NOT NULL,
  LCOUNT        NUMBER                          NOT NULL,
  DEFSCHCLASS   VARCHAR2(30 BYTE),
  EXT_USERNAME  VARCHAR2(4000 BYTE),
  SPARE1        NUMBER,
  SPARE2        NUMBER,
  SPARE3        NUMBER,
  SPARE4        VARCHAR2(1000 BYTE),
  SPARE5        VARCHAR2(1000 BYTE),
  SPARE6        DATE,
  DTDROPPED     DATE,
  DROPPED       VARCHAR2(10 BYTE),
  DTINSERT      DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE
(
  INSTANCE                      VARCHAR2(16 BYTE),
  SEARCH                        CHAR(1 BYTE)    DEFAULT 'N',
  VERSION                       VARCHAR2(17 BYTE),
  STARTUP_TIME                  DATE,
  HOSTNAME                      VARCHAR2(64 BYTE),
  STATUS                        VARCHAR2(7 BYTE),
  CS                            VARCHAR2(100 BYTE),
  TYPE                          CHAR(1 BYTE)    DEFAULT 'D',
  KSIZE                         NUMBER,
  SEARCH_TRACE                  CHAR(1 BYTE)    DEFAULT 'N',
  MESSAGE                       VARCHAR2(400 BYTE),
  ERRORM                        VARCHAR2(400 BYTE),
  CONNECT_STRING                VARCHAR2(2000 BYTE),
  SEARCH_PRIVS                  CHAR(1 BYTE)    DEFAULT 'N',
  SEARCH_PROFILE                CHAR(1 BYTE)    DEFAULT 'N',
  SEARCH_LINKS                  CHAR(1 BYTE)    DEFAULT 'N',
  PRIORITY                      NUMBER(3),
  STATEMENT                     VARCHAR2(400 BYTE),
  DESCRIPTION                   VARCHAR2(200 BYTE),
  SESSIONS_CURRENT              NUMBER,
  SESSIONS_HIGHWATER            NUMBER,
  CPU_COUNT_CURRENT             NUMBER,
  CPU_COUNT_HIGHWATER           NUMBER,
  FIXED_SIZE                    NUMBER,
  VARIABLE_SIZE                 NUMBER,
  DATABASE_BUFFERS              NUMBER,
  REDO_BUFFERS                  NUMBER,
  CREATED                       DATE,
  RESETLOGS_TIME                DATE,
  CONTROLFILE_CREATED           DATE,
  CONTROLFILE_TIME              DATE,
  VERSION_TIME                  DATE,
  PLATFORM_ID                   NUMBER,
  PLATFORM_NAME                 VARCHAR2(101 BYTE),
  RECOVERY_TARGET_INCARNATION#  NUMBER,
  LAST_OPEN_INCARNATION#        NUMBER,
  SERVER_INSTANCES              NUMBER(3),
  SERVER_INSTANCES_ACTIVE       NUMBER(3),
  VSTATUS                       VARCHAR2(7 BYTE),
  VMESSAGE                      VARCHAR2(400 BYTE),
  VERRORM                       VARCHAR2(400 BYTE),
  INSERTED                      DATE            NOT NULL,
  CHECK_PCS                     VARCHAR2(1 BYTE) DEFAULT 'Y',
  LOGICAL_READS                 NUMBER,
  PHYSICAL_READS                NUMBER,
  PHYSICAL_WRITES               NUMBER,
  HIT_RATIO_BUFFER              NUMBER,
  RC_GETS                       NUMBER,
  RC_GETMISSES                  NUMBER,
  HIT_RATIO_LIBRARY_CACHE       NUMBER,
  LBC_PINS                      NUMBER,
  LBC_RELOADS                   NUMBER,
  HIT_HATIO_CACHEMISS           NUMBER,
  VERRORDT                      DATE,
  VERRORCOUNT                   NUMBER,
  PREFERRED_NODE                VARCHAR2(64 BYTE),
  FILE_AUTOEXTENSIBLE           NUMBER,
  NOTIFY                        CHAR(1 BYTE)    DEFAULT 'Y',
  INSTANCE_NUMBER               NUMBER,
  SERVICE_NAME                  VARCHAR2(50 BYTE),
  OBS                           VARCHAR2(4000 BYTE),
  SGBD                          VARCHAR2(30 BYTE),
  LOG_MODE                      VARCHAR2(15 BYTE),
  VALIDATED_BY                  VARCHAR2(50 BYTE),
  NLS_NCHAR_CS                  VARCHAR2(50 BYTE),
  NLS_LENGTH_SEMANTICS          VARCHAR2(50 BYTE),
  SUBSIDIARY                    VARCHAR2(50 BYTE),
  BACKUP_DAY                    VARCHAR2(10 BYTE) DEFAULT '1234567',
  BKPLOGIC_FULL                 CHAR(1 BYTE)    DEFAULT 'N',
  BKPLOGIC_REENG                CHAR(1 BYTE)    DEFAULT 'N',
  LOCATION                      VARCHAR2(30 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          32K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_LINK
(
  INSTANCE   VARCHAR2(16 BYTE),
  OWNER      VARCHAR2(30 BYTE),
  DBLINK     VARCHAR2(128 BYTE),
  CTIME      DATE,
  HOST       VARCHAR2(2000 BYTE),
  USERNAME   VARCHAR2(30 BYTE),
  PASSWORD   VARCHAR2(30 BYTE),
  FLAG       NUMBER,
  AUTHUSR    VARCHAR2(30 BYTE),
  AUTPHPWD   VARCHAR2(30 BYTE),
  DTINSERT   DATE,
  DTUPDATE   DATE,
  DTDROPPED  DATE,
  DROPPED    VARCHAR2(10 BYTE),
  PASSWORDX  RAW(128)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          160K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_LOGIN
(
  INSTANCE  VARCHAR2(16 BYTE),
  USERNAME  VARCHAR2(30 BYTE),
  PROGRAM   VARCHAR2(100 BYTE),
  USERSO    VARCHAR2(30 BYTE),
  MACHINE   VARCHAR2(100 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          624K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_PROFILE
(
  INSTANCE       VARCHAR2(16 BYTE),
  PROFILE        VARCHAR2(30 BYTE),
  RESOURCE_NAME  VARCHAR2(32 BYTE),
  RESOURCE_TYPE  VARCHAR2(8 BYTE),
  LIMIT          VARCHAR2(40 BYTE),
  DTDROPPED      DATE,
  DROPPED        VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_ROLE
(
  INSTANCE           VARCHAR2(16 BYTE)          NOT NULL,
  ROLE               VARCHAR2(30 BYTE)          NOT NULL,
  PASSWORD_REQUIRED  VARCHAR2(8 BYTE),
  DTDROPPED          DATE,
  DROPPED            VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_ROLEPRIV
(
  INSTANCE      VARCHAR2(16 BYTE)               NOT NULL,
  GRANTEE       VARCHAR2(30 BYTE),
  GRANTED_ROLE  VARCHAR2(30 BYTE)               NOT NULL,
  ADMIN_OPTION  VARCHAR2(3 BYTE),
  DEFAULT_ROLE  VARCHAR2(3 BYTE),
  DTDROPPED     DATE,
  DROPPED       VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_SYSPRIV
(
  INSTANCE      VARCHAR2(16 BYTE)               NOT NULL,
  GRANTEE       VARCHAR2(30 BYTE)               NOT NULL,
  PRIVILEGE     VARCHAR2(40 BYTE)               NOT NULL,
  ADMIN_OPTION  VARCHAR2(3 BYTE),
  DTDROPPED     DATE,
  DROPPED       VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_TABPRIV
(
  INSTANCE    VARCHAR2(16 BYTE)                 NOT NULL,
  GRANTEE     VARCHAR2(30 BYTE)                 NOT NULL,
  OWNER       VARCHAR2(30 BYTE)                 NOT NULL,
  TABLE_NAME  VARCHAR2(30 BYTE)                 NOT NULL,
  GRANTOR     VARCHAR2(30 BYTE)                 NOT NULL,
  PRIVILEGE   VARCHAR2(40 BYTE)                 NOT NULL,
  GRANTABLE   VARCHAR2(3 BYTE),
  DTDROPPED   DATE,
  DROPPED     VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
ENABLE ROW MOVEMENT;


CREATE TABLE PCSOX.SARBOX_INSTANCE_USER
(
  INSTANCE              VARCHAR2(16 BYTE),
  USERNAME              VARCHAR2(30 BYTE),
  STATUS                VARCHAR2(32 BYTE),
  OWNER                 VARCHAR2(10 BYTE),
  DTINSERT              DATE,
  DTUPDATE              DATE,
  PROFILE               VARCHAR2(30 BYTE),
  RDBMS                 VARCHAR2(30 BYTE),
  TPCARGA               CHAR(1 BYTE),
  DTDROPPED             DATE,
  DROPPED               VARCHAR2(10 BYTE),
  OWNER_DBLINK          VARCHAR2(10 BYTE),
  LOCK_DATE             DATE,
  EXPIRY_DATE           DATE,
  LAST_LOGON            DATE,
  DEFAULT_TABLESPACE    VARCHAR2(30 BYTE),
  TEMPORARY_TABLESPACE  VARCHAR2(30 BYTE),
  CREATED               DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          584K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_USER_HISTORY
(
  INSTANCE     VARCHAR2(16 BYTE),
  USERNAME     VARCHAR2(30 BYTE),
  DTCOLETA     DATE,
  PASSWORD     VARCHAR2(100 BYTE),
  STATUS       VARCHAR2(32 BYTE),
  PROFILE      VARCHAR2(30 BYTE),
  LOCK_DATE    DATE,
  EXPIRY_DATE  DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_TROCA_LOG
(
  DTTROCA   DATE,
  USERNAME  VARCHAR2(30 BYTE),
  INSTANCE  VARCHAR2(16 BYTE),
  PASSWORD  VARCHAR2(100 BYTE),
  ERRO      VARCHAR2(4000 BYTE),
  MENSAGEM  VARCHAR2(500 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_USER_PASSWORD
(
  USERNAME   VARCHAR2(30 BYTE),
  DTGERACAO  DATE,
  PASSWORD   VARCHAR2(100 BYTE),
  USEREXEC   VARCHAR2(50 BYTE),
  TERMINAL   VARCHAR2(100 BYTE),
  TYPE       VARCHAR2(10 BYTE)                  NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.USUARIOS_FORA_PADRAO
(
  INSTANCE           VARCHAR2(16 BYTE)          NOT NULL,
  CHAVE_REFERENCIA   VARCHAR2(30 BYTE)          NOT NULL,
  CHAVE_FORA_PADRAO  VARCHAR2(30 BYTE)          NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M20090506_SS080019_PRJ1_DEBENT
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.LOCK_20090130
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_MF_SEGS
(
  DSN_NAME       VARCHAR2(50 BYTE),
  DB_NAME        VARCHAR2(50 BYTE),
  TBS_NAME       VARCHAR2(50 BYTE),
  SEG_NAME       VARCHAR2(50 BYTE),
  SEG_TYPE       VARCHAR2(50 BYTE),
  OBJ_NAME       VARCHAR2(50 BYTE),
  DBID           NUMBER,
  OBID           NUMBER,
  CREATEDTS      DATE,
  ALTEREDTS      DATE,
  PQTY_TRK       NUMBER,
  SQTY_TRK       NUMBER,
  PQTY_KB        NUMBER,
  SQTY_KB        NUMBER,
  SEG_PARTS      NUMBER(5),
  LPART_EXT      NUMBER,
  PART_NAME      VARCHAR2(10 BYTE),
  LPART_SIZETRK  NUMBER,
  LPART_SIZEKB   NUMBER,
  LPART_LEXTTRK  NUMBER,
  LPART_LEXTKB   NUMBER,
  SEG_EXT        NUMBER,
  SEG_SIZETRK    NUMBER,
  SEG_SIZEKB     NUMBER,
  DTDROPPED      DATE,
  DROPPED        VARCHAR2(10 BYTE),
  DTINSERT       DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_PRJ001_20090409
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_SYSIBM_DBAUTH
(
  INSTANCE       VARCHAR2(16 BYTE)              NOT NULL,
  GRANTOR        CHAR(8 BYTE)                   NOT NULL,
  GRANTEE        CHAR(8 BYTE)                   NOT NULL,
  NAME           CHAR(8 BYTE)                   NOT NULL,
  TIMESTAMP      CHAR(12 BYTE)                  NOT NULL,
  DATEGRANTED    CHAR(6 BYTE)                   NOT NULL,
  TIMEGRANTED    CHAR(8 BYTE)                   NOT NULL,
  GRANTEETYPE    CHAR(1 BYTE)                   NOT NULL,
  AUTHHOWGOT     CHAR(1 BYTE)                   NOT NULL,
  CREATETABAUTH  CHAR(1 BYTE)                   NOT NULL,
  CREATETSAUTH   CHAR(1 BYTE)                   NOT NULL,
  DBADMAUTH      CHAR(1 BYTE)                   NOT NULL,
  DBCTRLAUTH     CHAR(1 BYTE)                   NOT NULL,
  DBMAINTAUTH    CHAR(1 BYTE)                   NOT NULL,
  DISPLAYDBAUTH  CHAR(1 BYTE)                   NOT NULL,
  DROPAUTH       CHAR(1 BYTE)                   NOT NULL,
  IMAGCOPYAUTH   CHAR(1 BYTE)                   NOT NULL,
  LOADAUTH       CHAR(1 BYTE)                   NOT NULL,
  REORGAUTH      CHAR(1 BYTE)                   NOT NULL,
  RECOVERDBAUTH  CHAR(1 BYTE)                   NOT NULL,
  REPAIRAUTH     CHAR(1 BYTE)                   NOT NULL,
  STARTDBAUTH    CHAR(1 BYTE)                   NOT NULL,
  STATSAUTH      CHAR(1 BYTE)                   NOT NULL,
  STOPAUTH       CHAR(1 BYTE)                   NOT NULL,
  IBMREQD        CHAR(1 BYTE)                   NOT NULL,
  GRANTEDTS      CHAR(26 BYTE)                  NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_SYSIBM_TABAUTH
(
  INSTANCE         VARCHAR2(16 BYTE)            NOT NULL,
  GRANTOR          CHAR(8 BYTE)                 NOT NULL,
  GRANTEE          CHAR(8 BYTE)                 NOT NULL,
  GRANTEETYPE      CHAR(1 BYTE)                 NOT NULL,
  DBNAME           CHAR(8 BYTE)                 NOT NULL,
  SCREATOR         CHAR(8 BYTE)                 NOT NULL,
  STNAME           VARCHAR2(18 BYTE)            NOT NULL,
  TCREATOR         CHAR(8 BYTE)                 NOT NULL,
  TTNAME           VARCHAR2(18 BYTE)            NOT NULL,
  AUTHHOWGOT       CHAR(1 BYTE)                 NOT NULL,
  TIMESTAMP        CHAR(12 BYTE)                NOT NULL,
  DATEGRANTED      CHAR(6 BYTE)                 NOT NULL,
  TIMEGRANTED      CHAR(8 BYTE)                 NOT NULL,
  UPDATECOLS       CHAR(1 BYTE)                 NOT NULL,
  ALTERAUTH        CHAR(1 BYTE)                 NOT NULL,
  DELETEAUTH       CHAR(1 BYTE)                 NOT NULL,
  INDEXAUTH        CHAR(1 BYTE)                 NOT NULL,
  INSERTAUTH       CHAR(1 BYTE)                 NOT NULL,
  SELECTAUTH       CHAR(1 BYTE)                 NOT NULL,
  UPDATEAUTH       CHAR(1 BYTE)                 NOT NULL,
  IBMREQD          CHAR(1 BYTE)                 NOT NULL,
  GRANTEELOCATION  CHAR(16 BYTE)                NOT NULL,
  LOCATION         CHAR(16 BYTE)                NOT NULL,
  COLLID           CHAR(18 BYTE)                NOT NULL,
  CONTOKEN         CHAR(8 BYTE)                 NOT NULL,
  CAPTUREAUTH      CHAR(1 BYTE)                 NOT NULL,
  REFERENCESAUTH   CHAR(1 BYTE)                 NOT NULL,
  REFCOLS          CHAR(1 BYTE)                 NOT NULL,
  GRANTEDTS        CHAR(26 BYTE)                NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_DROPUSER_LOG
(
  INSTANCE   VARCHAR2(16 BYTE)                  NOT NULL,
  USERNAME   VARCHAR2(30 BYTE)                  NOT NULL,
  DTDROPPED  DATE,
  USUARIOSO  VARCHAR2(30 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          168K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_DEBUG
(
  DEBUGINFO  VARCHAR2(4000 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_TEMP_INSTANCE_TABPRIV
(
  INSTANCE    VARCHAR2(16 BYTE)                 NOT NULL,
  GRANTEE     VARCHAR2(30 BYTE)                 NOT NULL,
  OWNER       VARCHAR2(30 BYTE)                 NOT NULL,
  TABLE_NAME  VARCHAR2(30 BYTE)                 NOT NULL,
  GRANTOR     VARCHAR2(30 BYTE)                 NOT NULL,
  PRIVILEGE   VARCHAR2(40 BYTE)                 NOT NULL,
  GRANTABLE   VARCHAR2(3 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.LOCK_20081217
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_MF_VOLS_SEGS_NEW
(
  VOL_ID              VARCHAR2(50 BYTE),
  DSN_NAME            VARCHAR2(50 BYTE),
  DB_NAME             VARCHAR2(50 BYTE),
  TBS_NAME            VARCHAR2(50 BYTE),
  PART_NAME           VARCHAR2(10 BYTE),
  DT_UPD              DATE,
  TRKS                NUMBER,
  KBYTES              NUMBER,
  EXTENTS             NUMBER,
  NEXT_EXTENT_TRKS    NUMBER,
  NEXT_EXTENT_KBYTES  NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_PVT1_20090213
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_PVT026_20090116
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_STREAMS
(
  INSTANCE_SOURCE          VARCHAR2(16 BYTE)    NOT NULL,
  INSTANCE_TARGET          VARCHAR2(16 BYTE)    NOT NULL,
  OWNER                    VARCHAR2(30 BYTE)    NOT NULL,
  CAPTURE_COUNT            NUMBER               NOT NULL,
  APPLY_COUNT              NUMBER               NOT NULL,
  PROPAGATION_COUNT        NUMBER               NOT NULL,
  LATENCY_CAPTURE          NUMBER,
  LATENCY_APPLY            NUMBER,
  REPLICATION_TYPE         CHAR(1 BYTE)         NOT NULL,
  OBS                      VARCHAR2(4000 BYTE),
  PARALLEL_CAPTURE_COUNT   NUMBER,
  PARALLEL_APPLY_COUNT     NUMBER,
  ERROR_CAPTURE            VARCHAR2(4000 BYTE),
  ERROR_APPLY              VARCHAR2(4000 BYTE),
  REPLICATION_OBJECT_TYPE  CHAR(1 BYTE),
  STATUS                   CHAR(1 BYTE),
  NOTIFY                   CHAR(1 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_TEMP_INSTANCE_OBJECT
(
  INSTANCE        VARCHAR2(16 BYTE)             NOT NULL,
  OWNER           VARCHAR2(30 BYTE)             NOT NULL,
  OBJECT_NAME     VARCHAR2(128 BYTE)            NOT NULL,
  SUBOBJECT_NAME  VARCHAR2(30 BYTE),
  OBJECT_ID       NUMBER                        NOT NULL,
  DATA_OBJECT_ID  NUMBER,
  OBJECT_TYPE     VARCHAR2(19 BYTE),
  CREATED         DATE,
  LAST_DDL_TIME   DATE,
  TIMESTAMP       VARCHAR2(19 BYTE),
  STATUS          VARCHAR2(7 BYTE),
  TEMPORARY       VARCHAR2(1 BYTE),
  GENERATED       VARCHAR2(1 BYTE),
  SECONDARY       VARCHAR2(1 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_OBJECT
(
  INSTANCE        VARCHAR2(16 BYTE)             NOT NULL,
  OWNER           VARCHAR2(30 BYTE)             NOT NULL,
  OBJECT_ID       NUMBER                        NOT NULL,
  OBJECT_NAME     VARCHAR2(128 BYTE)            NOT NULL,
  SUBOBJECT_NAME  VARCHAR2(30 BYTE),
  DATA_OBJECT_ID  NUMBER,
  OBJECT_TYPE     VARCHAR2(19 BYTE),
  CREATED         DATE,
  LAST_DDL_TIME   DATE,
  TIMESTAMP       VARCHAR2(19 BYTE),
  STATUS          VARCHAR2(7 BYTE),
  TEMPORARY       VARCHAR2(1 BYTE),
  GENERATED       VARCHAR2(1 BYTE),
  SECONDARY       VARCHAR2(1 BYTE),
  DTDROPPED       DATE,
  DROPPED         VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_PARAMETER
(
  INSTANCE    VARCHAR2(16 BYTE)                 NOT NULL,
  INST_ID     NUMBER                            NOT NULL,
  NAME        VARCHAR2(80 BYTE)                 NOT NULL,
  NUM         NUMBER,
  TYPE        NUMBER,
  VALUE       VARCHAR2(512 BYTE),
  ISDEFAULT   VARCHAR2(9 BYTE),
  ISMODIFIED  VARCHAR2(10 BYTE),
  ISADJUSTED  VARCHAR2(5 BYTE),
  DTINSERT    DATE,
  DTDROPPED   DATE,
  DROPPED     VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_HISTORY
(
  INSTANCE     VARCHAR2(16 BYTE),
  TABLE_NAME   VARCHAR2(30 BYTE),
  COLUMN_NAME  VARCHAR2(30 BYTE),
  ROWVALUE     VARCHAR2(2000 BYTE),
  DTHISTORY    DATE,
  OLDVALUE     VARCHAR2(2000 BYTE),
  NEWVALUE     VARCHAR2(2000 BYTE),
  INST_ID      NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE GLOBAL TEMPORARY TABLE PCSOX.SARBOX_TEMP_INSTANCE_ROLEPRIV
(
  INSTANCE      VARCHAR2(16 BYTE)               NOT NULL,
  GRANTEE       VARCHAR2(30 BYTE)               NOT NULL,
  GRANTED_ROLE  VARCHAR2(30 BYTE)               NOT NULL,
  ADMIN_OPTION  VARCHAR2(3 BYTE),
  DEFAULT_ROLE  VARCHAR2(3 BYTE)
)
ON COMMIT PRESERVE ROWS
NOCACHE;


CREATE GLOBAL TEMPORARY TABLE PCSOX.SARBOX_TEMP_INSTANCE_SYSPRIV
(
  INSTANCE      VARCHAR2(16 BYTE)               NOT NULL,
  GRANTEE       VARCHAR2(30 BYTE)               NOT NULL,
  PRIVILEGE     VARCHAR2(40 BYTE)               NOT NULL,
  ADMIN_OPTION  VARCHAR2(3 BYTE)
)
ON COMMIT PRESERVE ROWS
NOCACHE;


CREATE GLOBAL TEMPORARY TABLE PCSOX.SARBOX_TEMP_INSTANCE_LOGIN
(
  INSTANCE  VARCHAR2(16 BYTE)                   NOT NULL,
  USERNAME  VARCHAR2(30 BYTE)                   NOT NULL,
  PROGRAM   VARCHAR2(100 BYTE)                  NOT NULL,
  USERSO    VARCHAR2(30 BYTE)                   NOT NULL,
  MACHINE   VARCHAR2(100 BYTE)
)
ON COMMIT PRESERVE ROWS
NOCACHE;


CREATE TABLE PCSOX.SARBOX_MF_VOLS_SEGS
(
  VOL_ID              VARCHAR2(50 BYTE),
  DSN_NAME            VARCHAR2(50 BYTE),
  DB_NAME             VARCHAR2(50 BYTE),
  TBS_NAME            VARCHAR2(50 BYTE),
  PART_NAME           VARCHAR2(10 BYTE),
  TRKS                NUMBER,
  KBYTES              NUMBER,
  EXTENTS             NUMBER,
  NEXT_EXTENT_TRKS    NUMBER,
  NEXT_EXTENT_KBYTES  NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.BLOQUEIO_20090921_SS080019
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_EXPORT
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  ID_PROCESS   VARCHAR2(100 BYTE)               NOT NULL,
  STARTED      DATE,
  ENDED        DATE,
  STATUS       VARCHAR2(500 BYTE),
  EXPTYPE      VARCHAR2(25 BYTE),
  FILENAME     VARCHAR2(250 BYTE),
  FILESIZE     NUMBER,
  MESSAGE_ORA  VARCHAR2(4000 BYTE),
  MESSAGE_EXP  VARCHAR2(4000 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_STARTUP
(
  INSTANCE         VARCHAR2(16 BYTE)            NOT NULL,
  STARTUP_TIME     DATE                         NOT NULL,
  INSTANCE_ID      NUMBER,
  INSTANCE_NAME    VARCHAR2(64 BYTE),
  USER_SO          VARCHAR2(30 BYTE),
  USER_ORACLE      VARCHAR2(30 BYTE),
  TERMINAL         VARCHAR2(100 BYTE),
  OPERATION        VARCHAR2(100 BYTE),
  HOST_NAME        VARCHAR2(100 BYTE),
  VERSION          VARCHAR2(50 BYTE),
  STATUS           VARCHAR2(25 BYTE),
  ARCHIVER         VARCHAR2(25 BYTE),
  LOGINS           VARCHAR2(35 BYTE),
  DATABASE_STATUS  VARCHAR2(25 BYTE),
  ARCHIVE_MODE     VARCHAR2(30 BYTE),
  DTSTARTUP        DATE,
  DTSHUTDOWN       DATE
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_CLUSTER
(
  CLUSTER_ID   NUMBER,
  NAME         VARCHAR2(100 BYTE),
  DESCRIPTION  VARCHAR2(250 BYTE),
  NODES        NUMBER,
  SO           VARCHAR2(50 BYTE),
  DTINSERT     DATE,
  SITE         VARCHAR2(50 BYTE),
  ACTIVE       CHAR(1 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_CLUSTER_NODE
(
  CLUSTER_ID  NUMBER,
  NAME        VARCHAR2(100 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.PVT002_20090211
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_USER_DESCRIPTION
(
  USERNAME     VARCHAR2(32 BYTE),
  DESCRIPTION  VARCHAR2(150 BYTE),
  USEREXEC     VARCHAR2(50 BYTE),
  USERSO       VARCHAR2(50 BYTE),
  TERMINAL     VARCHAR2(100 BYTE),
  CODAF        VARCHAR2(10 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.ACB299_SYSINDEXES
(
  NAME            VARCHAR2(18 BYTE)             NOT NULL,
  CREATOR         CHAR(8 BYTE)                  NOT NULL,
  TBNAME          VARCHAR2(18 BYTE)             NOT NULL,
  TBCREATOR       CHAR(8 BYTE)                  NOT NULL,
  UNIQUERULE      CHAR(1 BYTE)                  NOT NULL,
  COLCOUNT        NUMBER(5)                     NOT NULL,
  CLUSTERING      CHAR(1 BYTE)                  NOT NULL,
  CLUSTERED       CHAR(1 BYTE)                  NOT NULL,
  DBID            NUMBER(5)                     NOT NULL,
  OBID            NUMBER(5)                     NOT NULL,
  ISOBID          NUMBER(5)                     NOT NULL,
  DBNAME          CHAR(8 BYTE)                  NOT NULL,
  INDEXSPACE      CHAR(8 BYTE)                  NOT NULL,
  FIRSTKEYCARD    NUMBER(10)                    NOT NULL,
  FULLKEYCARD     NUMBER(10)                    NOT NULL,
  NLEAF           NUMBER(10)                    NOT NULL,
  NLEVELS         NUMBER(5)                     NOT NULL,
  BPOOL           CHAR(8 BYTE)                  NOT NULL,
  PGSIZE          NUMBER(5)                     NOT NULL,
  ERASERULE       CHAR(1 BYTE)                  NOT NULL,
  DSETPASS        CHAR(8 BYTE)                  NOT NULL,
  CLOSERULE       CHAR(1 BYTE)                  NOT NULL,
  SPACE           NUMBER(10)                    NOT NULL,
  IBMREQD         CHAR(1 BYTE)                  NOT NULL,
  CLUSTERRATIO    NUMBER(5)                     NOT NULL,
  CREATEDBY       CHAR(8 BYTE)                  NOT NULL,
  IOFACTOR        NUMBER(5)                     NOT NULL,
  PREFETCHFACTOR  NUMBER(5)                     NOT NULL,
  STATSTIME       CHAR(26 BYTE)                 NOT NULL,
  INDEXTYPE       CHAR(1 BYTE)                  NOT NULL,
  FIRSTKEYCARDF   FLOAT(53)                     NOT NULL,
  FULLKEYCARDF    FLOAT(53)                     NOT NULL,
  CREATEDTS       CHAR(26 BYTE)                 NOT NULL,
  ALTEREDTS       CHAR(26 BYTE)                 NOT NULL,
  PIECESIZE       NUMBER(10)                    NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.ACB299_SYSINDEXPART
(
  PARTITION   NUMBER(5)                         NOT NULL,
  IXNAME      VARCHAR2(18 BYTE)                 NOT NULL,
  IXCREATOR   CHAR(8 BYTE)                      NOT NULL,
  PQTY        NUMBER(10)                        NOT NULL,
  SQTY        NUMBER(5)                         NOT NULL,
  STORTYPE    CHAR(1 BYTE)                      NOT NULL,
  STORNAME    CHAR(8 BYTE)                      NOT NULL,
  VCATNAME    CHAR(8 BYTE)                      NOT NULL,
  CARD        NUMBER(10)                        NOT NULL,
  FAROFFPOS   NUMBER(10)                        NOT NULL,
  NEAROFFPOS  NUMBER(10)                        NOT NULL,
  IBMREQD     CHAR(1 BYTE)                      NOT NULL,
  FREEPAGE    NUMBER(5)                         NOT NULL,
  "PCTFREE"   NUMBER(5)                         NOT NULL
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_DEFS
(
  KEY     VARCHAR2(100 BYTE),
  VALUE1  VARCHAR2(100 BYTE),
  VALUE2  VARCHAR2(100 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_STREAMS_OBJECT
(
  INSTANCE_SOURCE         VARCHAR2(16 BYTE)     NOT NULL,
  INSTANCE_TARGET         VARCHAR2(16 BYTE)     NOT NULL,
  OWNER                   VARCHAR2(30 BYTE)     NOT NULL,
  OBJECT_NAME             VARCHAR2(128 BYTE)    NOT NULL,
  OBS                     VARCHAR2(4000 BYTE),
  STATUS                  VARCHAR2(8 BYTE)      NOT NULL,
  CAPTURE_NAME            VARCHAR2(30 BYTE)     NOT NULL,
  APPLY_NAME              VARCHAR2(30 BYTE)     NOT NULL,
  PROPAGATION_NAME        VARCHAR2(30 BYTE),
  CAPTURE_QUEUE_NAME      VARCHAR2(30 BYTE)     NOT NULL,
  APPLY_QUEUE_NAME        VARCHAR2(30 BYTE)     NOT NULL,
  PROPAGATION_QUEUE_NAME  VARCHAR2(30 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_DVT1_20090311
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DR$SIOBJECT_CTX_IDX$I
(
  TOKEN_TEXT   VARCHAR2(64 BYTE)                NOT NULL,
  TOKEN_TYPE   NUMBER(3)                        NOT NULL,
  TOKEN_FIRST  NUMBER(10)                       NOT NULL,
  TOKEN_LAST   NUMBER(10)                       NOT NULL,
  TOKEN_COUNT  NUMBER(10)                       NOT NULL,
  TOKEN_INFO   BLOB
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
LOB (TOKEN_INFO) STORE AS 
      ( TABLESPACE  D3SOX01T 
        ENABLE      STORAGE IN ROW
        CHUNK       8192
        RETENTION
        NOCACHE
        INDEX       (
          TABLESPACE D3SOX01T
          STORAGE    (
                      INITIAL          5M
                      NEXT             1
                      MINEXTENTS       1
                      MAXEXTENTS       UNLIMITED
                      PCTINCREASE      0
                      BUFFER_POOL      DEFAULT
                     ))
        STORAGE    (
                    INITIAL          5M
                    NEXT             5M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
      )
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DR$SIOBJECT_CTX_IDX$K
(
  DOCID    NUMBER(38),
  TEXTKEY  ROWID, 
  CONSTRAINT SYS_IOT_TOP_1687533
 PRIMARY KEY
 (TEXTKEY)
)
ORGANIZATION INDEX
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DR$SIOBJECT_CTX_IDX$R
(
  ROW_NO  NUMBER(3),
  DATA    BLOB
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
LOB (DATA) STORE AS 
      ( TABLESPACE  D3SOX01T 
        ENABLE      STORAGE IN ROW
        CHUNK       8192
        RETENTION
        CACHE
        INDEX       (
          TABLESPACE D3SOX01T
          STORAGE    (
                      INITIAL          5M
                      NEXT             1
                      MINEXTENTS       1
                      MAXEXTENTS       UNLIMITED
                      PCTINCREASE      0
                      BUFFER_POOL      DEFAULT
                     ))
        STORAGE    (
                    INITIAL          5M
                    NEXT             5M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
      )
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DR$SIOBJECT_CTX_IDX$N
(
  NLT_DOCID  NUMBER(38),
  NLT_MARK   CHAR(1 BYTE)                       NOT NULL, 
  CONSTRAINT SYS_IOT_TOP_1687538
 PRIMARY KEY
 (NLT_DOCID)
)
ORGANIZATION INDEX
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M20090429_SS080019_PRJ1_PRJVAL
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.B20090316_SS080019
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_HVT1_20090311
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_DVT1_20090407
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_REPLICA
(
  HOSTNAME     VARCHAR2(64 BYTE)                NOT NULL,
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE),
  TABLE_NAME   VARCHAR2(30 BYTE)                NOT NULL,
  LOAD_DATE    DATE                             NOT NULL,
  STATUS       VARCHAR2(7 BYTE),
  MSG          VARCHAR2(4000 BYTE),
  BYTES        NUMBER,
  SQL_SELECT   LONG,
  SQL_DELETE   VARCHAR2(4000 BYTE),
  NUM_REG_DB2  NUMBER,
  NUM_REG_FTP  NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M20090415_SS080019_PVT1
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.BLOQUEIO_20090916_SS080019
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M20090512_SS080019_PRJ1_SGT
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_DVT025_20090514
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_DVT025_20090515
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DESATIVACOES_FASE3_MAI2009
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DESATIVACOES_FASE2_MAR2009
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.BLOQUEIO_20091027_SS080019
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.B20090601_SS080019
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  RENAMED_TO   VARCHAR2(100 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_INSTANCE_SERVICE
(
  INSTANCE        VARCHAR2(16 BYTE)             NOT NULL,
  SERVICE_NAME    VARCHAR2(32 BYTE)             NOT NULL,
  SERVICE_TNS     VARCHAR2(32 BYTE),
  SERVICE_STRING  VARCHAR2(2000 BYTE),
  USER_MAPED      VARCHAR2(2000 BYTE),
  DESCRIPTION     VARCHAR2(2000 BYTE),
  INSERTED        DATE                          NOT NULL,
  INSERTED_BY     VARCHAR2(50 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.M_DVT1_20091021
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_MAPPING_IDM
(
  INSTANCE        VARCHAR2(16 BYTE)             NOT NULL,
  CONNECT_STRING  VARCHAR2(2000 BYTE),
  PRIORITY        NUMBER(3),
  CREATEUSER      CHAR(1 BYTE)                  DEFAULT 'N'
)
TABLESPACE D4TRAM1T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.SARBOX_MAPPING_LOG
(
  DTLOG     DATE                                NOT NULL,
  USERNAME  VARCHAR2(30 BYTE)                   NOT NULL,
  OPERTYPE  VARCHAR2(10 BYTE),
  ERRORM    VARCHAR2(400 BYTE)
)
TABLESPACE D4TRAM1T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.BLOQUEIO_20100120_LOGIST
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  OWNER        VARCHAR2(30 BYTE)                NOT NULL,
  OBJECT_NAME  VARCHAR2(128 BYTE)               NOT NULL,
  OBJECT_TYPE  VARCHAR2(19 BYTE),
  DROPPED      VARCHAR2(10 BYTE),
  NEWNAME      VARCHAR2(40 BYTE),
  CMD1         VARCHAR2(150 BYTE),
  CMD2         VARCHAR2(150 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DEMANDA_11354_NAO_ORACLE
(
  INSTANCIA  VARCHAR2(15 BYTE)                  NOT NULL,
  ANOMES     NUMBER,
  SIGLA      VARCHAR2(8 BYTE),
  SISTEMA    VARCHAR2(40 BYTE),
  OWNER      VARCHAR2(30 BYTE),
  ALOC       NUMBER,
  USADO      NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.PLANCAP_201003
(
  INSTANCE       VARCHAR2(16 BYTE),
  DATA_START     DATE,
  MB_START_ALOC  NUMBER,
  MB_START_USED  NUMBER,
  DATA_END       DATE,
  MB_END_ALOC    NUMBER,
  MB_END_USED    NUMBER,
  PCT_ALOC       NUMBER,
  PCT_USED       NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE TABLE PCSOX.DEMANDA_11354
(
  INSTANCE    VARCHAR2(50 BYTE),
  D4LUSORA    VARCHAR2(50 BYTE),
  COLETA      VARCHAR2(50 BYTE),
  MB_ALOCADO  NUMBER,
  MB_USADO    NUMBER
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE GLOBAL TEMPORARY TABLE PCSOX.TB_TMP_STREAMS
(
  INST_SOURCE  VARCHAR2(30 BYTE),
  INST_TARGET  VARCHAR2(30 BYTE),
  ERRORS       VARCHAR2(4000 BYTE)
)
ON COMMIT PRESERVE ROWS
NOCACHE;


CREATE TABLE PCSOX.SARBOX_INSTANCE_AUDITLOGIN
(
  INSTANCE     VARCHAR2(16 BYTE)                NOT NULL,
  LOGIN_DATE   DATE,
  USER_ORACLE  VARCHAR2(64 BYTE),
  USER_SO      VARCHAR2(64 BYTE),
  MACHINE      VARCHAR2(64 BYTE),
  PROGRAM      VARCHAR2(64 BYTE)
)
TABLESPACE D3SOX01T
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_TABLESPACE_PK ON PCSOX.SARBOX_INSTANCE_TABLESPACE
(INSTANCE, TABLESPACE_NAME, DTCOLLECT)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_DE_PARA_ACN_PK ON PCSOX.SARBOX_DE_PARA_ACN
(CHAVE_C00)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_FS_PK ON PCSOX.SARBOX_INSTANCE_FS
(HOSTNAME, FILESYSTEM)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_TEMP_INSTANCE_OBJ_IX01 ON PCSOX.SARBOX_TEMP_INSTANCE_OBJECT
(INSTANCE, OWNER, OBJECT_TYPE, OBJECT_NAME)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_INSTANCE_TABLESPACE_IX ON PCSOX.SARBOX_INSTANCE_TABLESPACE
(DTCOLLECT)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_IDM_PK ON PCSOX.SARBOX_INSTANCE_IDM
(INSTANCE, INSTANCE_SOURCE)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_JOB_PK ON PCSOX.SARBOX_INSTANCE_JOB
(INSTANCE, JOB, LOG_USER, PRIV_USER, SCHEMA_USER)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_MF_VOLS_PK ON PCSOX.SARBOX_MF_VOLS
(VOL_ID)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_MF_VOLS_FREESEGS_PK ON PCSOX.SARBOX_MF_VOLS_FREESEGS
(VOL_ID, SEG_ID)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.USER_FOR_DROP_108_PK ON PCSOX.USER_FOR_DROP_108
(USERNAME, NUMEIMAC)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_REGISTRY_PK ON PCSOX.SARBOX_INSTANCE_REGISTRY
(INSTANCE, COMP_ID)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_STORAGE_PK ON PCSOX.SARBOX_INSTANCE_STORAGE
(INSTANCE, FILESYSTEM, DTCOLLECT)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_PK ON PCSOX.SARBOX_INSTANCE
(INSTANCE)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          32K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_LINK_PK ON PCSOX.SARBOX_INSTANCE_LINK
(INSTANCE, OWNER, DBLINK)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_LOGIN_PK ON PCSOX.SARBOX_INSTANCE_LOGIN
(INSTANCE, USERNAME, PROGRAM, USERSO)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_PROFILE_PK ON PCSOX.SARBOX_INSTANCE_PROFILE
(INSTANCE, PROFILE, RESOURCE_NAME)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_ROLE_PK ON PCSOX.SARBOX_INSTANCE_ROLE
(INSTANCE, ROLE)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_ROLEPRIV_PK ON PCSOX.SARBOX_INSTANCE_ROLEPRIV
(INSTANCE, GRANTEE, GRANTED_ROLE)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_SYSPRIV_PK ON PCSOX.SARBOX_INSTANCE_SYSPRIV
(INSTANCE, GRANTEE, PRIVILEGE)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_TABPRIV_PK ON PCSOX.SARBOX_INSTANCE_TABPRIV
(INSTANCE, GRANTEE, OWNER, TABLE_NAME, GRANTOR, 
PRIVILEGE)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_USER_PK ON PCSOX.SARBOX_INSTANCE_USER
(INSTANCE, USERNAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          264K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_USER_HIST_PK ON PCSOX.SARBOX_INSTANCE_USER_HISTORY
(DTCOLETA, INSTANCE, USERNAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_INSTANCE_TABPRIV_IX01 ON PCSOX.SARBOX_INSTANCE_TABPRIV
(INSTANCE)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_INSTANCE_OBJECTS_IX02 ON PCSOX.SARBOX_INSTANCE_OBJECT
(INSTANCE)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_MF_SEGS_PK ON PCSOX.SARBOX_MF_SEGS
(DSN_NAME, DB_NAME, TBS_NAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_TEMP_MF_SEGS_IX01 ON PCSOX.SARBOX_TEMP_MF_SEGS
(DSN_NAME, DS_DBNAME, DS_TBSNAME, DS_PNAME, EXT_SEQ)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_USER$_PK ON PCSOX.SARBOX_INSTANCE_USER$
(INSTANCE, USER#, NAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_TROCA_LOG_IX1 ON PCSOX.SARBOX_TROCA_LOG
(USERNAME, MENSAGEM)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_USER_PASSWORD_PK ON PCSOX.SARBOX_USER_PASSWORD
(USERNAME, DTGERACAO, TYPE)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_MF_VOLS_SEGS_NEW_PK ON PCSOX.SARBOX_MF_VOLS_SEGS_NEW
(VOL_ID, DSN_NAME, DB_NAME, TBS_NAME, PART_NAME, 
DT_UPD)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_STREAMS_PK ON PCSOX.SARBOX_INSTANCE_STREAMS
(INSTANCE_SOURCE, OWNER, INSTANCE_TARGET)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_OBJECTS_PK ON PCSOX.SARBOX_INSTANCE_OBJECT
(INSTANCE, OWNER, OBJECT_ID, OBJECT_NAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_PARAMETER_PK ON PCSOX.SARBOX_INSTANCE_PARAMETER
(INSTANCE, NAME, INST_ID)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_EXPORT_PK ON PCSOX.SARBOX_INSTANCE_EXPORT
(INSTANCE, ID_PROCESS)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_STARTUP_PK ON PCSOX.SARBOX_INSTANCE_STARTUP
(INSTANCE, STARTUP_TIME)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_INSTANCE_OBJECTS_IX03 ON PCSOX.SARBOX_INSTANCE_OBJECT
(OWNER)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_MF_VOLS_SEGS_IX ON PCSOX.SARBOX_MF_VOLS_SEGS
(VOL_ID)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SARBOX_INSTANCE_OBJECTS_IX01 ON PCSOX.SARBOX_INSTANCE_OBJECT
(OBJECT_NAME)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_CLUSTER_PK ON PCSOX.SARBOX_CLUSTER
(CLUSTER_ID)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_CLUSTER_NODE_PK ON PCSOX.SARBOX_CLUSTER_NODE
(CLUSTER_ID, NAME)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_USER_DESCRIPTION_PK ON PCSOX.SARBOX_USER_DESCRIPTION
(USERNAME)
NOLOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_STREAMS_OBJ_PK ON PCSOX.SARBOX_INSTANCE_STREAMS_OBJECT
(INSTANCE_SOURCE, INSTANCE_TARGET, OWNER, OBJECT_NAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PCSOX.SIOBJECT_CTX_IDX ON PCSOX.SARBOX_INSTANCE_OBJECT
(OBJECT_NAME)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS('DATASTORE CTXSYS.DEFAULT_DATASTORE')
NOPARALLEL;


CREATE INDEX PCSOX.DR$SIOBJECT_CTX_IDX$X ON PCSOX.DR$SIOBJECT_CTX_IDX$I
(TOKEN_TEXT, TOKEN_TYPE, TOKEN_FIRST, TOKEN_LAST, TOKEN_COUNT)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL
COMPRESS 2;


CREATE UNIQUE INDEX PCSOX.SARBOX_INSTANCE_SERVICE_PK ON PCSOX.SARBOX_INSTANCE_SERVICE
(INSTANCE, SERVICE_NAME)
LOGGING
TABLESPACE D3SOX01T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PCSOX.SARBOX_MAPPING_IDM_PK ON PCSOX.SARBOX_MAPPING_IDM
(INSTANCE)
LOGGING
TABLESPACE D4TRAM1T
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             5M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE DATABASE LINK "ORAPON001_SARBOX_VD.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-pon001-01)(PORT=1521)))(CONNECT_DATA=(SID=pon001)))';


CREATE DATABASE LINK "ORAPON001_SARBOX.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-pon001-01)(PORT=1521)))(CONNECT_DATA=(SID=pon001)))';


CREATE DATABASE LINK "ORAPON001_SARBOX_D4C.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-pon001-01)(PORT=1521)))(CONNECT_DATA=(SID=pon001)))';


CREATE DATABASE LINK "ORADGB004_SARBOX.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=BRQSB1VALEDB071)(PORT=1521)))(CONNECT_DATA=(SID=dgb004)))';


CREATE DATABASE LINK "ORAPMVS_TOBDBA.WORLD"
 CONNECT TO TOBDBA
 IDENTIFIED BY <PWD>
 USING 'orapmvs';


CREATE DATABASE LINK "ORAPMVS_PCSOX.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING 'orapmvs';


CREATE DATABASE LINK "ORAPVT008_DROPUSER108.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-pvt008-01)(PORT=1521)))(CONNECT_DATA=(SID=pvt008)))';


CREATE DATABASE LINK "ORAPVT005_AUDITLOGIN.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING 'orapvt005';


CREATE DATABASE LINK "ORAPVT4_SARBOX.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=susvtsb4)(PORT=1521)))(CONNECT_DATA=(SID=pvt4)))';


CREATE DATABASE LINK "ORAMGPRJ001_DROPUSER108.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-mgprj001-01)(PORT=1521)))(CONNECT_DATA=(SID=mgprj001)))';


CREATE DATABASE LINK "ORAPVT001_DROPUSER.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING 'ORAPVT001';


CREATE DATABASE LINK "ORAJVT014_SARBOX.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-jvt014-01)(PORT=1521)))(CONNECT_DATA=(SID=jvt014)))';


CREATE DATABASE LINK "ORADEIL.WORLD"
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=eirepod01.inco.net)(PORT=1521)))(CONNECT_DATA=(SERVICE_NAME=eild)))';


CREATE DATABASE LINK "ORAPVT052_SARBOX_STREAMS.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(LOAD_BALANCE=YES)(FAILOVER=ON)(ADDRESS=(PROTOCOL=TCP)(HOST=ORA-PVT052-01)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=ORA-PVT052-02)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=SRN_PVT052_001)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=20)(DELAY=1))))';


CREATE DATABASE LINK "ORAHVT061_SARBOX_STREAMS.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(LOAD_BALANCE=YES)(FAILOVER=ON)(ADDRESS=(PROTOCOL=TCP)(HOST=ora-hvt061-01)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=ora-hvt061-02)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=srn_hvt061_001)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=20)(DELAY=1))))';


CREATE DATABASE LINK "ORAHVT052_SARBOX_STREAMS.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(LOAD_BALANCE= ON)(FAILOVER= ON)(ADDRESS= (PROTOCOL= TCP)(HOST= ora-hvt052-01)(PORT= 1521))(ADDRESS= (PROTOCOL= TCP)(HOST= ora-hvt052-02)(PORT= 1521))(CONNECT_DATA= (SERVICE_NAME= srn_hvt052_001.world)(FAILOVER_MODE= (TYPE= SELECT)(METHOD= BASIC)(RETRIES = 20)(DELAY = 1))))';


CREATE DATABASE LINK "ORAPVT061_SARBOX_STREAMS.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(LOAD_BALANCE=YES)(FAILOVER=ON)(ADDRESS=(PROTOCOL=TCP)(HOST=ora-pvt061-01)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=ora-pvt061-02)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=srn_pvt061_001)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=20)(DELAY=1))))';


CREATE DATABASE LINK "ORADVT061_SARBOX_STREAMS.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=ora-dvt061-01)(PORT=1521)))(CONNECT_DATA=(SID=dvt061)))';


CREATE DATABASE LINK "ORADVT052_SARBOX_STREAMS.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(LOAD_BALANCE=ON)(FAILOVER=ON)(ADDRESS=(PROTOCOL=TCP)(HOST=ora-dvt052-01)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=ora-dvt052-02)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=srn_dvt052_001)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=20)(DELAY=1))))';


CREATE DATABASE LINK "ORADGB004_SARBOX_VD.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=BRQSB1VALEDB071)(PORT=1521)))(CONNECT_DATA=(SID=dgb004)))';


CREATE DATABASE LINK "ORADGB005_SARBOX_VD.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=BRQSB1VALEDB071.CVRD.BR)(PORT=1521)))(CONNECT_DATA=(SID=DGB005)))';


CREATE DATABASE LINK "ORADGB003_SARBOX_VD.WORLD"
 CONNECT TO PCSOX
 IDENTIFIED BY <PWD>
 USING '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=BRQSB1VALEDB071.CVRD.BR)(PORT=1521)))(CONNECT_DATA=(SID=DGB003)))';


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PACKAGE pcsox.pak_sox00001
IS
   FUNCTION gs
      RETURN VARCHAR2;

   FUNCTION gsu
      RETURN VARCHAR2;

   FUNCTION c (p_k IN VARCHAR2, p_s IN VARCHAR2)
      RETURN RAW;

   FUNCTION d (p_k IN VARCHAR2, p_s IN RAW)
      RETURN VARCHAR2;

   PROCEDURE nuser (
      p_k   IN   VARCHAR2,
      p_i   IN   VARCHAR2,
      p_u   IN   VARCHAR2,
      p_r   IN   VARCHAR2,
      p_d   IN   VARCHAR2,
      p_t   IN   VARCHAR2 DEFAULT 'P',
      p_p   IN   VARCHAR2 DEFAULT NULL
   );

   PROCEDURE nuser (
      p_k   IN   VARCHAR2,
      p_u   IN   VARCHAR2,
      p_t   IN   VARCHAR2 DEFAULT 'P'
   );

   FUNCTION ctr (c IN VARCHAR2)
      RETURN RAW;

   FUNCTION ctv (r IN RAW)
      RETURN VARCHAR2;

   --procedure   change_pass(p_k in varchar2, p_opertype in char default 'M', p_user in varchar2 default 'ACB299');
   FUNCTION apura_disponibilidade (
      p_instance   IN   VARCHAR2,
      p_instid     IN   NUMBER,
      p_month      IN   NUMBER,
      p_notify     IN   VARCHAR2 DEFAULT 'Y'
   )
      RETURN NUMBER;

   PROCEDURE coleta_sarbox (
      p_instance   IN   VARCHAR2 DEFAULT '%',
      p_full       IN   VARCHAR2 DEFAULT 'S',
      p_email      IN   VARCHAR2 DEFAULT NULL,
      p_notify     IN   VARCHAR2 DEFAULT 'Y',
      p_debug      IN   BOOLEAN DEFAULT FALSE
   );

   PROCEDURE verifica_disponibilidade (
      p_email    IN   VARCHAR2 DEFAULT NULL,
      p_notify   IN   VARCHAR2 DEFAULT 'Y'
   );

   PROCEDURE report_disponibilidade (
      p_email    IN   VARCHAR2 DEFAULT NULL,
      p_notify   IN   VARCHAR2 DEFAULT 'Y'
   );

   PROCEDURE verifica_export (
      p_dia      IN   NUMBER DEFAULT 1,
      p_email    IN   VARCHAR2 DEFAULT NULL,
      p_notify   IN   VARCHAR2 DEFAULT 'Y'
   );

   PROCEDURE verifica_privsoutsi (
      p_email    IN   VARCHAR2 DEFAULT NULL,
      p_notify   IN   VARCHAR2 DEFAULT 'Y'
   );

   PROCEDURE reports (
      p_email    IN   VARCHAR2 DEFAULT NULL,
      p_month         NUMBER DEFAULT NULL,
      p_notify   IN   VARCHAR2 DEFAULT 'Y'
   );

   PROCEDURE verifica_node (
      p_email    IN   VARCHAR2 DEFAULT NULL,
      p_notify   IN   VARCHAR2 DEFAULT 'Y'
   );

   PROCEDURE auto_verificacao (p_email IN VARCHAR2 DEFAULT NULL);

   PROCEDURE getinfo_oem;

   PROCEDURE drop_user;

   PROCEDURE grava_log (
      p_instance      IN   VARCHAR2,
      p_table_name    IN   VARCHAR2,
      p_column_name   IN   VARCHAR2,
      p_rowvalue      IN   VARCHAR2,
      p_oldvalue      IN   VARCHAR2,
      p_newvalue      IN   VARCHAR2,
      p_instid        IN   NUMBER DEFAULT 1
   );
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PACKAGE pcsox.demo_pkg
AS
   TYPE rc IS REF CURSOR;

   PROCEDURE get_query (p_cursor IN OUT rc);
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PACKAGE BODY pcsox.pak_sox00001 WRAPPED a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
3ff71 2a6d0
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
Re0fL1NLSq+qLa
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
xWROdvr4/Bfg52reKkrlAnJaHtWS+
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
tl10pqamUb0CTxQeUavq8idRRtY4
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
jXHnpmcha6W3k
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
m
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
OleHW0hV3kXLsGrO
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
JkjMiIBDVUrebSS2J/9jM40DurBXisF
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
icY+PGW5hB2mYnAZMkMj8vh7y6
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
MynrnIYpKbn
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
nYl
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
mBs5V2QFDJ3nGS/9Hw
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
hYNoux1LLYlr0L9j13Miw6amDtTNVxfd1AlAIhm
NBVL/lKamTVJ1hBjXInALPoQsu5c4yz7f
+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
vvoHvmGJjkiXP4qSTCxFgwkJ
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
1rWqQVLkZ
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
Q0tYz
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
0K6dvDv/eJSmplTyH+xz
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
3LvAeijEzUK/yO7BpT8AP8GahyixHcZOuAVBv
1unkYZUSBVdxJqwhrQNO723ylyoDTIogh7g
JeIh61JWeDibBbvrAuGmpqaph/KaId/XnGhijqampqbOPFfy9JYtsjM+wps3hwYL7Wmmpqam
aRKaxaampqamKxuN/fL0li2yMz7gTJvS0w/g/Yq32Naf+nVuhwYMftYQ8d+0SboTDfopbLzb
37RJs1wLkM7fk7tvnqampqamTn62c9RX8vSWLbIzPvkGz6M6/1yZRKampqapTLMMKRPUG6fk
gblKoH/c+6ampqamibzefqMWpqampqaph/KaId9/D8DEaaampqamBOo46plEpqampmeWYyCr
E3WWKWPSLgu2qu6xAgmmpqampvV5Y7eo/GnOFy3RG83y7whsYa8iPqampqamUaFnlM8F7J6m
cKGLz+impqampoX7TQmUzwXsnqanU+LilKampqamc9Q21jJ/3uqrpnChsWEbWazDAnc8AEfY
baGYJVmUpqampqaDXN17EZxf+6ZUJQzP9HlLrsLLg2wLjqampqamg1xn/Yq3O9eDpt3xhwYM
ftYQ8d+0SboTDZMWRKampqapTPMsHg+suwyavtvx2iXUV46mpqampqkys0ZGMvq2MhbkA1Qf
t59j987TBXBPjqampqampqZZ2G2hmCVd2Naf+nVu37RJuhMN+rNcC5DO35O7wOWPBTzDrVzl
rCC6Xi6UpqampqampRoe/6JEpqampqamprfieS51NiaeJjsSdZMft59jWIvS0w/g/Yq32Naf
+nVuhwYMftYQ8d+0SboTDfopbLzb37RJs1wLkM7fk7vAZcEDdrE9gfVrpqampqZ84hXib/L7
pqamqVKUDf7N5vumpqZnKRPU6ALhpqamqcIzs2nyz/R5S65Sa6ampqYOnM5Ugg/xVeKa/5jN
zd15+EPN3fhIU+R1sgUenNkovqTcu8B6KMTNQr/I7sGlPwA/F6rtNIJo0bHNsYRhaaampqZw
QS4xbNZ5q16TkHTt28Yja6ampqaGxYona46mpqZw6n3l5VmzOzu6QqcaUIgl1FdEpqampvI+
pqampn1jZenEp8WI6vt8D/E0if2kGwhsK3tYbn6dtTB7EDSHZOqHDyQQQU9KTjiF6JlEpqam
pjzpttM8bK66YLV6bXuO+ZPFXvX2QfVVWIUUA8HuYQC7y8fCUoqDPEahyOXIg0UHWDJ/3urs
KVfJz6kwBYcgx8JSimNl6cSnxZUahKvGXyh1Tj/c30rtw+h9PAlshuVSR85ng8uq//rUf/iB
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
Z/3YKN/tpqZLGh+6KiU5Ht
Yulp6mpqamqXYW1rP69bM2pnChlmEnGnRgSevpto6mpqampnPU
NtYyf97qq6ZwobFhG1mswwJ3PABH2G2hmCVZlKampqamg1ypMn/e6qv0vJljkyVtO6st0RvN
8u+zv2shmUSmpqamqUzzLB4PrLsMmr7b8dol1FeOpqampqapMrNGGqampqampqYe8Un8ac4X
LdEbzfLvYSeOpqampqamplnYbaGYJV1UH7efY/d9mGnsbiXaF5cUf0QePK15SyK00vFeOYy3
KVG9XkSmpqampqZ6KUWCzPumpqampqbdGva6ths15eYnHhzJPJUaTN7ore205fMe4CXiIdMQ
H/K36207qz7tx+hZ015LSJDrbTur3taBr+icbod+PVqIX9zobRtZH56mpqampobFiidrpqam
pt1TGIP4n2umpqamDtIuC+vm+6ampmeT+BEWY7M7O+wC4aampkfH3oOR7V6mpqamUCBfarDw
vfegf9z7pqampnDq28ZF0o04+geaJKpmeV9epqampqam4goeAuGmpqam3VOemKMWpqam3VMn
a46mpqZw6n3l5VmzOzu6QqcaUIgl1FdEpqampvI+pqampn1jZenEp8WI6vt8D/E0if2kGwhs
K3tYbn6dtTB7EDSHZOqHDyQQQU9KTjiF6JlEpqampjzpttM8bK66YLV6bXuO+ZPFXvX2QfVV
WIUUA8HuYQC7y8fCUoqDPEahyOXIg0UHWDJ/3ursKVfJz6kwBYcgx8JSimNl6cSnxZUahKvG
Xyh1Tj/c30rtw+h9PAlshuVSR85ng8uq//rUf/iBZL/PDmiHnUgxLFfkMJ1xIDH1a6ampqYO
nJeOVaPljrfLvXWWoYeX8Mu3ztPVkFncYZqqepAih2Sx1WRkTyJyrsY6fJHrAuGmpqZfCksK
AgmmpqapCZ6mpqZppqamZ5aN3Bsx1KCvnEec25xUKZFvnqamplQ6Z8gSD+NC1Hsbs3foWTaa
BRhcpbLMBxUkbTJ/3uqrvv5Ec9Q2hLFhG1nYbaGYJVmTJQ07vbfKXKgNMiiCHuAl4iFeoApN
rCC6XgjEnbftdXUulKampmkSmsWmpqamfYPySYR3a6Vy4ExZg41guRBrpqampsrsNmlEmmHo
4aeRlhvJnqampqbApk0JlM8F7Bhs7cN7WJH96zkPxaampqZ9eBsErLt5lfHK/rwvTnqZvMQ9
5vumpqbUXHcZxJlEpqamibzefqMWRKamphampqYOnM5Ugg/xsgfEarnUnYe8XSCcZJt5V3FO
/h4ImM/9y7HPtO0c3Lo633biOgWfU/o/EtpdIAXuG2o4nJqH0NaKxMSEPxIAy2V2nzo6pYYb
+M3NyE8oJEhldp86zcAFvPrNMHtdD+KcJCjB5DC8pOKaxCA6LAWGBcQeOIW1zTIS2XIg1nb/
mk7rUrT67uQAJEEHBTM02qXGgcDgtQHVtSM6ZeTv/cbKXKgNMiiCHuAl4iGGdfpL7T++5IVv
nqampn1j0i4L68/6Veb7pqamvCpKCbkQr5dbI/TQgeb7pqamDf474aampqmNoUNACbkQNzL6
69ntll0ZH0KW/rzIg2RjbRtd7Wj45oNwTxptG13taPgGnb9BjdHsyP7Au5kmMlkJKZGbh7kQ
qA1KoVE+Toe5EKjeC4zDe1g0nBIPWoO0FrOJQpb+vC8XQbfDe1g0nBIP44JyoVE+Toe5EKj6
SUwMwvD6Er7+Ao6vJASc/sC7mS3RWKUaHjScEg+F8gVFmRuL7Wj45pLw3EKW/rwv6oB/uT67
QxkfJbRUGFKuQpb+vC8e4CXiIeAKAuGmpqamTn62c9RX8r7+lZb/sI27cQ1ppqampnDq0gmS
6C30bKrtmO95X16mpqampom83n6jFqampqamIz4Q67Tbz/pV5vumpqapUpSfDWmmpqamUAwp
E9QbiwwjPhDrtNsPzjJrpqampg721ZB0zAcVJG0yf97qq77+AuGmpqapEdNnOwvx8kkd3fGH
uRCoDUqhxZBf4aampql2piekt6Je4d3xh7kQqA1KoVE+lKampqZdpsjf3/Jjt/twoZb+vMig
LczFkF/hpqamqXamJdRg9Og2qWztaPjmJdRg9OjDpqampsgdqYJyocWQdKYMI77+AldObhol
+hampqamhfvdWMEUs4mmSxqcEg/jgnKhUT6Upqampl2myM8lDRQFBKls7Wj45vGuRaeR/Yym
pqamylupZs5bhqamp9LAu5k+rKp83PumpqZny6Y8bLZB9bKmDCO+/gJUnFkwJQ3hpqamqXam
K4M8THzzpqfSwLuZk966v6+iRKampqatptL9kKamcKGW/rzIP4y34aampql2pnGklVNJpnCh
lv68L+qAf7mh+6ampmfLpvDwYwT+NqYMI77+AiHfp+Bot+GmpqapdqbYbaGYJeM7qWztaPjm
2G2hmCXjO46mpqamXaZpRJph6OGmp5H/F56mpqamwKZNCZTPBeyeqWziCvZEpqampnPUNh08
lRpM3qZwobFhG1mswwJ3PABH2G2hmCVZlKampqYR6vto+OGmplQl2e2WXRkfnqampqagCqYn
nafR7KamDCO+/gJ3P2JMITX7pqamqZ+UZ/2Kt/WzNqan0sC7md7WEPHR7A6mpqamZ5ieyqf9
6xEpUb3d8Ye5EKgtaHVgDB8uVBampqamS9UGC3MMpRAp2pxUwICDBAfhpqampt1FEeYJpqam
pqamPGyud2ulcuBMWYONYLkQa6ampqampqn0Mn/e6uxuEg9ddz9iTCGosLIzoUUR5txWeOiz
Jem2wCekt8N7WG6jxhSzia3eC4zDe1huoC3MUT7HbkLcCSmRwG5C3NMuWLfPJQ0UBXVuZs5b
hsDYDBt6KXsXY3lVRLbHkvDcreJK4Ghe3AsLPtQAQ1Qft59j87pDw6/EOybA5cNEmmHolybx
MrNGIVympqampqauRblZw6ampqampt0a9rq2GzXl5iceHMk8lRpM3uit7Wj45rkQ9+vZ7ZYa
M/YpUb2t7Wj45oNwTxptG13SwLuZ9EPUIaNFEebclv68yKPGFI3cG7CcEg9aOwvxEZduh7kQ
qN4LjMN7WG6HuRCo3guMol6L0sC7mVKLraFjt/opQxkfBkfH8RGXboe5EKj6SUwMwvD6KUMZ
Hwk2tXBx3Jb+vC8e8b2uRf8pQxkfwiVhuaz0re1o+OaS8Nyt7Wj45nGklVOwboe5EKjw8GME
/onr2e2W20V1oNXwtMVJxyLZUkxMwRpQvsDTD+Bjt1jcH56mpqamXwpLCgIJpqamqVKUDf7N
5vumpqZjIKsTb56mpqYW9iyyY2j44GuOpqamcOp95eVZszs7ukKnGlCIJdRXRKampqbyPqam
pqZ9Y2XpxKfFiOr7fA/xNIn9pBsIbCt7WG5+nbUwexA0h2Tqhw8kEEFPSk44heiZRKampqY8
6bbTPGyuumC1em17jvmTxV719kH1VViFFAPB7mEAu8vHwlKKgzxGocjlyINFB1gyf97q7ClX
yc+pMAWHIMfCUopjZenEp8WVGoSrxl8odU4/3N9K7cPofTwJbIblUkfOZ4PLqv/61H/4gQ+5
zme+7T9VwiSln3q1rZHrAuGmpqaph8Ve9fYmCVl7FHC8FEI+eHtZBgzY9WWtMT+1CPWSMO2H
ZDS8P5J6JKTBasguH56mpqZ84hXib56mpt1TnpijFkSmpg6J4aamfYPySR3MBxUkbTJ/3uqr
RKamLy7hyhuQReemVvrkhOimpqbApg5/f/wN+6ls7Xc8eaB3P9dX8TSJ/aQbCGwre1hufp21
MHsQ5DpOwa6HDyQQQU9KTjiF6F/vMXQS+YbAAHm1xLVzfEuYNKRIBXOfcL+tf88FpEDuZdmO
pqZny6Z1L88Rpqls4gr2RKamyB2mfymRq4bT3dOxPQ3hpqZ9eBsE3UV1oNWyDKzDAnc8AEfY
baGYJVa
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
7HZCQnR
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
eQOpKfvuSWmsGwmZZOHkPS
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
cCVWG/SfCDwHdKamZ9/e/Sj8hG+22OtWG/p
X2JgwHoS88YaP30SmWeyVFLM84zHsiiFt938d
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
qiMj7TRPhyyLT9kBoYNI
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
OJo/v
BLt+MKqBZ0c+aBXHMe6h2EyWSxy4MUyWgtXHB/NuP6SKUOcM82vDyK7D/4/vBLt+MKq
BZ1FS1ccxlwiOmosrtDG6aOcYcspReKjvROoPVenlQhX4pv6LPkwnuDlt76VwycMHiU8qEyx
XNU4ghqrxk7LphXNBGEq3CYdpkcKyFkylMDM6qgypqm+lcMnDB4lPKhMsVzVOIIaq4As0VYl
S1e7psoaQ0Kx+2c0ZcRcednZn76YRZ4xmiOw4ub8pqbHuj1hNH6cmAoKyBBTpbk0HanIpwY9
QrH73UiYdicOdDrARXl/jXsaf/WmaeZEeKicV2ympqmZx20md5+2wPRe/KYOW4l7XUUFYat4
+6amH4tvXiY7d6ixVWEdqRwvXiaEq4QMmNcBhaamH4tvXiZi6AnrSOv7ZyhULmPoOLampqYf
i29eJnkqjYP7ZygEmaamplN8xHXyeR6oTCzQbWFXHMFvXiY7QG7QxpUxBjBuulljYS31plAd
JUWgIeJAaNThpqmZx20md6c8Y2NSKl3fp8umI2ejnGHLKUXio70TqD1Xb6ZxdbpZY2Gg0Xmk
JTJMDdPfhOVSiqYOW2iJe3dM+6amU0taalEdqRy4A71jdLH7pqa4OC0QEL6aLMuWHE8suyy7
HIeKnVR20DInhieFSUMHwnYnfWIcHD/+Q9m7P3OBsQ8Q+eT4/iy8ej9Xdm+wpKbSqRPITol4
pqamHyVI7bmmDlvPVghy+6amqZnHbSZ3KwZPhFumAA5GCQaJ8v2/rQfD+6Yfi29eJjtGCQaJ
8v2/rQfD2qZ9+2yJ07DDg8WHZItrQHSm0Udi6Am6vWPbPo1hGLEKQk2ov6ZQHdTN4vDr0T3f
ucDLJuGmH4tvXiZ5aLmDV80JeYbRwcgnW6YAcGi5g1fNCXkKMO3sB6tlpnF1ulljYVKY9oag
DA07BoEnHCeFpKbSqQow/ac72yRbpqa4OEh/jYPiBnlUYdO1dnumfft4hEpqQ3ug07V2pqZT
fMR18nl4hEpqQ3ug07V2e6Z9+9lry5yEvc3AvzKUwPumcXW6WWNhQ2kH2WtGn76YRZ6+9aZQ
HcBU3M3AvzKUwPum3QK+lcMn2TitDdlVPVyFYx2pHHyLfHdLNqamU3zEdfJ5C8uEstnLpiNn
y2x3gfVMo/ATpqaPFWjgxQ1DaeZMrrFjPVO9pKbSqVLyKq4eClPLeUc4TTi9ph+Lb14meTQn
C8uEstnLpiPdV2PssIFccQcrhhumptFHYugJBTA9J2hGy6Yj3S6FbNwmPVO9pqZTfMR18nl4
qJxXYyuGG/WmUB1hHmuHLkLrBtOmptFHYugJBZ8Adwo+IKNxn6ZQHWEea4cuQuslS72mpnF1
ulljYc0jTepeGaAhfuZbpgDKB1JFvToHKwfPpCdt3nbAqyduJQ/uFWjgxQ1DfGF11Kiwa9Q+
MqZQHTyEJnmDQHfgqwduQKuw0uqm0Udi6AkFIxYNlSHLrbIq3CYdqRxp5ry9vpXD/MjUaaam
H4tvXiY7Rs+2wFljn6ZQHfKFeKjEdfKkJQTy/dSrIOHdAr6VwyfVqJpGdl4meQT2W6YAcABM
xlJUxHZAAfumjxVoKw07sB5Xyx52QAFbpgBwmJJr21JUxHZAAfumuDhICoNhCizydgcyy2rC
HakcS0xzaQZX2AVuC7JEpo8VaCsNeeokiVfLHq3Gq3umffsKVLocJ26DQ7n8xZGm3QK+Oye6
h2HZVT1chaSm0ql6YR5pmaam3QK+Oye61C2HB4P7ZyiFC5jLMrYMvUSmph+LYeV5iMZF9GNG
JftnKFSVg5tphnc8CGUoOgffy4bFpnF1BeVhUgTqax2pHEu8dgXf6OGmplN8xFx5Htl/aEAt
9aZQHTycC9k4ALLZ4aamH4th5XkQrUjgPmtHax2pHEsYDTtAq7Dfy4bFfuA+prg4SAqDPJyG
fOLmW6YAcABMxNegdKamqZnHbSZ3YUHieOtl9aZ8ZObL4yZ3qPCvAminnHmk68YDdfKkJQT/
2qYEsNcbPE7iHaniHqYOHanZuKReW6Z1ujo/zWoClTi1oJ2qTqX5OgjuwbH4GWr4wWoFVR66
u+5zTvk67sH4GWr4wWoFVQVr/qX5OsZqhp0F/hwZJKoxnby80hwZJKoxnby5Eii7T6rPvPjC
/oYe2R8ou09PM53k5DOwlQh1BZvCOwuSMG9eJoSraghTEQeYsa6WnaAgKPmbQrVF/qX5OqWf
/pKLu9E07T8QvCSt5CMwUxIFT/kzmtH/2qbdaNTeA/SBagK/waSmcINAkX7un9pD/CeXiyu8
D0+/pqmBIXnapqbi5qTq1G9IxF7i4OW3vgIFeW3ZeRwSx5nEBSv8yPYgSO6fBeajM4tvSMQ7
d2u58iBI6lKk8uTHfdd5tvKI4oQTm1ATBRuJZXEHb0jE7b5MlTJaahtuv6amRgVU1wrIX2Jo
SLBxtXsugSeDY0NCW6bdaGFeOsss0TTau6amdQV7Grul7hWYTsumqb55sJukInHjJnfPZcS4
mHlSvtcLILNvsPnUv8GkpqbHugfSpCJx4yZ3z2XEuJh5Ur7XCyCzb+2aP7/8xIthkJe/waSm
psdtJnegCO4VSJiyOhqK0QzXSceZxAVvnAV6M4thkJe/7b47hJK50tI0HaYOHabKh/Qmd8/C
BUiEIvp5QjE8fxB6bSZ3qPDuoHjEdfIuE16q+L8ZJgrIe6amUPumqTABSIagMdv8FZ0Q/txM
Anf7pqZf68m2HkJbpqZ8xFKDfuCB7hWYTsumpkagjmT/2qamfMRSg37gge4VaNTeA/Q9ms65
NB2mppjNwE01iJtD9QXgxTJaCxHun9pDg/umqdPlCQdxatOpmceZxAUr/Mj2W6amI0agdAym
U3zEuJh5qGLapqZQjHdruZ6m0UdiaEi6JoRVjcumptJTGB5pBk8dqZnHmBgeaQZPhFumpiN+
5j5qMhFeHKmZxwVGCUAeUOh69aamDsYbiWVxB29IxN0CvnnmPmoyEe6fBfumqRzqUqQlS72m
0UfNxeKEq99rHaamTsVdyugJByE53QJVn/2boUjZ2WFKKYaTWWPL3nSwpKamBCXTUjFhQquE
Po8VaBXNYZVD39DBpKam4+qX/h6d/+t63JjDTDCw4uYl+6am28Pm4qSmpqbg5bdlXdkpYZXD
/MjUUBXNn5cNHaamptzgxTJaC32VAQWL3nRj0vKkwLLZh1rZS4qNe3dMKQIFeXM4/SPqUqTy
5Md9eeY+ajIRXhwjE2mXuKSjU1Uz4gZ7Gji23NqmpqZodB5MFqSmpqa4wgVIhCL6eUIxPH8Q
em0md6jw7qB4xLiYeVK+1wsgSO6fBfKkwM3XYmhIulrZGWgVzWGNe3dMKY1VASY6kUjunwXy
pPzi0rzrbSZ3z2XEuJh5Y8sy6iNtKG3rmj+/gxMFXHEH07V2I8cFRglAHlDoetKLYb1jdLFr
AgV5IEjqUqQlS72wwaSmpufePoeQv6amRqCOZP/apmdaDB7eg0G/pqlSg37gALumpoYjxa+0
Fc2fl4E0Ham42kB58F78pqZOxRReTAJxd1xapKamCPI6PwDc2Y8VILXO+f78xRrLpqYaVSMQ
GfumLyUJNHu7psoaQ0Kx+2exMqZQ+2dbppzue+jLpnzEm3ODB5ltavneqrWL7nPZalXr2a7t
B/6W0HIHxAcZavicB65yvw8jKLsPvByHh7sjKLsPvBy8HIcjKLsPvGhzlg8sEii7D4c/GZ0Z
gRwZnc8/rTQA/hwZnc8FnRxBEii7D8sgvyAPEii7D7mHuySqHgA0qkIjOikIvv6l+UPu6+7N
UBIwtcD+I7U6DLvuc9nuzc3uO/6l+UOlOs3u19Bklg96NKqtNFXtvHPeUnqLYTR+HnUiQZXD
/MjUuHrRg+65gevZls0F1p3PGZ25ADSqrc8/EjBOvx8Zh50imk92PwB6aO3Nrqr
4B5VCW6Z1
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
aScKXtlqz8IWtV99q9+cfxqr
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
7DI7TTwqR1Ee5XkFYXkFYXkFYXkFJ2pDn
MlM1eUysgN9RScFYXkFYXkFYXkFYXkFYXkFYXkF
YXkFYXkFYXkFYXkFYXkFYXkFJ2qcbclM1YNhOzwNUXkFYXkFYaOxcZKPQOgpjqampsjZVn/c
mbES5VQynqam3TDwpHtEpqbIbQP5FnG7vQN9e44eC9OaEzuBf/S710UJzOoeqxiBf/S71zNX
lV0BIR7yPcP9nx/XRSvDkOGmpoUBX3hREuL+w1ywpqamimfR7a7HdUi0xzV7q2SmpqapcfmN
0so8Uu3BUV6mpqZn0f+SjLjtSR8Xc8xU6hVWReLknZrOgXPNwf5O2TruO4O4OmOTsRjlXqam
pmfR/5KMuO1JHxdzzFTqFVZF4uSdms6Bc83B/k7ZOu47g7g6Y5OxGOVepqam1OmMpqampkSm
pqaihllPpUnqsFU8oVkBkkWoTEg70BsUjP1EpqamVE8byh+QbtshEFympqbdL+jM+6ampg3h
pqamUVLorhpLzrxhIuzIX0hLIuzIX8nn61qJuHVIbYF/9LuyOhGsr5J12/5AAGtULLfOGX47
0KHPII6mpqZQyNF4nqampk2UpqamL/CCEOCJBXsClf4yWdPxsy7Wt3WX0lz7pqamhHVgyvJX
WcSVknXb/uh1BUKeofumpqY6Eaz7x9qwmDFLsGXETktX6j6mpqZnNDnjoSXTMV5YBUJUbpjU
5AgeBfhJT9C7lq5kwXLGWyK8VZokP8/k0s06Oq4/qpLkQ80FSZ1Pmg9Ph6r5tCuepqamL2T7
CVTPD8YUqIhVpSgJVM8PxphNbFhhQW1hmw+WE2D7pqamBiqpgX/0u7IS55WSddv+yfYQWQYS
jKampqlAoB6OpqamyNmd8Rzbe+L+cfWepqamhUMPoSjgpLES5Po9Pla8ZIZMd/FZunLpujpk
nC6EDNF7rfTekkXuUSmOpqamcFvAKRCrb8G0xzV7q2SmpqamypwZsDhSSh4AH5DhpqamqRFu
KbZzoM7DD9+epqamptiutsgMu+tLV7CmpqamcOfr56K9BylhVCy3zhmOx9quqD6mpqamhYC2
dHUFrVXXQACNvpAHlb7y+6ampqkwssgVBvh7G736fUAAPla8ZIZMd/FZ2h95Y8ympqamyocd
d3+ho2YSxcfaKG3HsXUkPxAStV1OCHNDKYHkOs7dxsT4+MbQ0E+8ACS1+ruuT52l+DpzgSmB
wdB5lY7joSXTMV5YBUJUbpiLKYEp+SnkkqXUhiydvO2qSApg+6ampqkwsnAQWQYSahzmLSIb
CO0xoyy3zhn1nqampqaKZ9HtrmoGdrXOKNFagIaUpqampqaepqampqlxI09Ala3i/nH1nqam
pqapEW4ptnOgzsMP356mpqamph7rNl0l+CFW/z6mpqampkB88GeJuHVIbYF/9Lsuf8ROjvHh
pqampsosLnxwSMH1eP0zw4ufHG/BxUSmpqamqTCyyBUG+Hsbvfp9QAA+Vrxkhkx38VnaH3lj
zKampqam47Gmf6GjZhLFx9oobcexeu0iVSSQDywZMOSGscT+cnljpqampqYvZPvY0KHPILSE
FjzGFLx4uh4L05oT3PumpqamcFvAKRCrb8G0xzV7q2SmpqampqbLi9QjRKampqampqKGWU/n
yZ8lE3vRB3Xmza7iHC5fwAuXjpFqEeCJ/V5HzWh+U2ilQ1ExUCyEEEKzfn3Qa7yDKvDhpqam
pqam2K62yNkEIKL+nqampqampgQVIeHMFThFYjzGFLx4lWj/XlqepqampqamhYC2dHUFrVXX
QACNvpAHlb7y+6ampqampgYqZ55tux51FBSM/TMaS868Sr/MDGXNcaCNYPumpqampqYGKmek
txpswrBlxE5LV7/wOoaxxP6uIiyaD0GHck/QKM/PmJ2q5M7OKQVOTk/k+dI6mZ1Pmg9Ph6r5
tCvw4aampqamptv2ph4L05r9My8YgX/0u9c8knXb/uhepqampqami2F4x8K36qampqampmci
q67s6GUYndU4l/f1IYf7pqampqamZ9ELNPNVx+2we267tU4FZOT1P/lDzf2WwbAoHBy+XcTG
tdxz+c7OxoZzxHJOarpeMp6mpqampt3knTWWcHEhnqampqamZ/umpqampl1l1P2zALES5Wqx
WLGqnQg6zvmb0pIz8KMsUyQkEIbN/dCqehmq+HqdIjQqXLCmpqampnyHCwfc+6ampqlSsxam
pqampo6mpqampr5fCGD1coFB/KUyi4GaIOTSM9vrHutz6zru8JKwTk6WF7mamocT5V6mpqam
cDTUy5DhpqamqXFugYDuI67R/5KMS+JGk/VMkByaTz8jRSSd6v3RnSEeo8wynqampnzRq0Sm
pqamvlce0BWBQXFugYA4TL0DfUUj+HInakOcyUzV5dz7pqam1PaKUD6mpqbdy10l+I5fCHiK
vsqk8OqmpqamyG0D+RZxu/qVk6qOPI18beIK64b4666u/sH+J2pDnMlM1eXc+6amptTpjKam
pqbKHxdzzFMZt20D+RbY1ThvTOogtZN5U+Ql2PbpPT6mpqbdMPCke0SmpnA01MuQCaampr5X
HtAVgUFxboGAOEy9A32DT3GQ2QQgov795WEn38++ETwNUaPqeG3ixzrqJdZUxO7lk7EYJ0zr
w5KMRnsfSX8uD3jDo6p4SpoCaSqQ4aamVPHVUllO31sTWb3xbacUMtGMVLGuGSBU8dU1m2Gc
dfLs8shxwQbYJJdFiyVbeCEusKamfIcLB9z7qQhFXqZwNNQu62g+pksdvqKGMoiVezPDLWak
8Oqmplb6jVfoQgWYPuxRbKGQ2RY8gbf+LrCmplTx1VJZTjMPbS4y0YxUsa4ZeJDhpoYqn32J
4V+xbllL1s1jdQVCniZennVqd/3tNmr6Ntq0h5d2ij7cDBhhQW2IlXvYwRRrJPK0a9fKbQzO
lb6yxwhewmqkPMfxUCxsilDJyJVs5ZjlzKnwnqbALSIbCL2mUUZq9brY0KHPIPJ1bljWAHk7
0KHPIPkMRRMusKbKnBE00YxUW1AsbLjtsJtcsI6m0gzjXg6WwFDHS7Dj8J6mpqbj1Fgi+7NA
O4F/9Lvw4aampt+mprNAzS4vT1/Mpqam3TmmyoNL7b0Gt7NsWf8WpqamcB2mL3m0GBw7lutu
il2UpqamS/um499+DYiRUiZG+ohEpqamfqamFYlzZcWmpqZw5+vnZ4m4dUhtgX/0uy69t4LH
S0nj3xampqZwHaYvbHboBeAQWQYSHaamogqmpqapzyGvpqKYDSIbCO04rqA49hBZBhKMpqam
pgirplGyBRPKIohMFV10P/JUrkwp1sP95WzR04rDeU2S+hLrsCeElPCCEMXtFFLrLr23gj1A
8stFg2nweAvFDCFrg2kuyY4Aow95TRuC0bNGJ4Q9cpLA6nlNkpMPPybfw8BQ6ZIZzqA2Xiqe
pqamL2T7yoNL7b0Gt39UrqTwghAGFEh/nHQ4q/TTy+t5s8njXYy9QGSLSgA9xxL5CO7PDyqe
pqamL2T7yoNLPTjsF4wxXjomCaampqkwsqazSIz3UCzZdoo+wrBFCo6mpqbKhx1noAURFNKA
pnCuMuo+pqamZzQ5qRHEP/KfU2oxZEABQS5NwQawkQeYYPumpqZeUBumdrnj33470KHPIN+i
/WF4Nc9lyYSgOBK220mMDHVuKYkJplCWqNw3vIV8WxIYtE2mpqapEW4ptrPRBWzsjwEhnqam
prSmZ6C6HgvTmv1EpqamfqbKg0vtvQa3s2xZ/xampqZwHaaS+DHZETlEpqamdDirNxbufFVv
HgvTmhPTGxeLcK6i/Y6mpqZL+6Zzc3pWvCz7pqamBG+a1aampnAdpswVOEViPMYUvHgB9Bum
L81RpqamqbKmor0HKWFULLfOGaamZ6CepqamhYC2dKL9YXg1z2U5pqkAagb4O/k/h1G9h/um
pqYGKmegOBK220kLpq
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
6Q/
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
ZVQgp/bw3ew
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
iS2M6OFi106RA8C3jwCqX3J68K
dRpQayihX4UJRoLx5oBTz5pPpqampqamly1hA5bmEFrmeAzGkhS+PdeLB3J59AEW/AMcmN5x
Y7BCQt5FSvR4F8+eoGyna01yI4roUpQiLsOZh5UYktjOjhYtdOkQPAt48Aql9yevCnUaUGso
oV+FCUaC8eaAMMe5rqampqampkNUBTEfayIUaxNjCxDxaPzJTmrBYdtljoGT0FUh4iXrNDQh
TMbbE/NP4Xn0ARb8AxyY3nECrrY9rOotUSLVIkTyVoTMT4G0LobFzxqjpcUbPvV9hNPvwo7u
XxpQ8xlfSaampqa5Qro3Bk7rMxdtJk2uA1TMT4G0Pi1upqampn37Ds7koHMx4MX861ampokw
4aampg5bqWGFZgMlirKSNAxyhacd/jQ7RmqWdj5IKTampqampmf36cljvbKSNAxy/WF2U8F5
bHY/7lpSDEmmpqampqYYVmXV14w1T78pvktD3QAg1e6lmYAYunv7pqampqZpkfeT3os5EBlj
wWK6y2hOYdPLnbgaU2O2pqampqam6W9YjWD90kKcQb9+rbhyBfJX5BX3BqfcpqampqamjpOR
K+y1AzVPvylCcqcd/jQ7RmqWdj5IKTampqampmf36cljOiSr0kKcQf5+rbhyBfJX5BX3Bqfc
pqampqamjpORK+wlDnKY0jQX2TcSGSsV7h9KjsT14aampqamDoVmAyVdORAZY8EAustoTmHT
y524GlNjtqampqampulvWI2LEVDBTCMZA0PdACDV7qWZgBi6e/umpqampmmR95PeubKSNAxy
EmF2U8F5bHY/KVCwzTampqZnEFpvFlLjJk2uA6bdNmynqOhRItcl+Qu/4aampt2wpmkGDnKY
pqbdRiJ51iK75vjQVb2mpqamT+Fn9ITzT8Fbpt2iTmhupqampqU+polXRyhYtbfNx/twUUJI
3KampqbOjqbydiXoCPlH07W3uIqYXZ/EoN40JL9JpqampvmtIMbLrnJ9699+rdKJV31O0QBs
y3+Ugd6nQdPZL17MT8ktBNympqamfq1aQLAX0t79YXYj8nbgxfzrVgBsp6joUSLX4H/1SaZU
YXkk+6Yvu8PrwUzPCSI/ZtBqpx2SyPXhpqZX9S3C/CJ3dlxW+CevCiAKOyLRTqcJcmttAQ8H
MR8qVVb4gysTTsCqEHlux/+twW7H/63Bbsf/rcFux/+twW7H/63Bbsf/rcFux/+twW7H/63B
bsf/rcFux/+twW7H/63Bbsf/rcFux/+twW7H/63Bbsf/rcFux/+twW72hw8K10K+v1XNNqam
L7umxrwMSE5XfU7RpLbXGQ4ooUmmpqaPUJWX5fhpx8MtigpEZLw7YZJTR7ryAAfRpxCkyQ93
9QOK9gVXxreWCecVQcS45LG1wvumpqampqampqampqampqampqampqampqamplexNLwrE07A
u0UFvaamZ6fTu3b40b7Xhg5ymPVZIWs1LPHcpqam3WttjVz+a4tN4DHqmYcQunmBUljEiSPL
TFb4e0e8TSnJMbFhUkpJDxovRsrpJcF5OnbqoUX7pqampqampqampqampqampqampqampqam
j3FOkqN5/9ntHkhJpqamk/I0x4qYXd/Q1iK7JX+zeqvSqCk2pqamdkVUkzIsJ0rFpxANjz3E
PSssnEIMJsFQlcJkaopt7EinEHn9wTCb6Z41MH4eYX61irUeqjGmpqampqampqampqampqam
pqampqampqamprjiQhA738FDGTLEtqamqVZsGa0zTMATxjVPvyl1EYs5EFp7+6ampgfRKytV
B+yMGAEPYjCBeQ09xgEZCfyt9S2KHnz4UegTAQ8F1K1Bz/fmL4ti3lm15LUarSOmpqampqam
pqampqampqampqampqampqampsHssbEnx4e5TL/a+6amhQkGkAuabMRCdtJCnEr0YP3SqCk2
pqamdkVUkzIsJ0rFpxANjz3EPSssnEIMJsFQlcJkaopt7EinEHn9wTCb6Z41aT7FRKampqam
pqampqampqampqampqampqampqampm72hw8K10K+v1XNNqamygz3tqamprh94AE9EE2t5VQz
Pazqmiu6EHGLYmNBhB/ZvMsDlidFkzMNeW4L2iH4FbeWCaampqampqampqampqampqampqam
pqampqampqa44kIQO9/BQxkyxLampqkaZzSa3KampgfRKytVB+yMGAEPYjCBeQ09xgEZCfyt
9S2KHnz4UegTAQ8F1K3Bbsf/rcFux/+twW7H/63Bbsf/rcFux/+twW7H/63Bbsf/rcFux/+t
wW7H/63Bbsf/rcFux/+twW7H/63Bbsf/rcFux/+twW7H/63Bbsf/vouBDYNunBKxVdympqYH
0SsrVQfsjBgBD2IwgXkNPcYBGQn8rfUtih58+FHoEwEPBRvoUSLX4dvdQl3P7uRATrr/u1ed
weQ3Tr9unRd6gkpfH9R4XyCImn+8F+TdzqSG/nH/cWDRH9EgUzRDm0rZEtEsU8/GQxIZbkKC
UfLOKcQPpo815DpDsJo/N4uBDYNunBKxVdympqYH0SsrVQfsjBgBD2IwgXkNPcYBGQn8rfUt
ih58+FHoEwEPBdStwW7H/61uaq1uaq1uaq1uaq1uaq1uaq1uaq1uaq1uaq1uaq1uaq1uaq1u
aq1uaq1uaq1uaq1uaq3Bbsf/7m7H/63BcU6So3n/2e0eSEmmpqknkjRtrpcyZtBqp2rNNqap
Gmc0mtxJpqYYVmXVL1732NPcpqbbGv2mPayqYXUYkQD7prhyBZ5nCDre+AOVw3ewk9ympncH
kfvjJk2uA3z3xqjoUSLXwNr7pmlizhe6z8ym4rabF9c/PJ9V8SJTwXmVB3Aep9LMg5txrOop
UguxVdympsOZ+TElK/uPe6iqPIoXedaqi0HEjWGjpcUbPlMtHkiwtqamCP8XndtwryTEPayq
YXUYkc0mbzQYlIGTEuVEZODx5nJCinVQz+eSyKI0t8aoboAb/32E0z0VQl17s3SEx4SnZsOZ
wfceohwHuBwgWp7b+LKTGGliboDitvDH17KhNzCdkKam478i+Gw5mfm+O2/kA5XDFPauDY9c
2E1yg15iMJS3jiP/nEq91wcOKKHb2kJ2FToV24gQWlGjVw9T3CFqUGjIY+c9FToVMmbQhFcP
SFqe2/iykxhpYm6WcUmrwez98eEIP9r7pi+7zzMMdG/kx7pizhdtJlo8QSevClTMTw2wo6XF
Gz7SbprkECkTtVySi7tamuSuKROd7xBOnUySM7sMmvlkJcSqgJIzqvKa+aQpBbXNJb+qD5JK
9IKSyKINuD/+vxq7U9xdUufBv3gURAZzQFbpTW//u1PcIf8qeBREBnOf4abKGTqKnARWzsFh
o6Vyb1732AA9rOotUSL2rg2PXFkJfbXnAkq91wcOKKHb2kJ2FToAthfSqPQn7uRBHqKCdNey
kxhpYm6ax5CFhi//uyBantv4spMYaWJumseQEW72SFqe2/jNNqZnNE4xln9UpXJ5DY9PYuhm
kxLlRGTg6RA8QSevCnUaULX3TKS27Cg1LPHjv5tXRiRmeQZfIhTMYm4kuJARQGu+qAzz5QJO
W+K2QnYVOmqyoTcwnagM8+UCTlvitvDH17KhNzCdkKam478i+Gw5mfm+O2/kA5XDFPauDY9c
2E1yg15iMJS3jpIkZmEL5k6ofYTTCNwcB7j5SvSCksiiDbj5Sh6ignTXspMYaWJunYZ798ao
bp2YqD4vu3iRPuYNuPlKHqKGcceECcoZIEmmpgaQcj/0r6yqSApEtX5/lPqDXmIwlNX8AzPD
mYeVFAL50BtQf2s6L9Ko9DBJ0IRXqnLbiBBaUaNXqnIyUYhAi0BW6U1v/5rHkIWGL/+amsiO
4/79wo5ro1eqcjJRUuK+qD4vu8S2pqY
I/xed23CvJMQ9rKphdRiRzSZvNBiUgZMS5URk4PEV
qmgwOOZOqH2E0wjcHAd8QVhXjCihw5mGWB6ignTXspMYaWJfF+K2QnYVMLyoPi+7eJE+5g18
Qb7cIf8qeBREBnOf4abKGTqKnARWzsFho6Vyb1732AA9rOotUSL2rg2PXFkJfbWGx5u91wcO
KKHb2kJ2FVdlUmAs8U1v1PceooJ017KTGGliX++x9HrLOHYgWp7b+LKTGGliX++x9NS+i0Aa
ZzSa3Kam29pPc9PWRLVoK5n5MeDF8Q2wo6XFK3cXzSZvNBihnnMsgWQL5k6ofYTTCNwcB3yH
dVeMKKHDmYYCHqKCdNeykxhpYl8f4rZCdhUwvqg+L7t4kT7mDXyHU9wh/yp4FEQGc5/hpsoZ
OoqcBFbOwWGjpXJvXvfYAD2s6i1RIvauDY9cWQl9tREmpLbsKDUs8eO/m1dGCLK2F9Ko9Cc4
z2oyUYhAi0BW6U1v1HhxSZtXRgjXsqE3MJ2oDPPlAgiysfTUvotAGmc0mtymptvaT3PT1kS1
aCuZ+THgxfENsKOlxSt3F80mbzQYoZ4AhgVKvdcHDiih29pCdhXOp/SCksiiDXy8Q3uzdITH
hKdmw5mGuuK2QnYVzjNAGmc0mshj5z0VzqceooZxx4QJyhkgSaamBpByP/SvrKpICkS1fn+U
+oNeYjCU1fwDM8OZh5UUAkEITMZGi4RQBxQGkHrLOM/G24gQWlGjBJpSkBFAa76oDPPlAgik
sfR6yzjPv4QJyhkghQlGJzjPxjJRUuK+qD4vu8S2pqYI/xed23CvJMQ9rKphdRiRzSZvNBiU
gZMS5URk4PHmtcYhKXVQz+eSyKI0t8aoX7tYV4woocOZhhLittd8IXiRPuYNfLzBe/fGqF+7
IFqe2/iykxhpYl+7vtwh/yp4FEQGc5/hpsoZOoqcBFbOwWGjpXJvXvfYAD2s6i1RIvauDY9c
WQl9tVRppLbsKDUs8eO/m1dGCB22F9Ko9Cc45N0yUYhAi0BW6U1v1ChxSZtXRghqsqE3MJ2o
DPPlAggdsfTUvotAGmc0mtymptvaT3PT1kS1aCuZ+THgxfENsKOlxSt3F80mbzQYoZ5zLIRk
C+ZOqH2E0wjcHAd8P8bbiBBaUaMEnYZ7s3SEx4SnZsOZhr9xSZtXRgiY/fHhCD+Ep2bDmYa/
cUmrwez98eEIP9r7pi+7zzMMdG/kx7pizhdtJlo8QSevClTMTw2wo6XFGz7SqoqzSr3XBw4o
odvaQnYVzgC2F9Ko9Cc45EEeooJ017KTGGliX5rHkIWGL9S7IFqe2/iykxhpYl+ax5ARbvZI
Wp7b+M02pmc0TjGWf1SlcnkNj09i6GaTEuVEZODpEDxBJ68KdRqlLB9QdVDP55LIojS3xqhx
/1luswcU5QLZWB6ignTXspMYaWJx/3FJm1dG2TpAGmc0mshj5z0VQ0cyUVLivqg+L7vEtqam
CP8XndtwryTEPayqYXUYkc0mbzQYlIGTEuVEZODx5nIBinVQz+eSyKI0t8aocWAb/32E0z0V
AV17s3SEx4SnZsOZnPceohwHuIggWp7b+LKTGGlicWDitvDH17KhNzCdkKam478i+Gw5mfm+
O2/kA5XDFPauDY9c2E1yg15iMJS3jiPRnEq91wcOKKHb2kJ2FUMV24gQWlGjU3FT3CFqUGjI
Y+c9FUMVMmbQhFNxSFqe2/iykxhpYnHRcUmrwez98eEIP9r7pi+7zzMMdG/kx7pizhdtJlo8
QSevClTMTw2wo6XFGz7ScRn1WREiNhBaZhn6hi/RIHVXjCihw5mceHFJ7DgRSIUJRifum0Ae
ohwHuELHhAnKGSCFCUYn7ptAHqKGcceECcoZIEmmpgaQcj/0r6yqSApEtX5/lPqDXmIwlNX8
AzPDmYeVFAJB2QVKvdcHDiih29pCdhVDYrYX0qj0J+6bpx6ignTXspMYaWJxGcCQhYYv0SAg
Wp7b+LKTGGlicRnAkBFu9khantv4zTamZzROMZZ/VKVyeQ2PT2LoZpMS5URk4OkQPEEnrwp1
GlC1tXKVWFDP55LIojS3xqhxGX9SYCzxTW/Ru1PcIWpQaMhj5z0VQ6Sx9HrL7pu5QBpnNJrI
Y+c9FUOksfTUvotAGmc0mtymptvaT3PT1kS1aCuZ+THgxfENsKOlxSt3F80mbzQYoZ4AnP6k
tuwoNSzx47+bV0bZEhv/fYTTPRVDALH0yQTs/cKOa6NTNMF798aocRmayI7j/v3CjmujUzTB
e7NXsWjIjuP+Bb2mqTDBAw/gS49PBSevJLpZ6cIzw5mHlRiS2AA9rOp/oWvBm2sL5k6ofYTT
CNwcB7g63duIEFpRo1PPj3uzdITHhKdmw5mcKHFJm1dG2Qf98eEIP4SnZsOZnChxSavB7P3x
4Qg/2vumL7vPMwx0b+THumLOF20mWjxBJ68KVMxPDbCjpcUbPuSqilWa4gWDnEP+EgCV/kqR
k4vQ8XIILWzrhcKLkW29DdvYKkJNEA1LA2wF4WENsnMmeR0jMWAPNimw50UlvfEOtspNd0zt
1HULz4uJOgesq5nW4PaBoLI4K5fkHSqUYStydZH5N+kuK6cx081RZRtYqnDMtsljRyRWzJag
19PNUWUbWKpwzLftEBNizJag18DhpmcFpcQeo6EGHJt/9BJaO9Crfpd121joEdG0iX/0gi78
AZfkCzXwAjUtDSODQHzVAfn37J66ChdZZbWFURvV2X70n8yIt0ckwk29AwmLLJxNH4PJ9J/M
iLdHJMJN+hm816dNH4PJrfumDnnOBTI7FFIoOnXbABo8gLLfAVkGWV4hH36XddtYG4FlQ0xc
aQs4aX47QWGoR/JC6sxeOPaBX6EZXFYnwsJHpxEfjX/6mBjpLnWNm+KjUYcRE2yD6QFZm+Lg
zLftEBNizJag18DhpmcFpcQeo6EGHJt/9BJaO9Crfpd121joEdG0iX/0gi78AZeYkzXwAjUt
DSODQHzVQ1Vf7J66ChdZm0jUURvV2X70n8yItzQTLU29AwkZ16dNH4PJ9J/MiLc0Ey1N+hm8
16dNH4OLtZJhTIO0xCKrbauxKK9s3gudgc2cYfaV9Is4K2Eig7WfAygDwoGzbg/eJwGXqlW7
H9n6Nqapf6H9+Dz9plYn1BR55B/Hhk+FxhR5iroszSwD5cWntqam1Hcj3guaIx1Ud1+hg7QF
PM5Jm88rXCDGFHmKuiw7zsbY5RhDNqbOJJuL4r/xuhF4vnOx5ivrecSocsZ3I94LmiPV+fed
Eg9c6X9DhsbQXAgPyKm1wsLU5pj6eRMr9h+b6AVIhEHBOnWjlnmKuiDpr7qb6AVIhEHBCyft
oC0g7ZSVJJu/uwrlFvkpVfjlxRiqNGQYPiwK5Ra5/n73Vbtvgy5IBaCjmMggYfHBQiLoPAz9
+Dy6zKWnNClhBcjBOnWjlnmKuiDpCNDkVfjlxRiqI/685RjgkrzF6M/Y5VF1ZQrokZGVNqap
PAVvBF5+7aAtIO0upqb5/n5zncM4p7e9pqa3vabdnSXrkI070Ivk8rBH5QY/coW5/r2mpqam
pqam9e23ekeXPIDHP2MmjT5OBj9yhbn+vaampqampqb17bfPWQnX6Edt+ADvmJpJpqampqam
plCB3Jt/oSpPZZa5/l+KP0+mpqampqamZ7Ha+sYUPZg+TgY/coW5/r2mpqampqam9e23z1kJ
c38Bh2i7iDFzIvumpqampqap4r/x0KHlJLBHbfgA75iaSaampqampqZQgdybf6GBP5c0U5qC
wvgQ4aampqampqZMuxQst8OqLlgf/hJgn52upqampqampg4ekF0L8fxqiUJSnReR/vg2pqam
pqampkUZoSIbJiLcWB/+EmCfna6mpqampqamDh6QXQvxkyoBh2i7iDFzIvumpqampqap4r/x
0KHJAz5OBj9yhbn+
vaampqampqb17bfPWWUTrlgf/hJgn52upqampqampg4ekF0L8TGYPk4G
P3KFuf69pqampqampvXtt89ZZfgLlzRTmoLC+BDhpqampqampky7FCy3R/luZZa5/l+KP0+m
pqampqamZ7Ha+sYUA/5ei5VzQfdVu7ampqampqamfSNJOnWRM7GJQlKdF5H++Dampqampqam
RRmhIhtYEHVllrn+X4o/T6ampqampqZnsdr6xhQD0F6LlXNB91W7tqampqampqZ9I0k6dZGH
Llgf/hJgn52upqampqampg4ekF0L8Tp+lzRTmoLC+BDhpqampqampky7FCy3R8Fei5VzQfdV
u7ampqampqamfSNJOnWR+UiXNFOagsL4EOGmpqampqamTLsULLdHtXVllrn+X4o/T6ampqam
pqZnsdr6xhROJLBHbfgA75iaSaampqampqZQgdybf/rkc4lCUp0Xkf74NqampqampqZFGaEi
G1i1KgGHaLuIMXMi+6ampqampqniv/HQoYss6Edt+ADvmJpJpqampqamplCB3Jt/+uSGiUJS
nReR/vg2pqampqampkUZoSIbQuouWB/+EmCfna6mpqampqamDh6QXQvxvwM+TgY/coW5/r2m
pqampqam9e23ekfyJskgFdiJJ/kbR/ImGe29AwnlJBlGkz49TyAV2In8cxN81WOSHi51jQkQ
MLbJY8MsmkaTPgP8LnWNZRPtvQMJyU54OCuXilUTfNUBM8YTfNUBM8ETfNUBM/kudY1l+B4u
dY1l+KUbR/JYEM+2yWNHCng4K5fPMxtH8lhymkaTPk6/IBXYiTosIBXYiTpPIBXYiTr4eDgr
l+RkeDgrl+RqE3zVAfkILnWNm+IjtsljNBMuWB/+EmCfna6mpqampqamDh6QXW+DLkgFoKOY
yNChg7TEIoOJiobG0EPG0CwkP0cY4JfGrPgA75iaSaampqampqZQgdzAmc0bLF5+7aAtIO2U
XslcCKrRpFmmZ+1QecRzwOGm1jI+SNiWxlDs6I/UFP9xIujw9pg9PPg+1jI+Uy1xvhH6YT5T
CLUP8Rf4JEyXRBNqKZvOzaXWxgWBQ8aqNBxPHLDPEOTBnE6d54DBakPB2d6qV5wxcyLoXH3s
UVTcpnBL0ZXwgUMEo+uOaHXbWNnGoFJ5xIMjJAFL0UR4p9UfYjHfRHiLMZ3kAleH4sGqzI0z
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
4ckMz0vVTcbwZ
QU+qTiM0P6q+TEIQek9KsCCcZdVLDSPJER+NnoEJyk7+672mpqampmd23zqX6QFxCsZh+igT
lqvABeg9gwJ6YaNgx6/D6JH4ECuOd0e1FUKo0Duns3F8lCKxX6Fu3hiLrO40L7pijL5wxc/g
WQZZtyOvQqhho/zixAeHJvr1sXiEsQFXltsrDFGt/WYqWLmSyX1FRJIewdk6l4G4+VJ6AIco
EtHEsLBqQ5uBM+TkE7GGgfjZzZcehjr1ehCYiZM3Oz2ChJhNw02c4Vi1KpCmpqampqbbOLdk
ccPUDSN+E+RLOlGoxHmjO0yFCwoBIR9ZAfJhmhfpNdfkHf+ZQn4NX4usJqW+yVkGWV4hH3TB
ArQniNdEXu62C9MX7HeZ/5ktPQm/7QDS8i7omLyIRdFqQqhho9PXMS8m+vWxeISxYlAPJA//
6uIHTtCGKQgjtMe+AACk0ZxkxMHBmjQcZJoPSOqHLHKwhikFY0eefjtBiIPpY+btjoXkavXh
pqampqYvBy68wMyIsfwteZtqi21AaGHeDZ+o0Duns3F8jT4xP0+URCpO0FeWXS09ZeyZ6BXB
7H/0gi6zcXxuH+AKASEfWQKuX6Fu3gmWV5bbKwxVgTNQ1SpYuZLJfUV0wQK0J6EhF4QaG+tM
mnRMxGeqc8+tD74c/yRKsMYeOHJDM9L1U3G8GUFPqk4jND+qvkxCEHpPSrAgnGXVSw0jyREf
jZ6BCcpO0Ou9pqampqZndt86l+kBcQrGYfooE5arwAXoPYMCemGjYMevw+iR+BArjnc0CriH
hQsKASEfWQJyKgvTF+xRvnBXltsr2RHRdZ5PBLdX6xqHuIfjO6dFHs1r6idlVYHXUDKI/5kt
PfER/0BaLuiYvIhFSDf5kjrAvMAAbqp2rtCxakHZzSkpuL7P7QAktYuBMHP5wJibkjAipK6a
0QErcPaBR1DRxZT8Y2cZXOu9pqampqZndt86l+kBcQrGYfooE5arwAXoPYMCemGjYMevw+iR
+BArjnc0E+40yMYr2RHRdZ5P9tQU/yHpx6+4h+M7p7NxfJQifxtS6KHtjzQvumIysQWEZHeR
RR4Tax5lbh/gCmyzbrL37Fm/EIL1VeFzgU5Dz0MjV7VXQRxkBwCcBevr7sA6IxI/+dceCJJz
Q59DgQjPe0G8TJfY3Tz8WGtMw8V3DDc0Ey6mpqamERWfHdu1/bzYmD/9X7T8Nqampqk+pqIf
vH6/JoGzbg8+pqYtkKampqZ8RKl6J7DV7x6CimuxPoJhNREVn9Z04gulzTyupqampqam44Mp
l4UUahwjkJtKeS/sS1XK1h4Ez5iBtqampqamplGfRWXCMkAA0nsB/9/nLrRIyK8ydLxVkr2m
pqampqbM2kyIMcVqHCOQm1sFyiE4mDU5sX/Onx5Jpqampqamos31AZGnOCjt3Dq3eS/sS1XK
1h4Ez5iBtqampqamplGfRWXCtX9qHCOQm0F5L+xLVcrWHgTPmIG2pqampqamUZ9FZcK1Imoc
I5CbQXkv7EtVytYeBM+YgbampqampqZRn0VlwnU4KO3cQnLf5y60SMivMnS8VZK9pqampqam
zNpMiJOFSweHsDQX/UYbfniFj3s5mkhzNqampqamqU2Q4l9+hUsHh7A0F/1GG354hY97OZpI
czampqampqlNkOJf2PpLB4ewNBf9Rht+eIWPReH4tX6W9jGSEf9kIapeWaampqa4h6bguoOE
ZKamaQsPYWMA0vL56HWmpqamjzSm22Ff/BUnsqZptQW02aZnsfkol1D+q5siOjsN14R/+6am
po8kRs1QapxbitlhaDlY0wUlHCOQ0wXCgbNuDyk2pqamqXkvsqVD+/jCYsQ16NthfhAhweqj
WaYOBUj4+jamqU2Q4nQREHdwxbampqMguqbUFLmoDSInS72mpi60SKbj0c8xuQkejK2dJb2m
poaj1uGgIuxO1WMbR5c8gMc/Y9m9pqYL0/7Iex+yqenwuVZTjUMTO8QqLrRIuGbeA4EzINTS
8KHlkydUd8PZvaamC/EnQatvKj3A4abddRojnKtvKj3A4abddRqS7ypWJ+VDNqapf6GBFydU
d8PZvaamC/H8ECdUd8PZvaamC/H8ZHdLTSantqam1BQ9B3dLTSantqam1BQ9xndLTSantqam
1BQDxSpWJ+VDNqapf/p+p6tvKj3A4abddZHfrrJt7Cet+6ZwWWUSnKtvKj3A4abddZEzgCdU
d8PZvaamC/ExTyY4zF5iSaamX6HJu15qUeij3KamBLdH+fKybewnrfumcFll+Mirbyo9wOGm
3XWRM38qViflQzamqX/6NPKybewnrfumcFllT2NA6S4NbqamfBtYcl5qUeij3KamBLdHmmNA
6S4NbqamfBtYtferbyo9wOGm3XWR+RcnVHfD2b2mpgvxOvh3S00mp7amptQUTp0JalHoo9ym
pgS3RyQaQOkuDW6mpnwbWKpZsm3sJ637pnBZm+Lysm3sJ637pnBZm0inq28qPcDhpt11GuUJ
alHoo9wbpqagsqqY4o0Uuagst1MHd5JNr+hfoW7eGIusLoi3V+sah+jDA6yrmdbg9oGgsjgr
8iqGgpRhK3J1GuwtTfqXZbpRTMPUFD1f6S7oqLplGybJJjjMgrpRhxETbIPpAVkJ11R3kSCa
yQx3mXkDbqamUN/kzUUr8VMHz1kGHAkejDkTZRtS6D7smd8BWQZZtyNYCdeZJ1Z0GDs9699G
kz49bnLDtKMAC/En/1Eb1dl+9J/MiLfDx28qWEB++nUa7LBA6dd+9CNreacRH41/oSoXzLft
EBNizJag18DhpmcFpcQeo6EGHJt/9BJaO9Crfpd121joEdG0iX/0gi78AfKB4g7UFQ60owB5
hHWNCe2GgpRhK3J1GiPGURvV2X70n8yIt8O7VHeRq8JsC/H8TCdUd0enTR+DyfSfzIi3w7tU
d5EgmskMd5l5A26mplDf5M1FK/FTB89ZBhwJHow5E2UbUug+7JnfAVkGWbcjWAlzzGkLOGl+
O0FhqEfyJvmPgpRhK3J1GpLW6S4rpzHTzVFlGyb5cMy33oWnX6HlJAlqUclhou1Q3wygbZd1
GpLW6S4zM3lhou1Q39m9pqZ5apri9mz0EoXGFLmoDSInSz4L0xfsUb5wXtQU/yEmnD49T0Qq
bzmVPPze/RXYifyuIl449oFfoeUkk3eRAVhis9HFC/H8rm8qWEB++nUakoIqVifJDHeZeQOi
mE1foeUkk3eRIJrJDHeZeQNupqZQ3+TNRSvxUwfPWQYcCR6MORNlG1LoPuyZ3wFZBlm3I1gJ
7ZZNLXwWYSuuBS/JY8O7OlkCOz2CGyYZA036l2W6UUzD1BQ9Em8qWEB++nUaI0+rbyoDbPwC
YZNRTMPUFD0SbyoxBcQx04HmBVZJpqagsqqY4o0Uuagst1MHd5JNr+hfoW7eGIusLoi3V+sa
h+jDqpR3VASOugqweecDCeWdzlkCOz2CGyb54My3jQFhophNX6HlnVR3kavCbAvx/GR3S01Y
YsyWoNfTzVFlGyb54My37RATYsyWoNfA4aZnBaXEHqOhBhybf/QSWjvQq36XddtY6BHRtIl/
9IIu/AHygWsO1BUOtKMAeYR1jQkQj4KUYStydRqS3VEb1dl+9J/MiLfDLFR3kavCbAvx/IQn
VHdHp00fg8n0n8yIt8MsVHeRIJrJDHeZeQNupqZQ3+TNRSvxUwfPWQYcCR6MORNlG1LoPuyZ
3wFZBlm3I1gJEFZNLXwWYSuuBS/JY8MsOlkCOz2CGyYiwk36l2W6UUzD1BQ9gG8qWEB++nUa
knWrbyoDbPwCYZNRTMPUFD2AbyoxBcQx04HmBVZJpqagsqqY4o0Uuagst1MHd5JNr+hfoW7e
kg8xmBN2xli/LrvHOwbsRPRmQqIBEBiWmUnyCHzpqZ76
82t4ZYD7kInl8mDowg7Qqiv7aEwo
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
6JfxIINtxudg5LVbsyXCw4YE6xWyT
EF4tqampmc5mr9+eP1SWAoKpVP3bm8Nw0ZjtL2mpqam
fmrI5MV+5X2SyvopdV/Le23eY/g4LWFhcP1AXfXYb4MHjjz6KXUmwl0TMwZ/FcDtoygeEnMP
tdmrpqampqampqampqampqampqampqamphYMKkp/YmhQQ0KC+6amppGlEMafA/OcvkWe0P36
3syZ6VQYkKampqbd33T6ZBXoGOIo8W5K+n0OA3UrRSxv9vaZYTha3MYnaxBaOJBuSljFDLze
lhzvVjzf0jP5tUtthx2mpqampqampqampqampqampqampqZnk+VSX97uQNFyE72mpqbK1rva
YRPwU0c9XDBoWtxtnhhLjtr7pqamqXkE8Q8CLpRMLBStpLezNRd/O/UkVjw8b35qyG5KPeb4
yBV7raSCXKfP64d6YOcG1jCmpqampqampqampqampqampqampqampqnCw4YE6xWyTEF4tqam
pmc5lrampqamtECoOly0w7OBNfHrf4ik9W/r8v5q4Hl5r990+ilUYqAoPti3639eAfoj/W4z
z+uHeqampqampqampqampqampqampqampqampmmnJ3YLo1Nr2U7J4aampuMq0kyC+6ampmE4
Wj+U31z1EMhd9VlgW5CVoCVzS1S6ukuyhMB7K5nNhJ4eXfVHw5OnAZOnAZOnAZOnAZOnAZOn
AZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOnAZOn
AZOnAZOnAZOnAZOnAZOnY6vGdW9IfZs0WKampqYFfBSdnhPFRSJawHsbjNb/4KMpP1TYO2K0
QKitpAoCM6gCMsB7yeXEIhGYL6ampugq64jr2ui7WD9wkvcpSehPWD9rQQmxd4L82vz+dyxN
JAmqUflZcwIxiZPXftSKSjESySx1EJEz9DEXyQ9TE8DqtqyrxnVvSH2bNFimpqamBXwUnZ4T
xUUiWsB7G4zW/+CjKT9U2DtitECoraQKAjOoAjLAe8nlVtnCVtnCVtnCVtnCVtnxwhpWPgyX
8cIaVj4Ml/HCGlY+DJfxwhpWPgyX8cIaVj4Ml/HCGlY+DJfxwhpWPgyX8cIaVj4MlwnwC1mZ
ePVCGVmmpqapdRWGYKCyR7pxTDuQ3humpqbgshCxWaampmE4Wj+U31z1EMhd9VlgW5CVoCVz
S1S6ukuyhMB7K5nNhJ4eXfVHaGATRz1cIBBQn6hEA94iSp4qSrampqampqampkDw35NZyaMf
R5tSw01SbqampqampqamfH6g+uBl65OvViyAAqvGvaampqampqamamATVhuC7dV1Q4ZNaYZX
+6ampqampqZwtBG3lZHou5nJOlfFd1fcpqampqampqYE34ORf1gpB6yTIkqeKkq2pqampqam
pqZA8N+TWcmSLXCn0Izm8IY2pqampqampqk4jC5vt1g/xXVDhk1phlf7pqampqampnC0EbeV
kehPmck6V8V3V9ympqampqampgTfg5F/WCmcrJMiSp4qSrampqampqampkDw35NZ6EFvR5tS
w01SbqampqampqamfH6g+uBlMkx82cbMa9RS4aampqampqbdS7Mbbfp3A6yTIkqeKkq2pqam
pqampqZA8N+TWei81XVDhk1phlf7pqampqampnC0EbeVkfz+RAPPdpQndkmmpqampqampnT9
ecJ1WXNrcKfQjObwhjampqampqamqTiMLm+3JiRvR5tSw01SbqampqampqamfH6g+uBlgbCs
kyJKnipKtqampqampqamQPDfk1no+XF82cbMa9RS4aampqampqbdS7Mbbfp3D57JOlfFd1fc
pqampqampqYE34ORf1gxoHCn0Izm8IY2pqampqampqk4jC5vt1g9RAPPdpQndkmmpqampqam
pnT9ecJ1R34rfNnGzGvUUuGmpqampqam3UuzG236R7meyTpXxXdX3KampqampqamBN+DkX9Y
MfiskyJKnipKtqampqampqamQPDfk1nJM2twp9CM5vCGNqampqampqapOIwub7dYEFZ1Q4ZN
aYZX+6ampqampqZwtBG3lZHJT57JOlfFd1fcpqampqampqYE34ORf1gxwayTIkqeKkq2pqam
pqampqZA8N+TWckzY3Cn0Izm8IY2pqampqampqk4jC5vt74Tb0ebUsNNUm6mpqampqampnx+
oPrgZb8yr1YsgAKrxr2mpqampqampmpgE1YbgpBvR5tSX97uQNFyE72mpramL/YEPB4ugvup
eQTxDwIulEwsFK2kt7M1F3879SRWPDxvfmrIbko95vjIFXutpIJj1H/oAv1FeiAbpkuyhJsK
SyZRHtYUsAtle31W6I25B5WDg6x5BPHrLaMRLAlUSbAL6Dy1UiaL2Muw2bnG7gJVzZKSm6qH
0K6YrLuYqu1BrXPB1cFqQ7Ee3qpX6id2C6NTa9lOyeGmBXwUnZ4TxUUiWsB7G4zW/+CjKT9U
2DtitECoraQKAjOoAjLAe8nyuw9KsIZDIxlzxLXPAaqPBbnS0pf5qTHND5bk/ZIpKbhFGf9b
Kkp/YmhQQ0KC+6l5BPEPAi4NBDyH8bM1F3879SRWPDyL1zamYThaP5TfPbVhzYRv6/L+auB5
eRlZG6Yv6/L+auB5Yk6neQTxDwIuDRnjLm0NDcLnc4PJfzv1JFaxIo5HIl3XNqZhOFo/lN89
CUAyb+vy/mrgeXk1WdVVKNkNKEKC+6l5BPEPAi4NJXPIlaAlc0tUuroOn7Utlr/4nKq1sbk6
aQDtvE00WKZnmi2hwiVzZ7stBTjKVpXcpqa0QKg6XLTDSC29k1nVVShtDQ1EJ/4s+MDEqjr+
qs1BKD3rHm2XE72mpgV8FJ2eE5di36ht3mP4OC1hYWcALrAPIkciP87+qs1BKD3rHm2XE72m
hY8B4abd33T6ZBXowG0uheCjKT9U2DtitBSTKT+FE72m4yrSTIL7qXkE8Q8CLg0Z4y5gW5CV
oCVzS1S6E3i2prRAqDpctMOzgTXx63+IpPVv6/L+auB5ea/fdPopVGKgKD7Yt+t/Xsm/AEc9
V0Ayo1YN2eSMeHtaazP4m0OBw/k6TsEoJKr/GXIPSk7Z6UOGBOsVskxBeLamtECoOly0w7OB
NfHrf4ik9W/r8v5q4Hl5r990+ilUYqAoPti3639eVTqBAbwZ4+uZ7eiRDfgNhkO4RYpBPVfU
oLiEnMHXNqZhOFo/lN9c9RDIXfVZYFuQlaAlc0tUurpLsoTAeyuZzYSeHl31R8MwkLv5Cw+5
M5a1+WRVTmsjIxDMhgTrFbJMQXi2prRAqDpctMOzgTXx63+IpPVv6/L+auB5ea/fdPopVGKg
KD7Yt+t/XvkzLLX47il76oZNK5gP2ofLsNm5WHP7QrTYTN30tBI/zf/ah0I6ux93V5LNeCxx
6OjrJqvGdSv2/adEQ1YsgOno1H/Y6+AmTG+3szXxKIMC4Q2atQXZ2Z2QcsEDl8bMzFHUf9jr
4CZMb7ezNfFUXjxEJ521xJycqtpPcheN0IyXPVfUoLiEnMHXNqZhOFo/lN9c9RDIXfVZYFuQ
laAlc0tUurpLsoTAeyuZzYSeHl31R4mrxnVvSH2bNFim3d90+mQV6BjiKPFuSvp9DgN1K0Us
b/b2mWE4WtzGJ2sQWjiQbkpYq12H2LPHKkp/YmhQQ0KC+6l5BPEPAi6UTCwUraS3szUXfzv1
JFY8PG9+ashuSj3m+MgVe62kgkRsXERnOo3Z7gKxsLFOOp1PQUraM1vLnartQWTwq8Z1b0h9
mzRYpt3fdPpkFegY4ijxbkr6fQ4DdStFLG/29plhOFrcxidrEFo4kG5KWKzxwjYO5JdDpRUI
0nOB5ML4ILU6l+seTu5FBbswcw+bM7XZO7VsIOqzgTXx63+IpPVv6/L+auB5ea/fdPopVGKg
KD7Yt+sIqmZCBf
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
8Cf98WfesDszGoO
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
rAv49IGo4Nu1ynjjziE6umpqaPK6xd
DL7LKjoGFFjFPI7rK74ELKdi1EG6vfFZpG+3bYku8SY7JaP2Ow08o/Y7DTyj9qBg9qBg9qBg
9qBg9qBg9qBg9qBg9qBg9qBg9qBg9qBg9qBg9qBg9qBg9qBg9qBg9g27XKeOPOITq6ampg7y
QlN7tpmwWCHLBSQFSKbn6gsFxTO4sceKM0xrM+37pqampqampspx8HkKtGptQQvEu54Nu7Km
pqampqampu4nfrqVHIczdpgQ6k0QIKampqampqam5+oLBcUzpeXBtM2Y5s0SHaampqampqZn
U6sFKy0HsQDGSJqUJ5r9pqampqampqYVPbRhGAA0Ka2f+OJp+Bmmpqampqampi/i1GFciu55
ci0FvwKD/jmmpqampqamqbgqYTvgxoRyLQW/AoP+OaampqampqapuCphO+DGLcG0zZjmzRId
pqampqampmdTqwUrLYYtwbTNmObNEh2mpqampqamZ1OrBSsthkxyLQW/AoP+Oaampqampqap
uCphO+DGHwDGSJqUJ5r9pqampqampqYVPbRhGKQPM3aYEOpNECCmpqampqampufqCwXFn889
x4ozTGsz7fumpqampqamynHweQq0CDJyLQW/AoP+OaampqampqapuCphO+DGeADGSJqUJ5r9
pqampqampqYVPbRhGKSaM3aYEOpNECCmpqampqampufqCwXFMzB9rZ/44mn4Gaampqampqam
L+LUYVyKUoqtn/jiafgZpqampqampqYv4tRhXIoItMeKM0xrM+37pqampqampspx8HkKtIZM
ci0FvwKD/jmmpqampqamqbgqYTvg0JYjSlW81Xe8eKampqampqamRgoteZQSzzHHijNMazPt
+6ampqampqbKcfB5CrSGCkELxLueDbuypqampqampqbuJ366lRwP/naYEOpNECCmpqampqam
pufqCwXFM87owbTNmObNEh2mpqampqamZ1OrBSstxsQAxkialCea/aampqampqamFT20YRjt
2tJ2mBDqTRAgpqampqampqbn6gsFxTNIiq2f+OJp+Bmmpqampqampi/i1GFciu5Qx4oz7Zfx
FYMyXuumplCmqW2nS3mxJvupur3xlkN7d11tt5HlVF5ZukPgz1RhBBJIbFplMlRZ0Qnfoehh
8s0SjWwCDR7oOaZIbFq8iR5pt5bc8SbgLn95jW0IODHgir6Nyvp3OH++WjEUWIP5tXPNn7Px
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
cV8o2W8LeCqmj1GVZF7rptGjuUy
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
hWM9ofGkkXQZ
FqammyusL89hYv3mKeD3c3vOfgWj+6lTpxn4LSumcOR8tMPVRKbw5JGQ4abK
nDCxTt6EMli8rg/icSjBD+j2QgA0WeQjNHHqzxD5Ikw/mHGwH7yHKzR2modksIZOHo2c6xjZ
Trvr75zBmrDGlCCcKSn3xNnS0lMGHkLsHDojQejGlLFOBR6clQbNZQAA+Qib5PjSU+SYv8TE
DNwP4s8ALA9T5J9CrTTiDz9CvvnNQyN6LD9Yl0J7pHKxm3POQ6VzHkMP5UL/lUV1oIIJg+hP
wRid5HuQSRncsCk0MK287YeuxsGxHvG7cpobGdywKTRNizF+agZqxkN66njGTu4puABow05+
YTgI7obAQQpsxoIgsOv1hzR2modksIZOHjL6/sEgtiCw6/WHw05+YTgI7obAQQoT2QgegZYH
TvVe1wMxQJUH0NlC4qd2cjSQ3OtCCMDPEu1BSnJksWyaT50uNJDc60LM1wMxQJUH0NlC4kgc
nZC85Drk9V7XAzFAlQfQ2ULip3ZyNJDc60IIwM8S7UFKcmSxbJpPnS40kNzrQszXAzFAlQfQ
2ULiSOLBah5DHvW8JosxfmoGasZDeuoMSsGwKUeGIOQjNHEKo/umyG0IanDrsLLEDeGm3dAG
fGNt9SLIDDQe9kSmZ7tzTaampnuhyW0+TNtFXfpjbQEeC6P3DB8MH+pdJZVlX9XAKeD0MwMh
1cAp4DHp3hOUvvUt9TUak/cMH9kRCTumpqaRILZC1cteRTCGz/zk/w0N4aamS6S+BCR03y3u
xgW6JStu4aampl8sORMnRKampl3g5Hy027CyxA3hpqYvseCYo/umpl3g5Hy027CyvgQkdN8I
/jQKlKam3Uh+MtNRy/CaHx7gJf9aKVHhpqbj8aZRc1aypqb9wCng9DMDIZ6mpnBEppgWeR2m
3UBxRVSfzINg+6am2KYOmWaypqb9wCngKaxajKampiumfOygbeGmS6ic0aezFESmpkvhqd/O
UolvprRprQ8+pqaplKagJrI/dmNEcNYFge3hpqaFur3huiy369am3UBxRVRhIhtEpqYOTJlQ
MYcGhFllpn6FY21jbQ0JpqamYe8ZgXivF4a/0S3up6CUB+GmpqbYbdPx4aampqYe8Un8UM4Q
LdEbzV+J0cVEpqampt2sO9D6KTUrpmcXEvQof/pL4aY5ncfe0jxjlKYvzRfeK6amilGg1/L7
pqampqZML94rpqZ87KBtwuGmpoORTInIK6amoCayP3ZjTPtQOSRKJcWmpqampqeepqamprky
nbdNpqampqZUyAwf2TzGoOGpcUVURVPhpqlxRVRAUkSmpr71LaL4k+yUZ9FMVpgWeYympqam
plT3DB8MH6LslKa+9S1fGzumpuMoLT2hK6amj58QneGmqZc68vumpqamS9iUpqapU28FPZ6m
plJi7f4LO6amfD8EfuWUpqbo/sx8Y20N4aYx/Yi3gdz7psjEBhG/C76xEAjiVLGXQaCUBwWB
EDumpoW6Us6gjS+hulKepqbdn9uYGc4rtKUH0CQ0SXmVPqampt3NkrwrpqamBqN+6tWmL7E8
nqZfLDkTJ2OmDvdP2F6mpl3TuyMieU31TxQvbGAepOj+zBEyJfBK5iBVcsNObm0yf94XGqAu
D9WmppGWyZw22nQlo5BG6dEI4g88nqapcQZMcrCyPes6MAYpuAB6HNG2mk8PnczXx9E8lRqQ
9yXfEDumpsjtdUzTinxa9jLTb77bmD+T1abI7fd/k7uOpqZC1ctPYdNm3tXc+6amtEowsf2a
nv35pfkzLJr3YQaOpqamyAw0HjqgayfWLN4yJfBK5iBVcsNObm0yf94XGqAuD9WmpqZnM+D5
ZNzOmrXOtZwPgZrOqkcItUa1lHPXqqYJKANI
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PACKAGE BODY pcsox.demo_pkg
AS
   PROCEDURE get_query (p_cursor IN OUT rc)
   IS
      l_query   LONG := 'select instance ';
   BEGIN
      FOR r_i IN (SELECT hostname HOST
                    FROM sarbox_instance)
      LOOP
         l_query :=
               l_query
            || ', min(decode(hostname, '
            || CHR (39)
            || r_i.HOST
            || CHR (39)
            || ', hostname, null )) '
            || CHR (34)
            || TO_CHAR (r_i.HOST)
            || CHR (34);
      END LOOP;

      l_query :=
            l_query
         || ' from sarbox_instance where hostname is not null group by instance';
      DBMS_OUTPUT.put_line (l_query);

      OPEN p_cursor FOR l_query;
   END;
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.stp_sox00001_infodb2
IS
   inf              UTL_FILE.file_type;
   line_in          VARCHAR2 (1000);
   w_line_head      VARCHAR2 (250);
   w_line_tail      VARCHAR2 (250);
   w_vol_id         VARCHAR2 (50);
   w_trk_tot        NUMBER;
   w_trk_avail      NUMBER;
   w_trk_used       NUMBER;
   w_kbytes_tot     NUMBER;
   w_kbytes_avail   NUMBER;
   w_kbytes_used    NUMBER;
   w_pct_used       NUMBER;
   w_cp_start       NUMBER;
   w_cp_end         NUMBER;
   w_cp_len         NUMBER;
   w_dsn_name       VARCHAR2 (50);
   w_ds_aux1        VARCHAR2 (50);
   w_ds_dbname      VARCHAR2 (50);
   w_ds_tbsname     VARCHAR2 (50);
   w_ds_aux2        VARCHAR2 (50);
   w_ds_pname       VARCHAR2 (50);
   w_ext_seq        NUMBER;
   w_tbs_numtrk     NUMBER;
   w_read_order     NUMBER;
   w_order          NUMBER;
   w_write          BOOLEAN;
   w_freeseg        BOOLEAN;
   w_line_split     VARCHAR2 (50);
   w_datetimeproc   DATE;
   w_percuti        NUMBER;

   PROCEDURE carga_freesegs
   IS
      CURSOR c_segfree
      IS
         SELECT vol_id, tbs_numtrk, (tbs_numtrk * 48) kbytes_avail,
                read_order
           FROM pcsox.sarbox_temp_mf_segs
          WHERE ds_tbsname = '*** FREE EXTENT ***';
   BEGIN
      EXECUTE IMMEDIATE 'truncate table sarbox_mf_vols_freesegs';

      FOR r_segfree IN c_segfree
      LOOP
         INSERT INTO sarbox_mf_vols_freesegs
                     (vol_id, seg_id,
                      trk_avail, kbytes_avail
                     )
              VALUES (r_segfree.vol_id, r_segfree.read_order,
                      r_segfree.tbs_numtrk, r_segfree.kbytes_avail
                     );
      END LOOP;

      COMMIT;
   END carga_freesegs;

-- nova para o fardim
   PROCEDURE carga_volsegsnew
   IS
      CURSOR c_volsegs
      IS
         SELECT   vol_id, dsn_name, ds_dbname, ds_tbsname, ds_pname,
                  COUNT (1) qtdext, SUM (tbs_numtrk) trks,
                  MAX (ext_seq) lastext
             FROM sarbox_temp_mf_segs
            WHERE ds_tbsname <> '*** FREE EXTENT ***'
         GROUP BY vol_id, dsn_name, ds_dbname, ds_tbsname, ds_pname
         ORDER BY vol_id, dsn_name, ds_dbname, ds_tbsname, ds_pname;

      w_old_trks                 NUMBER;
      w_old_kbytes               NUMBER;
      w_old_extents              NUMBER;
      w_old_next_extent_trks     NUMBER;
      w_old_next_extent_kbytes   NUMBER;
      w_rowid                    ROWID;
      w_nextext_tks              NUMBER;
   BEGIN
      FOR r_volsegs IN c_volsegs
      LOOP
         BEGIN
            w_old_trks := 0;
            w_old_kbytes := 0;
            w_old_extents := 0;
            w_old_next_extent_trks := 0;
            w_old_next_extent_kbytes := 0;

            SELECT tbs_numtrk
              INTO w_nextext_tks
              FROM sarbox_temp_mf_segs
             WHERE vol_id = r_volsegs.vol_id
               AND dsn_name = r_volsegs.dsn_name
               AND ds_dbname = r_volsegs.ds_dbname
               AND ds_tbsname = r_volsegs.ds_tbsname
               AND ds_pname = r_volsegs.ds_pname
               AND ext_seq = r_volsegs.lastext;

            SELECT ROWID, trks, kbytes, extents,
                   next_extent_trks, next_extent_kbytes
              INTO w_rowid, w_old_trks, w_old_kbytes, w_old_extents,
                   w_old_next_extent_trks, w_old_next_extent_kbytes
              FROM sarbox_mf_vols_segs_new mfsegsext
             WHERE vol_id = r_volsegs.vol_id
               AND dsn_name = r_volsegs.dsn_name
               AND db_name = r_volsegs.ds_dbname
               AND tbs_name = r_volsegs.ds_tbsname
               AND part_name = r_volsegs.ds_pname
               AND dt_upd =
                      (SELECT MAX (dt_upd)
                         FROM sarbox_mf_vols_segs_new mfsegsint
                        WHERE mfsegsint.vol_id = mfsegsext.vol_id
                          AND mfsegsint.dsn_name = mfsegsext.dsn_name
                          AND mfsegsint.db_name = mfsegsext.db_name
                          AND mfsegsint.tbs_name = mfsegsext.tbs_name
                          AND mfsegsint.part_name = mfsegsext.part_name);

            IF    (r_volsegs.trks <> w_old_trks)
               OR ((r_volsegs.trks * 48) <> w_old_kbytes)
               OR (r_volsegs.qtdext <> w_old_extents)
               OR (w_nextext_tks <> w_old_next_extent_trks)
               OR ((w_nextext_tks * 48) <> w_old_next_extent_kbytes)
            THEN
               DBMS_OUTPUT.put_line (   'passou aqui ('
                                     || r_volsegs.trks
                                     || '/'
                                     || w_old_trks
                                     || ') ('
                                     || r_volsegs.trks * 48
                                     || '/'
                                     || w_old_kbytes
                                     || ') ('
                                     || r_volsegs.qtdext
                                     || '/'
                                     || w_old_extents
                                     || ') ('
                                     || w_nextext_tks
                                     || '/'
                                     || w_old_next_extent_trks
                                     || ') ('
                                     || w_nextext_tks * 48
                                     || '/'
                                     || w_old_next_extent_kbytes
                                     || ')'
                                    );
               RAISE NO_DATA_FOUND;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               INSERT INTO sarbox_mf_vols_segs_new
                           (vol_id, dsn_name,
                            db_name, tbs_name,
                            part_name, dt_upd,
                            trks, kbytes,
                            extents, next_extent_trks,
                            next_extent_kbytes
                           )
                    VALUES (r_volsegs.vol_id, r_volsegs.dsn_name,
                            r_volsegs.ds_dbname, r_volsegs.ds_tbsname,
                            NVL (r_volsegs.ds_pname, 'N/A'), SYSDATE,
                            r_volsegs.trks, (r_volsegs.trks * 48),
                            r_volsegs.qtdext, w_nextext_tks,
                            (w_nextext_tks * 48
                            )
                           );
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('passou aqui');
         END;
      END LOOP;
   END carga_volsegsnew;

   PROCEDURE carga_volsegs
   IS
      CURSOR c_volsegs
      IS
         SELECT   vol_id, dsn_name, ds_dbname, ds_tbsname, ds_pname,
                  COUNT (1) qtdext, SUM (tbs_numtrk) trks,
                  MAX (ext_seq) lastext
             FROM sarbox_temp_mf_segs
            WHERE ds_tbsname <> '*** FREE EXTENT ***'
         GROUP BY vol_id, dsn_name, ds_dbname, ds_tbsname, ds_pname
         ORDER BY vol_id, dsn_name, ds_dbname, ds_tbsname, ds_pname;

      w_nextext_tks   NUMBER;
   BEGIN
      EXECUTE IMMEDIATE 'truncate table sarbox_mf_vols_segs';

      FOR r_volsegs IN c_volsegs
      LOOP
         BEGIN
            SELECT tbs_numtrk
              INTO w_nextext_tks
              FROM sarbox_temp_mf_segs
             WHERE vol_id = r_volsegs.vol_id
               AND dsn_name = r_volsegs.dsn_name
               AND ds_dbname = r_volsegs.ds_dbname
               AND ds_tbsname = r_volsegs.ds_tbsname
               AND ds_pname = r_volsegs.ds_pname
               AND ext_seq = r_volsegs.lastext;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
               DBMS_OUTPUT.put_line (   r_volsegs.vol_id
                                     || ' - '
                                     || r_volsegs.dsn_name
                                     || ' - '
                                     || r_volsegs.ds_dbname
                                     || ' - '
                                     || r_volsegs.ds_tbsname
                                     || ' - '
                                     || r_volsegs.ds_pname
                                     || ' - '
                                     || r_volsegs.lastext
                                    );
            WHEN OTHERS
            THEN
               NULL;
               DBMS_OUTPUT.put_line (   r_volsegs.vol_id
                                     || ' - '
                                     || r_volsegs.dsn_name
                                     || ' - '
                                     || r_volsegs.ds_dbname
                                     || ' - '
                                     || r_volsegs.ds_tbsname
                                     || ' - '
                                     || r_volsegs.ds_pname
                                     || ' - '
                                     || r_volsegs.lastext
                                    );
         END;

         BEGIN
            INSERT INTO sarbox_mf_vols_segs
                        (vol_id, dsn_name,
                         db_name, tbs_name,
                         part_name, trks,
                         kbytes, extents,
                         next_extent_trks, next_extent_kbytes
                        )
                 VALUES (r_volsegs.vol_id, r_volsegs.dsn_name,
                         r_volsegs.ds_dbname, r_volsegs.ds_tbsname,
                         r_volsegs.ds_pname, r_volsegs.trks,
                         (r_volsegs.trks) * 48, r_volsegs.qtdext,
                         w_nextext_tks, (w_nextext_tks * 48)
                        );
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   r_volsegs.vol_id
                                     || ' - '
                                     || r_volsegs.dsn_name
                                     || ' - '
                                     || r_volsegs.ds_dbname
                                     || ' - '
                                     || r_volsegs.ds_tbsname
                                     || ' - '
                                     || r_volsegs.ds_pname
                                     || ' - '
                                     || r_volsegs.lastext
                                    );
         END;
      END LOOP;
   END carga_volsegs;

   PROCEDURE carga_segs
   IS
      -- dados do segmento
      w_partname      sarbox_mf_segs.part_name%TYPE;
      w_partcount     sarbox_mf_segs.seg_parts%TYPE;
      w_segcount      sarbox_mf_segs.seg_ext%TYPE;
      w_segsizetrk    sarbox_mf_segs.seg_sizetrk%TYPE;
      -- dados da ultima particao
      w_partexts      sarbox_mf_segs.lpart_ext%TYPE;
      w_parttrk       sarbox_mf_segs.lpart_sizetrk%TYPE;
      w_partlastext   NUMBER;
      -- dados do uttimo segmento
      w_lexttrk       sarbox_mf_segs.lpart_lexttrk%TYPE;

      CURSOR c_segs
      IS
         SELECT DISTINCT dsn_name, ds_dbname, ds_tbsname
                    FROM sarbox_temp_mf_segs
                   WHERE ds_tbsname <> '*** FREE EXTENT ***';
   BEGIN
      w_datetimeproc := SYSDATE;

      FOR r_segs_ex IN (SELECT ROWID
                          FROM sarbox_mf_segs
                         WHERE dropped <> 'YES')
      LOOP
         UPDATE sarbox_mf_segs
            SET dropped = 'YES',
                dtdropped = w_datetimeproc
          WHERE ROWID = r_segs_ex.ROWID;
      END LOOP;

      COMMIT;

      /*
      ** seg_parts     -- file ditto - calculado quantidade de partições                     -- ok
      ** part_name     -- file ditto - nome da última particao                               -- ok
      ** lpart_ext     -- file ditto - ultima partição - quantidade de extents
      ** lpart_sizetrk -- file ditto - ultima partição - tamanho da particao em trilhas
      ** lpart_sizekb  -- file ditto - ultima partição - tamanho da particao em kbytes
      ** lpart_lexttrk -- file ditto - ultima partição - tamanho do ultimo extent em trilhas
      ** lpart_lextkb  -- file ditto - ultima partição - tamanho do ultimo extent em kbytes
      ** seg_ext       -- file ditto - quantidade de extents                                 -- ok
      ** seg_sizetrk   -- file ditto - tamanho total do segmento em trilhas                  -- ok
      ** seg_sizekb    -- file ditto - tamanho total do segmento de kbytes                   -- ok
      */
      FOR r_segs IN c_segs
      LOOP
         w_partcount := 0;
         w_partname := 0;
         w_segcount := 0;
         w_segsizetrk := 0;
         w_partexts := 0;
         w_parttrk := 0;
         w_partlastext := 0;
         w_lexttrk := 0;

         -- dados de nome de particao, quantidade de particao, quantidade de extents, tamanho - isto para o segmento
         SELECT COUNT (DISTINCT ds_pname), MAX (ds_pname), COUNT (ext_seq),
                SUM (tbs_numtrk)
           INTO w_partcount, w_partname, w_segcount,
                w_segsizetrk
           FROM sarbox_temp_mf_segs
          WHERE dsn_name = r_segs.dsn_name
            AND ds_dbname = r_segs.ds_dbname
            AND ds_tbsname = r_segs.ds_tbsname;

         -- dados da ultima particao: quantidade de extents, tamanho do particao, ultimo extent
         SELECT COUNT (ext_seq), SUM (tbs_numtrk), MAX (ext_seq)
           INTO w_partexts, w_parttrk, w_partlastext
           FROM sarbox_temp_mf_segs
          WHERE dsn_name = r_segs.dsn_name
            AND ds_dbname = r_segs.ds_dbname
            AND ds_tbsname = r_segs.ds_tbsname
            AND ds_pname = w_partname;

         -- dados da ultima extensão
         SELECT SUM (tbs_numtrk)
           INTO w_lexttrk
           FROM sarbox_temp_mf_segs
          WHERE dsn_name = r_segs.dsn_name
            AND ds_dbname = r_segs.ds_dbname
            AND ds_tbsname = r_segs.ds_tbsname
            AND ds_pname = w_partname
            AND ext_seq = w_partlastext;

         BEGIN
            UPDATE sarbox_mf_segs
               SET seg_parts = w_partcount,
                   lpart_ext = w_partexts,
                   lpart_sizetrk = w_parttrk,
                   lpart_sizekb = (w_parttrk * 48),
                   lpart_lexttrk = w_lexttrk,
                   lpart_lextkb = (w_lexttrk * 48),
                   seg_ext = w_segcount,
                   part_name = w_partname,
                   seg_sizetrk = w_segsizetrk,
                   seg_sizekb = (w_segsizetrk * 48),
                   dtdropped = NULL,
                   dropped = 'NO',
                   dtinsert = SYSDATE
             WHERE dsn_name = r_segs.dsn_name
               AND db_name = r_segs.ds_dbname
               AND tbs_name = r_segs.ds_tbsname;

            IF SQL%ROWCOUNT = 0
            THEN
-- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
               INSERT INTO sarbox_mf_segs
                           (dsn_name, db_name,
                            tbs_name, seg_parts, lpart_ext,
                            lpart_sizetrk, lpart_sizekb, lpart_lexttrk,
                            lpart_lextkb, seg_ext, part_name,
                            seg_sizetrk, seg_sizekb, dtdropped, dropped,
                            dtinsert
                           )
                    VALUES (r_segs.dsn_name, r_segs.ds_dbname,
                            r_segs.ds_tbsname, w_partcount, w_partexts,
                            w_parttrk, (w_parttrk * 48), w_lexttrk,
                            (w_lexttrk * 48
                            ), w_segcount, w_partname,
                            w_segsizetrk, (w_segsizetrk * 48), NULL, 'NO',
                            SYSDATE
                           );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (   r_segs.dsn_name
                                     || ' - '
                                     || r_segs.ds_dbname
                                     || ' - '
                                     || r_segs.ds_tbsname
                                     || ' - '
                                     || w_partcount
                                     || ' - '
                                     || w_partexts
                                     || ' - '
                                     || w_parttrk
                                     || ' - '
                                     || w_lexttrk
                                     || ' - '
                                     || w_segcount
                                     || ' - '
                                     || w_partname
                                     || ' - '
                                     || w_segsizetrk
                                    );
         END;
      END LOOP;

      COMMIT;
   END carga_segs;
BEGIN
   EXECUTE IMMEDIATE ('truncate table pcsox.sarbox_temp_mf_segs');

   DBMS_OUTPUT.put_line ('V1 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
   w_datetimeproc := SYSDATE;

   FOR r_vols_ex IN (SELECT ROWID
                       FROM sarbox_mf_vols
                      WHERE dropped <> 'YES')
   LOOP
      UPDATE sarbox_mf_vols
         SET dropped = 'YES',
             dtdropped = w_datetimeproc
       WHERE ROWID = r_vols_ex.ROWID;
   END LOOP;

   COMMIT;
   DBMS_OUTPUT.put_line ('V2 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
   inf := UTL_FILE.fopen ('D_SARBOX_MONDB2', 'unixvtditto.txt', 'r');
   w_read_order := 0;

   LOOP
      BEGIN
         UTL_FILE.get_line (inf, line_in);
         w_vol_id := '';
         w_trk_tot := 0;
         w_trk_avail := 0;
         w_trk_used := 0;
         w_kbytes_tot := 0;
         w_kbytes_avail := 0;
         w_kbytes_used := 0;
         w_pct_used := 0;

         IF    (SUBSTR (line_in, 1, 9) = '-* * * * ')
            OR (SUBSTR (line_in, 1, 9) = '0* * * * ')
         THEN
            w_read_order := 0;
            w_line_head := line_in;
            w_cp_start := INSTR (w_line_head, 'VOLSER=') + 7;
            w_cp_end := INSTR (w_line_head, ',', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_vol_id := TRIM (SUBSTR (w_line_head, w_cp_start, w_cp_len));

            WHILE SUBSTR (line_in, 1, 6) <> '0 *** '
            LOOP
               w_dsn_name := NULL;
               w_ds_aux1 := NULL;
               w_ds_dbname := NULL;
               w_ds_tbsname := NULL;
               w_ds_aux2 := NULL;
               w_ds_pname := NULL;
               w_ext_seq := NULL;
               w_tbs_numtrk := NULL;
               line_in := TRIM (line_in);
               w_write := FALSE;
               w_freeseg := FALSE;

               IF    SUBSTR (line_in, 1, 4) = 'DB2V'
                  OR SUBSTR (line_in, 1, 4) = 'DSNS'
                  OR SUBSTR (line_in, 1, 4) = 'DB2T'
                  OR SUBSTR (line_in, 1, 4) = 'DB2L'
               THEN
                  w_write := TRUE;
                  w_line_split := TRIM (SUBSTR (line_in, 1, 44)) || '.';
                  w_cp_start := 1;
                  w_cp_end := INSTR (w_line_split, '.', w_cp_start);
                  w_cp_len := (w_cp_end - w_cp_start);
                  w_dsn_name :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
                  w_cp_start := w_cp_end + 1;
                  w_cp_end := INSTR (w_line_split, '.', w_cp_start);
                  w_cp_len := (w_cp_end - w_cp_start);
                  w_ds_aux1 :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
                  w_cp_start := w_cp_end + 1;
                  w_cp_end := INSTR (w_line_split, '.', w_cp_start);
                  w_cp_len := (w_cp_end - w_cp_start);
                  w_ds_dbname :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
                  w_cp_start := w_cp_end + 1;
                  w_cp_end := INSTR (w_line_split, '.', w_cp_start);
                  w_cp_len := (w_cp_end - w_cp_start);
                  w_ds_tbsname :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
                  w_cp_start := w_cp_end + 1;
                  w_cp_end := INSTR (w_line_split, '.', w_cp_start);
                  w_cp_len := (w_cp_end - w_cp_start);
                  w_ds_aux2 :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
                  w_cp_start := w_cp_end + 1;
                  w_cp_end := INSTR (w_line_split, '.', w_cp_start);
                  w_cp_len := (w_cp_end - w_cp_start);
                  w_ds_pname :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
                  w_tbs_numtrk := TRIM (SUBSTR (line_in, 74, 7));
                  w_ext_seq := TRIM (SUBSTR (line_in, 46, 3));
               ELSIF SUBSTR (line_in, 1, 19) = '*** FREE EXTENT ***'
               THEN
                  w_freeseg := TRUE;
                  w_write := TRUE;
                  w_read_order := w_read_order + 1;
                  w_ds_tbsname := '*** FREE EXTENT ***';
                  w_tbs_numtrk := TRIM (SUBSTR (line_in, 72, 7));
               END IF;

               IF w_write = TRUE
               THEN
                  IF w_freeseg = TRUE
                  THEN
                     w_order := w_read_order;
                  ELSE
                     w_order := 0;
                  END IF;

                  INSERT INTO pcsox.sarbox_temp_mf_segs
                              (vol_id, dsn_name, ds_aux1, ds_dbname,
                               ds_tbsname, ds_aux2, ds_pname,
                               tbs_numtrk, ext_seq, read_order
                              )
                       VALUES (w_vol_id, w_dsn_name, w_ds_aux1, w_ds_dbname,
                               w_ds_tbsname, w_ds_aux2, w_ds_pname,
                               w_tbs_numtrk, w_ext_seq, w_order
                              );
               END IF;

               UTL_FILE.get_line (inf, line_in);
            END LOOP;

            w_line_tail := line_in;
            w_cp_start := INSTR (w_line_head, 'with ') + 5;
            w_cp_end := INSTR (w_line_head, ' ', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_trk_tot := TRIM (SUBSTR (w_line_head, w_cp_start, w_cp_len))
                         * 15;
            w_cp_start := INSTR (w_line_tail, 'currently ') + 10;
            w_cp_end := INSTR (w_line_tail, ' ', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_pct_used := TRIM (SUBSTR (w_line_tail, w_cp_start, w_cp_len));
            w_cp_start := INSTR (w_line_tail, 'with ') + 5;
            w_cp_end := INSTR (w_line_tail, ' ', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_trk_avail := TRIM (SUBSTR (w_line_tail, w_cp_start, w_cp_len));
            w_trk_used := (w_trk_tot - w_trk_avail);
            w_kbytes_tot := (w_trk_tot * 48);
            w_kbytes_avail := (w_trk_avail * 48);
            w_kbytes_used := (w_trk_used * 48);

            UPDATE sarbox_mf_vols
               SET trk_tot = w_trk_tot,
                   trk_avail = w_trk_avail,
                   trk_used = w_trk_used,
                   kbytes_tot = w_kbytes_tot,
                   kbytes_avail = w_kbytes_avail,
                   kbytes_used = w_kbytes_used,
                   pct_used = w_pct_used,
                   dtdropped = NULL,
                   dropped = 'NO'
             WHERE vol_id = w_vol_id;

            IF SQL%ROWCOUNT = 0
            THEN
-- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
               INSERT INTO sarbox_mf_vols
                           (vol_id, trk_tot, trk_avail, trk_used,
                            kbytes_tot, kbytes_avail, kbytes_used,
                            pct_used, dtdropped, dropped, dtinsert
                           )
                    VALUES (w_vol_id, w_trk_tot, w_trk_avail, w_trk_used,
                            w_kbytes_tot, w_kbytes_avail, w_kbytes_used,
                            w_pct_used, NULL, 'NO', SYSDATE
                           );
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXIT;
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;
   END LOOP;

   COMMIT;
   UTL_FILE.fclose (inf);
   inf := UTL_FILE.fopen ('D_SARBOX_MONDB2', 'unixvtsegs.txt', 'r');
   w_read_order := 0;

   LOOP
      BEGIN
         w_read_order := w_read_order + 1;
         UTL_FILE.get_line (inf, line_in);

         IF SUBSTR (line_in, 1, 1) = '0'
         THEN
            line_in := REPLACE (line_in, CHR (128), ' ');
            w_dsn_name := NULL;
            w_ds_aux1 := NULL;
            w_ds_dbname := NULL;
            w_ds_tbsname := NULL;
            w_ds_aux2 := NULL;
            w_ds_pname := NULL;
            w_percuti := NULL;
            w_line_split := TRIM (SUBSTR (line_in, 9, 47)) || '.';
            w_cp_start := 1;
            w_cp_end := INSTR (w_line_split, '.', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_dsn_name := TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
            w_cp_start := w_cp_end + 1;
            w_cp_end := INSTR (w_line_split, '.', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_ds_aux1 := TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
            w_cp_start := w_cp_end + 1;
            w_cp_end := INSTR (w_line_split, '.', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_ds_dbname := TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
            w_cp_start := w_cp_end + 1;
            w_cp_end := INSTR (w_line_split, '.', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_ds_tbsname :=
                           TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
            w_cp_start := w_cp_end + 1;
            w_cp_end := INSTR (w_line_split, '.', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_ds_aux2 := TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
            w_cp_start := w_cp_end + 1;
            w_cp_end := INSTR (w_line_split, '.', w_cp_start);
            w_cp_len := (w_cp_end - w_cp_start);
            w_ds_pname := TRIM (SUBSTR (w_line_split, w_cp_start, w_cp_len));
            w_percuti := TO_NUMBER (TRIM (SUBSTR (line_in, 81, 3)));

            UPDATE sarbox_temp_mf_segs
               SET perc_used = w_percuti
             WHERE dsn_name = w_dsn_name
               AND ds_dbname = w_ds_dbname
               AND ds_tbsname = w_ds_tbsname
               AND ds_pname = w_ds_pname;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXIT;
         WHEN DUP_VAL_ON_INDEX
         THEN
            NULL;
      END;
   END LOOP;

   COMMIT;
   UTL_FILE.fclose (inf);
   DBMS_OUTPUT.put_line ('V3 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
   carga_freesegs;
   COMMIT;
   DBMS_OUTPUT.put_line ('V4 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
   carga_segs;
   COMMIT;
   DBMS_OUTPUT.put_line ('V5 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
   carga_volsegs;
   COMMIT;
   DBMS_OUTPUT.put_line ('V6 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
   carga_volsegsnew;
   COMMIT;
   DBMS_OUTPUT.put_line ('V7 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));

   FOR rsize IN (SELECT   dsn_name, SUM (seg_sizekb) ksize
                     FROM sarbox_mf_segs
                    WHERE dropped = 'NO'
                 GROUP BY dsn_name)
   LOOP
      UPDATE sarbox_instance
         SET ksize = rsize.ksize
       WHERE INSTANCE = rsize.dsn_name;
   END LOOP;

   COMMIT;
   DBMS_OUTPUT.put_line ('V8 :' || TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss'));
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.stp_sarbox_alterpass (p_user IN VARCHAR2, p_pass IN VARCHAR2)
AS
   w_sql   VARCHAR2 (500);
BEGIN
   w_sql :=
      UPPER (   'ALTER USER '
             || CHR (34)
             || p_user
             || CHR (34)
             || ' IDENTIFIED BY '
             || p_pass
            );

   EXECUTE IMMEDIATE (w_sql);
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.stp_sox00002_hostcmd (p_command IN VARCHAR2)
AS
   LANGUAGE JAVA
   NAME 'cls_sox00001_hostcmd.executeCommand (java.lang.String)';
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.testeacb299
IS
   w_sql   VARCHAR2 (1000);
BEGIN
   w_sql :=
         'call pcsox.prc_del_user@'
      || 'orapvt024'
      || '_dropuser108'
      || '('
      || CHR (39)
      || 'TESTEACB299'
      || CHR (39)
      || ')';

   EXECUTE IMMEDIATE w_sql;
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox."SP_DROP_USER_108"
AS
   /*
   ** Exclusão de usuários para atender chamados de EXCLUSÃO DE CHAVE DE TODOS OS AMBIENTES
   */
   w_ws                 VARCHAR2 (255)
      := '20636F6E6E65637420746F207063736F78202020206964656E746966696564206279206433616436797274202020';
   w_sql                VARCHAR2 (4000);
   v_dutidusu           user_for_drop_108.username%TYPE;
   v_dutidsol           user_for_drop_108.numeimac%TYPE;
   v_nom_chave_sybase   user_for_drop_108.chavesyb%TYPE;
   v_nom_chave_db2      user_for_drop_108.chavetso%TYPE;
   v_username           user_for_drop_108.username%TYPE;
   v_count              NUMBER;
   v_synonym            VARCHAR2 (30);
   w_sqll               VARCHAR2 (200);
   v_db2                CHAR (3);
   v_dblink             VARCHAR2 (30);

   CURSOR c_getimac
   IS
      SELECT a.dutidusu, a.dutidsol, b.nom_chave_db2, b.nom_chave_sybase
        FROM bdsegmap.dutusext a LEFT OUTER JOIN funcionario_108 b
             ON (   a.dutidusu = b.nom_chave_oracle
                 OR a.dutidusu = b.cod_id_funcionario
                )
       WHERE duttpusu = 'C'
         AND a.dutidsol IS NOT NULL
         AND a.dutidusu NOT IN (SELECT username
                                  FROM pcsox.user_for_drop_108);

   CURSOR c_db_link
   IS
      SELECT *
        FROM pcsox.sarbox_instance
       WHERE UPPER (search) = 'Y';

   CURSOR c_username
   IS
      SELECT DISTINCT su.username, su.INSTANCE
                 FROM pcsox.sarbox_instance_user su,
                      pcsox.sarbox_instance si,
                      pcsox.user_for_drop_108 s1
                WHERE si.INSTANCE = su.INSTANCE
                  AND su.username = s1.username
                  AND su.dropped = 'NO'
                  AND UPPER (search) = 'Y';

   CURSOR c_getsynonym
   IS
      SELECT synonym_name, db_link
        FROM user_synonyms
       WHERE synonym_name LIKE 'SYSTABAUTHDB2%';

   CURSOR c_getusername
   IS
      SELECT chavetso
        FROM pcsox.user_for_drop_108
       WHERE chavetso IS NOT NULL
         AND (   grantdb2pvt > 0
              OR grantdb2psl > 0
              OR grantdb2tvt > 0
              OR grantdb2tsl > 0
             );
BEGIN
   /*
   ** Determinar quais usuario possuem grants no DB2.
   */
   OPEN c_getsynonym;

   LOOP
      FETCH c_getsynonym
       INTO v_synonym, v_dblink;

      EXIT WHEN c_getsynonym%NOTFOUND;

      BEGIN
         OPEN c_getusername;

         LOOP
            FETCH c_getusername
             INTO v_username;

            EXIT WHEN c_getusername%NOTFOUND;
            w_sqll :=
                  'select count(*) from '
               || v_synonym
               || ' where grantee  = '''
               || v_username
               || ''' ';

            EXECUTE IMMEDIATE w_sqll
                         INTO v_count;

            v_db2 := SUBSTR (v_synonym, 14, 3);
            w_sqll :=
                  'update pcsox.user_for_drop_108 set GRANTDB2'
               || v_db2
               || '  = '
               || v_count
               || ' where CHAVETSO   = '''
               || v_username
               || ''' ';

            EXECUTE IMMEDIATE w_sqll;
         -- w_sqll := 'alter session close database link '||v_dblink||' ';
         --execute immediate w_sqll;
         END LOOP;

         CLOSE c_getusername;
      END;
   END LOOP;

   CLOSE c_getsynonym;

   /*
   ** Carrega a tabela user_for_drop_108 com novos usuário para a exclusão.
   */
   OPEN c_getimac;

   LOOP
      BEGIN
         FETCH c_getimac
          INTO v_dutidusu, v_dutidsol, v_nom_chave_db2, v_nom_chave_sybase;

         EXIT WHEN c_getimac%NOTFOUND;

         INSERT INTO pcsox.user_for_drop_108
                     (username, numeimac, chavetso,
                      chavesyb
                     )
              VALUES (v_dutidusu, v_dutidsol, v_nom_chave_db2,
                      v_nom_chave_sybase
                     );

         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (SQLCODE || ' - ' || SQLERRM);
      END;
   END LOOP;

   CLOSE c_getimac;

   /*
   ** criar db_links
   */
   FOR r_db_link IN c_db_link
   LOOP
      BEGIN
         w_sql :=
               'create database link '
            || r_db_link.INSTANCE
            || '_dropuser108 '
            || pak_sox00001.ctv (w_ws)
            || ' using '
            || CHR (39)
            || r_db_link.connect_string
            || CHR (39);

         EXECUTE IMMEDIATE w_sql;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (SQLCODE || ' - ' || SQLERRM);
      END;
   END LOOP;

   /*
   ** Dropa os usuario
   */
   FOR r_username IN c_username
   LOOP
      BEGIN
         DBMS_OUTPUT.put_line ('Intance...:' || r_username.INSTANCE);
         w_sql :=
               'call PCSOX.prc_del_user@'
            || r_username.INSTANCE
            || '_dropuser108'
            || '('
            || CHR (39)
            || r_username.username
            || CHR (39)
            || ')';

         EXECUTE IMMEDIATE w_sql;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (SQLCODE || ' - ' || SQLERRM);
      END;
   END LOOP;

   /*
   ** Excluir db_links
   */
   FOR r_db_link IN c_db_link
   LOOP
      BEGIN
         w_sql :=
                'drop database link ' || r_db_link.INSTANCE || '_dropuser108';

         EXECUTE IMMEDIATE w_sql;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (SQLCODE || ' - ' || SQLERRM);
      END;
   END LOOP;
END sp_drop_user_108;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.auto_verificacao (p_email IN VARCHAR2 DEFAULT NULL)
IS
   w_instant     sarbox_instance_rolepriv.INSTANCE%TYPE;
   w_send_mail   CHAR                                     := 'N';

   CURSOR c_verifica
   IS
      SELECT s.SID, dj.job, s.seconds_in_wait,
             TRIM (REPLACE (REPLACE (REPLACE (LOWER (dj.what), 'begin ', ''),
                                     'end;',
                                     ''
                                    ),
                            'pak_sox00001.',
                            ''
                           )
                  ) what,
             TRIM (REPLACE (REPLACE (REPLACE (s.client_info, 'SARBOX - ', ''),
                                     'Disponibilidade ',
                                     'D '
                                    ),
                            'Coleta ',
                            'C '
                           )
                  ) info,
             ROWNUM
        FROM v$session s, dba_jobs dj, dba_jobs_running djr
       WHERE s.SID = djr.SID
         AND dj.job = djr.job
         AND seconds_in_wait >= 900
         AND schema_user = 'PCSOX';
BEGIN
   w_send_mail := 'N';
   w_instant := '??????';
--      for r_verifica in c_verifica loop
--      begin
--         if w_send_mail = 'N' then
--            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
--            utl_smtp.helo(w_mailconn, w_mailhost);
--            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
--            if p_email is null then
--               utl_smtp.rcpt(w_mailconn, 'l-abdac@cvrd.com.br');
--            else
--               utl_smtp.rcpt(w_mailconn, p_email);
--            end if;
--            utl_smtp.open_data(w_mailconn);
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:l-abdac@cvrd.com.br'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'SARBOX: Auto verificação'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--            w_send_mail := 'S';
--         end if;
--
--         if r_verifica.rownum = 1 then
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Os seguintes jobs SARBOX apresentam algum problema. Favor verificar.'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(lpad('SID', 7)||' '||lpad('JOB', 7)||' '||lpad('Wait S', 7)||' '||  rpad('INFO', 25)||' '||rpad('WHAT', 55)||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('------- ------- ------- ------------------------- -------------------------------------------------------'||w_crlf));
--         end if;
--
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(lpad(r_verifica.sid, 7)||' '||lpad(r_verifica.job, 7)||' '||lpad(r_verifica.seconds_in_wait, 7)||' '||rpad(r_verifica.info, 25)||' '||rpad(r_verifica.what, 55)||w_crlf));
--      end;
--      end loop;
--      if w_send_mail = 'S' then
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Obs.: Mensagem automática, favor não responder.'||w_crlf));
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Administração de Banco de Dados / Accenture'||w_crlf));
--         utl_smtp.close_data(w_mailconn);
--         utl_smtp.quit(w_mailconn);
--      end if;
END auto_verificacao;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.stp_verifica_streams
IS
   TYPE rc IS REF CURSOR;

   w_sql                   VARCHAR2 (4000);
   w_ws                    VARCHAR2 (255)
      := '20636F6E6E65637420746F207063736F78202020206964656E746966696564206279206433616436797274202020';
   w_instance              sarbox_instance.INSTANCE%TYPE;
   w_conn_str              sarbox_instance.connect_string%TYPE;
   w_result                VARCHAR2 (100);
   w_nome_db_link_cap      VARCHAR2 (40);
   w_erro_mensagem         VARCHAR2 (4000);
   w_inst_source_email     VARCHAR2 (40);
   w_inst_target_email     VARCHAR2 (40);
   w_erro_mensagem_email   VARCHAR2 (4000);
   r_erros                 rc;

--String de conexao das instancias
   CURSOR c_db_link (pinst VARCHAR2)
   IS
      SELECT   INSTANCE, connect_string
          FROM sarbox_instance
         WHERE INSTANCE = pinst
      ORDER BY priority DESC;

--Instancia com streams
   CURSOR c_inst_streams
   IS
      SELECT instance_source, instance_target, owner, capture_count,
             apply_count, propagation_count, latency_capture,
             parallel_capture_count, parallel_apply_count, replication_type,
             replication_object_type, notify
        FROM sarbox_instance_streams
       WHERE status = 'E';

-- funcao cast to varchar
   FUNCTION ctv (r IN RAW)
      RETURN VARCHAR2
   AS
      w_ctv   VARCHAR2 (255);
   BEGIN
      w_ctv := UTL_RAW.cast_to_varchar2 (r);
      RETURN w_ctv;
   END ctv;

--Cria dblink
   PROCEDURE cria_db_link (pinst VARCHAR2)
   IS
   BEGIN
      FOR r_db_link IN c_db_link (pinst)
      LOOP
         BEGIN
            w_sql :=
                  'create database link '
               || r_db_link.INSTANCE
               || '_SARBOX_STREAMS '
               || ctv (w_ws)
               || ' using '
               || CHR (39)
               || r_db_link.connect_string
               || CHR (39);

            EXECUTE IMMEDIATE (w_sql);
         --dbms_output.put_line(r_streams.instance_source);
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END LOOP;
   END;

   --Exclui os dblinks
   PROCEDURE exlui_db_link
   IS
   BEGIN
      FOR r_db IN (SELECT db_link
                     FROM user_db_links
                    WHERE db_link LIKE '%_SARBOX_STREAMS%')
      LOOP
         BEGIN
            w_sql := 'DROP DATABASE LINK ' || r_db.db_link;

            EXECUTE IMMEDIATE (w_sql);
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END LOOP;
   END;

--Envia email
   PROCEDURE prc_00001_email (p_email IN VARCHAR2 DEFAULT 'c0155226@vale.com')
   IS
      w_send_mail   CHAR                := 'N';
      w_mailhost    VARCHAR2 (64)       := 'relay.cvrd.br';
      w_from        VARCHAR2 (64)       := 'c0012773@vale.com';
      w_mailconn    UTL_SMTP.connection;
      w_crlf        VARCHAR2 (2)        := CHR (13) || CHR (10);
      w_info        VARCHAR2 (200);
   BEGIN
      w_mailconn := UTL_SMTP.open_connection (w_mailhost, 25);
      UTL_SMTP.helo (w_mailconn, w_mailhost);
      UTL_SMTP.mail (w_mailconn, 'c0012773@vale.com');

      IF p_email IS NULL
      THEN
         UTL_SMTP.rcpt (w_mailconn, 'c0155226@vale.com');
      ELSE
         UTL_SMTP.rcpt (w_mailconn, p_email);
      END IF;

      UTL_SMTP.open_data (w_mailconn);
      UTL_SMTP.write_raw_data
                     (w_mailconn,
                      UTL_RAW.cast_to_raw (   'Date:'
                                           || TO_CHAR
                                                     (SYSDATE,
                                                      'dd-mon-yyyy hh24:mi:ss'
                                                     )
                                           || w_crlf
                                          )
                     );
      UTL_SMTP.write_raw_data (w_mailconn,
                               UTL_RAW.cast_to_raw (   'From:ORACLE EMAIL'
                                                    || w_crlf
                                                   )
                              );
      UTL_SMTP.write_raw_data (w_mailconn,
                               UTL_RAW.cast_to_raw (   'To:c0012773@vale.com'
                                                    || w_crlf
                                                   )
                              );
      UTL_SMTP.write_raw_data
                     (w_mailconn,
                      UTL_RAW.cast_to_raw (   'Subject:'
                                           || 'ORACLE Streams - Monitoring...'
                                           || w_crlf
                                          )
                     );
      UTL_SMTP.write_raw_data (w_mailconn, UTL_RAW.cast_to_raw (w_crlf));
      UTL_SMTP.write_raw_data
         (w_mailconn,
          UTL_RAW.cast_to_raw
                    (   'Below are warning/errors on the Streams environment:'
                     || w_crlf
                    )
         );
      UTL_SMTP.write_raw_data (w_mailconn, UTL_RAW.cast_to_raw (w_crlf));
      w_sql := 'select inst_source, inst_target,errors from  tb_tmp_streams';

      OPEN r_erros FOR w_sql;

      LOOP
         FETCH r_erros
          INTO w_inst_source_email, w_inst_target_email,
               w_erro_mensagem_email;

         EXIT WHEN r_erros%NOTFOUND;
         UTL_SMTP.write_raw_data (w_mailconn,
                                  UTL_RAW.cast_to_raw (   'Source:'
                                                       || w_inst_source_email
                                                       || ' - Target:'
                                                       || w_inst_target_email
                                                       || w_crlf
                                                      )
                                 );
         UTL_SMTP.write_raw_data (w_mailconn,
                                  UTL_RAW.cast_to_raw ('Errors:' || w_crlf)
                                 );
         UTL_SMTP.write_raw_data
                                (w_mailconn,
                                 UTL_RAW.cast_to_raw (   w_erro_mensagem_email
                                                      || w_crlf
                                                     )
                                );
         UTL_SMTP.write_raw_data (w_mailconn,
                                  UTL_RAW.cast_to_raw ('' || w_crlf)
                                 );
      END LOOP;

      UTL_SMTP.write_raw_data (w_mailconn,
                               UTL_RAW.cast_to_raw (   'Please! Do not reply.'
                                                    || w_crlf
                                                   )
                              );
      UTL_SMTP.close_data (w_mailconn);
      UTL_SMTP.quit (w_mailconn);
   END;

--Cria tabela temporária
   PROCEDURE cria_temp_table
   IS
   BEGIN
      BEGIN
         w_sql :=
               'create global temporary table tb_tmp_streams'
            || '(inst_source varchar2 (30),'
            || 'inst_target varchar2 (30),'
            || 'errors varchar2 (4000)) '
            || 'on commit preserve rows';

         EXECUTE IMMEDIATE w_sql;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_sql := 'truncate table tb_tmp_streams';

            EXECUTE IMMEDIATE w_sql;
      END;
   END;
BEGIN
   --Exclui os dblinks
   exlui_db_link;
   --Cria tabela temporária
   cria_temp_table;

   --Instancias onde o Streams está implementado
   FOR r_inst_streams IN c_inst_streams
   LOOP
      w_erro_mensagem := '';

      -- Verifica se a instância será monitorada
      IF (r_inst_streams.notify = 'S')
      THEN
         --Verifica o tipo da replicação (D=DownStreams,L=Local Capute)
         IF (r_inst_streams.replication_type = 'D')
         THEN
            --Nome do db_linlk para o Capture
            w_nome_db_link_cap := r_inst_streams.instance_target;
            --Cria dblinks para o destino
            cria_db_link (r_inst_streams.instance_target);
         ELSIF (r_inst_streams.replication_type = 'L')
         THEN
            --Nome do db_linlk para o Capture
            w_nome_db_link_cap := r_inst_streams.instance_source;
            --Cria dblinks para o origem
            cria_db_link (r_inst_streams.instance_source);
            --Cria dblinks para o destino
            cria_db_link (r_inst_streams.instance_target);
         END IF;

         --Verifica a Quant. de filas do capture
         w_sql :=
               'select count(1) from '
            || '( select (substr(capture_name,INSTR(capture_name,''_'',1,1) +1,'
            || '   (INSTR(capture_name,''_'',1,2) - INSTR(capture_name,''_'',1,1)-1))) as owner '
            || 'from gv$streams_capture@'
            || w_nome_db_link_cap
            || '_SARBOX_STREAMS) '
            || 'where owner='
            || ''''
            || r_inst_streams.owner
            || '''';

         EXECUTE IMMEDIATE w_sql
                      INTO w_result;

         IF (r_inst_streams.parallel_capture_count <> w_result)
         THEN
            w_erro_mensagem :=
                  w_erro_mensagem
               || '- Check capture queues ( Num. expected queues: '
               || r_inst_streams.parallel_capture_count
               || ' - Num. current queues: '
               || w_result
               || ' );'
               || CHR (13);
         --dbms_output.put_line ('Favor verificar as filas do Capture!');
         END IF;

         --Verifica a Quant. de filas do Apply
         w_sql :=
               'select count(1) from '
            || '( select (substr(apply_name,INSTR(apply_name,''_'',1,1) +1,'
            || '   (INSTR(apply_name,''_'',1,2) - INSTR(apply_name,''_'',1,1)-1))) as owner '
            || 'from gv$streams_apply_server@'
            || r_inst_streams.instance_target
            || '_SARBOX_STREAMS) '
            || 'where owner='
            || ''''
            || r_inst_streams.owner
            || '''';

         EXECUTE IMMEDIATE w_sql
                      INTO w_result;

         IF (r_inst_streams.parallel_apply_count <> w_result)
         THEN
            --dbms_output.put_line ('Favor verificar as filas do Apply!');
            w_erro_mensagem :=
                  w_erro_mensagem
               || '- Check apply queues ( Num. expected queues:'
               || r_inst_streams.parallel_apply_count
               || ' - Num. current queues:'
               || w_result
               || ' );'
               || CHR (13);
         END IF;

         --Verificar a latencia do Capture
         w_sql :=
               'select max (LATENCY_SECONDS)  from ('
            || 'SELECT capture_name,((SYSDATE - CAPTURE_MESSAGE_CREATE_TIME)*86400) LATENCY_SECONDS,'
            || '(substr(capture_name,INSTR(capture_name,''_'',1,1) +1, '
            || '(INSTR(capture_name,''_'',1,2) - INSTR(capture_name,''_'',1,1)-1))) as owner '
            || ' FROM V$STREAMS_CAPTURE@ '
            || w_nome_db_link_cap
            || '_SARBOX_STREAMS) '
            || 'where owner='
            || ''''
            || r_inst_streams.owner
            || '''';

         EXECUTE IMMEDIATE w_sql
                      INTO w_result;

         IF (r_inst_streams.latency_capture < w_result)
         THEN
            --dbms_output.put_line ('Latencia do capture atingiu o limite. Favor verificar!');
            w_erro_mensagem :=
                  w_erro_mensagem
               || '- Latency capture queues ( Latency time expected: '
               || r_inst_streams.latency_capture
               || ' - Latency time current: '
               || TO_CHAR (w_result, '9999999999.9')
               || ' );'
               || CHR (13);
         END IF;

         --Verificar erros no Apply
         w_sql :=
               'select nvl(count(1),0) from '
            || '( select (substr(apply_name,INSTR(apply_name,''_'',1,1) +1,'
            || '   (INSTR(apply_name,''_'',1,2) - INSTR(apply_name,''_'',1,1)-1))) as owner '
            || 'from dba_apply_error@'
            || r_inst_streams.instance_target
            || '_SARBOX_STREAMS) '
            || 'where owner='
            || ''''
            || r_inst_streams.owner
            || '''';

         EXECUTE IMMEDIATE w_sql
                      INTO w_result;

         IF (w_result > 0)
         THEN
            --dbms_output.put_line ('Existe erros do Apply!');
            w_erro_mensagem :=
                  w_erro_mensagem
               || '- Check apply errors ( Num. current errors: '
               || w_result
               || ' ).';
         END IF;

         -- Preenche dados tabela temporária
         IF LENGTH (w_erro_mensagem) > 0
         THEN
            w_sql :=
                  ' insert into tb_tmp_streams values ('
               || ''''
               || r_inst_streams.instance_source
               || ''''
               || ','
               || ''''
               || r_inst_streams.instance_target
               || ''''
               || ','
               || ''''
               || w_erro_mensagem
               || ''''
               || ')';

            EXECUTE IMMEDIATE w_sql;
         END IF;
      END IF;
   END LOOP;

   --Envia email
   w_sql := ' select count(1) from tb_tmp_streams';

   EXECUTE IMMEDIATE w_sql
                INTO w_result;

   IF w_result > 0
   THEN
      prc_00001_email ('l-abdac@vale.com');                         --Rodrigo
   --prc_00001_email('c0012773@vale.com'); --Fardim
   --prc_00001_email('c0095307@vale.com'); -- Bissoli
   --prc_00001_email('c0135418@vale.com'); -- Lucas
   END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.stp_sox00003_auditlogin
AS
   w_str1             VARCHAR2 (50)             := 'ABCDEFGHIJKMNPQRSTUVWXYZ';
   w_str2             VARCHAR2 (50)     := 'ABCDEFGHIJKMNPQRSTUVWXYZ23456789';
   w_str3             VARCHAR2 (10)                             := '23456789';
   w_wo               VARCHAR2 (255)
      := '20636F6E6E65637420746F206F7065726163616F206964656E74696669656420627920617374726F6E6175747320';
   w_ws               VARCHAR2 (255)
      := '20636F6E6E65637420746F207063736F78202020206964656E746966696564206279206433616436797274202020';
   w_mailhost         VARCHAR2 (64)                        := 'relay.cvrd.br';
   w_from             VARCHAR2 (64)                   := 'acb108@cvrd.com.br';
   w_mailconn         UTL_SMTP.connection;
   w_crlf             VARCHAR2 (2)                     := CHR (13)
                                                          || CHR (10);
   w_sql              VARCHAR2 (4000);
   w_linha_log        VARCHAR2 (4000);
   w_rows             NUMBER;
   w_sql_owner        VARCHAR2 (4000);
   w_bol_owner        VARCHAR2 (10);
   w_commit           NUMBER;
   w_erro_message     VARCHAR2 (400);
   w_erro_statement   VARCHAR2 (400);
   w_erro_carga       NUMBER                                        := 0;
   w_printcabec       NUMBER                                        := 0;
   w_datetimeproc     DATE;
   /* variaveis para longops */
   w_lgopsindex       NUMBER;
   w_internalstatus   NUMBER;
   w_cntreg           NUMBER;                           -- total de registros
   w_loopreg          NUMBER                                        := 0;
                                                                    -- avanco
   w_debug_dtstart    VARCHAR2 (30)
                                := TO_CHAR (SYSDATE, 'dd/mm/rrrr hh24:mi:ss');
   w_debug_dtend      VARCHAR2 (30);
   adddebuginfo       BOOLEAN                                       := FALSE;
   w_strmail          BOOLEAN;
   w_posfim           NUMBER;
   w_mailadd          VARCHAR2 (100);
   /* informação de login*/
   w_aud_dalog        sarbox_instance_auditlogin.login_date%TYPE;
   w_aud_userora      sarbox_instance_auditlogin.user_oracle%TYPE;
   w_aud_userso       sarbox_instance_auditlogin.user_so%TYPE;
   w_aud_machine      sarbox_instance_auditlogin.machine%TYPE;
   w_aud_progr        sarbox_instance_auditlogin.program%TYPE;
   /* string usuário excluir */
   w_string_usrabd    VARCHAR2 (1000);

   TYPE rc IS REF CURSOR;

   c_auditlogin       rc;

   CURSOR c_db_link
   IS
      SELECT   *
          FROM sarbox_instance
         WHERE UPPER (search) = 'Y' AND TYPE = 'P'
      ORDER BY priority;

   /*Definicao de variaveis para QUERY e envio de e-mail para coordenadores*/
   resultado          VARCHAR2 (30000);
   rec1               VARCHAR2 (17)                    := 'c0095265@vale.com';
   rec2               VARCHAR2 (34)   := 'l.accenture.coordenadores@vale.com';
BEGIN
   /*
   ** exclui db_links que ficaram perdidos em caso de erro.
   */
   FOR r_db IN (SELECT db_link
                  FROM user_db_links)
   LOOP
      BEGIN
         w_sql := 'DROP DATABASE LINK ' || r_db.db_link || '_sarbox_d4c';

         EXECUTE IMMEDIATE (w_sql);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   END LOOP;

   /*
   ** limpa a tabela
   */
   BEGIN
      w_sql := 'truncate table pcsox.sarbox_instance_auditlogin';

      EXECUTE IMMEDIATE (w_sql);
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   SELECT COUNT (1)
     INTO w_cntreg
     FROM sarbox_instance
    WHERE UPPER (search) = 'Y' AND TYPE = 'P';

   -- inicializa a linha longops
   w_lgopsindex := DBMS_APPLICATION_INFO.set_session_longops_nohint;
   -- inicializa a operacao na linha da longops
   DBMS_APPLICATION_INFO.set_session_longops
                                            (rindex           => w_lgopsindex,
                                             slno             => w_internalstatus,
                                             op_name          => 'SARBOX - Coleta D4C',
                                             sofar            => w_loopreg,
                                             totalwork        => w_cntreg,
                                             target_desc      => 'Instances',
                                             units            => 'Instance'
                                            );

   FOR r_db_link IN c_db_link
   LOOP
      DBMS_APPLICATION_INFO.set_client_info
                                        (   'SARBOX - Coleta D4C (Instance: '
                                         || r_db_link.INSTANCE
                                         || ')'
                                        );
      w_loopreg := w_loopreg + 1;
      DBMS_APPLICATION_INFO.set_session_longops (rindex         => w_lgopsindex,
                                                 slno           => w_internalstatus,
                                                 sofar          => w_loopreg,
                                                 totalwork      => w_cntreg
                                                );
      w_linha_log := '';
      w_linha_log := TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss') || ' - ';

      /*
      ** criar db_links
      */
      BEGIN
         w_sql :=
               'create database link '
            || r_db_link.INSTANCE
            || '_sarbox_d4c '
            || pak_sox00001.ctv (w_ws)
            || ' using '
            || CHR (39)
            || r_db_link.connect_string
            || CHR (39);

         EXECUTE IMMEDIATE (w_sql);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      BEGIN
         w_string_usrabd := '';

         FOR r1_user IN (SELECT value1
                           FROM pcsox.sarbox_defs
                          WHERE KEY = 'l-abdac')
         LOOP
            w_string_usrabd :=
               w_string_usrabd || CHR (39) || r1_user.value1 || CHR (39)
               || ',';
         END LOOP;

         w_string_usrabd :=
                      SUBSTR (w_string_usrabd, 1, LENGTH (w_string_usrabd) - 1);
         w_string_usrabd := '(' || w_string_usrabd || ')';
         w_sql :=
               'select d4cdalog, d4cusora, d4cususo, d4cmaqui, d4cprogr from d4cmolot@'
            || r_db_link.INSTANCE
            || '_sarbox_d4c where (d4cusora like '
            || CHR (39)
            || 'XTL%'
            || CHR (39)
            || ' or d4cusora like '
            || CHR (39)
            || 'PJ%'
            || CHR (39)
            || ' or d4cusora like '
            || CHR (39)
            || 'RP%'
            || CHR (39)
            || ') and d4cprogr like '
            || CHR (39)
            || '%SQL%'
            || CHR (39)
            || ' and d4cususo like '
            || CHR (39)
            || 'C0%'
            || CHR (39)
            || ' and (trunc (d4cdalog) > trunc (sysdate-7)) and d4cususo not in '
            || w_string_usrabd;
         w_commit := 0;

         BEGIN
            OPEN c_auditlogin FOR w_sql;

            LOOP
               FETCH c_auditlogin
                INTO w_aud_dalog, w_aud_userora, w_aud_userso, w_aud_machine,
                     w_aud_progr;

               EXIT WHEN c_auditlogin%NOTFOUND;

               IF w_commit = 500
               THEN
                  COMMIT;
                  w_commit := 0;
               END IF;

               w_commit := w_commit + 1;

               BEGIN
                  INSERT INTO sarbox_instance_auditlogin
                              (INSTANCE, login_date,
                               user_oracle, user_so, machine,
                               program
                              )
                       VALUES (UPPER (r_db_link.INSTANCE), w_aud_dalog,
                               w_aud_userora, w_aud_userso, w_aud_machine,
                               w_aud_progr
                              );
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
            END LOOP;

            COMMIT;

            CLOSE c_auditlogin;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         COMMIT;

         /*
         ** finalização do processo
         */
         UPDATE sarbox_instance
            SET status = 'OK',
                MESSAGE =
                      w_linha_log
                   || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
                   || '. Informações coletadas com sucesso.',
                errorm = NULL,
                STATEMENT = NULL
          WHERE INSTANCE = r_db_link.INSTANCE;

         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            w_erro_message := SUBSTR (SQLERRM, 1, 400);
            w_erro_statement :=
                SUBSTR (REPLACE (w_sql, pak_sox00001.ctv (w_ws), ''), 1, 400);

            UPDATE sarbox_instance
               SET status = 'NOK',
                   MESSAGE =
                         w_linha_log
                      || TO_CHAR (SYSDATE, 'dd/mm/yyyy hh24:mi:ss')
                      || '. Processo finalizado com erro.',
                   errorm = w_erro_message,
                   STATEMENT = w_erro_statement
             WHERE INSTANCE = r_db_link.INSTANCE;

            COMMIT;
      END;

      /*
      ** excluir o db_link
      */
      BEGIN
         w_sql :=
               'ALTER SESSION CLOSE DATABASE LINK '
            || r_db_link.INSTANCE
            || '_SARBOX_D4C';

         EXECUTE IMMEDIATE (w_sql);

         w_sql := 'DROP DATABASE LINK ' || r_db_link.INSTANCE || '_sarbox_d4c';

         EXECUTE IMMEDIATE (w_sql);
      EXCEPTION
         WHEN OTHERS
         THEN
            IF SQLCODE = -2081
            THEN
               w_sql :=
                  'DROP DATABASE LINK ' || r_db_link.INSTANCE
                  || '_sarbox_d4c';

               EXECUTE IMMEDIATE (w_sql);
            ELSE
               NULL;
            END IF;
      END;
   END LOOP;

   COMMIT;
   /*Apos carga de dados, faz Query na tabela e envia dados para e-mails informados nas variaveis*/
   resultado := CHR (13) || CHR (13);
   w_mailconn := UTL_SMTP.open_connection ('relay.cvrd.br');
   UTL_SMTP.helo (w_mailconn, 'relay.cvrd.br');
   UTL_SMTP.mail (w_mailconn, 'dnbarabd@vale.com');
   UTL_SMTP.rcpt (w_mailconn, rec1);
   UTL_SMTP.rcpt (w_mailconn, rec2);
   UTL_SMTP.open_data (w_mailconn);
   UTL_SMTP.write_raw_data
                     (w_mailconn,
                      UTL_RAW.cast_to_raw (   'Date: '
                                           || TO_CHAR
                                                     (SYSDATE,
                                                      'dd-mon-yyyy hh24:mi:ss'
                                                     )
                                           || UTL_TCP.crlf
                                          )
                     );
   UTL_SMTP.write_raw_data (w_mailconn,
                            UTL_RAW.cast_to_raw (   'From:dnbarabd@vale.com'
                                                 || UTL_TCP.crlf
                                                )
                           );
   UTL_SMTP.write_raw_data
               (w_mailconn,
                UTL_RAW.cast_to_raw (   'Subject:'
                                     || 'ABD/SARBOX: ACESSOS NÃO AUTORIZADOS!'
                                     || UTL_TCP.crlf
                                    )
               );
   UTL_SMTP.write_raw_data (w_mailconn, UTL_RAW.cast_to_raw (''));
   resultado := 'Senhores Coordenadores,' || CHR (13) || CHR (13);
   resultado :=
         resultado
      || 'Segue relatório semanal com os acessos em PRODUÇÃO que VIOLARAM o GAP07 Sarbox estabelecido para acesso a Banco de Dados.'
      || CHR (13)
      || CHR (13);
   resultado := resultado || 'Trecho do GAP violado:' || CHR (13);
   resultado := resultado || 'GAP07 - Acesso a Banco de Dados:' || CHR (13);
   resultado :=
         resultado
      || 'O acesso a tabelas de banco de dados não pode ser efetuado via chaves de processo, ex. chave PJ*, e sim via chave de rede do analista, mediante prévia autorização, pelo autorizador BD ou autorização formal via e-mail do gestor Vale responsável pelo sistema.'
      || CHR (13)
      || CHR (13);
   resultado :=
         resultado
      || 'Lembrando que esse mesmo tipo de acesso não é permitido também nas instâncias de Desenvolvimento e Homologação e que a Christina Vello/VALE possui um controle rigoroso sobre a violação destes GAP´s e a sua violação poderá ser passível de sanções à Accenture, prejudicando nossa credibilidade e integridade.'
      || CHR (13)
      || CHR (13)
      || CHR (13);

   /*ACESSOS DE CHAVES DE ANALISTAS EM BANCO DE DADOS UTILIZANDO CHAVES XTL, PJ OU RP
   Excluindo do relatorio as chaves de Administradores de ambiente*/
   FOR r_result IN (SELECT      UPPER (area.nom_area_accenture)
                             || ' -> '
                             || fun.nom_funcionario
                             || ', dia:'
                             || TO_CHAR (sia.login_date,
                                         'dd/mm/yyyy hh24:mi:ss'
                                        )
                             || ' com '
                             || sia.user_oracle
                             || ' em '
                             || sia.INSTANCE linha
                        FROM pcsox.sarbox_instance_auditlogin sia,
                             pcansexp.funcionario@orapvt005_auditlogin fun,
                             pcansexp.area_accenture@orapvt005_auditlogin area
                       WHERE (UPPER (fun.nom_chave_oracle) =
                                                           UPPER (sia.user_so)
                             )
                         AND (area.cod_area_accenture = fun.cod_area_accenture
                             )
                         AND (sia.user_so NOT IN
                                 ('C0061879', 'C0096297', 'C0123851',
                                  'C0101105', 'C0116160')
                             )
                    ORDER BY area.nom_area_accenture,
                             sia.user_so,
                             fun.nom_funcionario,
                             sia.login_date)
   LOOP
      resultado := resultado || r_result.linha || CHR (13);
   END LOOP;

   /* ENVIO DE E-MAIL*/
   IF resultado <> ' '
   THEN
      resultado :=
            resultado
         || CHR (13)
         || 'Obs.: Mensagem automática, favor não responder.'
         || CHR (13)
         || 'Administração de Banco de Dados / Accenture';
      UTL_SMTP.write_raw_data (w_mailconn, UTL_RAW.cast_to_raw (resultado));
      UTL_SMTP.close_data (w_mailconn);
      UTL_SMTP.quit (w_mailconn);
   END IF;
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
PROCEDURE pcsox.verifica_export (
   p_dia      IN   NUMBER DEFAULT 1,
   p_email    IN   VARCHAR2 DEFAULT NULL,
   p_notify   IN   VARCHAR2 DEFAULT 'Y'
)
IS
   w_str1        VARCHAR2 (50)                  := 'ABCDEFGHIJKMNPQRSTUVWXYZ';
   w_str2        VARCHAR2 (50)          := 'ABCDEFGHIJKMNPQRSTUVWXYZ23456789';
   w_str3        VARCHAR2 (10)                        := '23456789';
   w_wo          VARCHAR2 (255)
      := '20636F6E6E65637420746F206F7065726163616F206964656E74696669656420627920617374726F6E6175747320';
   w_ws          VARCHAR2 (255)
      := '20636F6E6E65637420746F207063736F78202020206964656E746966696564206279206433616436797274202020';
   w_mailhost    VARCHAR2 (64)                        := 'relay.cvrd.br';
   w_from        VARCHAR2 (64)                        := 'acb108@cvrd.com.br';
   w_mailconn    UTL_SMTP.connection;
   w_crlf        VARCHAR2 (2)                         := CHR (13) || CHR (10);
   w_status      sarbox_instance_export.status%TYPE;
   w_cntfull     NUMBER;
   w_cntreeng    NUMBER;
   w_cntprog     NUMBER;
   w_qtdfail     NUMBER;
   w_dtlastok    DATE;
   w_passou      CHAR;
   w_msgadc      VARCHAR2 (50);
   w_linha       VARCHAR2 (255);
   w_send_mail   CHAR                                 := 'N';
   w_lastok      DATE;

   CURSOR c_instance
   IS
      SELECT   INSTANCE, description, hostname, bkplogic_full,
               bkplogic_reeng
          FROM sarbox_instance
         WHERE UPPER (search) = 'Y'
           AND UPPER (check_pcs) = 'Y'
           AND notify LIKE UPPER (p_notify)
      ORDER BY hostname, INSTANCE;
BEGIN
   w_send_mail := 'N';
   w_passou := 'N';

   FOR r_instance IN c_instance
   LOOP
      BEGIN
         IF w_send_mail = 'N'
         THEN
            w_mailconn := UTL_SMTP.open_connection (w_mailhost, 25);
            UTL_SMTP.helo (w_mailconn, w_mailhost);
            UTL_SMTP.mail (w_mailconn, 'abd-adm@vale.com');

            IF p_email IS NULL
            THEN
               --utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
               UTL_SMTP.rcpt (w_mailconn, 'c0095265@vale.com');
            ELSE
               UTL_SMTP.rcpt (w_mailconn, p_email);
            END IF;

            UTL_SMTP.open_data (w_mailconn);
            UTL_SMTP.write_raw_data
                     (w_mailconn,
                      UTL_RAW.cast_to_raw (   'Date:'
                                           || TO_CHAR
                                                     (SYSDATE,
                                                      'dd-mon-yyyy hh24:mi:ss'
                                                     )
                                           || w_crlf
                                          )
                     );
            UTL_SMTP.write_raw_data
                   (w_mailconn,
                    UTL_RAW.cast_to_raw (   'From:OPERACAO - Relatório export'
                                         || w_crlf
                                        )
                   );
            --utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
            UTL_SMTP.write_raw_data
                               (w_mailconn,
                                UTL_RAW.cast_to_raw (   'To:c0095265@vale.com'
                                                     || w_crlf
                                                    )
                               );
            UTL_SMTP.write_raw_data
               (w_mailconn,
                UTL_RAW.cast_to_raw
                            (   'Subject:'
                             || 'EXPORT: Export (full e reeng) com falhas (D-'
                             || p_dia
                             || ')'
                             || w_crlf
                            )
               );
            UTL_SMTP.write_raw_data (w_mailconn,
                                     UTL_RAW.cast_to_raw ('' || w_crlf)
                                    );
            w_send_mail := 'S';
         END IF;

         w_cntfull := 0;
         w_cntreeng := 0;
         w_cntprog := 0;

         SELECT COUNT (1)
           INTO w_cntprog
           FROM sarbox_instance_export
          WHERE INSTANCE = r_instance.INSTANCE
            AND TRUNC (started) >= TRUNC (SYSDATE - 10);

         SELECT MAX (NVL (started, TO_DATE ('01/01/01', 'dd/mm/rr')))
           INTO w_lastok
           FROM sarbox_instance_export
          WHERE INSTANCE = r_instance.INSTANCE
            AND status =
                   'EXPFULL: Export terminated successfully without warnings.';

         SELECT COUNT (1)
           INTO w_cntfull
           FROM sarbox_instance_export
          WHERE INSTANCE = r_instance.INSTANCE
            AND TRUNC (started) = TRUNC (SYSDATE - p_dia)
            AND status =
                   'EXPFULL: Export terminated successfully without warnings.'
            AND exptype = 'EXPFULL';

         SELECT COUNT (1)
           INTO w_cntreeng
           FROM sarbox_instance_export
          WHERE INSTANCE = r_instance.INSTANCE
            AND TRUNC (started) = TRUNC (SYSDATE - p_dia)
            AND status =
                   'EXPREENG: Export terminated successfully without warnings.'
            AND exptype = 'EXPREENG';

         --dbms_output.put_line(rpad(r_instance.instance, 35)||'  '||w_cntfull||' - '||w_cntreeng||' - '||w_cntprog);
         w_msgadc := '';

         IF    (w_cntfull = 0 AND r_instance.bkplogic_full = 'Y')
            OR (w_cntreeng = 0 AND r_instance.bkplogic_reeng = 'Y')
            OR (    w_cntprog = 0
                AND (   r_instance.bkplogic_full = 'Y'
                     OR r_instance.bkplogic_reeng = 'Y'
                    )
               )
         THEN
            IF w_passou = 'N'
            THEN
               UTL_SMTP.write_raw_data
                   (w_mailconn,
                    UTL_RAW.cast_to_raw (   RPAD ('Instance', 30)
                                         || ' '
                                         || RPAD ('Export Full', 15)
                                         || ' '
                                         || RPAD ('Export Reeng', 15)
                                         || ' '
                                         || RPAD ('MSG Adicional (exp. full)',
                                                  50
                                                 )
                                         || ' '
                                         || ' FC'
                                         || RPAD (' Last OK', 10)
                                         || w_crlf
                                        )
                   );
               UTL_SMTP.write_raw_data
                  (w_mailconn,
                   UTL_RAW.cast_to_raw
                      (   RPAD ('------------------------------', 30)
                       || ' '
                       || RPAD ('---------------', 15)
                       || ' '
                       || RPAD ('---------------', 15)
                       || ' '
                       || RPAD
                             ('--------------------------------------------------',
                              50
                             )
                       || ' ---'
                       || ' --------'
                       || w_crlf
                      )
                  );
               w_passou := 'S';
            END IF;

            w_linha :=
                  RPAD (r_instance.INSTANCE || ' (' || r_instance.hostname
                        || ')',
                        30
                       )
               || ' ';
            w_msgadc := '';

            IF w_cntprog = 0
            THEN
               w_qtdfail := 0;

               IF r_instance.bkplogic_full = 'Y'
               THEN
                  w_linha := w_linha || RPAD ('Não programado', 15) || ' ';
               ELSE
                  w_linha := w_linha || RPAD ('Não se aplica ', 15) || ' ';
               END IF;

               IF r_instance.bkplogic_reeng = 'Y'
               THEN
                  w_linha := w_linha || RPAD ('Não programado', 15) || ' ';
               ELSE
                  w_linha := w_linha || RPAD ('Não se aplica ', 15) || ' ';
               END IF;
            ELSE
               -- quantidade de falhas consecutivas
               SELECT NVL (t2.last_ok, t1.inserted)
                 INTO w_dtlastok
                 FROM (SELECT TRUNC (inserted) inserted
                         FROM sarbox_instance
                        WHERE INSTANCE = r_instance.INSTANCE) t1,
                      (SELECT MAX (TRUNC (started)) last_ok
                         FROM sarbox_instance_export
                        WHERE exptype = 'EXPFULL'
                          AND status =
                                 'EXPFULL: Export terminated successfully without warnings.'
                          AND TRUNC (started) < TRUNC (SYSDATE - (p_dia + 1))
                          AND INSTANCE = r_instance.INSTANCE) t2;

               w_qtdfail := 0;
               w_qtdfail := NVL (TRUNC (SYSDATE - (p_dia + 1)) - w_dtlastok,
                                 0);

               IF w_cntfull = 0 AND r_instance.bkplogic_full = 'Y'
               THEN
                  w_cntfull := 0;

                  SELECT COUNT (1)
                    INTO w_cntfull
                    FROM sarbox_instance_export
                   WHERE exptype = 'EXPFULL'
                     AND TRUNC (started) = TRUNC (SYSDATE - p_dia)
                     AND (   status =
                                'EXPFULL: Export terminated successfully with warnings.'
                          OR status = 'EXPFULL: iniciando export.'
                         )
                     AND INSTANCE = r_instance.INSTANCE;

                  IF w_cntfull <> 0
                  THEN
                     -- terminou com warnings
                     w_cntfull := 0;

                     SELECT COUNT (1)
                       INTO w_cntfull
                       FROM sarbox_instance_export
                      WHERE exptype = 'EXPFULL'
                        AND TRUNC (started) = TRUNC (SYSDATE - p_dia)
                        AND status = 'EXPFULL: iniciando export.'
                        AND INSTANCE = r_instance.INSTANCE;

                     IF w_cntfull = 0
                     THEN
                        BEGIN
                           SELECT REPLACE (SUBSTR (NVL (message_ora,
                                                        message_exp
                                                       ),
                                                   1,
                                                   50
                                                  ),
                                           CHR (10),
                                           CHR (32)
                                          )
                             INTO w_msgadc
                             FROM sarbox_instance_export
                            WHERE exptype = 'EXPFULL'
                              AND TRUNC (started) = TRUNC (SYSDATE - p_dia)
                              AND (status =
                                      'EXPFULL: Export terminated successfully with warnings.'
                                  )
                              AND INSTANCE = r_instance.INSTANCE;
                        EXCEPTION
                           WHEN TOO_MANY_ROWS
                           THEN
                              w_msgadc :=
                                  'Backup falhou mais de 1 vez (reexecutado)';
                        END;
                     ELSE
                        -- foi iniciado e nao terminou
                        w_msgadc :=
                                   'BKP não terminou (DB caiu ou executando)';
                     END IF;
                  ELSE
                     -- nao foi iniciado
                     w_msgadc := 'BKP não foi iniciado (falha cron)';
                  END IF;

                  w_linha := w_linha || RPAD ('Verificar', 15) || ' ';
               ELSE
                  IF r_instance.bkplogic_full = 'Y'
                  THEN
                     w_linha := w_linha || RPAD ('ok', 15) || ' ';
                  ELSE
                     w_linha := w_linha || RPAD ('Não se aplica', 15) || ' ';
                  END IF;
               END IF;

               IF w_cntreeng = 0
               THEN
                  IF r_instance.bkplogic_reeng = 'Y'
                  THEN
                     w_linha := w_linha || RPAD ('Verificar', 15) || ' ';
                  ELSE
                     w_linha := w_linha || RPAD ('Não se aplica', 15) || ' ';
                  END IF;
               ELSE
                  w_linha := w_linha || RPAD ('ok', 15) || ' ';
               END IF;
            END IF;

            w_linha :=
                  w_linha
               || RPAD (NVL (w_msgadc, '-'), 50)
               || ' '
               || LPAD (w_qtdfail, 3)
               || ' '
               || TO_CHAR (w_lastok, 'DD/MM/RR');
            UTL_SMTP.write_raw_data (w_mailconn,
                                     UTL_RAW.cast_to_raw (w_linha || w_crlf)
                                    );
         END IF;
      END;
   END LOOP;

   IF w_send_mail = 'S'
   THEN
      UTL_SMTP.close_data (w_mailconn);
      UTL_SMTP.quit (w_mailconn);
   END IF;
END verifica_export;
/

SHOW ERRORS;


CREATE OR REPLACE FUNCTION PCSOX.soxauth wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
552 32f
nT5E8oWAkth8HHQXaEKLJXuVeKkwg/DDLtCDfC/NWA/uE7fFVQEx7Y5Fjea47PW22sKkItwr
b2k14cJmS+BsP8/GvUYUjjLHqFhCP4ZCTjl46ErSiOmTI1ozmERlZmx20EZhUZ9ayK6zUItK
F05KAmaVkp3072QJhaJuhXXrPK0lm+mZqCEJ6XGyzaYicpOM60jE14c3uE0UCw9aGiyrBxAV
roixKOObfnvn5+YtdJvdTByNt+PDzDrw5ZQcDPndsEKePZuunJndlJOiMB2lDk4Qm9mw12VV
F0YDkfjsHImnWe6GzGVjrojgZjlhFG8VOFerOE4w278K0ihIYZ6OzckyLtmHnk3K+31fdm9e
3s8qMoWw8T1a9VBDVne4E/4xVLLjuk258+KUbamxpkMLm3BRwet4ccytWcdaHcbhyPXjYlbj
L48dY++0R9WspaP3H2WzA9+l/LqbewzoBEUF/7dY4dlNxPUNbj+P5vKaOzPOhkkn7yn3cZ3o
Hw6Tq1s1ZOyYpzc2rGhX8JwTfpx+6McRdDmPMGgw5OKByWinNx35RaIgw2sBiBF3v06xwI8f
HvVylwiFHARsBwIcMr4ZJLAkE1Vksf66MFDgs0L84pxVVmoXz3mVl1QBxNwtg00zMc/amjRq
TcJCp2Lr8CX38U45n0WaFQW5XrTEeSPOzo7A98mYtTgl2PJcWDUyCg1hQ4fW5XfdHVxTiLqN
kANLEGsWrqItR4CRd1o74EixuLG9dRGpmY6I2hQlqtbBDKz28x27wPfazgZcS/L5unUti5eH
DEmd5ESaR3ma
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
FUNCTION pcsox.checkpass (p_passwd IN VARCHAR2)
   RETURN VARCHAR2
AS
   w_str1      VARCHAR2 (50) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   w_str2      VARCHAR2 (50) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
   w_str3      VARCHAR2 (10) := '0123456789';
   w_strlen1   NUMBER        := LENGTH (w_str1);
   w_strlen2   NUMBER        := LENGTH (w_str2);
   w_strlen3   NUMBER        := LENGTH (w_str3);
   w_pwdfnc    VARCHAR2 (50);
   w_pwd       VARCHAR2 (50);
   w_car_a     CHAR;
   w_car_n     CHAR;
   w_car_n_t   CHAR;
   w_car_v     NUMBER;
   w_var_v_p   NUMBER;
   w_val       BOOLEAN       := FALSE;
   w_contnum   NUMBER;
   icar        INTEGER;
   inum        INTEGER;
   r_passwd    CHAR;
BEGIN
   w_pwdfnc := UPPER (p_passwd);

   /*
   ** verifica largura da senha no minimo 8 caracters
   */
   IF LENGTH (w_pwdfnc) < 8
   THEN
      r_passwd := 'F';
      --dbms_output.put_line('P01 : ' || length(w_pwdfnc));
      RETURN r_passwd;
   END IF;

   /*
   ** verifca se não começa ou termina por numero
   ** se não tem letras consecutivas maior ou menor
   **
   ** valida os caracters intermediarios da senha
   **
   ** o primeiro caracter da senha
   */
   w_car_a := '?';

   FOR icar IN 1 .. LENGTH (w_pwdfnc)
   LOOP
      w_car_n := SUBSTR (w_pwdfnc, icar, 1);

      --dbms_output.put_line('PXX : avaliando caracter ' || w_car_n ||' - '||icar);
      IF (icar = 1) OR (icar = LENGTH (w_pwdfnc))
      THEN
         --dbms_output.put_line('P02 : avaliando caracter ' || w_car_n);
         IF INSTR (w_str1, w_car_n, 1) = 0
         THEN
            r_passwd := 'F';
            --dbms_output.put_line('P03 : saindo inicio/fim  ' || w_car_n || ' - ' || r_passwd);
            RETURN r_passwd;
         END IF;
      ELSE
         --dbms_output.put_line('P04 : avaliando caracter ' || w_car_n);
         IF INSTR (w_str2, w_car_n, 1) = 0
         THEN
            r_passwd := 'F';
            --dbms_output.put_line('P05 : caracter invalido  ' || w_car_n || ' - ' || r_passwd);
            RETURN r_passwd;
         END IF;
      END IF;

      /*
      ** faz a verificao se o caracter atual e igual, anterior ou posterior
      */
      IF    (ASCII (w_car_a) = ASCII (w_car_n))
         OR (ASCII (w_car_a) = (ASCII (w_car_n) - 1))
         OR (ASCII (w_car_a) = (ASCII (w_car_n) + 1))
      THEN
         r_passwd := 'F';
         --dbms_output.put_line('P06 : seq rep/ant/pos    ' || w_car_n || ' - ' || r_passwd);
         RETURN r_passwd;
      END IF;

      w_car_a := w_car_n;
   END LOOP;

   /*
   ** tem que ter dois números
   */
   w_contnum := 0;
   w_car_v := 0;
   w_var_v_p := 0;
   w_car_n_t := 0;

   FOR inum IN 1 .. LENGTH (w_pwdfnc)
   LOOP
      IF INSTR (w_str3, SUBSTR (w_pwdfnc, inum, 1)) <> 0
      THEN
         IF     (w_car_v <> SUBSTR (w_pwdfnc, inum, 1))
            AND ((w_var_v_p + 1) <> inum)
         THEN
            w_var_v_p := inum;
            w_contnum := w_contnum + 1;
         END IF;

         w_car_n_t := w_car_n_t + 1;
         w_car_v := SUBSTR (w_pwdfnc, inum, 1);
      END IF;
   END LOOP;

   IF     (w_car_n_t = 2)
      AND (w_contnum = 2)
      AND (SUBSTR (w_pwdfnc, 1, 1) <> SUBSTR (w_pwdfnc, -1, 1))
   THEN
      r_passwd := 'V';
      --dbms_output.put_line('P07 : validacao numerica ' || w_car_n_t || ' - ' || r_passwd);
      RETURN r_passwd;
   ELSE
      r_passwd := 'F';
      --dbms_output.put_line('P07 : validacao numerica ' || w_car_n_t || ' - ' || r_passwd);
      RETURN r_passwd;
   END IF;

   r_passwd := 'V';
   RETURN r_passwd;
END;
/

SHOW ERRORS;


CREATE OR REPLACE /* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
FUNCTION pcsox.fnc_fssize (
   p_instance    VARCHAR2,
   p_type        VARCHAR2,
   p_dtcollect   DATE
)
   RETURN NUMBER
AS
   w_size   NUMBER;
BEGIN
   w_size := 0;

   BEGIN
      IF p_type = 'DA'
      THEN
         SELECT bytes_aloc
           INTO w_size
           FROM sarbox_instance_tablespace
          WHERE INSTANCE = p_instance
            AND tablespace_name = 'INSTANCE ALLOCATION - DATA'
            AND dtcollect = TRUNC (p_dtcollect);
      ELSIF p_type = 'DU'
      THEN
         SELECT bytes_used
           INTO w_size
           FROM sarbox_instance_tablespace
          WHERE INSTANCE = p_instance
            AND tablespace_name = 'INSTANCE ALLOCATION - DATA'
            AND dtcollect = TRUNC (p_dtcollect);
      ELSIF p_type = 'BA'
      THEN
         SELECT bytes_aloc
           INTO w_size
           FROM sarbox_instance_tablespace
          WHERE INSTANCE = p_instance
            AND tablespace_name = 'INSTANCE ALLOCATION - BKP'
            AND dtcollect = TRUNC (p_dtcollect);
      ELSIF p_type = 'BU'
      THEN
         SELECT bytes_used
           INTO w_size
           FROM sarbox_instance_tablespace
          WHERE INSTANCE = p_instance
            AND tablespace_name = 'INSTANCE ALLOCATION - BKP'
            AND dtcollect = TRUNC (p_dtcollect);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         w_size := 0;
   END;

   RETURN w_size;
END;
/

SHOW ERRORS;


CREATE OR REPLACE FUNCTION PCSOX.soxauthpasswd wrapped
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
8
556 333
7EcSLSkUrQKRw58hdawBRnTn71kwg/DDTNCDfC+Kgp0VINzl0krWtglr6j42sBqctPfNpQiR
Q6aUFMoWQKe3zggNtuehFvxDApG/eh6QkJXwS2oArDdZSgg4nWiVCflYHe+OR4hR3W+0yy+l
fAQxd4iDoAE3acj5rl2lE458++l6UVNS9CF6PKamX+kcH+8F6k+c2LMn3xPJloBXdYz0xldQ
KEqsIlHBXx46WnR5eqXzpvP+A92Eb0PrL43MMfCXlINEnbvuVkTFOsEeRHeUoeMRsqUaThDS
amqBZVUfpgFuvGyAawK2pfUGon1eORPCN9f3RHAvX8ZQepCPans6RB47xRjJ7UXobGStiagP
KXR20zhIz98yhWpuw1r1UGMUULgTM/qidMgTCiKiw9VvxYeEPixrSbY0bp09lAKEIVt4cNuO
09AORIjgWb41fechAxjyMDuF1ez8k/24c2w/E8aCTUUMHwhxFobjTMKH1xk40WPBpxLkM6Qh
+yxRWZ1FH8MDV5tzh62/1R2biEXHqxxdZlXUEwInWbLdiAmMc1weO/199XuxtJCrUxZRg9Jo
ig0E/j1XVW1IIaBbYK84N2HRPPjBisFOxteLf1woVNG6clXX5dVsNI/VmSvb8hMySlw5Y5hM
fqoKNfoCiQqR1fUajzTWkKQJgWG1L5+cG8b+KKic9Gi1KLeFZVzeOUOQPINvujvDlTl242jZ
UMV5bkTN1elSZl8w32aM5idDx5gCmEquVLJujFDbNWv51TRxCUJvL0Nxl2W1h5Dl2PFziyvY
MMKxUPquqvuO1Ljn
/

SHOW ERRORS;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_mfvol
AS
   SELECT vol_id, TRUNC (kbytes_tot / 1024) kbytes_tot,
          TRUNC (kbytes_avail / 1024) kbytes_avail,
          TRUNC (kbytes_used / 1024) kbytes_used, pct_used
     FROM sarbox_mf_vols
    WHERE dropped = 'NO';


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_mfseg
AS
   SELECT dsn_name, db_name, tbs_name, seg_ext, seg_sizetrk, seg_sizekb,
          seg_parts, lpart_lextkb
     FROM sarbox_mf_segs
    WHERE dropped = 'NO';


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_user
AS
   SELECT siu.INSTANCE, si.hostname, siu.username, siu.status, siu.owner,
          siu.PROFILE, TO_CHAR (siu.dtdropped, 'dd/mm/yyyy') dtdropped,
          siu.dropped, siu.owner_dblink,
          TO_CHAR (siu.lock_date, 'dd/mm/yyyy') lock_date,
          TO_CHAR (siu.expiry_date, 'dd/mm/yyyy') expiry_date,
          TO_CHAR (siu.last_logon, 'dd/mm/yyyy') last_logon,
          siu.default_tablespace, siu.temporary_tablespace
     FROM sarbox_instance_user siu, sarbox_instance si
    WHERE siu.INSTANCE = si.INSTANCE AND si.search = 'Y';


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_sarbox_instance
AS
   SELECT "INSTANCE", "SEARCH", "VERSION", "STARTUP_TIME", "HOSTNAME",
          "STATUS", "CS", "TYPE", "KSIZE", "SEARCH_TRACE", "MESSAGE",
          "ERRORM", "CONNECT_STRING", "SEARCH_PRIVS", "SEARCH_PROFILE",
          "SEARCH_LINKS", "PRIORITY", "STATEMENT", "DESCRIPTION",
          "SESSIONS_CURRENT", "SESSIONS_HIGHWATER", "CPU_COUNT_CURRENT",
          "CPU_COUNT_HIGHWATER", "FIXED_SIZE", "VARIABLE_SIZE",
          "DATABASE_BUFFERS", "REDO_BUFFERS", "CREATED", "RESETLOGS_TIME",
          "CONTROLFILE_CREATED", "CONTROLFILE_TIME", "VERSION_TIME",
          "PLATFORM_ID", "PLATFORM_NAME", "RECOVERY_TARGET_INCARNATION#",
          "LAST_OPEN_INCARNATION#", "SERVER_INSTANCES",
          "SERVER_INSTANCES_ACTIVE", "VSTATUS", "VMESSAGE", "VERRORM",
          "INSERTED", "CHECK_PCS", "LOGICAL_READS", "PHYSICAL_READS",
          "PHYSICAL_WRITES", "HIT_RATIO_BUFFER", "RC_GETS", "RC_GETMISSES",
          "HIT_RATIO_LIBRARY_CACHE", "LBC_PINS", "LBC_RELOADS",
          "HIT_HATIO_CACHEMISS", "VERRORDT", "VERRORCOUNT", "PREFERRED_NODE",
          "FILE_AUTOEXTENSIBLE", "NOTIFY", "INSTANCE_NUMBER", "SERVICE_NAME",
          "OBS", "SGBD", "LOG_MODE", "VALIDATED_BY"
     FROM sarbox_instance;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_instance
AS
   SELECT si.INSTANCE, si.VERSION,
          LOWER (REPLACE (UPPER (si.hostname), '.CVRD.BR', '')) hostname,
          TRUNC (si.ksize / 1024) ksize,
          NVL (si.platform_name, 'N/A') platform_name, si.server_instances,
          si.description,
          LOWER (REPLACE (UPPER (si.preferred_node), '.CVRD.BR', '')
                ) preferred_node,
          cnt_null,
          sox.apura_disponibilidade (si.INSTANCE,
                                     instance_number,
                                     EXTRACT (MONTH FROM SYSDATE)
                                    ) disp,
          sgbd
     FROM sarbox_instance si,
          (SELECT   INSTANCE,
                    SUM (CASE
                            WHEN sud.username IS NULL
                               THEN 1
                            ELSE 0
                         END) cnt_null
               FROM sarbox_instance_user siu, sarbox_user_description sud
              WHERE siu.username = sud.username(+) AND siu.dropped = 'NO'
                    AND owner = 'YES'
           GROUP BY INSTANCE) dn
    WHERE si.INSTANCE = dn.INSTANCE AND si.search = 'Y'
   UNION
   SELECT si.INSTANCE, si.VERSION,
          LOWER (REPLACE (UPPER (si.hostname), '.CVRD.BR', '')) hostname,
          TRUNC (si.ksize / 1024) ksize,
          NVL (si.platform_name, 'N/A') platform_name, si.server_instances,
          si.description,
          LOWER (REPLACE (UPPER (si.preferred_node), '.CVRD.BR', '')
                ) preferred_node,
          0, 0, sgbd
     FROM sarbox_instance si
    WHERE sgbd = 'DB2';


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_owner_object
AS
   SELECT   siu.INSTANCE, siu.username,
            NVL (sud.description, 'No description found') dc,
            CASE
               WHEN sud.description IS NULL
                  THEN 0
               WHEN SUBSTR (UPPER (sud.description), 1, 5) = 'ABD -'
                  THEN 8
               WHEN UPPER (sud.description) = 'SGBD ORACLE'
                  THEN 9
               ELSE 2
            END ob,
            CASE
               WHEN status IS NULL
                  THEN 1
               WHEN status = 'OPEN'
                  THEN 0
               WHEN status = 'LOCKED'
                  THEN 8
               WHEN status = 'EXPIRED'
                  THEN 3
               ELSE 9
            END od1,
            status, NVL (TO_CHAR (lock_date, 'dd/mm/rrrr'), '-') lock_date,
            0 cnt_table, 0 cnt_index, 0 cnt_view, 0 cnt_others
       FROM sarbox_instance_user siu, sarbox_user_description sud
      WHERE siu.username = sud.username(+)
        AND siu.dropped = 'NO'
        AND owner = 'YES'
        AND siu.username NOT IN
               ('DBSNMP', 'EXFSYS', 'OUTLN', 'SYS', 'SYSTEM', 'TSMSYS',
                'WMSYS', 'CTXSYS', 'XDB', 'SYSMAN')
   ORDER BY od1, ob, username;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_instance_info
AS
   SELECT INSTANCE, hostname, service_name, description, VERSION
     FROM sarbox_instance
    WHERE search = 'Y' AND sgbd = 'ORACLE'
   UNION
   SELECT INSTANCE, hostname, service_name, description, VERSION
     FROM sarbox_instance
    WHERE sgbd = 'DB2';


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_defs
AS
   SELECT value1
     FROM sarbox_defs;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_user_desc
AS
   SELECT   dlenmown AS username, dlenmins AS instancia,
            duedescr AS descricao
       FROM bdpcdd.dleiowat dleiowat, bdsegmap.duepcddv@orapvt001
      WHERE dlecodig = duecodig(+)
        AND dlenmown NOT IN
               ('BDTRACE', 'OPERACAO', 'OPS$OPERACAO', 'SYSTEM', 'SYS',
                'PCSOX')
   ORDER BY dlenmown;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_sistemas
AS
   SELECT   SUBSTR (REPLACE (UPPER (si.hostname), '.CVRD.BR', ''),
                    1,
                    20
                   ) AS servidor,
            si.INSTANCE AS instancia, si.VERSION AS versao, siu.username,
            NVL (UPPER (t_legado.descricao),
                 '*** SISTEMA NÃO CADASTRADO. ***'
                ) AS descricao
       FROM (SELECT UPPER (dlenmown) AS username,
                    NVL (UPPER (duedescr),
                         '*** DESCRIÇÃO NÃO CADASTRADA. ***'
                        ) AS descricao,
                    TRIM (dlenmins) AS instancia
               FROM bdpcdd.dleiowat dleiowat, bdsegmap.duepcddv
              WHERE dlecodig = duecodig(+)
             UNION
             SELECT UPPER (duecodig) AS username,
                    NVL (UPPER (duedescr),
                         '*** DESCRIÇÃO NÃO CADASTRADA. ***'
                        ) AS descricao,
                    TRIM (dlenmins) AS instancia
               FROM bdpcdd.dleiowat dleiowat, bdsegmap.duepcddv
              WHERE duecodig = dlecodig(+)) t_legado,
            sarbox_instance si,
            sarbox_instance_user siu
      WHERE si.INSTANCE = siu.INSTANCE
        AND siu.INSTANCE = t_legado.instancia(+)
        AND siu.username = t_legado.username(+)
        AND siu.username NOT IN
               ('BDTRACE', 'OPERACAO', 'OPS$OPERACAO', 'SYSTEM', 'SYS',
                'PCSOX', 'DBSNMP', 'OUTLN', 'ORAFLY', 'RMAN', 'BDPCDD',
                'PERFSTAT', 'EDSDBA', 'SCOTT', 'PROCGID', 'EXFSYS', 'TSMSYS',
                'WMSYS')
        AND siu.username NOT LIKE 'ACB%'
        AND siu.username NOT LIKE 'C00%'
        AND siu.username NOT LIKE '%_BKP'
        AND siu.dropped = 'NO'
        AND siu.owner = 'YES'
        AND si.search = 'Y'
   ORDER BY si.INSTANCE, siu.username;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_dbs
AS
   SELECT   dsn_name, db_name, COUNT (DISTINCT vol_id) qtdvol,
            COUNT (DISTINCT tbs_name) qtdtbs, SUM (trks) voltrk,
            SUM (kbytes) volkb
       FROM sarbox_mf_vols_segs_new mfsegsext
      WHERE dt_upd =
               (SELECT MAX (dt_upd)
                  FROM sarbox_mf_vols_segs_new mfsegsint
                 WHERE mfsegsint.vol_id = mfsegsext.vol_id
                   AND mfsegsint.dsn_name = mfsegsext.dsn_name
                   AND mfsegsint.db_name = mfsegsext.db_name
                   AND mfsegsint.tbs_name = mfsegsext.tbs_name
                   AND mfsegsint.part_name = mfsegsext.part_name)
   GROUP BY dsn_name, db_name;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_volsegs
AS
   SELECT vol_id, dsn_name, db_name, tbs_name, part_name, trks, kbytes,
          extents
     FROM sarbox_mf_vols_segs;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_volfree
AS
   SELECT vol_id, seg_id, trk_avail, kbytes_avail
     FROM sarbox_mf_vols_freesegs;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_segfail
AS
   SELECT te.vol_id, te.dsn_name, te.db_name, te.tbs_name, te.part_name,
          te.kbytes, te.next_extent_kbytes, te.extents
     FROM sarbox_mf_vols_segs te
    WHERE te.next_extent_kbytes > (SELECT NVL (MAX (kbytes_avail), 0)
                                     FROM sarbox_mf_vols_freesegs ti
                                    WHERE ti.vol_id = te.vol_id);


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_instance_user_dropped
AS
   SELECT
/* antiga - select instance, username, dtdropped from sarbox_dropuser_log where dtdropped >=trunc(sysdate - 60) order by instance,username */
            INSTANCE, username, dtdropped
       FROM sarbox_instance_user siue
      WHERE dropped = 'YES'
        AND EXISTS (SELECT 1
                      FROM sarbox_dropuser_log sdul
                     WHERE sdul.username = siue.username)
        AND NOT EXISTS (
               SELECT 1
                 FROM sarbox_instance_user siui, sarbox_instance sii
                WHERE sii.INSTANCE = siui.INSTANCE
                  AND siui.username = siue.username
                  AND dtdropped IS NULL
                  AND search = 'Y')
        AND dtdropped >= TRUNC (SYSDATE - 60)
   ORDER BY username;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_instance_mininfo
AS
   SELECT INSTANCE, description
     FROM sarbox_instance
    WHERE search = 'Y';


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_space
AS
   SELECT   INSTANCE, TO_CHAR (TRUNC (dtcollect), 'RRRRMMDD') || 'S' coleta,
            TRUNC (SUM (bytes_aloc) / 1024 / 1024 / 1024) mb_alocado,
            TRUNC (SUM (bytes_used) / 1024 / 1024 / 1024) mb_usado,
            TRUNC (  fnc_fssize (INSTANCE, 'DA', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) fsmb_alocado,
            TRUNC (  fnc_fssize (INSTANCE, 'DU', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) fsmb_usado,
            TRUNC (  fnc_fssize (INSTANCE, 'BA', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) bkmb_alocado,
            TRUNC (  fnc_fssize (INSTANCE, 'BU', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) bkmb_usado
       FROM sarbox_instance_tablespace
      WHERE TRUNC (TO_CHAR (dtcollect, 'D')) = 2
        AND dtcollect >= TRUNC (SYSDATE - 90)
        AND tablespace_name = 'INSTANCE ALLOCATION'
   GROUP BY INSTANCE, TRUNC (dtcollect)
   UNION
   SELECT   INSTANCE, TO_CHAR (TRUNC (dtcollect), 'RRRRMMDD') || 'M' coleta,
            TRUNC (SUM (bytes_aloc) / 1024 / 1024 / 1024) mb_alocado,
            TRUNC (SUM (bytes_used) / 1024 / 1024 / 1024) mb_usado,
            TRUNC (  fnc_fssize (INSTANCE, 'DA', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) fsmb_alocado,
            TRUNC (  fnc_fssize (INSTANCE, 'DU', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) fsmb_usado,
            TRUNC (  fnc_fssize (INSTANCE, 'BA', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) bkmb_alocado,
            TRUNC (  fnc_fssize (INSTANCE, 'BU', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) bkmb_usado
       FROM sarbox_instance_tablespace
      WHERE TRUNC (TO_CHAR (dtcollect, 'dd')) = 1
        AND dtcollect < TRUNC (SYSDATE - 90)
        AND dtcollect >= TRUNC (SYSDATE - 450)
        AND tablespace_name = 'INSTANCE ALLOCATION'
   GROUP BY INSTANCE, TRUNC (dtcollect)
   UNION
   SELECT   INSTANCE, TO_CHAR (TRUNC (dtcollect), 'RRRRMMDD') || 'I' coleta,
            TRUNC (SUM (bytes_aloc) / 1024 / 1024 / 1024) mb_alocado,
            TRUNC (SUM (bytes_used) / 1024 / 1024 / 1024) mb_usado,
            TRUNC (  fnc_fssize (INSTANCE, 'DA', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) fsmb_alocado,
            TRUNC (  fnc_fssize (INSTANCE, 'DU', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) fsmb_usado,
            TRUNC (  fnc_fssize (INSTANCE, 'BA', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) bkmb_alocado,
            TRUNC (  fnc_fssize (INSTANCE, 'BU', TRUNC (dtcollect))
                   / 1024
                   / 1024
                   / 1024
                  ) bkmb_usado
       FROM sarbox_instance_tablespace te
      WHERE tablespace_name = 'INSTANCE ALLOCATION'
        AND dtcollect =
               (SELECT MIN (dtcollect)
                  FROM sarbox_instance_tablespace ti
                 WHERE ti.tablespace_name = 'INSTANCE ALLOCATION'
                   AND ti.INSTANCE = te.INSTANCE)
   GROUP BY INSTANCE, TRUNC (dtcollect)
   ORDER BY INSTANCE, coleta;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_instance_replica_nok
AS
   SELECT   INSTANCE, table_name, MAX (load_date) AS load_date
       FROM sarbox_instance_replica
      WHERE status = 'NOK'
   GROUP BY INSTANCE, table_name
   ORDER BY load_date;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_instance_replica_ok
AS
   SELECT   INSTANCE, table_name, MAX (load_date) AS load_date
       FROM sarbox_instance_replica
      WHERE status = 'OK'
   GROUP BY INSTANCE, table_name
   ORDER BY load_date;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.vw_web_srn
AS
   SELECT "INSTANCE", "SERVICE_NAME", "SERVICE_TNS", "SERVICE_STRING",
          "USER_MAPED", "DESCRIPTION", "INSERTED", "INSERTED_BY"
     FROM pcsox.sarbox_instance_service;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_instance_tbs_aloc
AS
   SELECT "NAME", "DUMMY", "BYTES", "USED", "FREE", "PCT_USED"
     FROM (SELECT   b.tablespace_name NAME, b.tablespace_name dummy,
                      SUM (NVL (b.BYTES, 0))
                    / COUNT (DISTINCT a.file_id || '.' || a.block_id) BYTES,
                        SUM (NVL (b.BYTES, 0))
                      / COUNT (DISTINCT a.file_id || '.' || a.block_id)
                    - SUM (NVL (a.BYTES, 0)) / COUNT (DISTINCT b.file_id)
                                                                         used,
                    SUM (NVL (a.BYTES, 0)) / COUNT (DISTINCT b.file_id) free,
                      100
                    * (  (  SUM (NVL (b.BYTES, 0))
                          / COUNT (DISTINCT a.file_id || '.' || a.block_id)
                         )
                       - (SUM (NVL (a.BYTES, 0)) / COUNT (DISTINCT b.file_id)
                         )
                      )
                    / (  SUM (NVL (b.BYTES, 0))
                       / COUNT (DISTINCT a.file_id || '.' || a.block_id)
                      ) pct_used
               FROM SYS.dba_free_space a,
                    (SELECT tablespace_name, BYTES, file_id
                       FROM SYS.dba_data_files
                     UNION
                     SELECT tablespace_name, BYTES, file_id
                       FROM SYS.dba_temp_files) b
              WHERE b.tablespace_name = a.tablespace_name(+)
           GROUP BY b.tablespace_name
           ORDER BY pct_used DESC)
    WHERE pct_used > 80;


/* Formatted on 2011/10/31 14:50 (Formatter Plus v4.8.8) */
CREATE OR REPLACE VIEW pcsox.sarbox_serverinfo
AS
   SELECT SYSDATE server_sysdate
     FROM DUAL;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00002_logparameter
   after update ON PCSOX.SARBOX_INSTANCE_PARAMETER    referencing new as new old as old for each row
begin
   if :old.value                 <> :new.value then
      pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE_PARAMETER', 'VALUE', :new.name, :old.value, :new.value, :new.inst_id);
   end if;
exception
   when others then null;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00003_registry
 after
  update
 ON PCSOX.SARBOX_INSTANCE_REGISTRY referencing new as new old as old
 for each row
begin

   if :old.version               <> :new.version then
      pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE_REGISTRY', 'VERSION', :new.comp_name, :old.version, :new.version);
   end if;
   if :old.status                <> :new.status then
      pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE_REGISTRY', 'STATUS' , :new.comp_name, :old.status,  :new.status);
   end if;

exception
   when others then null;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00001_userupdate
  before update
on sarbox_instance_user
  referencing
  new as new
  old as old
for each row
begin
   if (:new.status <> :old.status) or (:new.owner <> :old.owner) or (:new.profile <> :old.profile) or (:new.rdbms <> :old.rdbms) or (:new.tpcarga <> :old.tpcarga) then
      :new.dtupdate := sysdate;
   end if;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00002_linkupdate
  before update
on sarbox_instance_link
  referencing
  new as new
  old as old
for each row
begin
   if (:new.ctime <> :new.ctime) or (:new.host <> :new.host) or (:new.username <> :new.username) or (:new.password <> :new.password) or (:new.flag <> :new.flag) or (:new.authusr <> :new.authusr) or (:new.autphpwd <> :new.autphpwd) then
      :new.dtupdate := sysdate;
   end if;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00005_logfs
 after
  update
 ON PCSOX.SARBOX_INSTANCE_FS referencing new as new old as old
 for each row
begin

   if :old.sizeb  <> :new.sizeb then
      pak_sox00001.grava_log(:new.hostname, 'SARBOX_INSTANCE_FS', 'SIZEB', :new.filesystem, :old.sizeb, :new.sizeb);
   end if;

   if :old.usedb  <> :new.usedb then
      pak_sox00001.grava_log(:new.hostname, 'SARBOX_INSTANCE_FS', 'USEDB', :new.filesystem, :old.usedb, :new.usedb);
   end if;

   if :old.pctuse <> :new.pctuse then
      pak_sox00001.grava_log(:new.hostname, 'SARBOX_INSTANCE_FS', 'PCTUSE', :new.filesystem, :old.pctuse, :new.pctuse);
   end if;


exception
   when others then null;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00001_description
  before insert
ON PCSOX.SARBOX_USER_DESCRIPTION   referencing
  new as new
  old as old
for each row
declare
   w_username  v$session.username%type;
   w_osuser    v$session.osuser%type;
   w_machine   v$session.machine%type;
begin
   --
   -- indentifica informacoes da sessão
   --
   begin
      select   upper(t1.username)
      ,        upper(t1.osuser)
      ,        upper(t1.machine)
      into     w_username
      ,        w_osuser
      ,        w_machine
      from     v$session   t1
      where    t1.audsid = userenv('sessionid')
      and      program not like 'oracle@%';
   exception
      when others then null;
   end;

   :new.userexec  := w_username;
   :new.userso    := w_osuser;
   :new.terminal  := w_machine;

exception
    when others then null;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00004_inserted
 BEFORE
  INSERT OR UPDATE
 ON PCSOX.SARBOX_INSTANCE REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
declare
   w_username  v$session.username%type;
   w_osuser    v$session.osuser%type;
   w_machine   v$session.machine%type;
   w_program   v$session.program%type;
begin
   select   upper(t1.username)
   ,        upper(t1.osuser)
   ,        upper(t1.machine)
   ,        upper(t1.program)
   into     w_username
   ,        w_osuser
   ,        w_machine
   ,        w_program
   from     v$session   t1
   where    t1.audsid = userenv('sessionid');

   if updating then
      :new.inserted     := trunc(:old.inserted);
      :new.validated_by := trunc(:old.validated_by);
   elsif inserting then
      :new.inserted     := trunc(sysdate);
      :new.validated_by := substr(w_username||' - '||w_osuser||' - '||w_machine||' - '||w_program, 1, 50);
   end if;
exception
   when others then null;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.TRG_SOX00001_LOGINSTANCE
 AFTER 
 UPDATE
 ON PCSOX.SARBOX_INSTANCE  REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
begin
   if :old.instance_number = :new.instance_number then
      if :old.search                <> :new.search then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'SEARCH', 'SEARCH', :old.search, :new.search);
      end if;
      if :old.version               <> :new.version then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'VERSION', 'VERSION', :old.version, :new.version);
      end if;
      if :old.startup_time          <> :new.startup_time then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'STARTUP_TIME', 'STARTUP_TIME', :old.startup_time, :new.startup_time);
      end if;
      if :old.hostname              <> :new.hostname then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'HOSTNAME', 'HOSTNAME', :old.hostname, :new.hostname);
      end if;
      if :old.cs                    <> :new.cs then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'CS', 'CS', :old.cs, :new.cs);
      end if;
      if :old.ksize                 <> :new.ksize then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'KSIZE', 'KSIZE', :old.ksize, :new.ksize);
      end if;
      if (:old.sessions_highwater    <> :new.sessions_highwater) and (:old.startup_time          <> :new.startup_time)  then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'SESSIONS_HIGHWATER', 'SESSIONS_HIGHWATER', :old.sessions_highwater, :new.sessions_highwater);
      end if;
      if (:old.cpu_count_highwater   <> :new.cpu_count_highwater) and (:old.startup_time          <> :new.startup_time) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'CPU_COUNT_HIGHWATER', 'CPU_COUNT_HIGHWATER', :old.cpu_count_highwater, :new.cpu_count_highwater);
      end if;
      if :old.fixed_size            <> :new.fixed_size then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'FIXED_SIZE', 'FIXED_SIZE', :old.fixed_size, :new.fixed_size);
      end if;
      if :old.variable_size         <> :new.variable_size then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'VARIABLE_SIZE', 'VARIABLE_SIZE', :old.variable_size, :new.variable_size);
      end if;
      if :old.database_buffers      <> :new.database_buffers then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'DATABASE_BUFFERS', 'DATABASE_BUFFERS', :old.database_buffers, :new.database_buffers);
      end if;
      if :old.redo_buffers          <> :new.redo_buffers then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'REDO_BUFFERS', 'REDO_BUFFERS', :old.redo_buffers, :new.redo_buffers);
      end if;
      if (:old.created                      <> :new.created) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'CREATED', 'CREATED', :old.created, :new.created);
      end if;
      if (:old.resetlogs_time               <> :new.resetlogs_time) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'RESETLOGS_TIME', 'RESETLOGS_TIME', :old.resetlogs_time, :new.resetlogs_time);
      end if;
      if (:old.controlfile_created          <> :new.controlfile_created) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'CONTROLFILE_CREATED', 'CONTROLFILE_CREATED', :old.controlfile_created, :new.controlfile_created);
      end if;
      if (:old.version_time                 <> :new.version_time) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'VERSION_TIME', 'VERSION_TIME', :old.version_time, :new.version_time);
      end if;
      if (:old.platform_name                <> :new.platform_name) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'PLATFORM_NAME', 'PLATFORM_NAME', :old.platform_name, :new.platform_name);
      end if;
      if (:old.recovery_target_incarnation# <> :new.recovery_target_incarnation#) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'RECOVERY_TARGET_INCARNATION#', 'RECOVERY_TARGET_INCARNATION#', :old.recovery_target_incarnation#, :new.recovery_target_incarnation#);
      end if;
      if (:old.last_open_incarnation#       <> :new.last_open_incarnation#) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'LAST_OPEN_INCARNATION#', 'LAST_OPEN_INCARNATION#', :old.last_open_incarnation#, :new.last_open_incarnation#);
      end if;
      if (:old.server_instances             <> :new.server_instances) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'SERVER_INSTANCES', 'SERVER_INSTANCES', :old.server_instances, :new.server_instances);
      end if;
      if (:old.server_instances_active      <> :new.server_instances_active) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'SERVER_INSTANCES_ACTIVE', 'SERVER_INSTANCES_ACTIVE', :old.server_instances_active, :new.server_instances_active);
      end if;
      if (:old.hit_ratio_buffer             <> :new.hit_ratio_buffer) and (:new.hit_ratio_buffer < 90 or :old.hit_ratio_buffer < 90) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'HIT_RATIO_BUFFER', 'HIT_RATIO_BUFFER', :old.hit_ratio_buffer, :new.hit_ratio_buffer);
      end if;
      if (:old.hit_ratio_library_cache      <> :new.hit_ratio_library_cache) and (:new.hit_ratio_library_cache < 90 or :old.hit_ratio_library_cache < 90) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'HIT_RATIO_LIBRARY_CACHE', 'HIT_RATIO_LIBRARY_CACHE', :old.hit_ratio_library_cache, :new.hit_ratio_library_cache);
      end if;
      if (:old.preferred_node               <> :new.preferred_node) then
         pak_sox00001.grava_log(:new.instance, 'SARBOX_INSTANCE', 'PREFERRED_NODE', 'PREFERRED_NODE', :old.preferred_node, :new.preferred_node);
      end if;
   end if;
exception
   when others then null;
end;
/
SHOW ERRORS;


CREATE OR REPLACE TRIGGER PCSOX.trg_sox00006_inserted
 BEFORE
  INSERT OR UPDATE
 ON PCSOX.SARBOX_INSTANCE_SERVICE REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
declare
   w_username  v$session.username%type;
   w_osuser    v$session.osuser%type;
   w_machine   v$session.machine%type;
   w_program   v$session.program%type;
begin
   select   upper(t1.username)
   ,        upper(t1.osuser)
   ,        upper(t1.machine)
   ,        upper(t1.program)
   into     w_username
   ,        w_osuser
   ,        w_machine
   ,        w_program
   from     v$session   t1
   where    t1.audsid = userenv('sessionid');
   if updating then
      :new.inserted     := trunc(:old.inserted);
      :new.inserted_by  := trunc(:old.inserted_by);
   elsif inserting then
      :new.inserted     := trunc(sysdate);
      :new.inserted_by  := substr(w_username||' - '||w_osuser||' - '||w_machine||' - '||w_program, 1, 50);
   end if;
exception
   when others then null;
end;
/
SHOW ERRORS;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_TABLESPACE FOR PCSOX.SARBOX_INSTANCE_TABLESPACE;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_FS FOR PCSOX.SARBOX_INSTANCE_FS;


CREATE PUBLIC SYNONYM VW_WEB_MFVOL FOR PCSOX.VW_WEB_MFVOL;


CREATE PUBLIC SYNONYM VW_WEB_MFSEG FOR PCSOX.VW_WEB_MFSEG;


CREATE PUBLIC SYNONYM VW_WEB_USER FOR PCSOX.VW_WEB_USER;


CREATE PUBLIC SYNONYM VW_WEB_SARBOX_INSTANCE FOR PCSOX.VW_WEB_SARBOX_INSTANCE;


CREATE PUBLIC SYNONYM SARBOX_SEC_LOG FOR PCSOX.SARBOX_SEC_LOG;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_LOG FOR PCSOX.SARBOX_INSTANCE_LOG;


CREATE PUBLIC SYNONYM VW_WEB_INSTANCE FOR PCSOX.VW_WEB_INSTANCE;


CREATE PUBLIC SYNONYM VW_WEB_OWNER_OBJECT FOR PCSOX.VW_WEB_OWNER_OBJECT;


CREATE PUBLIC SYNONYM VW_WEB_INSTANCE_INFO FOR PCSOX.VW_WEB_INSTANCE_INFO;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_JOB FOR PCSOX.SARBOX_INSTANCE_JOB;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_IDM FOR PCSOX.SARBOX_INSTANCE_IDM;


CREATE PUBLIC SYNONYM VW_WEB_DEFS FOR PCSOX.VW_WEB_DEFS;


CREATE PUBLIC SYNONYM SARBOX_MF_VOLS FOR PCSOX.SARBOX_MF_VOLS;


CREATE PUBLIC SYNONYM SARBOX_MF_VOLS_FREESEGS FOR PCSOX.SARBOX_MF_VOLS_FREESEGS;


CREATE PUBLIC SYNONYM SARBOX_DE_PARA_ACN FOR PCSOX.SARBOX_DE_PARA_ACN;


CREATE PUBLIC SYNONYM CID_ROLE FOR PCSOX.CID_ROLE;


CREATE PUBLIC SYNONYM CID_ROLEPRIV FOR PCSOX.CID_ROLEPRIV;


CREATE PUBLIC SYNONYM CID_SYSPRIV FOR PCSOX.CID_SYSPRIV;


CREATE PUBLIC SYNONYM CID_TABPRIV FOR PCSOX.CID_TABPRIV;


CREATE PUBLIC SYNONYM CID_TEMP_TABPRIV FOR PCSOX.CID_TEMP_TABPRIV;


CREATE PUBLIC SYNONYM CID_OBJECT FOR PCSOX.CID_OBJECT;


CREATE PUBLIC SYNONYM SARBOX_MF_SEGS FOR PCSOX.SARBOX_MF_SEGS;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_REGISTRY FOR PCSOX.SARBOX_INSTANCE_REGISTRY;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_STORAGE FOR PCSOX.SARBOX_INSTANCE_STORAGE;


CREATE PUBLIC SYNONYM CHECKPASS FOR PCSOX.CHECKPASS;


CREATE PUBLIC SYNONYM PAK_SOX00001 FOR PCSOX.PAK_SOX00001;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_SYSPRIV FOR PCSOX.SARBOX_INSTANCE_SYSPRIV;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_USER_HISTORY FOR PCSOX.SARBOX_INSTANCE_USER_HISTORY;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_USER$ FOR PCSOX.SARBOX_INSTANCE_USER$;


CREATE PUBLIC SYNONYM SARBOX_TROCA_LOG FOR PCSOX.SARBOX_TROCA_LOG;


CREATE PUBLIC SYNONYM SARBOX_USER_PASSWORD FOR PCSOX.SARBOX_USER_PASSWORD;


CREATE PUBLIC SYNONYM USUARIOS_FORA_PADRAO FOR PCSOX.USUARIOS_FORA_PADRAO;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_ROLEPRIV FOR PCSOX.SARBOX_INSTANCE_ROLEPRIV;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_ROLE FOR PCSOX.SARBOX_INSTANCE_ROLE;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_PROFILE FOR PCSOX.SARBOX_INSTANCE_PROFILE;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_USER FOR PCSOX.SARBOX_INSTANCE_USER;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE FOR PCSOX.SARBOX_INSTANCE;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_TABPRIV FOR PCSOX.SARBOX_INSTANCE_TABPRIV;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_LOGIN FOR PCSOX.SARBOX_INSTANCE_LOGIN;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_LINK FOR PCSOX.SARBOX_INSTANCE_LINK;


CREATE PUBLIC SYNONYM SARBOX_USER_DESC FOR PCSOX.SARBOX_USER_DESC;


CREATE PUBLIC SYNONYM SARBOX_TEMP_MF_SEGS FOR PCSOX.SARBOX_TEMP_MF_SEGS;


CREATE PUBLIC SYNONYM SARBOX_DROPUSER_LOG FOR PCSOX.SARBOX_DROPUSER_LOG;


CREATE PUBLIC SYNONYM PAK_SOX99999 FOR PCSOX.PAK_SOX99999;


CREATE PUBLIC SYNONYM SARBOX_SISTEMAS FOR PCSOX.SARBOX_SISTEMAS;


CREATE PUBLIC SYNONYM SOX FOR PCSOX.PAK_SOX00001;


CREATE PUBLIC SYNONYM FNC_FSSIZE FOR PCSOX.FNC_FSSIZE;


CREATE PUBLIC SYNONYM SARBOX_MF_VOLS_SEGS_NEW FOR PCSOX.SARBOX_MF_VOLS_SEGS_NEW;


CREATE PUBLIC SYNONYM VW_WEB_DBS FOR PCSOX.VW_WEB_DBS;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_STREAMS FOR PCSOX.SARBOX_INSTANCE_STREAMS;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_OBJECT FOR PCSOX.SARBOX_INSTANCE_OBJECT;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_STARTUP FOR PCSOX.SARBOX_INSTANCE_STARTUP;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_PARAMETER FOR PCSOX.SARBOX_INSTANCE_PARAMETER;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_HISTORY FOR PCSOX.SARBOX_INSTANCE_HISTORY;


CREATE PUBLIC SYNONYM VW_WEB_VOLFREE FOR PCSOX.VW_WEB_VOLFREE;


CREATE PUBLIC SYNONYM VW_WEB_VOLSEGS FOR PCSOX.VW_WEB_VOLSEGS;


CREATE PUBLIC SYNONYM VW_WEB_SEGFAIL FOR PCSOX.VW_WEB_SEGFAIL;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_EXPORT FOR PCSOX.SARBOX_INSTANCE_EXPORT;


CREATE PUBLIC SYNONYM SARBOX_CLUSTER FOR PCSOX.SARBOX_CLUSTER;


CREATE PUBLIC SYNONYM SARBOX_CLUSTER_NODE FOR PCSOX.SARBOX_CLUSTER_NODE;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_USER_DROPPED FOR PCSOX.SARBOX_INSTANCE_USER_DROPPED;


CREATE PUBLIC SYNONYM SARBOX_USER_DESCRIPTION FOR PCSOX.SARBOX_USER_DESCRIPTION;


CREATE PUBLIC SYNONYM SARBOX_DEFS FOR PCSOX.SARBOX_DEFS;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_STREAMS_OBJECT FOR PCSOX.SARBOX_INSTANCE_STREAMS_OBJECT;


CREATE PUBLIC SYNONYM STP_SOX00003_AUDITLOGIN FOR PCSOX.STP_SOX00003_AUDITLOGIN;


CREATE PUBLIC SYNONYM VW_WEB_INSTANCE_MININFO FOR PCSOX.VW_WEB_INSTANCE_MININFO;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_REPLICA FOR PCSOX.SARBOX_INSTANCE_REPLICA;


CREATE PUBLIC SYNONYM VW_WEB_SPACE FOR PCSOX.VW_WEB_SPACE;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_SERVICE FOR PCSOX.SARBOX_INSTANCE_SERVICE;


CREATE PUBLIC SYNONYM VW_WEB_SRN FOR PCSOX.VW_WEB_SRN;


CREATE PUBLIC SYNONYM SARBOX_INSTANCE_AUDITLOGIN FOR PCSOX.SARBOX_INSTANCE_AUDITLOGIN;


BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_EXPORT'
    ,policy_name           => 'SELSOX_SI_EXPORT'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_OBJECT'
    ,policy_name           => 'SELSOX_SI_OBJECT'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_DROPUSER_LOG'
    ,policy_name           => 'SELSOX_SDL'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_HISTORY'
    ,policy_name           => 'SELSOX_SI_HIST'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_IDM'
    ,policy_name           => 'SELSOX_SI_IDM'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_JOB'
    ,policy_name           => 'SELSOX_SI_JOB'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_LINK'
    ,policy_name           => 'SELSOX_SI_LINK'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_LOG'
    ,policy_name           => 'SELSOX_SI_LOG'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_LOGIN'
    ,policy_name           => 'SELSOX_SI_LOGIN'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_PARAMETER'
    ,policy_name           => 'SELSOX_PARM'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_PROFILE'
    ,policy_name           => 'SELSOX_SI_PROFILE'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_REGISTRY'
    ,policy_name           => 'SELSOX_SI_REG'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_ROLE'
    ,policy_name           => 'SELSOX_SI_ROLE'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_ROLEPRIV'
    ,policy_name           => 'SELSOX_SI_RPRIV'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_STARTUP'
    ,policy_name           => 'SELSOX_SI_START'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_SYSPRIV'
    ,policy_name           => 'SELSOX_SI_SPRIV'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_TABLESPACE'
    ,policy_name           => 'SELSOX_SI_TBS'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_TABPRIV'
    ,policy_name           => 'SELSOX_SI_TPRIV'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_USER'
    ,policy_name           => 'SELSOX_SI_USER'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_USER$'
    ,policy_name           => 'SELSOX_SI_USER$'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE_USER_HISTORY'
    ,policy_name           => 'SELSOX_SI_UHIST'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_TEMP_INSTANCE_OBJECT'
    ,policy_name           => 'SELSOX_SI_TO'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_TEMP_INSTANCE_TABPRIV'
    ,policy_name           => 'SELSOX_SI_RT'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_INSTANCE'
    ,policy_name           => 'SELSOX_SI'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTH'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



BEGIN
  SYS.DBMS_RLS.ADD_POLICY     (
    object_schema          => 'PCSOX'
    ,object_name           => 'SARBOX_USER_PASSWORD'
    ,policy_name           => 'SELSOX_SUP'
    ,function_schema       => 'PCSOX'
    ,policy_function       => 'SOXAUTHPASSWD'
    ,statement_types       => 'SELECT'
    ,policy_type           => dbms_rls.dynamic
    ,long_predicate        => FALSE
    ,update_check          => FALSE
    ,static_policy         => FALSE
    ,enable                => TRUE );
END;
/



ALTER TABLE PCSOX.SARBOX_INSTANCE_TABLESPACE ADD (
  CONSTRAINT SARBOX_INSTANCE_TABLESPACE_PK
 PRIMARY KEY
 (INSTANCE, TABLESPACE_NAME, DTCOLLECT)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_DE_PARA_ACN ADD (
  CONSTRAINT SARBOX_DE_PARA_ACN_PK
 PRIMARY KEY
 (CHAVE_C00)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_FS ADD (
  CONSTRAINT SARBOX_INSTANCE_FS_PK
 PRIMARY KEY
 (HOSTNAME, FILESYSTEM)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.USER_FOR_DROP_108 ADD (
  CONSTRAINT USER_FOR_DROP_108_PK
 PRIMARY KEY
 (USERNAME, NUMEIMAC)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_IDM ADD (
  CONSTRAINT SARBOX_INSTANCE_IDM_PK
 PRIMARY KEY
 (INSTANCE, INSTANCE_SOURCE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_JOB ADD (
  CONSTRAINT SARBOX_INSTANCE_JOB_PK
 PRIMARY KEY
 (INSTANCE, JOB, LOG_USER, PRIV_USER, SCHEMA_USER)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_MF_VOLS ADD (
  CONSTRAINT SARBOX_MF_VOLS_PK
 PRIMARY KEY
 (VOL_ID)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_MF_VOLS_FREESEGS ADD (
  CONSTRAINT SARBOX_MF_VOLS_FREESEGS_PK
 PRIMARY KEY
 (VOL_ID, SEG_ID)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_REGISTRY ADD (
  CONSTRAINT SARBOX_INSTANCE_REGISTRY_PK
 PRIMARY KEY
 (INSTANCE, COMP_ID)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_STORAGE ADD (
  CONSTRAINT SARBOX_INSTANCE_STORAGE_PK
 PRIMARY KEY
 (INSTANCE, FILESYSTEM, DTCOLLECT)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_USER$ ADD (
  CONSTRAINT SARBOX_INSTANCE_USER$_PK
 PRIMARY KEY
 (INSTANCE, USER#, NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE ADD (
  CONSTRAINT SARBOX_INSTANCE_PK
 PRIMARY KEY
 (INSTANCE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          32K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_LINK ADD (
  CONSTRAINT SARBOX_INSTANCE_LINK_PK
 PRIMARY KEY
 (INSTANCE, OWNER, DBLINK)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_LOGIN ADD (
  CONSTRAINT SARBOX_INSTANCE_LOGIN_PK
 PRIMARY KEY
 (INSTANCE, USERNAME, PROGRAM, USERSO)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_PROFILE ADD (
  CONSTRAINT SARBOX_INSTANCE_PROFILE_PK
 PRIMARY KEY
 (INSTANCE, PROFILE, RESOURCE_NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_ROLE ADD (
  CONSTRAINT SARBOX_INSTANCE_ROLE_PK
 PRIMARY KEY
 (INSTANCE, ROLE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_ROLEPRIV ADD (
  CONSTRAINT SARBOX_INSTANCE_ROLEPRIV_PK
 PRIMARY KEY
 (INSTANCE, GRANTEE, GRANTED_ROLE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_SYSPRIV ADD (
  CONSTRAINT SARBOX_INSTANCE_SYSPRIV_PK
 PRIMARY KEY
 (INSTANCE, GRANTEE, PRIVILEGE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_TABPRIV ADD (
  CONSTRAINT SARBOX_INSTANCE_TABPRIV_PK
 PRIMARY KEY
 (INSTANCE, GRANTEE, OWNER, TABLE_NAME, GRANTOR, PRIVILEGE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_USER ADD (
  CONSTRAINT SARBOX_INSTANCE_USER_PK
 PRIMARY KEY
 (INSTANCE, USERNAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          264K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_USER_HISTORY ADD (
  CONSTRAINT SARBOX_INSTANCE_USER_HIST_PK
 PRIMARY KEY
 (DTCOLETA, INSTANCE, USERNAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_USER_PASSWORD ADD (
  CONSTRAINT SARBOX_USER_PASSWORD_PK
 PRIMARY KEY
 (USERNAME, DTGERACAO, TYPE)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_MF_SEGS ADD (
  CONSTRAINT SARBOX_MF_SEGS_PK
 PRIMARY KEY
 (DSN_NAME, DB_NAME, TBS_NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_MF_VOLS_SEGS_NEW ADD (
  CONSTRAINT SARBOX_MF_VOLS_SEGS_NEW_PK
 PRIMARY KEY
 (VOL_ID, DSN_NAME, DB_NAME, TBS_NAME, PART_NAME, DT_UPD)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_STREAMS ADD (
  CONSTRAINT SARBOX_INSTANCE_STREAMS_CHK001
 CHECK (REPLICATION_TYPE IN ('L','D')),
  CONSTRAINT SARBOX_INSTANCE_STREAMS_PK
 PRIMARY KEY
 (INSTANCE_SOURCE, OWNER, INSTANCE_TARGET)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_OBJECT ADD (
  CONSTRAINT SARBOX_INSTANCE_OBJECTS_PK
 PRIMARY KEY
 (INSTANCE, OWNER, OBJECT_ID, OBJECT_NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_PARAMETER ADD (
  CONSTRAINT SARBOX_INSTANCE_PARAMETER_PK
 PRIMARY KEY
 (INSTANCE, NAME, INST_ID)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_EXPORT ADD (
  CONSTRAINT SARBOX_INSTANCE_EXPORT_PK
 PRIMARY KEY
 (INSTANCE, ID_PROCESS)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_STARTUP ADD (
  CONSTRAINT SARBOX_INSTANCE_STARTUP_PK
 PRIMARY KEY
 (INSTANCE, STARTUP_TIME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_CLUSTER ADD (
  CONSTRAINT SARBOX_CLUSTER_PK
 PRIMARY KEY
 (CLUSTER_ID)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_CLUSTER_NODE ADD (
  CONSTRAINT SARBOX_CLUSTER_NODE_PK
 PRIMARY KEY
 (CLUSTER_ID, NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_USER_DESCRIPTION ADD (
  CONSTRAINT SARBOX_USER_DESCRIPTION_PK
 PRIMARY KEY
 (USERNAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_STREAMS_OBJECT ADD (
  CONSTRAINT SARBOX_INSTANCE_STREAMS_OBJ_PK
 PRIMARY KEY
 (INSTANCE_SOURCE, INSTANCE_TARGET, OWNER, OBJECT_NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_INSTANCE_SERVICE ADD (
  CONSTRAINT SARBOX_INSTANCE_SERVICE_PK
 PRIMARY KEY
 (INSTANCE, SERVICE_NAME)
    USING INDEX 
    TABLESPACE D3SOX01T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_MAPPING_IDM ADD (
  CONSTRAINT SARBOX_MAPPING_IDM_PK
 PRIMARY KEY
 (INSTANCE)
    USING INDEX 
    TABLESPACE D4TRAM1T
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          5M
                NEXT             5M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE PCSOX.SARBOX_CLUSTER_NODE ADD (
  CONSTRAINT SARBOX_CLUSTER_R1 
 FOREIGN KEY (CLUSTER_ID) 
 REFERENCES PCSOX.SARBOX_CLUSTER (CLUSTER_ID));

ALTER TABLE PCSOX.SARBOX_INSTANCE_SERVICE ADD (
  CONSTRAINT SARBOX_INSTANCE_SERVICE_R1 
 FOREIGN KEY (INSTANCE) 
 REFERENCES PCSOX.SARBOX_INSTANCE (INSTANCE));

GRANT EXECUTE ON PCSOX.PAK_SOX00001 TO BDPCDD;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO BDPCDD;

GRANT SELECT ON PCSOX.SARBOX_USER_PASSWORD TO BDPCDD;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER TO CANSAUT;

GRANT SELECT ON PCSOX.SARBOX_USER_PASSWORD TO CANSAUT;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER_DROPPED TO CSEGMAP;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER_DROPPED TO CSEGMAP2;

GRANT SELECT ON PCSOX.SARBOX_DEBUG TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_DROPUSER_LOG TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_EXPORT TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_HISTORY TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_LINK TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_LOG TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_LOGIN TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_OBJECT TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_PARAMETER TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_PROFILE TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_REGISTRY TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_ROLE TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_ROLEPRIV TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_STARTUP TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_SYSPRIV TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_TABLESPACE TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_TABPRIV TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER$ TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER_HISTORY TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_SYSIBM_DBAUTH TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_SYSIBM_TABAUTH TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_TEMP_INSTANCE_OBJECT TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_TEMP_INSTANCE_TABPRIV TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_TROCA_LOG TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_USER_PASSWORD TO CSOX;

GRANT SELECT ON PCSOX.USUARIOS_FORA_PADRAO TO CSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER_DROPPED TO C0125443;

GRANT EXECUTE ON PCSOX.PAK_SOX00001 TO EANSAUT;

GRANT EXECUTE ON PCSOX.PAK_SOX00001 TO OPERACAO;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO OPERACAO;

GRANT DELETE, INSERT, SELECT, UPDATE ON PCSOX.SARBOX_SYSIBM_DBAUTH TO OPERACAO;

GRANT DELETE, INSERT, SELECT, UPDATE ON PCSOX.SARBOX_SYSIBM_TABAUTH TO OPERACAO;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO PCANSAUT;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO PJANSAUT;

GRANT EXECUTE ON PCSOX.PAK_SOX00001 TO PJANSAUTABD;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO PJANSAUTABD;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_USER TO PJANSAUTABD;

GRANT SELECT ON PCSOX.SARBOX_USER_PASSWORD TO PJANSAUTABD;

GRANT DELETE, INSERT, SELECT, UPDATE ON PCSOX.SARBOX_SYSIBM_DBAUTH TO PJSOX;

GRANT DELETE, INSERT, SELECT, UPDATE ON PCSOX.SARBOX_SYSIBM_TABAUTH TO PJSOX;

GRANT SELECT ON PCSOX.SARBOX_USER_DESCRIPTION TO PJSOX;

GRANT SELECT ON PCSOX.VW_WEB_INSTANCE TO PJSOX;

GRANT SELECT ON PCSOX.VW_WEB_OWNER_OBJECT TO PJSOX;

GRANT SELECT ON PCSOX.VW_WEB_DBS TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_DEFS TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_INSTANCE TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_INSTANCE_INFO TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_INSTANCE_MININFO TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_MFSEG TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_MFVOL TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_OWNER_OBJECT TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_SARBOX_INSTANCE TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_SEGFAIL TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_SPACE TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_SRN TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_USER TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_VOLFREE TO RPSOX;

GRANT SELECT ON PCSOX.VW_WEB_VOLSEGS TO RPSOX;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE TO STRMADMIN;

GRANT SELECT ON PCSOX.SARBOX_INSTANCE_STREAMS TO STRMADMIN;

