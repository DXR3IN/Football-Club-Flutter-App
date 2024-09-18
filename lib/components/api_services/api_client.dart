import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;
  ApiClient(this._dio);

  Future<Iterable?> getApiFootballClub() async {
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
      throw const FormatException("Expected response to be a Map<String, dynamic>");
    }
  }

  Future<Iterable?> getApiPlayer(String id) async {
    final response = await _dio.get('/lookup_all_players.php?id=$id');

    // Check if the response data is a Map
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      // Extract the 'players' key and ensure it's an Iterable
      final players = data['players']; // Adjust the key name if needed
      if (players is Iterable) {
        return players;
      } else {
        // Handle the case where 'players' is not an Iterable
        throw const FormatException("Expected 'players' to be an Iterable");
      }
    } else {
      // Handle unexpected response format
      throw const FormatException("Expected response to be a Map<String, dynamic>");
    }
  }
}
