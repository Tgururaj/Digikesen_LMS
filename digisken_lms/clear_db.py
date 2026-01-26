import sqlite3

conn = sqlite3.connect('digisken_lms.db')
cursor = conn.cursor()

# Clear all tables
cursor.execute('DELETE FROM sessions')
cursor.execute('DELETE FROM otp_attempts')
cursor.execute('DELETE FROM users')

conn.commit()
conn.close()

print('✓ All users, OTP attempts, and sessions cleared')
print('Database is now empty - ready for fresh testing')
