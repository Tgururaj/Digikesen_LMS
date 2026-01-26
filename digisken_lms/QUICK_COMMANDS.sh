#!/bin/bash
# Quick Reference - SMS OTP Authentication System

# ============================================
# INSTALLATION
# ============================================

# Install Python dependencies
pip install -r requirements_auth.txt

# Verify Twilio installed
pip list | grep twilio

# ============================================
# RUNNING THE SYSTEM (Local Testing)
# ============================================

# Terminal 1: Start Backend (Debug Mode - prints OTP to console)
python backend.py

# Terminal 2: Start Frontend Server
python -m http.server 8000

# Then open browser:
# http://localhost:8000/login.html

# ============================================
# PRODUCTION SETUP (Real SMS via Twilio)
# ============================================

# Get Twilio Account
# Visit: https://www.twilio.com/
# Get: Account SID, Auth Token, Phone Number

# Set Environment Variables (Windows PowerShell)
$env:TWILIO_ACCOUNT_SID = "your_account_sid"
$env:TWILIO_AUTH_TOKEN = "your_auth_token"
$env:TWILIO_PHONE_NUMBER = "+1234567890"
$env:DEBUG_MODE = "False"

# Set Environment Variables (Linux/Mac)
export TWILIO_ACCOUNT_SID="your_account_sid"
export TWILIO_AUTH_TOKEN="your_auth_token"
export TWILIO_PHONE_NUMBER="+1234567890"
export DEBUG_MODE="False"

# Restart backend for production
python backend.py

# ============================================
# API TESTING (using curl)
# ============================================

# Register New User
curl -X POST http://localhost:5000/api/register \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","password":"Password123!"}'

# Login (sends SMS OTP)
curl -X POST http://localhost:5000/api/login \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","password":"Password123!"}'

# Verify OTP (replace 123456 with actual code)
curl -X POST http://localhost:5000/api/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890","otp":"123456"}'

# Resend OTP
curl -X POST http://localhost:5000/api/resend-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+1234567890"}'

# Verify Session Token
curl -X POST http://localhost:5000/api/verify-session \
  -H "Content-Type: application/json" \
  -d '{"session_token":"your_session_token_here"}'

# Logout (invalidate session)
curl -X POST http://localhost:5000/api/logout \
  -H "Content-Type: application/json" \
  -d '{"session_token":"your_session_token_here"}'

# Health Check
curl http://localhost:5000/api/health

# ============================================
# DATABASE OPERATIONS (SQLite)
# ============================================

# Connect to database
sqlite3 digisken_lms.db

# View all users
SELECT phone_number, created_at, last_login FROM users;

# View OTP attempts
SELECT phone_number, created_at, expires_at, attempt_count FROM otp_attempts;

# View active sessions
SELECT phone_number, created_at, expires_at FROM sessions;

# Delete all test data
DELETE FROM users;
DELETE FROM otp_attempts;
DELETE FROM sessions;

# ============================================
# TROUBLESHOOTING COMMANDS
# ============================================

# Check if Python is installed
python --version

# Check if Flask installed
python -c "import flask; print(flask.__version__)"

# Check if all dependencies installed
pip list | grep -E "Flask|bcrypt|Twilio"

# Check if port 5000 is in use
netstat -an | find "5000"  # Windows
lsof -i :5000              # Linux/Mac

# Check if port 8000 is in use
netstat -an | find "8000"  # Windows
lsof -i :8000              # Linux/Mac

# View backend logs in real-time
tail -f debug.log

# Kill backend if it won't stop
killall python              # Linux/Mac
taskkill /F /IM python.exe  # Windows

# ============================================
# PASSWORD TEST CASES
# ============================================

# Valid Password (meets all requirements)
# Password123!
# - At least 8 chars
# - Has uppercase P
# - Has number 1, 2, 3
# - Has special char !

# Invalid - no uppercase
# password123!

# Invalid - no number
# PasswordABC!

# Invalid - no special char
# Password123

# Invalid - too short
# Pass1!

# ============================================
# PHONE NUMBER TEST CASES
# ============================================

# Valid Format (10+ digits)
# +1234567890
# +61412345678
# +675712345678

# Invalid Format (< 10 digits)
# 123456

# ============================================
# OTP TEST CASES
# ============================================

# Debug Mode: Look for this in terminal
# ==================================================
# 📱 SMS OTP for +1234567890
# OTP Code: 562847
# Valid for 10 minutes
# ==================================================

# Valid OTP: Copy code from terminal and enter
# Invalid OTP: Enter wrong code (e.g., 000000)
# Expired OTP: Wait 10+ minutes before entering

# ============================================
# COMMON DEBUG STEPS
# ============================================

# 1. Clear browser cache
# Ctrl+Shift+Delete (Windows/Linux)
# Cmd+Shift+Delete (Mac)

# 2. Check browser console for errors
# F12 -> Console tab

# 3. Check backend terminal for error messages
# Look for: Exception, Error, Traceback

# 4. Test backend is running
# curl http://localhost:5000/api/health

# 5. Test frontend is running
# curl http://localhost:8000/login.html

# 6. Reset database (delete test data)
# rm digisken_lms.db
# Restart backend to recreate

# ============================================
# FILES OVERVIEW
# ============================================

# backend.py               - Main Flask API with SMS OTP
# login.html              - Registration/Login interface
# requirements_auth.txt   - Python dependencies
# SMS_OTP_README.md       - Full documentation
# SETUP_GUIDE.txt         - Quick setup reference
# IMPLEMENTATION_SUMMARY  - Complete overview
# TESTING_CHECKLIST.md    - All test cases
# digikesen_lms.db        - SQLite database (auto-created)

# ============================================
# QUICK START RECAP
# ============================================

# Step 1: Install
pip install -r requirements_auth.txt

# Step 2: Start Backend
python backend.py

# Step 3: Start Frontend (new terminal)
python -m http.server 8000

# Step 4: Open
# http://localhost:8000/login.html

# Step 5: Test
# - Register: phone +1234567890, password Password123!
# - Login: same phone/password
# - Check backend terminal for OTP
# - Enter OTP code
# - Success!

# ============================================
# FOR MORE HELP
# ============================================

# See: SMS_OTP_README.md (full documentation)
# See: SETUP_GUIDE.txt (quick reference)
# See: TESTING_CHECKLIST.md (test cases)
# See: IMPLEMENTATION_SUMMARY.md (complete overview)
