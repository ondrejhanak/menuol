# Menu Olomouc

Simple helper app that fetches local lunch menu specials in my home city Olomouc. Aggregator site [olomouc.cz](https://www.olomouc.cz/poledni-menu/) does not expose API, so app has to fetch HTML page, parse DOM and show results in a digestible way. On top of plain display, there is possibility to search and favorite places.

Project was created for personal usage.


## Tech

- Swift 6 language
- SwiftUI, `@Observable` and MVVM-C architecture
- [Kanna](https://github.com/tid-kijyun/Kanna) package for HTML parsing
- Manual protocols based constructor injection
- Fastlane for running configured `swiftlint` and `swiftformat`
- `automatic` code signing setup because of personal nature of the project
- Unit tests


## Preview

![Venue list](screenshot1.png) ![Menu items](screenshot2.png)
