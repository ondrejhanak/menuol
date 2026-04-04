# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make lint       # Run SwiftLint (output: swiftlint.html)
make lint-json  # Run SwiftLint (output: swiftlint.json, for programmatic processing)
make format     # Run SwiftFormat on all Swift files
make test       # Run unit tests with thread sanitizer on iPhone 15 Pro
make unused     # Find unused code via Periphery
```

To fix linter issues, run `make lint-json` first, then read `swiftlint.json`.

To run a single test class:
```bash
xcodebuild test -scheme menuol -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:tests/HTMLParserTests
```

## Architecture

iOS app (Swift 5, strict concurrency, minimum iOS 17, SwiftUI + MVVM-C). Prefer `@Observable` over Combine.

**Project structure:** The Xcode project uses folder-based file references — adding or renaming files on disk is automatically reflected in Xcode with no need to update `project.pbxproj` manually.

**Data flow:**
`olomouc.cz` HTML → `HTTPClient` (fetch) → `HTMLParser` (Kanna/XPath) → `VenueFetcher` → ViewModels → Views

**Dependency injection** is manual constructor injection. Each dependency has a `*Type` protocol with a real implementation and a mock (e.g. `HTTPClientType` / `HTTPClient` / `MockHTTPClient`). All `*Type` protocols conform to `Sendable` to support strict concurrency checking.

**Mocks:** Test-only mocks live in `tests/Mocks/`. Mocks needed for Xcode Previews live in the app target under `#if DEBUG`. Naming convention: `Mock` prefix (e.g. `MockHTMLParser`).

**Navigation** is handled by `AppCoordinator`, which owns a `NavigationPath` and maps `AppRoute` enum cases to views. `AppView` hosts the `NavigationStack` and routes all navigation through the coordinator.

**Scenes:** `VenueList` (search, favorites, fetch on app foreground) → `MenuList` (menu items for a selected venue).

**Persistence:** `FavoritesStorage` (`menuol/Classes/FavoritesStorage.swift`) stores favorited venue slugs via `UserDefaultsType` (protocol over `UserDefaults`). Conforms to `FavoritesStorageType` for mockability.

**Key files:**
- `menuol/Classes/AppCoordinator.swift` — navigation logic
- `menuol/Classes/HTMLParser.swift` — XPath-based HTML scraping
- `menuol/Classes/VenueFetcher.swift` — pure data-fetching service (Sendable, returns `[Venue]`); venue state is owned by `VenueListViewModel`
- `menuol/Classes/Geocoder.swift` — coordinate lookup (actor)
- `tests/` — `HTMLParserTests`, `HTTPClientTests`, `AppCoordinatorTests`

## Testing

Tests use modern Swift Testing (`@Test`, `#expect`), not XCTest.
