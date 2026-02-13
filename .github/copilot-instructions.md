# ShopQ Flutter App - AI Agent Instructions

## Project Overview
**ShopQ** is a Flutter-based grocery delivery app with category-based product browsing and tabbed navigation. Currently, the entire codebase is in [lib/main.dart](lib/main.dart) as a monolithic structure with dummy data.

### Key Architecture Components
- **HomePage** (StatefulWidget): Manages tab-based category navigation with dynamic AppBar color changes
- **TabContent**: Displays category banners and product grids with filtering logic
- **ProductGrid**: Renders 2-column grid of products with price, image, and ADD button
- **CategoriesPage**: Shows detailed category tiles with images
- **Data Models**: Inline Maps for products, categories, and detailedCategories (no database integration yet)

## Critical Workflow & Commands

### Development Commands
```bash
flutter pub get        # Install dependencies
flutter run            # Run on connected device/emulator (debug mode)
flutter run -v         # Verbose output for debugging issues
flutter analyze        # Check for lint violations
flutter test           # Run widget tests (currently only widget_test.dart exists)
flutter clean          # Clean build artifacts before troubleshooting
```

### Testing
- Tests are minimal; focus is on manual testing currently
- [test/widget_test.dart](test/widget_test.dart) contains only scaffold verification test
- No unit tests for business logic; UI tests are preferred when expanding

### Build & Platform-Specific
- **Android**: Configured with Gradle in [android/](android/) directory
- **iOS**: Configured in [ios/](ios/) directory; uses Flutter plugin auto-registration
- **Versioning**: `1.0.0+1` in pubspec.yaml; update both `version` and `build-number` for releases

## Project-Specific Patterns & Conventions

### State Management
- **No State Management Library Yet**: All state is local (e.g., TabController, AppBar color)
- **Pattern**: Stateful widgets with setState() for UI updates
- When adding features requiring shared state (cart, user auth), consider adding **Provider** or **Riverpod**

### Data Flow
1. **Dummy Data**: All products/categories hardcoded in main.dart as `List<Map<String, dynamic>>`
2. **No API Integration**: Currently no network calls; picsum.photos used for placeholder images
3. **Category Filtering**: Implemented inline in TabBarView.children using `.where()`
4. **Future Integration**: Expect API endpoints for products, categories, and user cart

### UI Patterns
- **TabBar with ScrollableTabBar**: Used for category navigation; tabs can scroll horizontally
- **GridView.builder**: Standard for product grids (2-column, 0.7 aspect ratio)
- **ClipRRect** + **Image.network**: Consistent image styling with rounded corners
- **Card** widgets: Wraps products and category items with consistent elevation/styling
- **SingleChildScrollView**: Top-level scroll for banner + product content

### Navigation
- **No Named Routes Yet**: All navigation commented out (`// Navigate to...`)
- **Future Pattern**: Expect implementation using Navigator 2.0 or go_router when full navigation is added
- **Entry Point**: HomePage is hardcoded as `home:` in MaterialApp

## Key Files & Their Responsibilities
| File | Purpose |
|------|---------|
| [lib/main.dart](lib/main.dart) | Single file containing entire app: theme, data, all widgets |
| [pubspec.yaml](pubspec.yaml) | Flutter SDK 3.9.2+, minimal dependencies (cupertino_icons, flutter_lints) |
| [analysis_options.yaml](analysis_options.yaml) | Lint rules; uses flutter_lints standard set |
| [test/widget_test.dart](test/widget_test.dart) | Basic widget test; extend when adding features |
| [android/](android/) , [ios/](ios/) | Native platform files; minimal custom code expected |

## Common Development Tasks

### Adding a New Feature
1. Add feature widget to [lib/main.dart](lib/main.dart) (eventually move to separate file)
2. Update navigation in HomePage or create new route
3. Add corresponding test in [test/](test/)
4. Run `flutter analyze` to catch lint issues

### Modifying Product List or Categories
- Edit `products` or `categories` List at top of [lib/main.dart](lib/main.dart)
- No database; changes are hardcoded until API integration

### Debugging Widget Issues
- Use `flutter run -v` for detailed logs
- Enable Dart DevTools: `flutter pub global activate devtools && flutter devtools`
- Check stderr output for widget rendering errors

## Important Conventions & Gotchas
- **No Null Safety Issues**: Project uses Dart 3.9.2+ (null safety enforced)
- **Asset Handling**: No local assets configured; images are network-based (picsum.photos)
- **State Persistence**: None currently; app resets on reload (no SharedPreferences/DB)
- **Platform-Specific Code**: iOS/Android folders exist but not actively modified; stick to Dart
- **Avoid Direct android/ or ios/ edits** unless instructed; use Flutter plugins instead

## Recommended Next Steps (If Expanding)
- **Modularize**: Split [lib/main.dart](lib/main.dart) into separate files (screens/, widgets/, models/)
- **State Management**: Integrate Provider or Riverpod for cart, user auth, product filters
- **API Integration**: Connect to backend for dynamic product/category data
- **Navigation**: Implement named routes or go_router for multi-screen flow
- **Localization**: Add i18n support for multi-language UI strings
