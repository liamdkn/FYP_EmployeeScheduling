from flask import current_app
from app.models.business_model import Business

def create_business(business_data):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        businesses_ref = db.collection('businesses')

        new_business = Business(**business_data)
        business_dict = new_business.to_dict()
        business_id = business_dict.pop('business_id', None)

        new_business_ref = businesses_ref.document(business_id)
        new_business_ref.set(business_dict)

        return business_id

    except Exception as e:
        raise Exception(f"Error creating business: {str(e)}")


def get_business_by_id(business_id):
    try:
        print("getting business for id:")
        db = current_app.config['FIRESTORE_CLIENT']
        businesses_ref = db.collection('businesses')
        
        business_doc = businesses_ref.document(business_id).get()

        if business_doc.exists:
            business_data = business_doc.to_dict()
            business = Business(business_id= business_id, **business_data)
            return business
        else:
            return None
    except Exception as e:
        print(f"Error fetching business: {e}")
        return None


def is_user_business(user_id):
    try:
        db = current_app.config['FIRESTORE_CLIENT']
        businesses_ref = db.collection('businesses')
        business_doc = businesses_ref.document(user_id).get()
        if business_doc.exists and not business_doc.to_dict().get('is_deleted', False):
            return True
        else: False
    except Exception as e:
        print(f"Error checking business: {e}")
        traceback.print_exc()
        return False