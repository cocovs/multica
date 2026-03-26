-- name: CreateVerificationCode :one
INSERT INTO verification_code (email, code, expires_at)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetLatestVerificationCode :one
SELECT * FROM verification_code
WHERE email = $1
  AND used = FALSE
  AND expires_at > now()
ORDER BY created_at DESC
LIMIT 1;

-- name: MarkVerificationCodeUsed :exec
UPDATE verification_code
SET used = TRUE
WHERE id = $1;

-- name: GetLatestCodeByEmail :one
SELECT * FROM verification_code
WHERE email = $1
ORDER BY created_at DESC
LIMIT 1;
