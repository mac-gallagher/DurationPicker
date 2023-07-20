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

/// A formatter that provides localized representations of duration measurements.
final class DurationFormatter {

  /// The list of all units of duration supported by the duration picker.
  enum UnitType {

    /// Represents the hour unit.
    case hour

    /// Represents the minute unit.
    case minute

    /// Represents the second unit.
    case second
  }

  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    // We currently only support languages with Western Arabic numerals
    formatter.locale = Locale(identifier: "en")
    return formatter
  }()

  /// Creates and returns a localized string representation of the provided value.
  ///
  /// - Parameter value: The value to be represented.
  /// - Parameter unit: The unit of duration to be represented.
  ///
  /// - Returns: A user-readable string that represents the value.
  func string(fromValue value: Int,
              unit: UnitType) -> String? {
    guard let valueString = string(fromValue: value) else {
      return nil
    }
    let unitString = unitString(
      fromValue: value,
      unit: unit)
    return valueString + " " + unitString
  }

  /// Creates and returns a localized string representation of the provided value, not including the unit string.
  ///
  /// - Parameter value: The value to be represented.
  ///
  /// - Returns: A user-readable string that represents the value, not including the unit string.
  func string(fromValue value: Int) -> String? {
    numberFormatter.string(from: NSNumber(value: value))
  }

  /// Creates and returns a localized string representation of the provided unit of duration.
  ///
  /// - Parameters:
  ///   - value: The value corresponding to the unit.
  ///   - unit: The unit of duration to be represented.
  ///
  /// - Returns: A user-readable string that represents the unit of duration.
  func unitString(fromValue value: Int,
                  unit: UnitType) -> String {
    switch unit {
    case .hour:
      hourUnitText(fromHour: value)
    case .minute:
      minuteUnitText(fromMinute: value)
    case .second:
      secondUnitText(fromSecond: value)
    }
  }

  /// Returns all possible unit strings for the provided unit of duration.
  ///
  /// - Parameter unit: The unit of duration for which unit strings are requested.
  ///
  /// - Returns: An array containing all possible localized unit strings for the specified unit.
  func possibleUnitStrings(forUnit unit: UnitType) -> [String] {
    switch unit {
    case .hour:
      [String(localizedFromModule: "hour_zero"),
       String(localizedFromModule: "hour_singular"),
       String(localizedFromModule: "hour_plural")]
    case .minute:
      [String(localizedFromModule: "minute_zero"),
       String(localizedFromModule: "minute_singular"),
       String(localizedFromModule: "minute_plural")]
    case .second:
      [String(localizedFromModule: "second_zero"),
       String(localizedFromModule: "second_singular"),
       String(localizedFromModule: "second_plural")]
    }
  }

  private func hourUnitText(fromHour hour: Int) -> String {
    if hour == 0 {
      return String(localizedFromModule: "hour_zero")
    }
    if hour == 1 {
      return String(localizedFromModule: "hour_singular")
    }
    return String(localizedFromModule: "hour_plural")
  }

  private func minuteUnitText(fromMinute minute: Int) -> String {
    if minute == 0 {
      return String(localizedFromModule: "minute_zero")
    }
    if minute == 1 {
      return String(localizedFromModule: "minute_singular")
    }
    return String(localizedFromModule: "minute_plural")
  }

  private func secondUnitText(fromSecond second: Int) -> String {
    if second == 0 {
      return String(localizedFromModule: "second_zero")
    }
    if second == 1 {
      return String(localizedFromModule: "second_singular")
    }
    return String(localizedFromModule: "second_plural")
  }
}
