import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
import '../utils/category_helper.dart';
import '../widgets/category_card.dart';
import '../widgets/error_retry_widget.dart';
import '../widgets/loading_widget.dart';
import 'quiz_config_screen.dart';

/// Screen 2: Category Selection (Matches Figma Screenshot 2)
/// Displays available trivia categories fetched from OpenTDB with pastel cards,
/// caching per session, skeleton loading, and retry on network failure.
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch categories on first load (CategoryProvider caches results for session)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CategoryProvider>();
      if (!provider.hasCategories && !provider.isLoading) {
        provider.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const SizedBox.shrink(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section matching Screenshot 2
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quizzical',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'choose a category to focus on:',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Content Area (Loading, Error, or Category Grid)
                Expanded(
                  child: Consumer<CategoryProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading && !provider.hasCategories) {
                        return const CategorySkeletonGrid();
                      }

                      if (provider.error != null && !provider.hasCategories) {
                        return ErrorRetryWidget(
                          title: 'Unable to Load Categories',
                          message: provider.error!,
                          buttonText: 'Retry',
                          onRetry: () => provider.retry(),
                        );
                      }

                      final categories = CategoryHelper.sortCategoriesForDisplay(
                          provider.categories);

                      if (categories.isEmpty) {
                        return Center(
                          child: ErrorRetryWidget(
                            title: 'No Categories Available',
                            message: 'Could not find any categories right now.',
                            buttonText: 'Refresh',
                            onRetry: () => provider.retry(),
                          ),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          int crossAxisCount = 2;
                          double childAspectRatio = 0.80;

                          if (width >= 720) {
                            crossAxisCount = 4;
                            childAspectRatio = 0.88;
                          } else if (width >= 480) {
                            crossAxisCount = 3;
                            childAspectRatio = 0.84;
                          } else {
                            crossAxisCount = 2;
                            childAspectRatio = 0.80;
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: categories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return CategoryCard(
                                category: category,
                                index: index,
                                onTap: () {
                                  // Pass selected category to QuizProvider and navigate
                                  final quizProvider =
                                      context.read<QuizProvider>();
                                  quizProvider.selectCategory(
                                      category.id, category.name);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const QuizConfigScreen(),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
