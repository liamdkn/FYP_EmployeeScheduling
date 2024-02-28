import json
from flask import Flask, jsonify, request, Blueprint
from flask_cors import CORS
from google.cloud import firestore

cred = json.loads(open('python-flask-api/rostergenerator-6bee3-firebase-adminsdk-ptvgm-4dfb90a923.json').read())
db = firestore.Client.from_service_account_info(cred)

shift_blueprint = Blueprint('shift', __name__)
shifts_ref = db.collection('shifts')

@shift_blueprint.route('/shifts', methods=['GET'])
def get_shifts():
    shifts = [doc.to_dict() for doc in shifts_ref.stream()]
    return jsonify(shifts)

@shift_blueprint.route('/shifts', methods=['POST'])
def create_shifts():
    try:
        shifts_data = request.json

        all_shifts = []
        for shift_data in shifts_data:
            all_shifts.append(shift_data)

        new_shift_ref = shifts_ref.add({'all_shifts': all_shifts})

        response_data = {
            "status": "Shifts data retrieved successfully",
            "shifts_data": all_shifts
        }

        return jsonify(response_data), 201

    except Exception as e:
        error_message = f"Error creating shifts: {str(e)}"
        return jsonify({"error": error_message}), 500

