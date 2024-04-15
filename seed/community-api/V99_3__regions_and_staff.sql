-- The default version of community does not include all of the probation area we have in production
-- for that reason we add a number directly here to ensure we have the correct regions
-- for the CAS1/3 test users

insert into PROBATION_AREA (PROBATION_AREA_ID, CODE, DESCRIPTION, SELECTABLE, ROW_VERSION,
                            CREATED_BY_USER_ID, CREATED_DATETIME, LAST_UPDATED_USER_ID,
                            LAST_UPDATED_DATETIME, PRIVATE, ORGANISATION_ID, ADDRESS_ID, START_DATE,
                            SPG_ACTIVE_ID, ALLOCATE_DOCUMENT_LIST, QUEUE_SPG_TRANSFER_REQUEST,
                            TRANSITION_TRANSFER_MESSAGES)
values
(3000000032,'N32','North East','Y',22,1500503033,to_date('12-APR-19', 'DD-MON-RR'),1500503033,to_date('12-APR-19', 'DD-MON-RR'),0,0,1500809765,to_date('12-APR-19', 'DD-MON-RR'),2500010759,0,1,1),
(3000000056,'N56','East of England','Y',22,1500503033,to_date('12-APR-19', 'DD-MON-RR'),1500503033,to_date('12-APR-19', 'DD-MON-RR'),0,0,1500809765,to_date('12-APR-19', 'DD-MON-RR'),2500010759,0,1,1),
(3000000058,'N58','South West','Y',22,1500503033,to_date('12-APR-19', 'DD-MON-RR'),1500503033,to_date('12-APR-19', 'DD-MON-RR'),0,0,1500809765,to_date('12-APR-19', 'DD-MON-RR'),2500010759,0,1,1);

-- update users already in community api database to use expected area codes

--- we update jim snow to use a probation area id we have configured in the system (N58, South West)
UPDATE STAFF set probation_area_id = (SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N58') WHERE staff_id = '17';
--- we update bernard beaks to use a probation area id we have configured in the system (N58, South West)
UPDATE STAFF set probation_area_id = (SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N58'), FORENAME = 'bernard', SURNAME = 'beaks' WHERE staff_id = '2500057096';
--- we update PANESAR.JASPAL to use a probation area id we have configured in the system (N03, Wales)
UPDATE USER_ set DISTINGUISHED_NAME = 'PANESAR.JASPAL' where USER_ID = '2500077536';
UPDATE STAFF set probation_area_id = (SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N03'), FORENAME = 'Jaspal', SURNAME = 'Panesar' WHERE staff_id = '2500054544';

-- insert users created for local testing in approved premises api

--- APPROVEDPREMISESTESTUSER → N56, East of England
--- CAS-LOAD-TESTER → N06, Kent, Surrey & Sussex
--- TEMPORARY-ACCOMMODATION-E2E-TESTER → N06, Kent, Surrey & Sussex
--- TEMPORARY-ACCOMMODATION-E2E-REFERRER → N06, Kent, Surrey & Sussex
--- TESTER.TESTY → N02, North East

Insert into USER_ (USER_ID, STAFF_ID, SURNAME, FORENAME, NOTES, ROW_VERSION,DISTINGUISHED_NAME, PRIVATE, ORGANISATION_ID)
values
    (10000, 10000, 'E2etester', 'A.', null, 5, 'APPROVEDPREMISESTESTUSER', 0, 0),
    (10001, 10001, 'Load-Tester', 'C.', null, 5, 'CAS-LOAD-TESTER', 0, 0),
    (10002, 10002, 'Assessor', 'T.', null, 5, 'TEMPORARY-ACCOMMODATION-E2E-TESTER', 0, 0),
    (10003, 10003, 'Referrer', 'T.', null, 5, 'TEMPORARY-ACCOMMODATION-E2E-REFERRER', 0, 0),
    (10004, 10004, 'Testy', 'Tester', null, 5, 'TESTER.TESTY', 0, 0);

INSERT INTO STAFF (STAFF_ID, START_DATE, SURNAME, FORENAME, ROW_VERSION, OFFICER_CODE, CREATED_BY_USER_ID,
                   LAST_UPDATED_USER_ID, CREATED_DATETIME, LAST_UPDATED_DATETIME, PRIVATE, PROBATION_AREA_ID)
VALUES
(10000,to_date('01-JAN-18','DD-MON-RR'),'E2etester','A.',1,'AP00001',1,1,to_date('01-JAN-18','DD-MON-RR'),to_date('01-JAN-18','DD-MON-RR'),0,(SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N56')),
(10001,to_date('01-JAN-18','DD-MON-RR'),'Load-Tester','C.',1,'AP00001',1,1,to_date('01-JAN-18','DD-MON-RR'),to_date('01-JAN-18','DD-MON-RR'),0,(SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N06')),
(10002,to_date('01-JAN-18','DD-MON-RR'),'Assessor','T.',1,'AP00001',1,1,to_date('01-JAN-18','DD-MON-RR'),to_date('01-JAN-18','DD-MON-RR'),0,(SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N06')),
(10003,to_date('01-JAN-18','DD-MON-RR'),'Referrer','T.',1,'AP00001',1,1,to_date('01-JAN-18','DD-MON-RR'),to_date('01-JAN-18','DD-MON-RR'),0,(SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N06')),
(10004,to_date('01-JAN-18','DD-MON-RR'),'Testy','Tester',1,'AP00001',1,1,to_date('01-JAN-18','DD-MON-RR'),to_date('01-JAN-18','DD-MON-RR'),0,(SELECT probation_area_id FROM PROBATION_AREA WHERE CODE = 'N02'));
