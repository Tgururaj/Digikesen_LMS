# SMS OTP Authentication - Testing Checklist

## Pre-Testing Verification

- [ ] Python 3.8+ installed
- [ ] All dependencies installed: `pip install -r requirements_auth.txt`
- [ ] Twilio package available: `pip list | grep twilio`
- [ ] Files present:
  - [ ] backend.py
  - [ ] login.html
  - [ ] requirements_auth.txt
  - [ ] START_AUTH.bat (Windows)

## Local Testing (Debug Mode)

### Backend Start
- [ ] Navigate to digisken_lms folder
- [ ] Run `python backend.py` (or `START_AUTH.bat` on Windows)
- [ ] See message: "Running on http://localhost:5000"
- [ ] See message: "Database initialized"
- [ ] Backend is listening on port 5000

### Frontend Start
- [ ] Open new terminal in digisken_lms folder
- [ ] Run `python -m http.server 8000`
- [ ] See message: "Serving HTTP on 0.0.0.0 port 8000"
- [ ] Frontend is listening on port 8000

### Browser Setup
- [ ] Open browser to `http://localhost:8000/login.html`
- [ ] See login page with three tabs: Login, Register, and password requirements
- [ ] Page is responsive and centered

## Registration Test

### Test Case 1: Valid Registration
- [ ] Click "Register" tab
- [ ] Enter Phone: `+1234567890`
- [ ] Enter Password: `Password123!`
- [ ] Verify password meets all requirements:
  - [ ] ✓ At least 8 characters
  - [ ] ✓ Contains uppercase letter
  - [ ] ✓ Contains number
  - [ ] ✓ Contains special character
- [ ] Click "Register" button
- [ ] See success message: "Registration successful!"
- [ ] See new screen: "Setup Complete - 2FA Enabled"
- [ ] Message explains: "SMS will be sent during login"
- [ ] Click "Got it, take me to login" button
- [ ] Redirected back to Login tab

### Test Case 2: Weak Password (Password123)
- [ ] Try registering with `Password123` (no special char)
- [ ] See error: "Password must contain special character"
- [ ] Form should not submit

### Test Case 3: Duplicate Phone
- [ ] Register with `+1234567890` first time (success)
- [ ] Try registering with same phone again
- [ ] See error: "Phone number already registered"

### Test Case 4: Invalid Phone
- [ ] Try registering with `123` (less than 10 digits)
- [ ] See error: "Invalid phone number format"

## Login Test

### Test Case 1: Successful Login Flow
- [ ] Go to Login tab
- [ ] Enter Phone: `+1234567890`
- [ ] Enter Password: `Password123!`
- [ ] Click "Login" button
- [ ] **Check backend terminal** - you should see:
  ```
  ==================================================
  📱 SMS OTP for +1234567890
  OTP Code: 562847
  Valid for 10 minutes
  ==================================================
  ```
- [ ] Front-end shows: "OTP sent to your phone. Valid for 10 minutes."
- [ ] Six digit input fields appear
- [ ] Focus is on first digit field

### Test Case 2: OTP Entry (Using Code from Terminal)
- [ ] Copy OTP code from backend terminal (e.g., 562847)
- [ ] In first digit field, paste the code
- [ ] All 6 digits should auto-fill
- [ ] Click "Verify OTP" button
- [ ] See success message: "✓ Verified! Redirecting..."
- [ ] After 1.5 seconds, redirected to `index.html`
- [ ] Session token stored in browser localStorage

### Test Case 3: Correct OTP Input (Manual)
- [ ] Log in again with same credentials
- [ ] Backend prints new OTP (e.g., 847352)
- [ ] Click first OTP digit field
- [ ] Type first digit `8`
- [ ] Focus moves to second field
- [ ] Continue typing all 6 digits: `847352`
- [ ] Last digit auto-focuses away
- [ ] Click "Verify OTP" button
- [ ] Successful login

### Test Case 4: Invalid OTP
- [ ] Log in again
- [ ] Backend prints OTP (e.g., 562847)
- [ ] Enter wrong code (e.g., 000000)
- [ ] Click "Verify OTP" button
- [ ] See error: "Invalid OTP"
- [ ] OTP fields cleared
- [ ] Still on OTP verification page

### Test Case 5: Expired OTP
- [ ] Log in with credentials
- [ ] Backend prints OTP
- [ ] Wait 10+ minutes (OTP expires after 10 minutes)
- [ ] Enter the old OTP code
- [ ] Click "Verify OTP" button
- [ ] See error message about invalid OTP

### Test Case 6: Wrong Password
- [ ] Enter Phone: `+1234567890`
- [ ] Enter wrong Password: `WrongPassword123!`
- [ ] Click "Login" button
- [ ] See error: "Invalid credentials"
- [ ] No OTP is sent

### Test Case 7: Resend OTP
- [ ] Log in with correct credentials
- [ ] Backend prints OTP (e.g., 562847)
- [ ] Click "Resend OTP" button
- [ ] Backend prints new OTP (different code, e.g., 847352)
- [ ] Enter new OTP code
- [ ] Verify successfully logs in

