import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/category_helper.dart';

/// Card widget displaying a trivia category with soft pastel background,
/// themed icon badge, and formatted title (Matches Figma Screenshot 2).
class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = CategoryHelper.getBackgroundColor(category.name, index);
    final assetImage = CategoryHelper.getAssetImage(category.name);
    final displayName = CategoryHelper.formatName(category.name);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: Colors.black.withValues(alpha: 0.05),
        highlightColor: Colors.black.withValues(alpha: 0.03),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Illustrated Visual matching Figma Frame 1
              Expanded(
                child: Center(
                  child: assetImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            assetImage,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackIcon(bgColor);
                            },
                          ),
                        )
                      : _buildFallbackIcon(bgColor),
                ),
              ),
              const SizedBox(height: 6),

              // Category Title aligned to bottom-left matching Figma Frame 1
              Text(
                displayName,
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.3,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(Color bgColor) {
    final icon = CategoryHelper.getIcon(category.name);
    final iconColor = CategoryHelper.getIconColor(bgColor);
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 28,
        color: iconColor,
      ),
    );
  }
}
