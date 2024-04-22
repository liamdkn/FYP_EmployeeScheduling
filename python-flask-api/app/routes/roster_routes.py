from flask import Blueprint, jsonify, request
import traceback
from flask_cors import CORS
from app.services.roster_service import *

roster_blueprint = Blueprint('roster', __name__)
CORS(roster_blueprint)

@roster_blueprint.route('/rosters', methods=['GET'])
def get_all_rosters_route():
    try:
        user_type = request.headers.get('User-Type')
        rosters = get_all_rosters(user_type)
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

        roster_id, status_code = generate_roster_service(roster, shifts_id, employee_ids)
        if status_code == 201:
            print("We have big sucess")
        else:
            print("Roster creation failed.")

        print("Finished making roster")
        response_data = roster_id
                
        return response_data, 201

    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500


@roster_blueprint.route('/rosters/<string:roster_id>', methods=['PUT'])
def soft_delete_roster_route(roster_id):
    response_data, status_code = soft_delete_roster(roster_id)
    if status_code == 200:
        return jsonify({'message': response_data['status']}), 200
    elif status_code == 404:
        return jsonify({'error': 'Roster not found'}), 404
    else:
        return jsonify({'error': response_data['error']}), 500



@roster_blueprint.route('/rosters/export', methods=['POST'])
def export_roster_route():
    try:
        roster_data = request.json
        export_result = export_roster_to_csv(roster_data)

        if export_result:
            email_exported_roster(export_result, BUSINESS_EMAIL)
        
        if export_result:
            return jsonify({'message': 'Roster exported successfully'}), 200
        else:
            return jsonify({'error': 'Failed to export roster or roster not found'}), 404
    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500




@roster_blueprint.route('/rosters/save', methods=['POST'])
def save_roster_route():
    try:
        roster_data = request.json
        roster_id, status_code = create_roster(roster_data)
        print(roster_id)
        if roster_id:
            return jsonify({'roster_id': roster_id}), 200
        else:
            return jsonify({'error': 'Failed to save roster'}), 500
    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500



@roster_blueprint.route('/rosters/publish/<roster_id>', methods=['PUT'])
def publish_roster_route(roster_id):
    print("trying to publishing roster")
    try:
        publish_result = publish_roster(roster_id)
        
        if publish_result:
            return jsonify({'message': 'Roster published successfully'}), 200
        else:
            return jsonify({'error': 'Failed to publish roster or roster not found'}), 404
    except Exception as e:
        traceback.print_exc()
        print(f"Exception: {e}")
        return jsonify({'error': 'Internal Server Error'}), 500



