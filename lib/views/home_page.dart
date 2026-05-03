import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import '../controllers/theme_controller.dart';
import '../widgets/article_card.dart';
import '../widgets/category_tab.dart';
import '../widgets/filter_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController ctrl = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF7F7F9),
        appBar: AppBar(
          backgroundColor:
              isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF7F7F9),
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'N',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NYT News Feed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const Text(
                    'Top Stories',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Dark mode toggle
            GetBuilder<ThemeController>(
              builder: (themeCtrl) => IconButton(
                onPressed: () => themeCtrl.toggleTheme(),
                icon: Icon(
                  themeCtrl.isDarkMode.value
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                tooltip:
                    themeCtrl.isDarkMode.value ? 'Light Mode' : 'Dark Mode',
              ),
            ),

            // Filter button
            GetBuilder<HomeController>(
              builder: (c) => IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    const FilterSheet(),
                    isScrollControlled: true,
                  );
                },
                icon: Stack(
                  children: [
                    const Icon(Icons.tune_rounded),
                    if (c.hasActiveFilter)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                tooltip: 'Filter',
              ),
            ),

            // Refresh button
            IconButton(
              onPressed: () => Get.find<HomeController>().refreshArticles(),
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
            ),

            const SizedBox(width: 4),
          ],
        ),
        body: Column(
          children: [
            // Category Tabs
            GetBuilder<HomeController>(
              builder: (c) => SizedBox(
                height: 52,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: c.categories.length,
                  itemBuilder: (context, index) {
                    final cat = c.categories[index];
                    return CategoryTab(
                      label: cat,
                      isSelected: c.selectedCategory == cat,
                      onTap: () => c.changeCategory(cat),
                    );
                  },
                ),
              ),
            ),

            // Body content
            Expanded(
              child: GetBuilder<HomeController>(
                builder: (c) {
                  if (c.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Color(0xFF1A1A2E)),
                          SizedBox(height: 16),
                          Text('Loading articles...',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  if (c.errorMessage.isNotEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(c.errorMessage,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: c.refreshArticles,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A2E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (c.filteredArticles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.article_outlined,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No articles found',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text(
                            'Try changing category or clearing filters',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () => c.applyFilter(),
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => c.refreshArticles(),
                    color: const Color(0xFF1A1A2E),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemCount: c.filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = c.filteredArticles[index];
                        return ArticleCard(
                          article: article,
                          onTap: () => Get.toNamed(
                            AppRoutes.articleDetail,
                            arguments: article,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
