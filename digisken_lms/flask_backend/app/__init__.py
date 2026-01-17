from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    from app.routes import main_bp
    from app.lms_routes import lms_bp
    
    app.register_blueprint(main_bp)
    app.register_blueprint(lms_bp)
    
    return app
