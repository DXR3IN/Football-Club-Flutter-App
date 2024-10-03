import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Future<Iterable?> getApiFootballClubs() async {
    final response =
        await _dio.get('/search_all_teams.php?l=English%20Premier%20League');

    // Check if the response data is a Map
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      // Extract the 'teams' key and ensure it's an Iterable
      final teams = data['teams'];
      if (teams is Iterable) {
        return teams;
      } else {
        // Handle the case where 'teams' is not an Iterable
        throw const FormatException("Expected 'teams' to be an Iterable");
      }
    } else {
      // Handle unexpected response format
      throw const FormatException(
          "Expected response to be a Map<String, dynamic>");
    }
  }

  Future<List<dynamic>?> getApiFootballClubById(String name) async {
    final response = await _dio.get("/searchteams.php?t=$name");

    // Check if the response data is a Map
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final teams = data['teams']; // Expecting this to be a list

      // Check if teams is a list
      if (teams is List<dynamic>) {
        return teams; // Return the list of teams
      } else {
        throw const FormatException("Expected 'teams' to be a List");
      }
    } else {
      // Handle unexpected response format
      throw const FormatException(
          "Expected response to be a Map<String, dynamic>");
    }
  }

  Future<Iterable?> getFcEquipment(String id) async {
    final response = await _dio.get('/lookupequipment.php?id=$id');

    // Check if the response data is a Map
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final players = data['equipment'];

      return players;
    } else {
      // Handle unexpected response format
      throw const FormatException(
          "Expected response to be a Map<String, dynamic>");
    }
  }
}
