-- create CAS2_COURT_BAIL_REFERRER group for delius users
INSERT INTO groups (group_id, group_code, group_name, create_datetime)
VALUES ('a274e977-4ff8-43cf-9334-5b4703c1aff7', 'CAS2_COURT_BAIL_REFERRER', 'CAS2 COURT BAIL REFERRER', '2023-10-15 21:35:52.043333');

-- create CAS2 Court Bail role
--   This will appear as the ROLE_CAS2_COURT_BAIL_REFERRER authority in the JWT
--   and can be referenced with either hasRole("CAS2_COURT_BAIL") or
--   hasAuthority("ROLE_CAS2_COURT_BAIL") in Spring Security filters
INSERT INTO roles (role_id, role_code, role_name, create_datetime, role_description, admin_type)
VALUES ('f62b8a99-00c7-4250-8279-3eb80129eb18', 'CAS2_COURT_BAIL_REFERRER_REFERRER', 'CAS2 COURT BAIL REFERRER', '2023-10-15 21:35:51.130000', null, 'EXT_ADM');

-- create CAS2_PRISON_BAIL_REFERRER group for delius users
INSERT INTO groups (group_id, group_code, group_name, create_datetime)
VALUES ('a274e977-4ff8-43cf-9334-5b4703c1afa7', 'CAS2_PRISON_BAIL_REFERRER', 'CAS2 PRISON_BAIL REFERRER', '2023-10-15 21:35:52.043333');

-- create CAS2 Court Bail role
--   This will appear as the ROLE_CAS2_COURT_BAIL authority in the JWT
--   and can be referenced with either hasRole("CAS2_COURT_BAIL_REFERRER") or
--   hasAuthority("ROLE_CAS2_COURT_BAIL_REFERRER") in Spring Security filters
INSERT INTO roles (role_id, role_code, role_name, create_datetime, role_description, admin_type)
VALUES ('f62b8a99-00c7-4250-8279-3eb80129eb68', 'CAS2_PRISON_BAIL_REFERRER', 'CAS2 PRISON BAIL REFERRER', '2023-10-15 21:35:51.130000', null, 'EXT_ADM');

