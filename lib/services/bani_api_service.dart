// lib/services/bani_api_service.dart (updated)

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bani_model.dart';

class BaniApiService {
  final String baseUrl = 'https://api.banidb.com/v2';

  Future<SearchResponse> searchGurbaniAdvanced({
    required String query,
    required int searchType,
    String source = 'all',
    int? writerId,
    int page = 1,
    int resultsPerPage = 30,
  }) async {
    final encodedQuery = Uri.encodeComponent(query);
    var url =
        '$baseUrl/search/$encodedQuery?searchtype=$searchType&page=$page&results=$resultsPerPage';

    if (source != 'all') {
      url += '&source=$source';
    }

    if (writerId != null) {
      url += '&writer=$writerId';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchResponse.fromJson(data);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Legacy method for backward compatibility
  Future<List<BaniVerse>> searchGurbani(
    String query, {
    int searchType = 2,
    String source = 'G',
    int page = 1,
  }) async {
    final response = await searchGurbaniAdvanced(
      query: query,
      searchType: searchType,
      source: source,
      page: page,
    );
    return response.verses;
  }

  Future<List<Raag>> getRaags() async {
    final url = '$baseUrl/raags';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final raagsList = data['raags'] as List? ?? [];
        return raagsList.map((raag) => Raag.fromJson(raag)).toList();
      } else {
        throw Exception('Failed to fetch raags: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Writer>> getWriters() async {
    final url = '$baseUrl/writers';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final writersList = data['writers'] as List? ?? [];
        return writersList.map((writer) => Writer.fromJson(writer)).toList();
      } else {
        throw Exception('Failed to fetch writers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

// ── Response Models ───────────────────────────────────────────────────────────

class SearchResponse {
  final ResultsInfo resultsInfo;
  final List<BaniVerse> verses;

  SearchResponse({
    required this.resultsInfo,
    required this.verses,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      resultsInfo: ResultsInfo.fromJson(json['resultsInfo'] ?? {}),
      verses: (json['verses'] as List? ?? [])
          .map((verse) => BaniVerse.fromJson(verse))
          .toList(),
    );
  }
}

class ResultsInfo {
  final int totalResults;
  final int pageResults;
  final PagesInfo pages;

  ResultsInfo({
    required this.totalResults,
    required this.pageResults,
    required this.pages,
  });

  factory ResultsInfo.fromJson(Map<String, dynamic> json) {
    return ResultsInfo(
      totalResults: json['totalResults'] ?? 0,
      pageResults: json['pageResults'] ?? 0,
      pages: PagesInfo.fromJson(json['pages'] ?? {}),
    );
  }
}

class PagesInfo {
  final int page;
  final int resultsPerPage;
  final int totalPages;
  final String? nextPage;

  PagesInfo({
    required this.page,
    required this.resultsPerPage,
    required this.totalPages,
    this.nextPage,
  });

  factory PagesInfo.fromJson(Map<String, dynamic> json) {
    return PagesInfo(
      page: json['page'] ?? 1,
      resultsPerPage: json['resultsPerPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      nextPage: json['nextPage'],
    );
  }
}