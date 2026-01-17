from flask import Blueprint, jsonify, request

lms_bp = Blueprint('lms', __name__, url_prefix='/api/lms')

@lms_bp.route('/courses', methods=['GET'])
def get_courses():
    courses = [
        {
            "id": 1,
            "title": "Introduction to Python",
            "description": "Learn Python programming basics",
            "instructor": "John Doe",
            "lessons": 10
        },
        {
            "id": 2,
            "title": "Web Development with Flask",
            "description": "Build web applications using Flask",
            "instructor": "Jane Smith",
            "lessons": 8
        }
    ]
    return jsonify(courses)

@lms_bp.route('/courses/<int:course_id>', methods=['GET'])
def get_course_detail(course_id):
    course = {
        "id": course_id,
        "title": "Sample Course",
        "description": "Course description",
        "instructor": "Instructor Name",
        "lessons": [
            {
                "id": 1,
                "title": "Lesson 1",
                "content": "Lesson content here"
            }
        ]
    }
    return jsonify(course)

@lms_bp.route('/lessons/<int:lesson_id>', methods=['GET'])
def get_lesson(lesson_id):
    lesson = {
        "id": lesson_id,
        "title": "Lesson Title",
        "content": "Lesson content",
        "videoUrl": "https://example.com/video.mp4"
    }
    return jsonify(lesson)
