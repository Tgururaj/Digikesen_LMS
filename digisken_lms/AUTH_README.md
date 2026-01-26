# DigiSken LMS - Secure 2FA Authentication System

## Overview

This is a production-ready, secure authentication system with 2-factor authentication (2FA) using Time-Based One-Time Password (TOTP).

## Features

✅ **Secure Password Hashing** - Uses bcrypt with 12 salt rounds  
✅ **2FA with TOTP** - Works with Google Authenticator, Authy, Microsoft Authenticator  
✅ **Rate Limiting** - Prevents brute force OTP attacks  
✅ **Session Management** - Secure token-based sessions  
✅ **Phone Number Username** - Easy to remember username  
✅ **Password Requirements** - Enforces strong passwords  
✅ **Clean Database Architecture** - Normalized SQLite schema  

## Setup Instructions

### 1. Install Backend Dependencies

```bash
pip install -r requirements_auth.txt
```

### 2. Start the Backend Server

```bash
python backend.py
```

The API will run on `http://localhost:5000`

### 3. Keep the Frontend Server Running

In another terminal:
```bash
cd digisken_lms
python -m http.server 8000
```

### 4. Access the Login Page

```
http://localhost:8000/login.html
```

## Architecture

### Database Schema

**users** table:
- `id` - Primary key
- `phone_number` - Unique phone number (username)
- `password_hash` - Bcrypt hashed password
- `totp_secret` - Base32 encoded TOTP secret
- `totp_enabled` - Boolean flag for 2FA status
- `created_at` - Account creation timestamp
- `last_login` - Last login timestamp

**otp_attempts** table:
- Tracks OTP verification attempts
- Implements rate limiting (max 5 attempts, 15 min lockout)
- Prevents brute force attacks

**sessions** table:
- Stores active user sessions
- Sessions expire after 7 days
- Tracks IP and user agent for additional security

### API Endpoints

#### POST `/api/register`
Register a new user
```json
{
  "phone_number": "+1234567890",
  "password": "SecurePass123!"
}
```

Returns QR code URI for TOTP setup

#### POST `/api/login`
First factor authentication (password)
```json
{
  "phone_number": "+1234567890",
  "password": "SecurePass123!"
}
```

Returns:
- If 2FA enabled: `requires_2fa: true, temp_token: "..."`
- If 2FA disabled: `session_token: "..."`

#### POST `/api/verify-otp`
Verify OTP for 2FA
```json
{
  "phone_number": "+1234567890",
  "otp": "123456"
}
```

Returns `session_token` on success

#### POST `/api/enable-2fa`
Enable 2FA after registering
```json
{
  "phone_number": "+1234567890",
  "otp": "123456"
}
```

#### POST `/api/verify-session`
Verify if a session token is valid
```json
{
  "session_token": "..."
}
```

#### POST `/api/logout`
Invalidate a session
```json
{
  "session_token": "..."
}
```

## Security Best Practices Implemented

### Password Security
- **Bcrypt hashing** with 12 salt rounds (industry standard)
- **Password validation** enforces:
  - Minimum 8 characters
  - At least one uppercase letter
  - At least one number
  - At least one special character

### 2FA Security
- **TOTP (Time-based OTP)** - 30-second validity window
- **Rate limiting** - Maximum 5 OTP attempts, 15-minute lockout
- **QR code provisioning** - Safe TOTP secret sharing

### Session Security
- **Secure tokens** - 32-byte random tokens (urlsafe base64)
- **Session expiry** - 7-day token validity
- **Single use** - One token per session
- **Database storage** - Never store plaintext passwords or secrets

### Data Protection
- **No plaintext storage** - All sensitive data hashed or encrypted
- **Rate limiting** - Prevents brute force attacks
- **Phone validation** - Basic international format check

## Usage Example

### Frontend Integration

```javascript
// Check if user is logged in
const sessionToken = localStorage.getItem('sessionToken');

if (!sessionToken) {
    // Redirect to login
    window.location.href = 'login.html';
}

// Verify session is valid
fetch('http://localhost:5000/api/verify-session', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ session_token: sessionToken })
})
.then(r => r.json())
.then(data => {
    if (data.success) {
        // User is authenticated
        console.log('User:', data.phone_number);
    } else {
        // Session invalid - redirect to login
        window.location.href = 'login.html';
    }
});
```

### Logout

```javascript
const sessionToken = localStorage.getItem('sessionToken');

fetch('http://localhost:5000/api/logout', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ session_token: sessionToken })
})
.then(() => {
    localStorage.removeItem('sessionToken');
    window.location.href = 'login.html';
});
```

## Test Accounts

After running the backend, you can register test accounts via the login page.

**Password Requirements for Testing:**
- `Test@12345` ✓ Valid
- `password123` ✗ No uppercase/special char
- `Test1234` ✗ No special character
- `Test@1` ✗ Too short

## Deployment Checklist

Before deploying to production:

- [ ] Change `debug=False` in backend.py (already done)
- [ ] Use HTTPS in production (add SSL certificate)
- [ ] Use strong secret key for session tokens
- [ ] Enable CORS properly (restrict to your domain)
- [ ] Use environment variables for sensitive data
- [ ] Set up database backups
- [ ] Implement CSRF protection
- [ ] Add rate limiting at reverse proxy level
- [ ] Monitor failed login attempts
- [ ] Implement email verification
- [ ] Add password reset functionality
- [ ] Implement account lockout after failed attempts

## File Structure

```
digisken_lms/
├── backend.py              # Flask authentication API
├── requirements_auth.txt   # Python dependencies
├── login.html             # Login/Register/2FA UI
├── index.html             # Main app (requires session)
├── digikesen.html         # Alternative main app
└── digisken_lms.db        # SQLite database (auto-created)
```

## Troubleshooting

### "Cannot POST /api/login"
- Make sure backend.py is running on port 5000
- Check CORS is enabled in Flask

### "Invalid OTP"
- Make sure time is synced on your device
- Check authenticator app shows 6-digit code
- TOTP codes expire every 30 seconds

### Database locked error
- Close all connections to the database
- Delete `digisken_lms.db` and restart backend
- Ensure only one backend process is running

### CORS errors
- Backend must be running on localhost:5000
- Frontend must be on localhost:8000
- CORS is enabled in the Flask app

## Support

For questions or issues, check the security logs in the database and Flask output.
