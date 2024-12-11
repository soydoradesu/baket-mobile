// lib/features/user/services/profile_service.dart
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';

class ProfileService {
  final CookieRequest request;

  ProfileService(this.request);

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String updateNameUrl = '$baseUrl/user/update-name-api/';
  static const String updateBirthDateUrl = '$baseUrl/user/update-birth-date-api/';
  static const String updateEmailUrl = '$baseUrl/user/update-email-api/';
  static const String updatePhoneUrl = '$baseUrl/user/update-phone-api/';
  static const String updateGenderUrl = '$baseUrl/user/update-gender-api/';
  static const String logoutUrl = '$baseUrl/auth/logout/';

  Future<bool> updateName(String firstName, String lastName) async {
    final response = await request.post(updateNameUrl, {
      'first_name': firstName,
      'last_name': lastName,
    });
    return response['status'] == 'success';
  }

  Future<bool> updateBirthDate(DateTime newDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
    final response = await request.post(updateBirthDateUrl, {
      'birth_date': formattedDate,
    });
    return response['status'] == 'success';
  }

  Future<bool> updateEmail(String newEmail) async {
    final response = await request.post(updateEmailUrl, {
      'email': newEmail,
    });
    return response['status'] == 'success';
  }

  Future<bool> updatePhone(String newPhone) async {
    final response = await request.post(updatePhoneUrl, {
      'phone_number': newPhone,
    });
    return response['status'] == 'success';
  }

  Future<bool> updateGender(String newGender) async {
    final response = await request.post(updateGenderUrl, {
      'gender': newGender,
    });
    return response['status'] == 'success';
  }

  Future<Map<String, dynamic>> logoutUser() async {
    return await request.logout(logoutUrl);
  }
}