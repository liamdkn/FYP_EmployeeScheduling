from flask import Blueprint, jsonify, request
import traceback
from flask_cors import CORS
from app.services.roster_service import create_roster, get_roster

roster_blueprint = Blueprint('roster', __name__)
CORS(roster_blueprint)

@roster_blueprint.route('/roster', methods=['GET'])
def get_rosters_route():
    print("Getting Rosters")

@roster_blueprint.route('/roster/<roster_id>', methods=['GET'])
def get_roster_by_id_route(roster_id):
    try:
        roster = get_roster(roster_id)
        if roster:
            return roster, 200
        else:
            return jsonify({'error': 'Roster not found'}), 404
    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


@roster_blueprint.route('/roster', methods=['POST'])
def create_roster_route():
    try:
        roster_data = request.json        
        shifts_id = roster_data.get('shifts_id')
        employee_ids = roster_data.get('employee_ids')
        roster_id = create_roster(shifts_id, employee_ids)
        print("made it here")

        response_data = {
                        "status": "Roster created successfully",
                        "roster_id": roster_id
                    }
        return response_data

    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500
