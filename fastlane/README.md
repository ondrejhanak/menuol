fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### lint
```
fastlane lint
```
Runs swiftlint tool.
### format
```
fastlane format
```
Runs swiftformat tool.
### unit_tests
```
fastlane unit_tests
```
Runs unit tests.
### app_icons
```
fastlane app_icons
```
Creates app icons.
### unused
```
fastlane unused
```
Searches unused code.
### longs
```
fastlane longs
```
Lists logest source files.

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
