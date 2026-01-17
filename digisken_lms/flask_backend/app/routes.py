from flask import Blueprint, jsonify

main_bp = Blueprint('main', __name__)

@main_bp.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"})

@main_bp.route('/', methods=['GET'])
def index():
    return jsonify({"message": "DigiSken LMS API"})
