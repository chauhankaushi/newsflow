import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController keywordCtrl = TextEditingController();
  String selectedSection = '';

  // Subsections jo NYT API return karta hai
  final List<Map<String, String>> sectionFilters = [
    {'value': '', 'label': 'All', 'icon': '🌐'},
    {'value': 'us', 'label': 'U.S.', 'icon': '🇺🇸'},
    {'value': 'world', 'label': 'World', 'icon': '🌍'},
    {'value': 'politics', 'label': 'Politics', 'icon': '🏛️'},
    {'value': 'business', 'label': 'Business', 'icon': '💼'},
    {'value': 'arts', 'label': 'Arts', 'icon': '🎨'},
    {'value': 'science', 'label': 'Science', 'icon': '🔬'},
    {'value': 'sports', 'label': 'Sports', 'icon': '⚽'},
    {'value': 'opinion', 'label': 'Opinion', 'icon': '💬'},
    {'value': 'travel', 'label': 'Travel', 'icon': '✈️'},
    {'value': 'nyregion', 'label': 'NY Region', 'icon': '🗽'},
    {'value': 'magazine', 'label': 'Magazine', 'icon': '📰'},
    {'value': 'well', 'label': 'Well', 'icon': '🏥'},
  ];

  @override
  void initState() {
    super.initState();
    selectedSection = controller.selectedSection;
    keywordCtrl.text = controller.searchKeyword;
  }

  @override
  void dispose() {
    keywordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDark ? Colors.white60 : Colors.black54;
    final chipBg = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F5);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Handle ----
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // ---- Header ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Filter Articles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  // Active filter count badge
                  if (selectedSection.isNotEmpty || keywordCtrl.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${(selectedSection.isNotEmpty ? 1 : 0) + (keywordCtrl.text.isNotEmpty ? 1 : 0)} active',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.15), height: 1),

            // ---- Scrollable Content ----
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Keyword Search ----
                    Text(
                      'Search by Keyword',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: keywordCtrl,
                      style: TextStyle(color: textColor),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'e.g. climate, Iran, economy...',
                        hintStyle: TextStyle(color: subTextColor),
                        prefixIcon: Icon(Icons.search, color: subTextColor),
                        suffixIcon: keywordCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: subTextColor),
                                onPressed: () {
                                  keywordCtrl.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: Color(0xFF1A1A2E), width: 2),
                        ),
                        filled: true,
                        fillColor: chipBg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---- Section Filter ----
                    Text(
                      'Filter by Section',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: sectionFilters.map((s) {
                        final isSelected = selectedSection == s['value'];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedSection = s['value']!),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? const Color(0xFF1A1A2E) : chipBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1A1A2E)
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF1A1A2E)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  s['icon']!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  s['label']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isSelected
                                        ? Colors.white
                                        : subTextColor,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // ---- Buttons ----
                    Row(
                      children: [
                        // Clear button
                        Expanded(
                          child: OutlinedButton.icon(
                            // Clear button onPressed:
                            onPressed: () {
                              keywordCtrl.clear();
                              setState(() => selectedSection = '');
                              Get.back(); // pehle sheet band karo
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                controller.applyFilter();
                              });
                            },
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear All'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              foregroundColor: textColor,
                              side: BorderSide(
                                  color: Colors.grey.withOpacity(0.4)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Apply button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            // Apply button onPressed:
                            onPressed: () {
                              Get.back(); // pehle sheet band karo
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                controller.applyFilter(
                                  section: selectedSection,
                                  keyword: keywordCtrl.text.trim(),
                                );
                              });
                            },
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A1A2E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
