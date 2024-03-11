from flask import Blueprint, jsonify, request
from flask_cors import CORS
from app.services.roster_service import create_new_roster

roster_blueprint = Blueprint('roster', __name__)
CORS(roster_blueprint)

@roster_blueprint.route('/roster', methods=['GET'])
def get_rosters():
    print("Getting Rosters")

@roster_blueprint.route('/roster', methods=['POST'])
def create_roster():
    try:
        roster_data = request.json
        print(roster_data)
        
        shifts_id = roster_data.get('shifts_id')
        employee_ids = roster_data.get('employee_ids')
        
        roster = create_new_roster(shifts_id, employee_ids)

        return "Sucess"
    except Exception as e:
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500