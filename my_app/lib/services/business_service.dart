import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/models/business_model.dart';
import 'package:my_app/services/api_headers.dart';

class BusinessService {
  String businessEndpoint = "/business";

  Future<String> createBusiness(Business business) async {
    print("DEBUG: Creating business");
    final businessData = business.toJson();
    final response = await http.post(
      Uri.parse('$APIURI$businessEndpoint'),
      body: jsonEncode(businessData),
      headers: await authenticatedHeaders(json: true),
    );
    print(businessData);
    print(response.body);
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['business_id'];
    } else {
      throw Exception('Failed to create business: ${response.body}');
    }
  }

  Future<List<Business>> getBusinesses() async {
    final response = await http.get(
      Uri.parse('$APIURI$businessEndpoint'),
      headers: await authenticatedHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      final List<Business> businessList = jsonList.map((dynamic json) {
        return Business.fromJson(json);
      }).toList();

      return businessList;
    } else {
      throw Exception('Failed to fetch businesses: ${response.body}');
    }
  }

  Future<Business?> getBusinessById(String businessId) async {
    final response = await http.get(
      Uri.parse('$APIURI$businessEndpoint/$businessId'),
      headers: await authenticatedHeaders(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final Business business = Business.fromJson(jsonData);
      return business;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch business: ${response.body}');
    }
  }

  Future<void> editBusiness(
      String businessId, Map<String, dynamic> businessData) async {
    final response = await http.put(
      Uri.parse('$APIURI$businessEndpoint/$businessId'),
      body: jsonEncode(businessData),
      headers: await authenticatedHeaders(json: true),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit business: ${response.body}');
    }
  }

  Future<void> deleteBusiness(String businessId) async {
    final response = await http.delete(
      Uri.parse('$APIURI$businessEndpoint/$businessId'),
      headers: await authenticatedHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete business: ${response.body}');
    }
  }
}
