-- create CAS2 Assessors group
INSERT INTO groups (group_id, group_code, group_name, create_datetime)
VALUES ('a274e977-4ff8-43cf-9334-5b4703c1aff6', 'CAS2_ASSESSORS', 'CAS2 ASSESSORS', '2023-10-15 21:35:52.043333');

-- create CAS2 Assessor role
--   This will appear as the ROLE_CAS2_ASSESSOR authority in the JWT
--   and can be referenced with either hasRole("CAS2_ASSESSOR") or
--   hasAuthority("ROLE_CAS2_ASSESSOR") in Spring Security filters
INSERT INTO roles (role_id, role_code, role_name, create_datetime, role_description, admin_type)
VALUES ('f62b8a99-00c7-4250-8279-3eb80129eb19', 'CAS2_ASSESSOR', 'CAS2 Assessor', '2023-10-15 21:35:51.130000', null, 'EXT_ADM');

