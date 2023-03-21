CREATE TABLE CLEAR_AUD (
	ID NUMBER(38,0) NOT NULL,
	T_SCHEMA VARCHAR2(100), 
	TABLE_NAME VARCHAR2(100) NOT NULL,
	COLUMN_NAME VARCHAR2(100) NOT NULL,
	TIME_TYPE NUMBER(38,0) NOT NULL, -- 1-Days, 2-Months
	DAYS_CNT NUMBER(38,0) NULL,
	MONTH_CNT NUMBER(38,0) NULL,
	RUN_SCRIPT VARCHAR2(4000) NOT NULL,
	IS_ACTIVE VARCHAR2(1) DEFAULT 'Y' NOT NULL, -- 'Y'-yes, 'N'-no
	IS_LAST_RUN_SUCCESS NUMBER(38,0) NULL, -- 1-Success, 2-Error
	LAST_RUN_SUCCESS_DATE DATE NULL,
	ERROR_LOG CLOB NULL,
	CONSTRAINT CLEAR_AUD_CHECK_DAYS_MONTH CHECK ("TIME_TYPE"=1 AND "DAYS_CNT" IS NOT NULL AND "MONTH_CNT" IS NULL OR "TIME_TYPE"=2 AND "DAYS_CNT" IS NULL AND "MONTH_CNT" IS NOT NULL),
	CONSTRAINT CLEAR_AUD_PK PRIMARY KEY (ID),
	CONSTRAINT CLEAR_AUD_UN UNIQUE (TABLE_NAME),
	CONSTRAINT CLEAR_AUD_NN_TABLE_NAME CHECK ("TABLE_NAME" IS NOT NULL),
	CONSTRAINT CLEAR_AUD_NN_COLUMN_NAME CHECK ("COLUMN_NAME" IS NOT NULL),
	CONSTRAINT CLEAR_AUD_NN_RUN_SCRIPT CHECK ("RUN_SCRIPT" IS NOT NULL),
	CONSTRAINT CLEAR_AUD_NN_IS_ACTIVE CHECK ("IS_ACTIVE" IS NOT NULL),
	CONSTRAINT CLEAR_AUD_NN_TIME_TYPE CHECK ("TIME_TYPE" IS NOT NULL)
);

CREATE SEQUENCE CLEAR_AUD_SEQ
	START WITH 1
	INCREMENT BY 1
	NOCACHE
	NOCYCLE;

CREATE OR REPLACE TRIGGER CLEAR_AUD_I_U
	BEFORE INSERT OR UPDATE
		ON CLEAR_AUD
	FOR EACH ROW
DECLARE
BEGIN

	IF INSERTING THEN
		:NEW.ID := CLEAR_AUD_SEQ.NEXTVAL;
	END IF;

	IF(UPDATING) THEN
		IF :NEW.ID <> :OLD.ID THEN 
			raise_application_error(-20555, 'Can`t change id');
		END IF;
	END IF;

	IF :NEW.TIME_TYPE = 1 THEN 
		:NEW.RUN_SCRIPT := 'DELETE FROM '|| :NEW.T_SCHEMA ||'.'|| :NEW.TABLE_NAME || 
									' WHERE '||:NEW.COLUMN_NAME ||' < SYSDATE - ' ||:NEW.DAYS_CNT;
	ELSIF :NEW.TIME_TYPE = 2 THEN 
		:NEW.RUN_SCRIPT := 'DELETE FROM '|| :NEW.T_SCHEMA ||'.'|| :NEW.TABLE_NAME || 
									' WHERE '||:NEW.COLUMN_NAME ||' < ADD_MONTHS(SYSDATE, - '||:NEW.MONTH_CNT||')';
	END IF;
END CLEAR_AUD_I_U;
/