# Tables-Audit

An audit is needed to monitor for the addition, updating, or deletion of records to the table.

## Instalation

Create all objects from 
- **AUDIT_CLEAR.sql**
- **AUDIT_TABLES_OBJECTS_LIST.sql**
- **PKG_AUD_(SPECIFICATION)**
- **PKG_AUD_(BODY)**

## Using

:one: Creating Audit Objects with Default Paramentres

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
- **tGRANTS** - list of schemas. Grant select will be added on <AUDIT_TABLE> to this schemas
- **nINSERT** - 1 - add INSERT Audit, 0 - don't add
- **nUPDATE** - 1 - add UPDATE Audit, 0 - don't add
- **nDELETE** - 1 - add DELETE Audit, 0 - don't add
- **nTIME_TYPE** - 1 - add Clearing <AUDIT_TABLE> with Days paramenter, 2 - add Clearing <AUDIT_TABLE> with Month paramenter, null - don't add Clearing for <AUDIT_TABLE>
- **nDAYS_CNT** - if nTIME_TYPE = 1 then this parameter show Days count for saving Audit
- **nMONTHS_CNT** - if nTIME_TYPE = 2 then this parameter show Month count for saving Audit