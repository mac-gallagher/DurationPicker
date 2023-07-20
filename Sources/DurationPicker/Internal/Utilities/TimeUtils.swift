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

/// Utility methods for working with time-related calculations and durations.
enum TimeUtils {

  /// Calculates the total number of seconds from the provided hours, minutes, and seconds.
  ///
  /// - Parameters:
  ///   - hours: The number of hours.
  ///   - minutes: The number of minutes.
  ///   - seconds: The number of seconds.
  ///
  /// - Returns: The total number of seconds.
  static func seconds(fromHours hours: Int = 0,
                      minutes: Int = 0,
                      seconds: Int = 0) -> Int {
    hours * OneHour
    + minutes * OneMinute
    + seconds
  }

  /// Calculates the absolute maximum duration that can be displayed for the given picker mode and intervals.
  ///
  /// - Parameters:
  ///   - pickerMode: The mode of the duration picker.
  ///   - hourInterval: The interval for hours, defaults to 1.
  ///   - minuteInterval: The interval for minutes, defaults to 1.
  ///   - secondInterval: The interval for seconds, defaults to 1.
  ///
  /// - Returns: The absolute maximum duration in seconds.
  static func absoluteMaximumDuration(forPickerMode pickerMode: DurationPicker.Mode,
                                      hourInterval: Int = 1,
                                      minuteInterval: Int = 1,
                                      secondInterval: Int = 1) -> Int {
    seconds(
      fromHours: maximumNumberOfHours(
        forPickerMode: pickerMode,
        hourInterval: hourInterval),
      minutes: maximumNumberOfMinutes(
        forPickerMode: pickerMode,
        minuteInterval: minuteInterval),
      seconds: maximumNumberOfSeconds(
        forPickerMode: pickerMode,
        secondInterval: secondInterval))
  }

  /// Rounds the provided duration to the nearest allowed value based on the picker mode and intervals.
  ///
  /// - Parameters:
  ///   - duration: The duration to be rounded.
  ///   - pickerMode: The mode of the duration picker.
  ///   - roundingRule: The rounding rule to apply.
  ///   - hourInterval: The interval for hours, defaults to 1.
  ///   - minuteInterval: The interval for minutes, defaults to 1.
  ///   - secondInterval: The interval for seconds, defaults to 1.
  ///
  /// - Returns: The rounded duration.
  static func roundedDuration(_ duration: Int,
                              forPickerMode pickerMode: DurationPicker.Mode,
                              roundingRule: FloatingPointRoundingRule,
                              hourInterval: Int = 1,
                              minuteInterval: Int = 1,
                              secondInterval: Int = 1) -> Int {
    let absoluteMaximumDuration = absoluteMaximumDuration(
      forPickerMode: pickerMode,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    switch pickerMode {
    case .hour:
      let roundedDuration = duration.rounded(
        toNearest: hourInterval * OneHour,
        roundingRule: roundingRule)
      return roundedDuration.clamped(to: 0...absoluteMaximumDuration)
    case .hourMinute,
        .minute:
      let roundedDuration = duration.rounded(
        toNearest: minuteInterval * OneMinute,
        roundingRule: roundingRule)
      return roundedDuration.clamped(to: 0...absoluteMaximumDuration)
    case .hourMinuteSecond,
        .minuteSecond,
        .second:
      let roundedDuration = duration.rounded(
        toNearest: secondInterval,
        roundingRule: roundingRule)
      return roundedDuration.clamped(to: 0...absoluteMaximumDuration)
    }
  }

  /// Calculates the maximum number of hours that can be displayed for the given picker mode and interval.
  ///
  /// - Parameters:
  ///   - pickerMode: The mode of the duration picker.
  ///   - hourInterval: The hour interval.
  ///
  /// - Returns: The maximum number of hours that can be displayed.
  static func maximumNumberOfHours(forPickerMode pickerMode: DurationPicker.Mode,
                                   hourInterval: Int) -> Int {
    switch pickerMode {
    case .hour,
        .hourMinute,
        .hourMinuteSecond:
      NumberOfHours - hourInterval
    default: 0
    }
  }

  /// Calculates the maximum number of minutes that can be displayed for the given picker mode and interval.
  ///
  /// - Parameters:
  ///   - pickerMode: The mode of the duration picker.
  ///   - minuteInterval: The minute interval.
  ///
  /// - Returns: The maximum number of minutes that can be displayed.
  static func maximumNumberOfMinutes(forPickerMode pickerMode: DurationPicker.Mode,
                                     minuteInterval: Int) -> Int {
    switch pickerMode {
    case .hourMinuteSecond,
        .hourMinute,
        .minute,
        .minuteSecond:
      NumberOfMinutes - minuteInterval
    default: 0
    }
  }

  /// Calculates the maximum number of seconds that can be displayed for the given picker mode and interval.
  ///
  /// - Parameters:
  ///   - pickerMode: The mode of the duration picker.
  ///   - minuteInterval: The second interval.
  ///
  /// - Returns: The maximum number of seconds that can be displayed.
  static func maximumNumberOfSeconds(forPickerMode pickerMode: DurationPicker.Mode,
                                     secondInterval: Int) -> Int {
    switch pickerMode {
    case .hourMinuteSecond,
        .minuteSecond,
        .second:
      NumberOfSeconds - secondInterval
    default: 0
    }
  }
}
