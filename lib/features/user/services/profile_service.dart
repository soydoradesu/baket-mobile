// lib/features/user/services/profile_service.dart
import 'dart:io';
import 'package:baket_mobile/services/pref_service.dart';
import 'package:http/http.dart' as http;
import 'package:baket_mobile/core/constants/_constants.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';

class ProfileService {
  final CookieRequest request;

  ProfileService(this.request);

  static const String baseUrl = Endpoints.baseUrl;
  static const String updateNameUrl = '$baseUrl/user/update-name-api/';
  static const String updateBirthDateUrl =
      '$baseUrl/user/update-birth-date-api/';
  static const String updateEmailUrl = '$baseUrl/user/update-email-api/';
  static const String updatePhoneUrl = '$baseUrl/user/update-phone-api/';
  static const String updateGenderUrl = '$baseUrl/user/update-gender-api/';
  String get uploadProfilePictureUrl =>
      '$baseUrl/user/upload-profile-picture/'; // Adjusted based on Django view
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

  /// Uploads a profile picture to the backend.
  /// Returns true if the upload is successful, false otherwise.
  Future<bool> uploadProfilePicture(File imageFile) async {
    final uri = Uri.parse(uploadProfilePictureUrl);
    var multipartRequest = http.MultipartRequest('POST', uri);

    // Add the cookie from request.headers to multipartRequest
    if (request.headers.containsKey('cookie')) {
      // Note the capital 'C' in 'Cookie' as required by HTTP standards
      multipartRequest.headers['Cookie'] = request.headers['cookie']!;
    }

    // Attach the image file
    multipartRequest.files.add(
        await http.MultipartFile.fromPath('profile_picture', imageFile.path));

    try {
      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to upload profile picture. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception during profile picture upload: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> logoutUser() async {
    PrefService.removeKey('username');
    PrefService.removeKey('password');
    return await request.logout(logoutUrl);
  }
}
