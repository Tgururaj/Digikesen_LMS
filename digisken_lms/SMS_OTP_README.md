# DigiSken LMS - SMS OTP Authentication System

## Overview

This authentication backend provides a secure 2FA system using **SMS-based OTP** (One-Time Password). This approach is accessible for users in Papua New Guinea and other regions where Google Authenticator may not be available.

**Features:**
- User registration with phone number + password
- SMS-based 2FA using Twilio or debug mode
- OTP codes sent via text message (6 digits)
- Secure bcrypt password hashing (12 salt rounds)
- Session token management with 7-day expiry
- Rate limiting and account lockout protection
- SQLite database for persistent storage
- Debug mode for local testing (prints OTP to console)

## Quick Start

### 1. Install Dependencies
```bash
pip install -r requirements_auth.txt
```

### 2. Start Backend (Debug Mode - No SMS Costs)
```bash
python backend.py
```

Or on Windows:
```
START_AUTH.bat
```

The backend will start on `http://localhost:5000`

### 3. Start Frontend Server (In Another Terminal)
```bash
cd digisken_lms
python -m http.server 8000
```

### 4. Access Login Page
```
http://localhost:8000/login.html
```

### 5. Test Registration & Login

**Register:**
- Phone: +1234567890 (any format, at least 10 digits)
- Password: Password123! (requires uppercase, number, special char)

**After registering, log in:**
- You'll receive a message: "Check console for OTP code"
- Look at the backend terminal for printed OTP code
- Enter the 6-digit code to verify

## How It Works

### Registration Flow
```
User enters phone + password
        ↓
Password hashed with bcrypt (12 rounds)
        ↓
Account created with SMS 2FA enabled
        ↓
Directed to confirmation screen
        ↓
Ready to log in
```

### Login Flow
```
User enters phone + password
        ↓
Credentials verified against database
        ↓
6-digit OTP generated randomly
        ↓
OTP sent via SMS (or printed in debug mode)
        ↓
User enters OTP code from text message
        ↓
Code verified against database (10 min expiry)
        ↓
Session token created (7-day expiry)
        ↓
User logged in!
```

## API Endpoints

### 1. Register - `POST /api/register`
Create a new account with SMS 2FA enabled.
```json
{
  "phone_number": "+1234567890",
  "password": "SecurePass123!"
}
```

### 2. Login - `POST /api/login`
First factor: Verify phone + password, send SMS OTP.
```json
{
  "phone_number": "+1234567890",
  "password": "SecurePass123!"
}
```
Response includes `requires_2fa: true` and OTP is sent via SMS.

### 3. Verify OTP - `POST /api/verify-otp`
Second factor: Verify the 6-digit OTP from SMS.
```json
{
  "phone_number": "+1234567890",
  "otp": "123456"
}
```
Response includes `session_token` for accessing the app.

### 4. Resend OTP - `POST /api/resend-otp`
Resend OTP if user didn't receive it.
```json
{
  "phone_number": "+1234567890"
}
```

### 5. Verify Session - `POST /api/verify-session`
Check if session token is still valid.
```json
{
  "session_token": "token_here"
}
```

### 6. Logout - `POST /api/logout`
Invalidate session token.
```json
{
  "session_token": "token_here"
}
```

## Debug Mode (Local Testing)

**Default behavior:** Debug mode is ON by default
- OTP codes print to terminal/console
- No SMS sent (saves costs during development)
- Perfect for testing without Twilio account

When you log in, the backend terminal will show:
```
==================================================
📱 SMS OTP for +1234567890
OTP Code: 562847
Valid for 10 minutes
==================================================
```

Copy the code and paste it into the login form.

## Production Deployment (Real SMS)

### Get Twilio Account

1. Visit https://www.twilio.com/
2. Sign up for free trial account
3. Get your credentials from Twilio console:
   - Account SID
   - Auth Token
   - Phone Number (for sending SMS)

### Set Environment Variables

