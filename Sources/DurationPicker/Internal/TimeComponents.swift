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

/// A model representing the duration displayed on the duration picker.
struct TimeComponents: Equatable {

  /// An enum describing how the components should be rounded.
  ///
  /// Only applies when the hour, minute, and/or second intervals are not equal to 1.
  enum RoundingMode {

    /// Round up to the nearest allowed value.
    case up

    /// Round down to the nearest allowed value.
    case down
  }

  /// An integer representing the hour component of the duration picker. Between 0 and 23.
  var hour: Int

  /// An integer representing the minute component of the duration picker. Between 0 and 59.
  var minute: Int

  /// An integer representing the second component of the duration picker. Between 0 and 59.
  var second: Int

  /// The total duration (in seconds) represented by the time components.
  var duration: Int {
    TimeUtils.seconds(
      fromHours: hour,
      minutes: minute,
      seconds: second)
  }

  /// Creates a ``TimeComponents`` instance with the provided hour, minute, and second components.
  ///
  /// - Parameters:
  ///   - uncheckedHour: The hour component. must be within 0 and 23.
  ///   - uncheckedMinute: The minute component, must be within 0 and 59.
  ///   - uncheckedSecond: The second component, must be within 0 and 59.
  init(uncheckedHour: Int = 0,
       uncheckedMinute: Int = 0,
       uncheckedSecond: Int = 0) {
    precondition(
      (0..<NumberOfHours).contains(uncheckedHour),
      "Hour not in the range [0, \(NumberOfHours)]")
    precondition(
      (0..<NumberOfMinutes).contains(uncheckedMinute),
      "Minute not in the range [0, \(NumberOfMinutes)]")
    precondition(
      (0..<NumberOfSeconds).contains(uncheckedSecond),
      "Second not in the range [0, \(NumberOfSeconds)]")
    hour = uncheckedHour
    minute = uncheckedMinute
    second = uncheckedSecond
  }

