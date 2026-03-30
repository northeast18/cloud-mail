-- Preview orphan users: user exists, account missing
SELECT u.user_id, u.email, u.is_del
FROM user u
LEFT JOIN account a ON lower(u.email) = lower(a.email)
WHERE a.account_id IS NULL
ORDER BY u.user_id;

-- Backfill missing primary account rows for orphan users
INSERT INTO account (email, name, user_id, is_del)
SELECT u.email,
       substr(u.email, 1, instr(u.email, '@') - 1) AS name,
       u.user_id,
       u.is_del
FROM user u
LEFT JOIN account a ON lower(u.email) = lower(a.email)
WHERE a.account_id IS NULL;

-- Verify the repair result
SELECT u.user_id, u.email, u.is_del
FROM user u
LEFT JOIN account a ON lower(u.email) = lower(a.email)
WHERE a.account_id IS NULL
ORDER BY u.user_id;
