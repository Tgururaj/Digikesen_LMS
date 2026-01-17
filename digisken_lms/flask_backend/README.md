# DigiSken LMS - Flask Backend

Flask-based REST API for the DigiSken Learning Management System.

## Installation

```bash
pip install -r requirements.txt
```

## Running the Server

```bash
python run.py
```

The server will run on `http://localhost:5000`

## API Endpoints

- `GET /health` - Health check
- `GET /api/lms/courses` - Get all courses
- `GET /api/lms/courses/<id>` - Get course details
- `GET /api/lms/lessons/<id>` - Get lesson details
