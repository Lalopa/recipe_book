# Changelog

## 0.6.1+20 (2025-01-27)

### Added
- feat(di): add MealBloc to dependency injection configuration
  - Register MealBloc factory in GetIt configuration
  - Ensure proper dependency injection for meal-related functionality
  - Maintain dependency injection pattern consistency

### Changed
- refactor(favorites): replace FavoriteMealWidget with MealPreviewWidget in favorites page
  - Use MealPreviewWidget for consistent meal display across the app
  - Remove unused FavoriteMealWidget import
  - Ensure consistent UI and functionality between meals and favorites pages
- perf(cache): optimize ObjectBoxCacheManager code formatting and structure
  - Improve code readability with better line breaks and formatting
  - Maintain consistent code style across cache management functions
- perf(meals): optimize meals page code formatting and structure
  - Improve code readability with better line breaks and formatting
  - Maintain consistent code style across meal display functions
- perf(detail): optimize meal detail page code formatting and structure
  - Improve code readability with better line breaks and formatting
  - Maintain consistent code style across detail page functions

### Removed
- chore: remove unused build.yaml file
  - Clean up project configuration files
  - Remove unnecessary build configuration

## 0.6.0+19 (2025-01-27)

### Added
- feat(animations): implement Hero animations and custom page transitions
  - Add Hero tags for smooth image transitions between preview and detail pages
  - Implement custom PageRouteBuilder with slide transitions
  - Add entrance animations with TweenAnimationBuilder for smooth widget appearance
  - Include AnimatedScale for favorite button interactions
- feat(favorites): resolve missing ingredients issue in favorite meals
  - Automatically fetch complete meal data from cache when navigating from favorites
  - Ensure consistent meal data across all navigation paths
  - Maintain favorite status during data retrieval

### Fixed
- fix(cache): resolve ObjectBoxCacheManager initialization error in clear cache button
  - Use GetIt singleton instead of creating new instances
  - Ensure proper dependency injection for ObjectBoxCacheManager
  - Maintain existing functionality while resolving provider access issues

### Changed
- perf(animations): optimize animation durations and curves for better UX
  - Increase entrance animation duration to 800ms for smoother feel
  - Use easeOutCubic curve for natural animation progression

### Test
- test(meals): update MealPreviewWidget test to handle AnimatedScale wrapper
  - Update test to expect AnimatedScale instead of FavoriteButtonWidget directly
  - Verify that AnimatedScale contains FavoriteButtonWidget as child
  - Maintain test coverage for favorite icon positioning functionality
- test(search): update SearchPage test to match current Skeletonizer implementation
  - Update loading state test to expect Skeletonizer instead of SearchLoadingWidget
  - Add Skeletonizer import to test file
  - Maintain test coverage for loading state functionality

## 0.0.1 (2025-08-22)

### Added
- docs(changelog.md): changelog file was added to the project ([68ac785](https://github.com/Lac78534fb38311606eee1b960920a4bff13204))
