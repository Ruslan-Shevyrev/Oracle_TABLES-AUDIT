# Tables-Audit

An audit is needed to monitor the inserting, updating, or deleting records in the table.

## Instalation

Create all objects from
1. **AUDIT_TABLES_OBJECTS_LIST.sql**
2. **AUDIT_CLEAR.sql**
3. **CLEAR_AUDIT_TABLES_JOB.sql** - job for cleaning audit table. You can configurate your own job.\
:warning: Probably, you should add ***GRANT SCHEDULER_ADMIN TO Your_Schema***
4. **V_AUDIT_TABLES_OBJECTS_LIST.sql**\
:warning: Probably, you should add ***GRANT CREATE ANY VIEW TO Your_Schema***
5. **PKG_AUD_(SPECIFICATION)**
6. **PKG_AUD_(BODY)**

## Using

### :one: Creating Audit Objects with Default Objects Names

```
PROCEDURE CREATE_AUDIT_OBJECTS(vTABLE_NAME IN varchar2,
                               vSCHEMA     IN varchar2 DEFAULT vSCHEMA_DEFAULT,
                               tGRANTS     IN GRANTS DEFAULT NULL,
                               nINSERT     IN NUMBER DEFAULT 1,
                               nUPDATE     IN NUMBER DEFAULT 1,
                               nDELETE     IN NUMBER DEFAULT 1,
                               nTIME_TYPE  IN NUMBER DEFAULT NULL,
                               nDAYS_CNT   IN NUMBER DEFAULT NULL,
                               nMONTHS_CNT IN NUMBER DEFAULT NULL);
```

|PARAMETER|VALUES|NOTE|
|----------|------|----|
|**vTABLE_NAME**|varchar2|Table for audit|
|**vSCHEMA**|varchar2|Default schema is a schema where Package is|
|**tGRANTS**|PKG_AUDIT.GRANTS (TYPE GRANTS IS TABLE OF VARCHAR2(100))|List of schemas. Grant select will be added on **<AUDIT_TABLE>** to these schemas|
|**nINSERT**|1, 0|1 - add INSERT Audit, 0 - don't add|
|**nUPDATE**|1, 0|1 - add UPDATE Audit, 0 - don't add|
|**nDELETE**|1, 0|1 - add DELETE Audit, 0 - don't add|
|**nTIME_TYPE**|1, 2, null|1 - add Clearing **<AUDIT_TABLE>** with ***Days*** parameter, 2 - add Clearing **<AUDIT_TABLE>** with ***Month*** parameter, null - don't add Clearing for **<AUDIT_TABLE>**|
|**nDAYS_CNT**|number|if nTIME_TYPE = 1 then this parameter sets a Days count for Audit saving|
|**nMONTHS_CNT**|number|if nTIME_TYPE = 2 then this parameter sets a Months count for Audit saving|

### :two: Creating Audit Objects with Custom Objects Names

```
PROCEDURE CREATE_AUDIT_OBJECTS_CUSTOM(vTABLE_NAME     IN varchar2,
                                      vSCHEMA         IN varchar2,
                                      vAUD_TABLE      IN varchar2,
                                      vAUD_SEQ        IN varchar2,
                                      nAUD_SEQ_CACHE  IN NUMBER DEFAULT NULL,
                                      vAUD_TRG_NAME   IN varchar2,
                                      vTABLE_TRG_NAME IN varchar2,
                                      tGRANTS         IN GRANTS DEFAULT NULL,
                                      nINSERT         IN NUMBER DEFAULT 1,
                                      nUPDATE         IN NUMBER DEFAULT 1,
                                      nDELETE         IN NUMBER DEFAULT 1,
                                      nTIME_TYPE      IN NUMBER DEFAULT NULL,
                                      nDAYS_CNT       IN NUMBER DEFAULT NULL,
                                      nMONTHS_CNT     IN NUMBER DEFAULT NULL);
```

