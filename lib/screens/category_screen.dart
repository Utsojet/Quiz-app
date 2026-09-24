import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/app_colors.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section matching Screenshot 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
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

                  final categories = provider.categories;

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

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        category: category,
                        index: index,
                        onTap: () {
                          // Pass selected category to QuizProvider and navigate
                          final quizProvider = context.read<QuizProvider>();
                          quizProvider.selectCategory(category.id, category.name);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuizConfigScreen(),
                            ),
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
    );
  }
}
