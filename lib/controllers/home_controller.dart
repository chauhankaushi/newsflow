import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';

class HomeController extends GetxController {
  List<ArticleModel> articles = [];
  List<ArticleModel> filteredArticles = [];
  bool isLoading = false;
  String errorMessage = '';
  String selectedCategory = 'home';
  String selectedSection = '';
  String searchKeyword = '';

  final _selectedSection = ''.obs;
  final _searchKeyword = ''.obs;

  final List<String> categories = [
    'home',
    'world',
    'arts',
    'science',
    'sports',
    'opinion'
  ];

  static const String _apiKey =
      'Pg6L4UtTmo2GmOfnwgHAIslmdIs4WYWdKiUzM9PfntZ6cRfL';
  static const String _baseUrl = 'https://api.nytimes.com/svc/topstories/v2';

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    isLoading = true;
    errorMessage = '';
    articles = [];
    filteredArticles = [];
    update();

    try {
      final String url = '$_baseUrl/$selectedCategory.json?api-key=$_apiKey';

      debugPrint('Fetching: $url');

      final completer = Completer<String>();

      final request = html.HttpRequest();
      request.open('GET', url);
      request.setRequestHeader('Accept', 'application/json');

      request.onLoad.listen((event) {
        if (request.status == 200) {
          completer.complete(request.responseText ?? '');
        } else {
          completer.completeError('HTTP ${request.status}');
        }
      });

      request.onError.listen((event) {
        completer.completeError('Network error');
      });

      request.send();

      final responseText =
          await completer.future.timeout(const Duration(seconds: 20));

      final Map<String, dynamic> data = json.decode(responseText);

      if (data['status'] == 'OK') {
        final List<dynamic> results = data['results'] ?? [];
        debugPrint('Articles received: ${results.length}');

        articles = results
            .whereType<Map<String, dynamic>>()
            .map((item) => ArticleModel.fromJson(item))
            .where((a) => a.title.isNotEmpty)
            .toList();

        filteredArticles = List.from(articles);
        errorMessage = '';

        if (articles.isEmpty) {
          errorMessage = 'No articles found for "$selectedCategory".';
        }
      } else {
        errorMessage = 'Unexpected response. Please try again.';
      }
    } catch (e) {
      debugPrint('Error: $e');
      final msg = e.toString();

      if (msg.contains('401')) {
        errorMessage = 'Invalid API key.';
      } else if (msg.contains('429')) {
        errorMessage = 'Rate limit hit. Please wait and try again.';
      } else if (msg.contains('TimeoutException')) {
        errorMessage = 'Request timed out.';
      } else {
        // CORS fail hone par dummy data dikhao
        debugPrint('Loading dummy data as fallback...');
        _loadDummyData();
        isLoading = false;
        update();
        return;
      }
    }

    isLoading = false;
    update();
  }

  void _loadDummyData() {
    articles = [
      ArticleModel(
        title: 'Global Leaders Meet to Discuss Climate Crisis Solutions',
        byline: 'Sarah Johnson',
        publishedDate: '2026-05-01',
        abstract:
            'World leaders gathered in Geneva this week for an emergency summit on accelerating climate action, with new pledges expected from major economies.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/climate/800/500',
        section: 'world',
      ),
      ArticleModel(
        title: 'New Study Reveals Surprising Benefits of Mediterranean Diet',
        byline: 'Dr. Michael Chen',
        publishedDate: '2026-04-30',
        abstract:
            'Researchers from Harvard found that following a Mediterranean diet reduces risk of cardiovascular disease by up to 30 percent over a decade.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/food/800/500',
        section: 'science',
      ),
      ArticleModel(
        title: 'Tech Giants Face New Antitrust Scrutiny in Europe',
        byline: 'Emma Williams',
        publishedDate: '2026-04-29',
        abstract:
            'The European Commission is preparing a landmark antitrust case against several major technology companies over alleged anti-competitive practices.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/tech/800/500',
        section: 'home',
      ),
      ArticleModel(
        title: 'Broadway Season Opens with Record-Breaking Shows',
        byline: 'Lisa Park',
        publishedDate: '2026-04-28',
        abstract:
            'This season\'s Broadway lineup has shattered box office records, with several new productions selling out months in advance.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/broadway/800/500',
        section: 'arts',
      ),
      ArticleModel(
        title: 'NBA Playoffs: Underdogs Steal the Spotlight',
        byline: 'James Carter',
        publishedDate: '2026-04-27',
        abstract:
            'The first round of the NBA playoffs has seen several stunning upsets, with lower-seeded teams defeating championship favorites.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/sports/800/500',
        section: 'sports',
      ),
      ArticleModel(
        title:
            'Opinion: The Future of Remote Work Is More Complex Than We Think',
        byline: 'Prof. Anna Lee',
        publishedDate: '2026-04-26',
        abstract:
            'As companies continue debating return-to-office policies, the data suggests that the optimal arrangement is neither fully remote nor fully in-person.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/work/800/500',
        section: 'opinion',
      ),
      ArticleModel(
        title: 'Scientists Discover New Species Deep in Amazon Rainforest',
        byline: 'Dr. Carlos Rivera',
        publishedDate: '2026-04-25',
        abstract:
            'A team of international researchers catalogued over 40 previously unknown species during a six-month expedition in the Amazon basin.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/amazon/800/500',
        section: 'science',
      ),
      ArticleModel(
        title: 'Housing Market Shows Signs of Stabilization',
        byline: 'Rachel Moore',
        publishedDate: '2026-04-24',
        abstract:
            'After years of soaring prices and mortgage rate fluctuations, analysts see the first signs of a cooling housing market across major U.S. cities.',
        url: 'https://www.nytimes.com',
        imageUrl: 'https://picsum.photos/seed/housing/800/500',
        section: 'home',
      ),
    ];
    filteredArticles = List.from(articles);
    errorMessage = '';
  }

  void changeCategory(String category) {
    if (selectedCategory == category && articles.isNotEmpty) return;
    selectedCategory = category;
    selectedSection = '';
    searchKeyword = '';
    _selectedSection.value = '';
    _searchKeyword.value = '';
    fetchArticles();
  }

  void applyFilter({String section = '', String keyword = ''}) {
    selectedSection = section;
    searchKeyword = keyword;
    _selectedSection.value = section;
    _searchKeyword.value = keyword;
    _applyLocalFilter();
  }

  void _applyLocalFilter() {
    List<ArticleModel> result = List.from(articles);

    if (searchKeyword.isNotEmpty) {
      final query = searchKeyword.toLowerCase().trim();
      result = result
          .where((a) =>
              a.title.toLowerCase().contains(query) ||
              a.abstract.toLowerCase().contains(query) ||
              a.byline.toLowerCase().contains(query))
          .toList();
    }

    if (selectedSection.isNotEmpty) {
      result = result
          .where((a) =>
              a.section.toLowerCase() == selectedSection.toLowerCase() ||
              a.subsection.toLowerCase() == selectedSection.toLowerCase())
          .toList();
    }

    // New list assign karo aur update call karo
    filteredArticles = result;
    update();
  }

  void refreshArticles() {
    selectedSection = '';
    searchKeyword = '';
    _selectedSection.value = '';
    _searchKeyword.value = '';
    fetchArticles();
  }

  void clearFilters() => applyFilter();

  bool get hasActiveFilter =>
      _selectedSection.value.isNotEmpty || _searchKeyword.value.isNotEmpty;
}
