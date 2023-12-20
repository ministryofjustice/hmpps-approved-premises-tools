
-- SET UP CAS2_MI_USER
--  this is all copied from HMPPS-Auth, see:
--  https://github.com/ministryofjustice/hmpps-auth/blob/main/src/main/resources/db/dev/data/auth/V900_3__users.sql

CREATE USER IF NOT EXISTS CAS2_MI_USER password 'password123456';

INSERT INTO STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME, STATUS) VALUES (2929, 'CAS2', 'MI User', 'ACTIVE');

INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id, working_caseload_id, id_source)
VALUES ('CAS2_MI_USER', 'GENERAL', 2929, 'BAI', 'USER');

INSERT INTO DBA_USERS (username, account_status, profile)
VALUES ('CAS2_MI_USER', 'OPEN', 'TAG_GENERAL');

INSERT INTO SYS.USER$ (name, spare4)
VALUES ('CAS2_MI_USER', 'S:C59371608F601E454682E0B5293F2752A1DC31C4BDEF9D50802212AD981E');

INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'CAS2_MI_USER', now());

insert into OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_TYPE, ROLE_FUNCTION, ROLE_SEQ, PARENT_ROLE_CODE, SYSTEM_DATA_FLAG) values (ROLE_ID.nextval, 'CAS2_MI', 'CAS2 MI', 'APP', 'ADMIN', 1, null, 'Y');

-- assign MI role to CAS2_MI_USER
-- This will appear as the ROLE_CAS2_MI authority in the JWT
--   and can be referenced with either hasRole("CAS2_MI") or
--   hasAuthority("ROLE_CAS2_MI") in Spring Security filters
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES ((SELECT ROLE_ID FROM OMS_ROLES WHERE ROLE_CODE = 'CAS2_MI'), 'NWEB', 'CAS2_MI_USER');


-- SET UP CAS2_ADMIN_USER
--  this is all copied from HMPPS-Auth, see:
--  https://github.com/ministryofjustice/hmpps-auth/blob/main/src/main/resources/db/dev/data/auth/V900_3__users.sql

CREATE USER IF NOT EXISTS CAS2_ADMIN_USER password 'password123456';

INSERT INTO STAFF_MEMBERS (STAFF_ID, FIRST_NAME, LAST_NAME, STATUS) VALUES (2930, 'CAS2', 'Admin User', 'ACTIVE');

INSERT INTO STAFF_USER_ACCOUNTS (username, staff_user_type, staff_id, working_caseload_id, id_source)
VALUES ('CAS2_ADMIN_USER', 'GENERAL', 2930, 'BAI', 'USER');

INSERT INTO DBA_USERS (username, account_status, profile)
VALUES ('CAS2_ADMIN_USER', 'OPEN', 'TAG_GENERAL');

INSERT INTO SYS.USER$ (name, spare4)
VALUES ('CAS2_ADMIN_USER', 'S:C59371608F601E454682E0B5293F2752A1DC31C4BDEF9D50802212AD981E');

INSERT INTO USER_ACCESSIBLE_CASELOADS (CASELOAD_ID, USERNAME, START_DATE) VALUES ('NWEB', 'CAS2_ADMIN_USER', now());

insert into OMS_ROLES (ROLE_ID, ROLE_CODE, ROLE_NAME, ROLE_TYPE, ROLE_FUNCTION, ROLE_SEQ, PARENT_ROLE_CODE, SYSTEM_DATA_FLAG) values (ROLE_ID.nextval, 'CAS2_ADMIN', 'CAS2 ADMIN', 'APP', 'ADMIN', 1, null, 'Y');

-- assign CAS2_ADMIN role to CAS2_ADMIN_USER
-- This will appear as the ROLE_CAS2_ADMIN authority in the JWT
--   and can be referenced with either hasRole("CAS2_ADMIN") or
--   hasAuthority("ROLE_CAS2_ADMIN") in Spring Security filters
INSERT INTO USER_CASELOAD_ROLES (ROLE_ID, CASELOAD_ID, USERNAME) VALUES ((SELECT ROLE_ID FROM OMS_ROLES WHERE ROLE_CODE = 'CAS2_ADMIN'), 'NWEB', 'CAS2_ADMIN_USER');
