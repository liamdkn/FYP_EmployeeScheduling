from flask import Blueprint, jsonify, request
import traceback
from flask_cors import CORS
from app.services.roster_service import *

roster_blueprint = Blueprint('roster', __name__)
CORS(roster_blueprint)

@roster_blueprint.route('/rosters', methods=['GET'])
def get_all_rosters_route():
    try:
        rosters = get_all_rosters()
        print(rosters)
        return jsonify(rosters), 200 
    except Exception as e:
        return jsonify({'error': str(e)}), 500



@roster_blueprint.route('/rosters/<roster_id>', methods=['GET'])
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




@roster_blueprint.route('/rosters', methods=['POST'])
def create_roster_route():
    try:
        roster_data = request.json    
        roster = roster_data.get('roster')
        shifts_id = roster_data.get('shifts_id')
        employee_ids = roster_data.get('employee_ids')
        print("makde it here")

        roster_id, status_code = generate_roster_service(roster, shifts_id, employee_ids)
        if status_code == 201:
            print("We have big scuess")
        else:
            print("Roster creation failed.")

        print("Finished making roster")
        print(roster_id)

        response_data = roster_id
                
        return response_data, 201

    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500
