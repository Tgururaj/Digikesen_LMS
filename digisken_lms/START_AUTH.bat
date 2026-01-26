@echo off
REM DigiSken LMS - Authentication System Startup Script

echo.
echo ==========================================
echo   DigiSken LMS - 2FA Authentication
echo ==========================================
echo.

REM Check if we're in the right directory
if not exist backend.py (
    echo Error: backend.py not found. Please run this script from the digisken_lms directory.
    pause
    exit /b 1
)

echo Starting the authentication backend...
echo Backend will run on: http://localhost:5000
echo.
echo In another terminal, start the frontend with:
echo   python -m http.server 8000
echo.
echo Then open: http://localhost:8000/login.html
echo.
echo Press Ctrl+C to stop the server.
echo.

python backend.py

pause
