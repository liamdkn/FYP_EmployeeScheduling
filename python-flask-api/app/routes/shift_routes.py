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
def create_shift():
    shift_data = request.json
    new_shift_ref = shifts_ref.add(shift_data)

    response_data = {
        "status": "Shift data retrieved successfully",
        "shift_data": shift_data
    }
    return jsonify(response_data), 201