**Windows PowerShell:**
```powershell
$env:TWILIO_ACCOUNT_SID = "your_account_sid"
$env:TWILIO_AUTH_TOKEN = "your_auth_token"
$env:TWILIO_PHONE_NUMBER = "+1234567890"  # Your Twilio phone number
$env:DEBUG_MODE = "False"
```

**Linux/Mac:**
```bash
export TWILIO_ACCOUNT_SID="your_account_sid"
export TWILIO_AUTH_TOKEN="your_auth_token"
export TWILIO_PHONE_NUMBER="+1234567890"
export DEBUG_MODE="False"
```

### Restart Backend
```bash
python backend.py
```

Now OTP codes will be sent via real SMS instead of printing to console.

## Security Details

### Password Security
- Hashed with bcrypt using 12 salt rounds
- Never stored in plain text
- Requirements enforced:
  - Minimum 8 characters
  - At least 1 uppercase letter
  - At least 1 number
  - At least 1 special character

### SMS OTP Security
- 6-digit random codes
- Valid for 10 minutes only
- Cannot be reused
- Deleted after successful verification
- Rate limited to 5 attempts before 15-minute lockout

### Session Security
- Cryptographically random tokens (32 characters)
- 7-day expiration
- Stored in browser's localStorage
- Invalidated on logout
- Cannot be guessed or brute-forced

## Database Schema

```sql
-- Users
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phone_number TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  two_fa_enabled INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP
);

-- SMS OTP codes & rate limiting
CREATE TABLE otp_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phone_number TEXT NOT NULL,
  otp_code TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP,
  attempt_count INTEGER DEFAULT 0,
  last_attempt TIMESTAMP,
  locked_until TIMESTAMP
);

-- Session tokens
CREATE TABLE sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phone_number TEXT NOT NULL,
  session_token TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP,
  ip_address TEXT,
  user_agent TEXT
);
```

## Troubleshooting

### "OTP code not received"
- In debug mode: Check backend terminal for printed code
- In production: Verify Twilio credentials are correct
- Verify phone number includes country code (+1 for US, etc.)

### "Invalid OTP"
- Code expired? OTP valid for 10 minutes only
- Copied correctly? No spaces
- Try "Resend OTP" button to get new code

### "Rate limited - too many attempts"
- Wait 15 minutes before trying again
- Check phone number and password are correct

### "Session expired"
- Sessions valid for 7 days
- Log in again to get new session

### Twilio Not Working
1. Verify credentials in environment variables
2. Test with `pip install twilio`
3. In Twilio console, verify your phone number can receive SMS
4. Check Twilio account has credit (trial accounts have limits)

## Files Included

```
digisken_lms/
├── backend.py                # Flask API with SMS OTP
├── requirements_auth.txt     # Dependencies (includes twilio)
├── START_AUTH.bat           # Windows startup batch file
├── login.html               # Registration/Login UI
├── digikesen.html           # Main app (requires session token)
├── index.html               # Alias for digikesen.html
├── manifest.json            # PWA manifest
├── sw.js                    # Service worker
├── SMS_OTP_README.md        # This file
└── css/, js/                # Styles and scripts
```

## Common Questions

**Q: Do I need to pay for SMS?**
A: Not in debug mode (default). With Twilio, you only pay per SMS sent in production.

**Q: Will this work on mobile?**
A: Yes! The entire app is responsive and works on all devices.

**Q: What if user doesn't have text messaging?**
A: They can switch to debug mode or you can add email OTP as alternative.

**Q: How many users can the backend handle?**
A: SQLite works well for up to 100-1000 concurrent users. For larger scale, migrate to PostgreSQL.

**Q: Is data encrypted?**
A: Passwords are hashed (one-way), sessions are random tokens, data in transit uses HTTPS in production.

## Next Steps

1. Test locally with debug mode ✅
2. Get Twilio account for production SMS 📱
3. Set environment variables 🔑
4. Deploy with `DEBUG_MODE="False"` 🚀

---

**Built for accessibility in Papua New Guinea** 🇵🇬
