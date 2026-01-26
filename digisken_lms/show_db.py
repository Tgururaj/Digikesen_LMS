import sqlite3

conn = sqlite3.connect('digisken_lms.db')
cursor = conn.cursor()

print('=== USERS TABLE ===')
cursor.execute('SELECT id, phone_number, two_fa_enabled, created_at, last_login FROM users')
for row in cursor.fetchall():
    print(f'ID: {row[0]}, Phone: {row[1]}, 2FA: {row[2]}, Created: {row[3]}, Last Login: {row[4]}')

print('\n=== OTP ATTEMPTS TABLE (Last 5) ===')
cursor.execute('SELECT id, phone_number, otp_code, expires_at, attempt_count FROM otp_attempts ORDER BY created_at DESC LIMIT 5')
for row in cursor.fetchall():
    print(f'ID: {row[0]}, Phone: {row[1]}, OTP: {row[2]}, Expires: {row[3]}, Attempts: {row[4]}')

print('\n=== SESSIONS TABLE (Last 5) ===')
cursor.execute('SELECT id, phone_number, expires_at FROM sessions ORDER BY created_at DESC LIMIT 5')
for row in cursor.fetchall():
    print(f'ID: {row[0]}, Phone: {row[1]}, Expires: {row[2]}')

conn.close()
print('\n✓ Database file location: digisken_lms.db')
