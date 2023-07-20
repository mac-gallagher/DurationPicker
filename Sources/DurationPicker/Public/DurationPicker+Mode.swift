/// MIT License
///
/// Copyright (c) 2023 Mac Gallagher
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import Foundation

extension DurationPicker {

  /// The mode displayed by the duration picker.
  ///
  /// The mode determines which combination of hours, minutes, and seconds are displayed. You can set and retrieve the mode value through the ``DurationPicker/pickerMode`` property.
  public enum Mode {

    /// A mode that displays hour values, for example [ 1 ].
    case hour

    /// A mode that displays hour and minute values, for example [ 1 | 25 ].
    case hourMinute

    /// A mode that displays hour, minute, and second values, for example [ 1 | 25 | 41 ].
    case hourMinuteSecond

    /// A mode that displays minute values, for example [ 25 ].
    case minute

    /// A mode that displays minute and second values, for example [ 25 | 41 ].
    case minuteSecond

    /// A mode that displays second values, for example [ 41 ].
    case second
  }
}

// MARK: - Picker Mode + Components

/// The type of component displayed by the picker view.
enum DurationPickerComponentType {

  /// The component which displays the hour values.
  case hour

  /// The component which displays the minute values.
  case minute

  /// The component which displays the second values.
  case second
}

extension DurationPicker.Mode {

  /// A zero-indexed number identifing the the hour component of the picker view, or `nil` if the component is not present for the mode.
  var hourComponent: Int? {
    switch self {
    case .hour,
        .hourMinute,
        .hourMinuteSecond:
      return 0
    default:
      return nil
    }
  }

  /// A zero-indexed number identifing the the minute component of the picker view, or `nil` if the component is not present  for the mode.
  var minuteComponent: Int? {
    switch self {
    case .hourMinute,
        .hourMinuteSecond:
      return 1
    case .minute,
        .minuteSecond:
      return 0
    default:
      return nil
    }
  }

  /// A zero-indexed number identifing the the second component of the picker view, or `nil` if the component is not present for the mode.
  var secondComponent: Int? {
    switch self {
    case .hourMinuteSecond:
      return 2
    case .minuteSecond:
      return 1
    case .second:
      return 0
    default:
      return nil
    }
  }

  /// The number of components for the mode.
  var numberOfComponents: Int {
    switch self {
    case .hourMinuteSecond:
      return 3
    case .hourMinute,
        .minuteSecond:
      return 2
    case .hour,
        .minute,
        .second:
      return 1
    }
  }

  /// Returns the component type for the component of the picker view.
  ///
  /// - Parameter component: The component of the picker view.
  func componentType(fromComponent component: Int) -> DurationPickerComponentType? {
    if component == hourComponent { return .hour }
    if component == minuteComponent { return .minute }
    if component == secondComponent { return .second }
    return nil
  }
}
