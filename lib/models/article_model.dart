class ArticleModel {
  final String title;
  final String byline;
  final String publishedDate;
  final String abstract;
  final String url;
  final String imageUrl;
  final String section;
  final String subsection;
  final String kicker;

  ArticleModel({
    required this.title,
    required this.byline,
    required this.publishedDate,
    required this.abstract,
    required this.url,
    required this.imageUrl,
    required this.section,
    this.subsection = '',
    this.kicker = '',
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // ---- Image Parsing ----
    String image = '';
    try {
      final multimedia = json['multimedia'];
      if (multimedia != null && multimedia is List && multimedia.isNotEmpty) {
        // Pehle Super Jumbo dhundo
        Map<String, dynamic>? superJumbo;
        Map<String, dynamic>? threeByTwo;
        Map<String, dynamic>? fallback;

        for (var m in multimedia) {
          if (m is Map<String, dynamic>) {
            final format = m['format']?.toString() ?? '';
            if (format == 'Super Jumbo') {
              superJumbo = m;
              break;
            } else if (format == 'threeByTwoSmallAt2X') {
              threeByTwo = m;
            } else {
              fallback ??= m;
            }
          }
        }

        // Priority: Super Jumbo > threeByTwo > fallback
        final chosen = superJumbo ?? threeByTwo ?? fallback;
        if (chosen != null && chosen['url'] != null) {
          image = chosen['url'].toString();
        }
      }
    } catch (_) {
      image = '';
    }

    // ---- Date Parsing ----
    // API returns "2026-05-02T05:01:29-04:00" — sirf date part lenge
    String rawDate = json['published_date']?.toString() ?? '';
    if (rawDate.contains('T')) {
      rawDate = rawDate.split('T').first; // "2026-05-02"
    }

    // ---- Byline Cleanup ----
    // API returns "By Shane Goldmacher" — "By " remove karenge display ke liye
    String byline = json['byline']?.toString() ?? '';
    if (byline.toLowerCase().startsWith('by ')) {
      byline = byline.substring(3).trim();
    }
    if (byline.isEmpty) byline = 'NYT Staff';

    return ArticleModel(
      title: json['title']?.toString() ?? '',
      byline: byline,
      publishedDate: rawDate,
      abstract: json['abstract']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      imageUrl: image,
      section: json['section']?.toString() ?? '',
      subsection: json['subsection']?.toString() ?? '',
      kicker: json['kicker']?.toString() ?? '',
    );
  }
}
