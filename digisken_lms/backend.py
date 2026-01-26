"""
DigiSken LMS - Secure Authentication Backend
Uses bcrypt for password hashing and SMS OTP for 2FA
Supports Twilio SMS or local development mode
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import bcrypt
from datetime import datetime, timedelta
import secrets
import json
import os
import random
import string

# Optional: Twilio for SMS
try:
    from twilio.rest import Client
    TWILIO_AVAILABLE = True
except ImportError:
    TWILIO_AVAILABLE = False

app = Flask(__name__)
CORS(app)

DATABASE = 'digisken_lms.db'

# ============ SMS Configuration ============
# For production, use Twilio
TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID', 'your_account_sid')
TWILIO_AUTH_TOKEN = os.environ.get('TWILIO_AUTH_TOKEN', 'your_auth_token')
TWILIO_PHONE_NUMBER = os.environ.get('TWILIO_PHONE_NUMBER', '+1234567890')

# Set to False in production
DEBUG_MODE = os.environ.get('DEBUG_MODE', 'True').lower() == 'true'

def send_sms(phone_number, otp_code):
    """Send SMS with OTP code. Uses Twilio or debug mode."""
    if DEBUG_MODE:
        # In debug mode, print OTP to console
        print(f"\n{'='*50}")
        print(f"📱 SMS OTP for {phone_number}")
        print(f"OTP Code: {otp_code}")
        print(f"Valid for 10 minutes")
        print(f"{'='*50}\n")
        return True
    
    if not TWILIO_AVAILABLE:
        print(f"Warning: Twilio not installed. Install with: pip install twilio")
        print(f"SMS Code for {phone_number}: {otp_code}")
        return False
    
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        message = client.messages.create(
            body=f"Your DigiSken LMS login code is: {otp_code}\n\nValid for 10 minutes.",
            from_=TWILIO_PHONE_NUMBER,
            to=phone_number
        )
        print(f"SMS sent to {phone_number} (SID: {message.sid})")
        return True
    except Exception as e:
        print(f"Error sending SMS: {e}")
        return False

# ============ Database Setup ============

def init_db():
    """Initialize database with proper schema"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    
    # Users table with secure password storage
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phone_number TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            two_fa_enabled INTEGER DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_login TIMESTAMP
        )
    ''')
    
    # OTP verification attempts (rate limiting)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS otp_attempts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phone_number TEXT NOT NULL,
            otp_code TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            expires_at TIMESTAMP,
            attempt_count INTEGER DEFAULT 0,
            last_attempt TIMESTAMP,
            locked_until TIMESTAMP
        )
    ''')
    
    # Sessions table for tracking active sessions
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            phone_number TEXT NOT NULL,
            session_token TEXT UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            expires_at TIMESTAMP,
            ip_address TEXT,
            user_agent TEXT
        )
    ''')
    
    conn.commit()
    conn.close()

def get_db():
    """Get database connection"""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

# ============ Utility Functions ============

def hash_password(password):
    """Hash password using bcrypt with salt rounds"""
    salt = bcrypt.gensalt(rounds=12)
    return bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8')

def verify_password(password, password_hash):
    """Verify password against hash"""
    return bcrypt.checkpw(password.encode('utf-8'), password_hash.encode('utf-8'))

def validate_phone_number(phone_number):
    """Validate phone number format (basic validation)"""
    # Remove common formatting characters
    cleaned = ''.join(c for c in phone_number if c.isdigit())
    # Check if it's 10-15 digits (international standard)
    return len(cleaned) >= 10 and len(cleaned) <= 15

def validate_password(password):
    """Validate password strength"""
    if len(password) < 8:
        return False, "Password must be at least 8 characters"
    if not any(c.isupper() for c in password):
        return False, "Password must contain uppercase letter"
    if not any(c.isdigit() for c in password):
        return False, "Password must contain number"
    if not any(c in "!@#$%^&*()_+-=[]{}|;:,.<>?" for c in password):
        return False, "Password must contain special character"
    return True, "Password valid"

def generate_session_token():
    """Generate secure session token"""
    return secrets.token_urlsafe(32)

def check_rate_limit(phone_number):
    """Check if user is rate limited for OTP attempts"""
    conn = get_db()
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT attempt_count, locked_until FROM otp_attempts 
        WHERE phone_number = ?
    ''', (phone_number,))
    
    result = cursor.fetchone()
    conn.close()
    
    if result:
        locked_until = result['locked_until']
        if locked_until and datetime.fromisoformat(locked_until) > datetime.now():
            return False, "Too many attempts. Try again later."
        if result['attempt_count'] >= 5:
            # Lock account for 15 minutes
            conn = get_db()
            cursor = conn.cursor()
            locked_until = (datetime.now() + timedelta(minutes=15)).isoformat()
            cursor.execute('''
                UPDATE otp_attempts SET locked_until = ? WHERE phone_number = ?
            ''', (locked_until, phone_number))
            conn.commit()
            conn.close()
            return False, "Too many attempts. Account locked for 15 minutes."
    
    return True, "OK"

