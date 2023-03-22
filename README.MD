# Tables-Audit

An audit is needed to monitor for the addition, updating, or deletion of records to the table.

## Instalation

Create all objects from
- **AUDIT_TABLES_OBJECTS_LIST.sql**
- **AUDIT_CLEAR.sql**
- **CLEAR_AUDIT_TABLES_JOB.sql** - job for cleaning audit table. You can configurate you own job. You maybe should add ***GRANT SCHEDULER_ADMIN TO <Your Schema>***
- **V_AUDIT_TABLES_OBJECTS_LIST.sql** - You maybe should add ***GRANT CREATE ANY VIEW TO <Your Schema>***
- **PKG_AUD_(SPECIFICATION)**
- **PKG_AUD_(BODY)**

## Using

### :one: Creating Audit Objects with Default Objects Names

```
PROCEDURE CREATE_AUDIT_OBJECTS(vTABLE_NAME	IN varchar2,
								vSCHEMA		IN varchar2 DEFAULT vSCHEMA_DEFAULT,
								tGRANTS		IN GRANTS DEFAULT NULL,
								nINSERT		IN NUMBER DEFAULT 1,
								nUPDATE		IN NUMBER DEFAULT 1,
								nDELETE		IN NUMBER DEFAULT 1,
								nTIME_TYPE	IN NUMBER DEFAULT NULL,
								nDAYS_CNT	IN NUMBER DEFAULT NULL,
								nMONTHS_CNT	IN NUMBER DEFAULT NULL);
```

- **vTABLE_NAME** - table for audit
- **vSCHEMA** - default schema is schema where Package is
- **tGRANTS** - list of schemas. Grant select will be added on **<AUDIT_TABLE>** to this schemas
- **nINSERT** - 1 - add INSERT Audit, 0 - don't add
- **nUPDATE** - 1 - add UPDATE Audit, 0 - don't add
- **nDELETE** - 1 - add DELETE Audit, 0 - don't add
- **nTIME_TYPE** - 1 - add Clearing <AUDIT_TABLE> with Days parameter, 2 - add Clearing <AUDIT_TABLE> with Month parameter, null - don't add Clearing for **<AUDIT_TABLE>**
- **nDAYS_CNT** - if nTIME_TYPE = 1 then this parameter show Days count for saving Audit
- **nMONTHS_CNT** - if nTIME_TYPE = 2 then this parameter show Month count for saving Audit

:two: Creating Audit Objects with Custom Objects Names

```
PROCEDURE CREATE_AUDIT_OBJECTS_CUSTOM(vTABLE_NAME	IN varchar2,
									vSCHEMA			IN varchar2,
									vAUD_TABLE		IN varchar2,
									vAUD_SEQ		IN varchar2,
									nAUD_SEQ_CACHE	IN NUMBER DEFAULT NULL,
									vAUD_TRG_NAME	IN varchar2,
									vTABLE_TRG_NAME	IN varchar2,
									tGRANTS			IN GRANTS DEFAULT NULL,
									nINSERT			IN NUMBER DEFAULT 1,
									nUPDATE			IN NUMBER DEFAULT 1,
									nDELETE			IN NUMBER DEFAULT 1,
									nTIME_TYPE		IN NUMBER DEFAULT NULL,
									nDAYS_CNT		IN NUMBER DEFAULT NULL,
									nMONTHS_CNT		IN NUMBER DEFAULT NULL);
```

- **vAUD_TABLE** - audit table name (Default **AUD_<vTABLE_NAME>**)
- **vAUD_SEQ** - ID sequence name for **vAUD_TABLE** (Default **AUD_<vTABLE_NAME>_SEQ**)
- **nAUD_SEQ_CACHE** - cashe for **vAUD_SEQ** (Default 100)
- **vAUD_TRG_NAME** - trigger name for **vAUD_TABLE** (Default **AUD_<vTABLE_NAME>_I**)
- **vTABLE_TRG_NAME** - trigger name for **vTABLE_NAME** (Default **LOG_<vTABLE_NAME>**)

:three: Drop Audit Objects by **AUDIT_TABLES_OBJECTS_LIST.ID**
```
PROCEDURE DROP_AUDIT_OBJECTS(nID IN NUMBER);
```

:four: Drop Audit Objects by **AUDIT_TABLES_OBJECTS_LIST.T_SCHEMA** and **AUDIT_TABLES_OBJECTS_LIST.SOURCE_TABLE**
```
PROCEDURE DROP_AUDIT_OBJECTS(vTABLE_NAME	IN varchar2,
							vSCHEMA			IN varchar2 DEFAULT vSCHEMA_DEFAULT);
```
