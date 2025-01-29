-- create CAS_2_ASSESSOR_USER
 INSERT INTO users (user_id, username, password, email, first_name, last_name, verified, locked, enabled, master, create_datetime, password_expiry, last_logged_in, source, mfa_preference)
 VALUES ('98cf4cf3-ec67-4ffe-a740-daee48676dc6', 'CAS2_ASSESSOR_USER', '{bcrypt}$2a$10$Fmcp2KUKRW53US3EJfsxkOh.ekZhqz5.Baheb9E98QLwEFLb9csxy', 'cas2.assessor@nacro.org.uk', 'CAS2', 'Assessor (NACRO)', true, false, true, false, '2023-10-15 11:48:34.2723638', '2040-04-26 16:17:28.4953990', '2040-03-05 11:48:34.2723638', 'auth', 'EMAIL');

-- assign to Assessors group
INSERT INTO user_group (group_id, user_id) SELECT group_id, user_id from groups, users where username = 'CAS2_ASSESSOR_USER' and group_code = 'CAS2_ASSESSORS';

-- assign CAS2 Assessor role
--   This will appear as the ROLE_CAS2_ASSESSOR authority in the JWT
--   and can be referenced with either hasRole("CAS2_ASSESSOR") or
--   hasAuthority("ROLE_CAS2_ASSESSOR") in Spring Security filters
INSERT INTO user_role (role_id, user_id) SELECT role_id, user_id FROM roles, users WHERE username = 'CAS2_ASSESSOR_USER' AND role_code = 'CAS2_ASSESSOR';


-- create CAS_2_ADMIN_USER
 INSERT INTO users (user_id, username, password, email, first_name, last_name, verified, locked, enabled, master, create_datetime, password_expiry, last_logged_in, source, mfa_preference)
 VALUES ('98cf4cf3-ec67-4ffe-a740-daee48676dd5', 'CAS2_ADMIN_USER', '{bcrypt}$2a$10$Fmcp2KUKRW53US3EJfsxkOh.ekZhqz5.Baheb9E98QLwEFLb9csxy', 'cas2Admin@example.com', 'CAS2', 'Admin', true, false, true, false, '2023-10-15 11:48:34.2723638', '2040-04-26 16:17:28.4953990', '2040-03-05 11:48:34.2723638', 'nomis', 'EMAIL');