## Rate Limiting Test

### Test Case: 5 Failed Attempts Lock Account
- [ ] Log in with correct credentials
- [ ] Backend prints OTP
- [ ] Enter wrong OTP code 5 times:
  - [ ] Attempt 1: Wrong code → Error message
  - [ ] Attempt 2: Wrong code → Error message
  - [ ] Attempt 3: Wrong code → Error message
  - [ ] Attempt 4: Wrong code → Error message
  - [ ] Attempt 5: Wrong code → Error message
- [ ] See error: "Too many attempts. Account locked for 15 minutes."
- [ ] Cannot attempt again until 15 minutes have passed
- [ ] After clicking "Resend OTP", lockout resets

## Session Management Test

### Test Case 1: Session Persistence
- [ ] Successfully log in
- [ ] See in browser console: `sessionToken: "abc123def456..."`
- [ ] Refresh page
- [ ] Should stay logged in (no redirect to login.html)

### Test Case 2: Session Expiry (Optional - Takes 7 Days)
- [ ] Session token is valid for 7 days
- [ ] After 7 days of no activity, session expires
- [ ] User must log in again

### Test Case 3: Logout
- [ ] After successful login, find logout functionality
- [ ] Click logout button (if available)
- [ ] Session token removed from localStorage
- [ ] User redirected to login.html

## Mobile Responsive Test

- [ ] Open `http://localhost:8000/login.html` on mobile device
- [ ] Page is fully responsive
- [ ] Login form is usable on small screens
- [ ] OTP digit inputs are large enough to tap
- [ ] No horizontal scrolling required

## Backend Verification

### Test Case: API Endpoints Direct Call (Using curl or Postman)

**Register Endpoint:**
```bash
curl -X POST http://localhost:5000/api/register \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","password":"Password123!"}'
```
Expected response: `{"success":true,"message":"Registration successful!"}`

**Login Endpoint:**
```bash
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","password":"Password123!"}'
```
Expected response: `{"success":true,"requires_2fa":true,"message":"OTP sent to your phone"}`

**Verify OTP Endpoint:**
```bash
curl -X POST http://localhost:5000/api/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","otp":"123456"}'
```
Expected response: `{"success":true,"session_token":"..."}`

## Database Verification

### Check Created Tables
- [ ] Database file created: `digisken_lms.db` (in backend folder)
- [ ] Tables created:
  - [ ] users table
  - [ ] otp_attempts table
  - [ ] sessions table

### Verify Data Storage
- [ ] After registration, user can query:
  - [ ] Phone number stored
  - [ ] Password hash stored (not plain text)
  - [ ] 2FA enabled flag set to 1
- [ ] After login attempt:
  - [ ] OTP code stored in otp_attempts table
  - [ ] OTP expires_at timestamp set to 10 minutes in future
- [ ] After successful OTP verification:
  - [ ] Session token created in sessions table
  - [ ] OTP code deleted from otp_attempts
  - [ ] Session expires_at set to 7 days in future

## Production Setup Test (Optional)

### Prerequisites
- [ ] Twilio account created
- [ ] Account SID, Auth Token, Phone Number obtained
- [ ] Twilio phone number verified for sending SMS

### Environment Setup
- [ ] Environment variables set:
  - [ ] TWILIO_ACCOUNT_SID
  - [ ] TWILIO_AUTH_TOKEN
  - [ ] TWILIO_PHONE_NUMBER
  - [ ] DEBUG_MODE = "False"

### Production Test
- [ ] Start backend with production config
- [ ] Register and log in
- [ ] Check phone for real SMS with OTP code
- [ ] SMS format correct: "Your DigiSken LMS login code is: 123456"
- [ ] OTP code works and logs in successfully

## Security Test

### Test Case: Password Storage Security
- [ ] Check database: `SELECT password_hash FROM users WHERE phone_number='+1234567890'`
- [ ] Password hash should NOT be plain text
- [ ] Should be bcrypt hash (60 characters, starts with $2b$)

### Test Case: OTP Security
- [ ] OTP codes are random
- [ ] Each code is different
- [ ] Old used codes cannot be reused
- [ ] Codes expire after 10 minutes

### Test Case: Session Security
- [ ] Session tokens are random and unique
- [ ] Session tokens are long (32+ characters)
- [ ] Cannot guess or brute-force sessions

## Documentation Verification

- [ ] SMS_OTP_README.md exists and is readable
- [ ] SETUP_GUIDE.txt has quick start instructions
- [ ] All API endpoints documented
- [ ] Security practices documented
- [ ] Troubleshooting section covers common issues

## Sign-Off

- [ ] All tests passed locally (debug mode)
- [ ] All tests passed with Twilio (production mode) - *optional*
- [ ] No errors in browser console
- [ ] No errors in backend terminal
- [ ] User can register, log in, and verify OTP successfully
- [ ] System is ready for deployment

**Date Tested:** _______________  
**Tested By:** _______________  
**Notes:** 