def increment_otp_attempts(phone_number):
    """Increment OTP attempt counter"""
    conn = get_db()
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT id FROM otp_attempts WHERE phone_number = ?
    ''', (phone_number,))
    
    if cursor.fetchone():
        cursor.execute('''
            UPDATE otp_attempts SET attempt_count = attempt_count + 1, 
            last_attempt = CURRENT_TIMESTAMP WHERE phone_number = ?
        ''', (phone_number,))
    else:
        cursor.execute('''
            INSERT INTO otp_attempts (phone_number, attempt_count, last_attempt)
            VALUES (?, 1, CURRENT_TIMESTAMP)
        ''', (phone_number,))
    
    conn.commit()
    conn.close()

def reset_otp_attempts(phone_number):
    """Reset OTP attempts after successful verification"""
    conn = get_db()
    cursor = conn.cursor()
    cursor.execute('''
        DELETE FROM otp_attempts WHERE phone_number = ?
    ''', (phone_number,))
    conn.commit()
    conn.close()

# ============ API Endpoints ============

@app.route('/api/register', methods=['POST'])
def register():
    """Register new user"""
    try:
        data = request.json
        phone_number = data.get('phone_number', '').strip()
        password = data.get('password', '')
        
        # Validation
        if not phone_number or not password:
            return jsonify({'success': False, 'error': 'Phone and password required'}), 400
        
        if not validate_phone_number(phone_number):
            return jsonify({'success': False, 'error': 'Invalid phone number format'}), 400
        
        valid, msg = validate_password(password)
        if not valid:
            return jsonify({'success': False, 'error': msg}), 400
        
        # Check if user exists
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('SELECT id FROM users WHERE phone_number = ?', (phone_number,))
        
        if cursor.fetchone():
            conn.close()
            return jsonify({'success': False, 'error': 'Phone number already registered'}), 400
        
        # Create user
        password_hash = hash_password(password)
        
        cursor.execute('''
            INSERT INTO users (phone_number, password_hash, two_fa_enabled)
            VALUES (?, ?, 1)
        ''', (phone_number, password_hash, ))
        
        conn.commit()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Registration successful! 2FA is enabled by default.',
            'phone_number': phone_number
        }), 201
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/login', methods=['POST'])
def login():
    """First factor authentication - verify phone and password, send OTP via SMS"""
    try:
        data = request.json
        phone_number = data.get('phone_number', '').strip()
        password = data.get('password', '')
        
        if not phone_number or not password:
            return jsonify({'success': False, 'error': 'Phone and password required'}), 400
        
        # Get user
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('''
            SELECT id, password_hash, two_fa_enabled FROM users WHERE phone_number = ?
        ''', (phone_number,))
        
        user = cursor.fetchone()
        
        if not user or not verify_password(password, user['password_hash']):
            conn.close()
            return jsonify({'success': False, 'error': 'Invalid credentials'}), 401
        
        # Check if 2FA is enabled
        if user['two_fa_enabled']:
            # Generate 6-digit OTP code
            otp_code = ''.join(random.choices(string.digits, k=6))
            expires_at = (datetime.now() + timedelta(minutes=10)).isoformat()
            
            # Store OTP in database
            cursor.execute('''
                DELETE FROM otp_attempts WHERE phone_number = ? AND expires_at < CURRENT_TIMESTAMP
            ''', (phone_number,))
            
            cursor.execute('''
                INSERT INTO otp_attempts (phone_number, otp_code, expires_at)
                VALUES (?, ?, ?)
            ''', (phone_number, otp_code, expires_at))
            
            conn.commit()
            conn.close()
            
            # Send SMS
            sms_sent = send_sms(phone_number, otp_code)
            
            return jsonify({
                'success': True,
                'requires_2fa': True,
                'message': 'OTP sent to your phone' if sms_sent else 'Check console for OTP code',
                'phone_number': phone_number
            }), 200
        else:
            # Create session (2FA disabled)
            session_token = generate_session_token()
            expires_at = (datetime.now() + timedelta(days=7)).isoformat()
            
            cursor.execute('''
                INSERT INTO sessions (phone_number, session_token, expires_at)
                VALUES (?, ?, ?)
            ''', (phone_number, session_token, expires_at))
            
            cursor.execute('''
                UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE phone_number = ?
            ''', (phone_number,))
            
            conn.commit()
            conn.close()
            
            return jsonify({
                'success': True,
                'requires_2fa': False,
                'session_token': session_token,
                'message': 'Login successful'
            }), 200
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/verify-otp', methods=['POST'])
def verify_otp():
    """Verify SMS OTP for 2FA login"""
    try:
        data = request.json
        phone_number = data.get('phone_number', '').strip()
        otp = data.get('otp', '')
        
        if not phone_number or not otp:
            return jsonify({'success': False, 'error': 'Phone and OTP required'}), 400
        
        # Check rate limit
        allowed, msg = check_rate_limit(phone_number)
        if not allowed:
            return jsonify({'success': False, 'error': msg}), 429
        
        # Get the most recent valid OTP
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('''
            SELECT otp_code FROM otp_attempts 
            WHERE phone_number = ? AND expires_at > CURRENT_TIMESTAMP
            ORDER BY created_at DESC LIMIT 1
        ''', (phone_number,))
        
        result = cursor.fetchone()
        
        if not result or result['otp_code'] != otp:
            increment_otp_attempts(phone_number)
            conn.close()
            return jsonify({'success': False, 'error': 'Invalid OTP'}), 401
        
        # Reset rate limit
        reset_otp_attempts(phone_number)
        
        # Delete used OTP
        cursor.execute('''
            DELETE FROM otp_attempts WHERE phone_number = ? AND otp_code = ?
        ''', (phone_number, otp))
        
        # Create session
        session_token = generate_session_token()
        expires_at = (datetime.now() + timedelta(days=7)).isoformat()
        
        cursor.execute('''
            INSERT INTO sessions (phone_number, session_token, expires_at)
            VALUES (?, ?, ?)
        ''', (phone_number, session_token, expires_at))
        
        cursor.execute('''
            UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE phone_number = ?
        ''', (phone_number,))
        
        conn.commit()
        conn.close()
        
        return jsonify({
            'success': True,
            'session_token': session_token,
            'message': '2FA verification successful'
        }), 200
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/resend-otp', methods=['POST'])
def resend_otp():
    """Resend OTP via SMS"""
    try:
        data = request.json
        phone_number = data.get('phone_number', '').strip()
        
        if not phone_number:
            return jsonify({'success': False, 'error': 'Phone required'}), 400
        
        # Generate new OTP
        otp_code = ''.join(random.choices(string.digits, k=6))
        expires_at = (datetime.now() + timedelta(minutes=10)).isoformat()
        
        conn = get_db()
        cursor = conn.cursor()
        
        # Delete old OTP
        cursor.execute('''
            DELETE FROM otp_attempts WHERE phone_number = ?
        ''', (phone_number,))
        
        # Store new OTP
        cursor.execute('''
            INSERT INTO otp_attempts (phone_number, otp_code, expires_at)
            VALUES (?, ?, ?)
        ''', (phone_number, otp_code, expires_at))
        
        conn.commit()
        conn.close()
        
        # Send SMS
        sms_sent = send_sms(phone_number, otp_code)
        
        return jsonify({
            'success': True,
            'message': 'OTP resent to your phone' if sms_sent else 'Check console for OTP code'
        }), 200
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/verify-session', methods=['POST'])
def verify_session():
    """Verify if session token is valid"""
    try:
        data = request.json
        session_token = data.get('session_token', '')
        
        if not session_token:
            return jsonify({'success': False, 'error': 'Session token required'}), 400
        
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('''
            SELECT phone_number, expires_at FROM sessions WHERE session_token = ?
        ''', (session_token,))
        
        session = cursor.fetchone()
        conn.close()
        
        if not session:
            return jsonify({'success': False, 'error': 'Invalid session'}), 401
        
        if datetime.fromisoformat(session['expires_at']) < datetime.now():
            return jsonify({'success': False, 'error': 'Session expired'}), 401
        
        return jsonify({
            'success': True,
            'phone_number': session['phone_number'],
            'message': 'Session valid'
        }), 200
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/logout', methods=['POST'])
def logout():
    """Logout user by invalidating session"""
    try:
        data = request.json
        session_token = data.get('session_token', '')
        
        if not session_token:
            return jsonify({'success': False, 'error': 'Session token required'}), 400
        
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('DELETE FROM sessions WHERE session_token = ?', (session_token,))
        conn.commit()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Logout successful'
        }), 200
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'OK'}), 200

if __name__ == '__main__':
    init_db()
    app.run(host='localhost', port=5000, debug=False)
