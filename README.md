# AsyncDataLoader
> AsyncDataLoader is a Swift module that provides asynchronous data loading functionalities for iOS applications. It offers the ability to load data from a URL asynchronously, download data asynchronously from a URL, and clear the cache asynchronously. This module is designed to handle various caching scenarios efficiently.

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![codecov](https://codecov.io/gh/alvinh77/async-data-loader/graph/badge.svg?token=ORSSZ7CCA8)](https://codecov.io/gh/alvinh77/async-data-loader)

## Features
- Asynchronous data loading from a URL
- Asynchronous data downloading from a URL
- Cache management for efficient data storage
- Support for in-memory caching and disk caching
- Customizable cache and download managers

## Installation
You can integrate AsyncDataLoader into your project using Swift Package Manager (SPM) or manually.

### Swift Package Manager
Add the following dependency to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/alvinh77/async-data-loader", .branch("main"))
]   
```
### Manual Installation
Clone the repository or download the source code, then drag and drop the `AsyncDataLoader` folder into your Xcode project.

## Usage
Import the module wherever you need to use it:
```swift
import AsyncDataLoader
```
Initialize an instance of `AsyncDataLoader` with appropriate cache and download managers:
```swift
let asyncDataLoader = AsyncDataLoader(
    diskCacheManager: DiskCacheManager(fileMananger: FileManager.default),
    downloadManager: DownloadManager(downloadSessionFactory: DownloadSessionFactory(serverSession: URLSession.shared)),
    inMemoryCacheMananger: InMemoryCacheManager(cache: .init()),
    serverSession: URLSession.shared
)
```
Use the provided methods to load or download data asynchronously:
```swift
// Load data from a URL asynchronously
let data = try await asyncDataLoader.data(from: urlString)
// Handle the loaded data
imageView.image = UIImage(data: data)

// Download data from a URL with progress asynchronously
let stream = try await asyncDataLoader.download(from: imageURL)
for try await status in stream {
    switch status {
    case let .inProgress(progress):
        // Update progress, eg. progress indicator
        progressIndicator.progress = progress
    case let .finished(data):
        // Hide progress indicator and load image
        progressIndicator.isHidden = true
        imageView.image = UIImage(data: data)
    }
}
```
Optionally, clear the cache when necessary:
```swift
// Clear the cache asynchronously
try await asyncDataLoader.clearCache()
```

## Requirements
- Swift 5.9+
- iOS 15.0+
- Xcode 15.0+

## Coverage
![Logo](https://codecov.io/gh/alvinh77/async-data-loader/graphs/tree.svg?token=ORSSZ7CCA8)

## License
`AsyncDataLoader` is available under the MIT license. See the [LICENSE][license-url] file for more information.

## Contribution
Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.

[swift-image]:https://img.shields.io/badge/swift-5.9-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: https://github.com/alvinh77/async-data-loader/blob/main/LICENSE