  /// Creates a ``TimeComponents`` instance from the provided duration, respecting picker mode and rounding options.
  ///
  /// - Parameters:
  ///   - duration: The duration in seconds.
  ///   - pickerMode: The mode of the duration picker.
  ///   - minimumDuration: The optional minimum duration, defaults to nil.
  ///   - maximumDuration: The optional maximum duration, defaults to nil.
  ///   - roundingMode: The rounding mode to apply, defaults to `.down`.
  ///   - hourInterval: The interval for hours, defaults to 1.
  ///   - minuteInterval: The interval for minutes, defaults to 1.
  ///   - secondInterval: The interval for seconds, defaults to 1.
  ///
  /// - Returns: A ``TimeComponents`` instance rounded and clamped based on the provided options.
  static func components(fromDuration duration: Int,
                         pickerMode: DurationPicker.Mode = .hourMinuteSecond,
                         minimumDuration: Int? = nil,
                         maximumDuration: Int? = nil,
                         roundingMode: RoundingMode = .down,
                         hourInterval: Int = 1,
                         minuteInterval: Int = 1,
                         secondInterval: Int = 1) -> TimeComponents {
    let roundedMinimumDuration = TimeUtils.roundedDuration(
      minimumDuration ?? 0,
      forPickerMode: pickerMode,
      roundingRule: .up,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    let absoluteMaximumDuration = TimeUtils.absoluteMaximumDuration(
      forPickerMode: pickerMode,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    let roundedMaximumDuration = TimeUtils.roundedDuration(
      maximumDuration ?? absoluteMaximumDuration,
      forPickerMode: pickerMode,
      roundingRule: .down,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    let isMinMaxOrderValid = roundedMinimumDuration <= roundedMaximumDuration

    let roundedComponents = roundingMode == .down
    ? roundedDownComponents(
      fromDuration: duration,
      minimumDuration: isMinMaxOrderValid ? roundedMinimumDuration : 0,
      maximumDuration: isMinMaxOrderValid ? roundedMaximumDuration : absoluteMaximumDuration,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)
    : roundedUpComponents(
      fromDuration: duration,
      minimumDuration: isMinMaxOrderValid ? roundedMinimumDuration : 0,
      maximumDuration: isMinMaxOrderValid ? roundedMaximumDuration : absoluteMaximumDuration,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    // Zero out specific components based on the picker mode
    switch pickerMode {
    case .hour:
      return TimeComponents(uncheckedHour: roundedComponents.hour)
    case .hourMinute:
      return TimeComponents(
        uncheckedHour: roundedComponents.hour,
        uncheckedMinute: roundedComponents.minute)
    case .hourMinuteSecond:
      return roundedComponents
    case .minute:
      return TimeComponents(uncheckedMinute: roundedComponents.minute)
    case .minuteSecond:
      return TimeComponents(
        uncheckedMinute: roundedComponents.minute,
        uncheckedSecond: roundedComponents.second)
    case .second:
      return TimeComponents(uncheckedSecond: roundedComponents.second)
    }
  }

  private static func roundedDownComponents(fromDuration duration: Int,
                                            minimumDuration: Int,
                                            maximumDuration: Int,
                                            hourInterval: Int,
                                            minuteInterval: Int,
                                            secondInterval: Int) -> TimeComponents {
    let clampedDuration = duration.clamped(to: minimumDuration...maximumDuration)

    let hour = clampedDuration.quotientAndRemainder(dividingBy: hourInterval * OneHour)
    let hourRemainder = min(hour.remainder, OneHour - minuteInterval)

    let minute = hourRemainder.quotientAndRemainder(dividingBy: minuteInterval * NumberOfSeconds)
    let minuteRemainder = min(minute.remainder, NumberOfSeconds - secondInterval)

    let second = minuteRemainder.quotientAndRemainder(dividingBy: secondInterval)

    return TimeComponents(
      uncheckedHour: hour.quotient * hourInterval,
      uncheckedMinute: minute.quotient * minuteInterval,
      uncheckedSecond: second.quotient * secondInterval)
  }

  private static func roundedUpComponents(fromDuration duration: Int,
                                          minimumDuration: Int,
                                          maximumDuration: Int,
                                          hourInterval: Int,
                                          minuteInterval: Int,
                                          secondInterval: Int) -> TimeComponents {
    let clampedDuration = duration.clamped(to: minimumDuration...maximumDuration)

    // There are some special cases where we actually round _down_
    // For example, if clampedDuration is equal to the absolute maximum 23:59:59 and secondInterval == 2,
    // we cannot round up to 24:00:00
    if clampedDuration == maximumDuration {
      return roundedDownComponents(
        fromDuration: clampedDuration,
        minimumDuration: minimumDuration,
        maximumDuration: maximumDuration,
        hourInterval: hourInterval,
        minuteInterval: minuteInterval,
        secondInterval: secondInterval)
    }

    let hour = clampedDuration.quotientAndRemainder(dividingBy: hourInterval * OneHour)
    // If we cannot fit the hour remainder into the minute and second components, make space in the hour component
    let additionalHourInterval = hour.remainder <= OneHour - minuteInterval * NumberOfSeconds ? 0 : hourInterval
    let hourRemainder = max(hour.remainder - additionalHourInterval * OneHour, 0)
    let numberOfHours = min(
      NumberOfHours - hourInterval,
      hour.quotient * hourInterval + additionalHourInterval)

    let minute = hourRemainder.quotientAndRemainder(dividingBy: minuteInterval * NumberOfSeconds)
    // If we cannot fit the minute remainder into the second component, make space in the minute component
    let additionalMinuteInterval = minute.remainder <= NumberOfSeconds - secondInterval ? 0 : minuteInterval
    let minuteRemainder = max(minute.remainder - additionalMinuteInterval * NumberOfSeconds, 0)
    let numberOfMinutes = min(
      NumberOfMinutes - minuteInterval,
      minute.quotient * minuteInterval + additionalMinuteInterval)

    let second = minuteRemainder.quotientAndRemainder(dividingBy: secondInterval)
    let additionalSecondInterval = second.remainder == 0 ? 0 : secondInterval
    let numberOfSeconds = min(
      NumberOfSeconds - secondInterval,
      second.quotient * secondInterval + additionalSecondInterval)

    return TimeComponents(
      uncheckedHour: numberOfHours,
      uncheckedMinute: numberOfMinutes,
      uncheckedSecond: numberOfSeconds)
  }
}
