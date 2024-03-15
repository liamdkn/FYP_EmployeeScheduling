from flask import Blueprint, jsonify, request
import traceback
from flask_cors import CORS
from app.services.roster_service import create_roster

roster_blueprint = Blueprint('roster', __name__)
CORS(roster_blueprint)

@roster_blueprint.route('/roster', methods=['GET'])
def get_rosters_route():
    print("Getting Rosters")

@roster_blueprint.route('/roster', methods=['POST'])
def create_roster_route():
    try:
        roster_data = request.json        
        shifts_id = roster_data.get('shifts_id')
        employee_ids = roster_data.get('employee_ids')
        
        roster = create_roster(shifts_id, employee_ids)

        return "Sucesses"
    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500
