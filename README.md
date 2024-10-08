# Menu Olomouc

Simple helper app that fetches local lunch menu specials in my home city Olomouc. Aggregator site [olomouc.cz](https://www.olomouc.cz/poledni-menu/) does not expose API, so app has to fetch HTML page, parse DOM and show results in a digestible way. On top of plain display, there is possibility to search and favorite places.

Project was created for personal usage.


## Tech

- Swift 5
- Strict Concurrency Checking: `Complete`
- SwiftUI for user interface
- [Kanna](https://github.com/tid-kijyun/Kanna) library for HTML parsing
- Fastlane for running configured `swiftlint` and `swiftformat`
- `automatic` code signing setup because of personal nature of the project
- basic unit tests for HTTP fetcher and HTML parser


## Preview

![Venues list](screenshot_venues.png) ![Menu items](screenshot_menu.png)