|PARAMETER|NOTE|DEFAULT|
|----------|----|----|
|**vAUD_TABLE**|Audit table name|**AUD_<vTABLE_NAME>**|
|**vAUD_SEQ**|ID sequence name for **vAUD_TABLE**|**AUD_<vTABLE_NAME>_SEQ**|
|**nAUD_SEQ_CACHE**|Caсhe for **vAUD_SEQ**|100|
|**vAUD_TRG_NAME**|Trigger name for **vAUD_TABLE**|**AUD_<vTABLE_NAME>_I**|
|**vTABLE_TRG_NAME**|Trigger name for **vTABLE_NAME**|**LOG_<vTABLE_NAME>**|

### :three: Drop Audit Objects by **AUDIT_TABLES_OBJECTS_LIST.ID**

```
PROCEDURE DROP_AUDIT_OBJECTS(nID IN NUMBER);
```

### :four: Drop Audit Objects by **AUDIT_TABLES_OBJECTS_LIST.T_SCHEMA** and **AUDIT_TABLES_OBJECTS_LIST.SOURCE_TABLE**

```
PROCEDURE DROP_AUDIT_OBJECTS(vTABLE_NAME IN varchar2,
                             vSCHEMA     IN varchar2 DEFAULT vSCHEMA_DEFAULT);
```

### :five: Add Table to clear in Job

```
PROCEDURE CREATE_AUDIT_CLEAR(P_vSCHEMA      IN VARCHAR2,
                             P_vTABLE_NAME  IN VARCHAR2,
                             P_vCOLUMN_NAME IN VARCHAR2,
                             P_nTIME_TYPE   IN NUMBER,
                             P_nDAYS_CNT    IN NUMBER,
                             P_nMONTHS_CNT  IN NUMBER,
                             P_vIS_ACTIVE   IN VARCHAR2);
```

|PARAMETER|VALUES|NOTE|
|----------|------|----|
|**P_vSCHEMA**|varchar2|Default schema is a schema where Package is|
|**P_vTABLE_NAME**|varchar2|Table for clearing|
|**P_vCOLUMN_NAME**|varchar2|Column with Date type|
|**nTIME_TYPE**|1, 2, null|1 - add Clearing **<AUDIT_TABLE>** with ***Days*** parameter, 2 - add Clearing **<AUDIT_TABLE>** with ***Month*** parameter, null - don't add Clearing for **<AUDIT_TABLE>**|
|**nDAYS_CNT**|number|if nTIME_TYPE = 1 then this parameter sets a Days count for Audit saving|
|**nMONTHS_CNT**|number|if nTIME_TYPE = 2 then this parameter sets a Month count for Audit saving|
|**P_vIS_ACTIVE**|'Y', 'N'|'Y' - active clearing, 'N' - inactive clearing|

### :six: Update Table to clear in Job

```
PROCEDURE UPDATE_AUDIT_CLEAR(P_nID          IN NUMBER,
                             P_vSCHEMA      IN VARCHAR2,
                             P_vTABLE_NAME  IN VARCHAR2,
                             P_vCOLUMN_NAME IN VARCHAR2,
                             P_nTIME_TYPE   IN NUMBER,
                             P_nDAYS_CNT    IN NUMBER,
                             P_nMONTHS_CNT  IN NUMBER,
                             P_vIS_ACTIVE   IN VARCHAR2);
```

|PARAMENTER|VALUES|NOTE|
|----------|------|----|
|**P_nID**|number|**AUDIT_CLEAR.ID**|

### :seven: Delete Table to clear in Job

```
PROCEDURE DELETE_AUDIT_CLEAR(P_nID IN NUMBER);
```

|PARAMENTER|VALUES|NOTE|
|----------|------|----|
|**P_nID**|number|**AUDIT_CLEAR.ID**|

### :eight: Clearing Job

```
PROCEDURE CLEAR_AUDIT_TABLES;
```

Procedure for **CLEAR_AUDIT_TABLES_JOB**

<table>
	<tr>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logo_mini.gif" title="logo"></td>
		<td valign="center" width="49%"><img src="https://github.com/Ruslan-Shevyrev/Ruslan-Shevyrev/blob/main/logoRS/logoRS_FULL.png" title="RuslanShevyrev"></td>
	</tr>
</table>