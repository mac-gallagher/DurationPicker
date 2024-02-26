# DurationPicker
[![CI](https://github.com/mac-gallagher/DurationPicker/actions/workflows/ci.yml/badge.svg)](https://github.com/mac-gallagher/DurationPicker/actions/workflows/ci.yml)
[![Documentation](https://github.com/mac-gallagher/DurationPicker/actions/workflows/documentation.yml/badge.svg)](https://github.com/mac-gallagher/DurationPicker/actions/workflows/documentation.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmac-gallagher%2FDurationPicker%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/mac-gallagher/DurationPicker)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmac-gallagher%2FDurationPicker%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/mac-gallagher/DurationPicker)

DurationPicker is an iOS library that provides a customizable control for inputting time values ranging between 0 and 24 hours. It serves as a drop-in replacement of [UIDatePicker](https://developer.apple.com/documentation/uikit/uidatepicker) with [countDownTimer](https://developer.apple.com/documentation/uikit/uidatepicker/mode/countdowntimer) mode with additional functionality for time input.

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://imgur.com/ADsLNpn.png" width=450>
    <img alt="A screenshot of a duration picker showing the selected value of 1 hour, 30 minutes, and 45 seconds." src="https://imgur.com/eBndHzh.png" width=450>
  </picture>
</p>

## Features

- [x] Styled to match `UIDatePicker` with `countDownTimer` mode
- [x] Multiple modes for selection of hours, minutes, and/or seconds
- [x] Option to specify intervals for hour, minute, and/or seconds
- [x] Support for minimum and maximum durations
- [x] Localization in [26+ languages](https://mac-gallagher.github.io/DurationPicker/documentation/durationpicker/localization)
- [x] Built-in support for accessibility and VoiceOver

## Usage

To use DurationPicker, simply create an instance of `DurationPicker` and add it to your view hierarchy. You can customize your picker using the following properties:

- `pickerMode`: The mode of the picker, determines whether the duration picker allows selection of hours, minutes, and/or seconds
- `{hour|minute|second}Interval`: The intervals at which the duration picker should display
- `{minimum|maximum}Duration`: The minimum/maximum duration that the picker can show

The code below will produce the following duration picker.

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://imgur.com/ugGjBPb.png" width=400>
    <img alt="A screenshot of a duration picker showing the selected value of 30 minutes and 30 seconds." src="https://imgur.com/Tu01Iwa.png" width=400>
  </picture>
</p>

```swift
import DurationPicker

let picker = DurationPicker()
addSubview(picker)

picker.pickerMode = .minuteSecond
picker.minuteInterval = 5
picker.secondInterval = 30
picker.minimumDuration = (15 * 60) // 15 minutes
picker.maximumDuration = (45 * 60) + 30 // 45 minutes, 30 seconds
```

The selected duration can also be set programmatically through the `duration` property. 

```swift
picker.duration = (30 * 60) + 30 // 30 minutes, 30 seconds
```

You can react to changes in the duration's picker value using [UIActions](https://developer.apple.com/documentation/uikit/uiaction).

```swift
let action = UIAction { [weak picker] _ in
    guard let picker else { return }
        print(picker.duration) // 1830
    },
    for: .primaryAction)
    
picker.addAction(action)
```

## Demo

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://imgur.com/uDKJiS4.jpg" width=300>
  <img alt="A screenshot of the demo project for DurationPicker." src="https://i.imgur.com/eUlm0Bh.png" width=300>
</picture>

To see `DurationPicker` in action, clone the repository and open the `DurationPickerDemo` project. 

In addition to demonstrating the features of `DurationPicker`, the demo app serves as an example of how a `DurationPicker` can be used in a [modern collection view](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views).

## Documentation
Full documentation available on [Github Pages](https://mac-gallagher.github.io/DurationPicker/documentation/durationpicker).

## Installation

### Swift Package Manager
DurationPicker is available through [Swift PM](<https://swift.org/package-manager/>). To install it, simply add the package as a dependency in `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/mac-gallagher/DurationPicker.git", from: "1.0.0"),
]
```

### Manual
Download and drop the `Sources` directory into your project.

## Requirements
- iOS 15.0+
- XCode 15.0+
- Swift 5.9+

## License

DurationPicker is available under the MIT license. See [LICENSE](LICENSE) for more information.

## Contributing
Contributions are welcome! Fork the repo, make your changes, and submit a pull request.
