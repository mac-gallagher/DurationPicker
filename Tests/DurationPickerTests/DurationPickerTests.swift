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

@testable import DurationPicker
import XCTest

/// Tests which cover the basic functionality of `DurationPicker`.
///
/// We also include some tests which compare behavior against `UIDatePicker` with `countDownTimer` mode.
final class DurationPickerTests: XCTestCase {

  /// The duration picker used for testing.
  private var durationPicker: DurationPicker!

  /// A date picker instance used for comparison purposes.
  private var datePicker: UIDatePicker!

  override func setUp() {
    super.setUp()
    durationPicker = DurationPicker()
    datePicker = UIDatePicker()
    datePicker.datePickerMode = .countDownTimer
  }

  // MARK: - Initializer Date Picker Comparison

  /// Tests whether the initial frame of a `DurationPicker` initialized with a zero frame matches that of a `UIDatePicker`.
  func testInitWithZeroFrameComparisonWithDatePicker() {
    durationPicker.pickerMode = .hourMinute
    XCTAssertEqual(
      datePicker.frame.size,
      durationPicker.frame.size)
    XCTAssertEqual(
      durationPicker.frame.size,
      datePicker.intrinsicContentSize)
    XCTAssertEqual(
      datePicker.intrinsicContentSize,
      durationPicker.intrinsicContentSize)
  }

  /// Tests whether the frame of a `DurationPicker` initialized with non-zero frame matches that of a `UIDatePicker`.
  func testInitWithNonZeroFrameComparisonWithDatePicker() {
    let nonZeroFrame = CGRect(x: 1, y: 1, width: 1, height: 1)

    let durationPicker = DurationPicker(frame: nonZeroFrame)
    let datePicker = UIDatePicker(frame: nonZeroFrame)
    datePicker.datePickerMode = .countDownTimer

    XCTAssertEqual(
      datePicker.frame.size,
      durationPicker.frame.size)
    XCTAssertEqual(
      durationPicker.frame.size,
      datePicker.intrinsicContentSize)
    XCTAssertEqual(
      datePicker.intrinsicContentSize,
      durationPicker.intrinsicContentSize)
  }

  // MARK: - Event Handling

  /// Tests that updating the `duration` property on the picker triggers the expected actions.
  func testEventsOnDurationUpdate() {
    let valueChangedExpectation = XCTestExpectation(description: "Received update via the valueChanged event")
    let primaryActionExpectation = XCTestExpectation(description: "Received update via the primaryAction event")

    let updatedDuration = TimeInterval(1)

    durationPicker.addAction(
      UIAction { [weak self] _ in
        if self?.durationPicker.duration == updatedDuration {
          valueChangedExpectation.fulfill()
        }
      },
      for: .valueChanged)

    durationPicker.addAction(
      UIAction { [weak self] _ in
        if self?.durationPicker.duration == updatedDuration {
          primaryActionExpectation.fulfill()
        }
      },
      for: .primaryActionTriggered)

    durationPicker.duration = updatedDuration

    wait(for: [
      valueChangedExpectation,
      primaryActionExpectation])
  }

  // MARK: - Duration Rounding

  /// Tests that the rounding behavior of a duration picker with `hourMinute` mode matches that of a `UIDatePicker`.
  func testDurationRoundingDatePickerComparison() {
    durationPicker.pickerMode = .hourMinute
    datePicker.countDownDuration = twoMinutes - 1
    durationPicker.duration = twoMinutes - 1
    XCTAssertEqual(
      durationPicker.duration,
      datePicker.countDownDuration)
  }

  /// Tests rounding to the nearest hour.
  func testDurationRoundingHourMode() {
    durationPicker.pickerMode = .hour
    durationPicker.duration = twoHours - 1
    XCTAssertEqual(
      durationPicker.duration,
      oneHour)
  }

  /// Tests rounding to the nearest minute.
  func testDurationRoundingMinuteMode() {
    durationPicker.pickerMode = .minute
    durationPicker.duration = twoMinutes - 1
    XCTAssertEqual(
      durationPicker.duration,
      oneMinute)
  }

  /// Tests rounding to the nearest second.
  func testDurationRoundingSecondMode() {
    durationPicker.pickerMode = .second
    durationPicker.duration = twoSeconds - 0.5
    XCTAssertEqual(
      durationPicker.duration,
      oneSecond)
  }

  // MARK: - Minimum & Maximum Durations

  /// Tests that setting the minimum above the current duration will set the duration to the minimum.
  func testMinimumDuration() {
    durationPicker.duration = oneSecond
    durationPicker.minimumDuration = twoSeconds
    XCTAssertEqual(
      durationPicker.duration,
      twoSeconds)
  }

  /// Tests that setting a duration below the minimum will set it to the minimum.
  func testMinimumDurationAboveCurrentDuration() {
    durationPicker.minimumDuration = twoSeconds
    durationPicker.duration = oneSecond
    XCTAssertEqual(
      durationPicker.duration,
      twoSeconds)
  }

  /// Tests that setting a duration above the maximum will set it to the maximum.
  func testMaximumDuration() {
    durationPicker.maximumDuration = oneSecond
    durationPicker.duration = twoSeconds
    XCTAssertEqual(
      durationPicker.duration,
      oneSecond)
  }

  /// Tests that setting the maximum below the current duration will set the duration to the maximum.
  func testMaximumDurationBelowCurrentDuration() {
    durationPicker.duration = twoSeconds
    durationPicker.maximumDuration = oneSecond
    XCTAssertEqual(
      durationPicker.duration,
      oneSecond)
  }

  /// Tests that when setting the minimum above the absolute maximum duration, it will be ignored the current duration will remain unaffected.
  func testMinimumDurationAboveAbsoluteMaximumDuration() {
    let absoluteMaximumDuration = TimeUtils.absoluteMaximumDuration(forPickerMode: .hourMinuteSecond)
    durationPicker.duration = oneSecond
    durationPicker.minimumDuration = TimeInterval(absoluteMaximumDuration) + 1
    XCTAssertEqual(durationPicker.duration, oneSecond)
  }

  /// Tests that when setting the maximum below zero, it will be ignored and the current duration will remain unaffected.
  func testMaximumDurationBelowAbsoluteMinimumDuration() {
    durationPicker.duration = oneSecond
    durationPicker.maximumDuration = -1
    XCTAssertEqual(durationPicker.duration, oneSecond)
  }

  /// Tests that both the minimum and maximum durations are ignored when the minimum is greater than the maximum.
  func testMinimumDurationGreaterThanMaximumDuration() {
    durationPicker.minimumDuration = twoSeconds
    durationPicker.maximumDuration = oneSecond

    let timeBelowMinimum = TimeInterval(0)
    durationPicker.duration = 0
    XCTAssertEqual(
      durationPicker.duration,
      timeBelowMinimum)

    let timeAboveMaximum = TimeInterval(3)
    durationPicker.duration = timeAboveMaximum
    XCTAssertEqual(
      durationPicker.duration,
      timeAboveMaximum)
  }

  /// Tests whether the duration property is propertly rounded when the picker has a second interval with a non-divisible minimum duration.
  func testMinimumDurationSecondIntervalRounding() {
    durationPicker.pickerMode = .second
    durationPicker.secondInterval = 2
    durationPicker.minimumDuration = oneSecond
    durationPicker.duration = 0
    XCTAssertEqual(
      durationPicker.duration,
      twoSeconds)
  }

  /// Tests whether the duration property is propertly rounded when the picker has a minute interval with a non-divisible minimum duration.
  func testMinimumDurationMinuteIntervalRounding() {
    durationPicker.pickerMode = .minute
    durationPicker.minuteInterval = 2
    durationPicker.minimumDuration = oneMinute
    durationPicker.duration = 0
    XCTAssertEqual(
      durationPicker.duration,
      twoMinutes)
  }

  /// Tests whether the duration property is propertly rounded when the picker has an hour interval with a non-divisible minimum duration.
  func testMinimumDurationHourIntervalRounding() {
    durationPicker.pickerMode = .hour
    durationPicker.hourInterval = 2
    durationPicker.minimumDuration = oneHour
    durationPicker.duration = 0
    XCTAssertEqual(
      durationPicker.duration,
      twoHours)
  }

  /// Tests whether the duration property is propertly rounded when the picker has a second interval with a non-divisible maximum duration.
  func testMaximumDurationSecondIntervalRounding() {
    durationPicker.pickerMode = .second
    durationPicker.secondInterval = 2
    durationPicker.maximumDuration = threeSeconds
    durationPicker.duration = fourSeconds
    XCTAssertEqual(
      durationPicker.duration,
      twoSeconds)
  }

  /// Tests whether the duration property is properly rounded when the picker has a minute interval with a non-divisible maximum duration.
  func testMaximumDurationMinuteIntervalRounding() {
    durationPicker.pickerMode = .minute
    durationPicker.minuteInterval = 2
    durationPicker.maximumDuration = threeMinutes
    durationPicker.duration = fourMinutes
    XCTAssertEqual(
      durationPicker.duration,
      twoMinutes)
  }

  /// Tests whether the duration property is properly rounded when the picker has an hour interval with a non-divisible maximum duration.
  func testMaximumDurationHourIntervalRounding() {
    durationPicker.pickerMode = .hour
    durationPicker.hourInterval = 2
    durationPicker.maximumDuration = threeHours
    durationPicker.duration = fourHours
    XCTAssertEqual(
      durationPicker.duration,
      twoHours)
  }

  /// Tests whether the duration property is properly rounded (based on the next component's intervals) when the minimum duration does not allow for any values in the current component.
  func testMinimumDurationRoundingToNextComponentWithInterval() {
    durationPicker.pickerMode = .minuteSecond
    durationPicker.minuteInterval = 2
    durationPicker.minimumDuration = oneMinute
    XCTAssertEqual(
      durationPicker.duration,
      twoMinutes)
  }

  /// Tests whether the duration property is properly rounded (based on the previous component's intervals) when the maximum duration does not allow for any values in the current component.
  func testMaximumDurationRoundingToPreviousComponentWithInterval() {
    durationPicker.pickerMode = .minuteSecond
    durationPicker.duration = twoMinutes
    durationPicker.secondInterval = 2
    durationPicker.maximumDuration = oneMinute - 1
    XCTAssertEqual(
      durationPicker.duration,
      fiftyEightSeconds)
  }

  // MARK: - Picker Mode

  /// Tests whether setting the picker mode rounds the duration to the nearest allowed value.
  func testPickerModeUpdate() {
    durationPicker.duration = oneMinute + thirtySeconds
    durationPicker.pickerMode = .minute
    XCTAssertEqual(durationPicker.duration, oneMinute)
  }

  // MARK: - Hour Interval

  /// Tests whether setting the hour interval to a negative value resets it to 1.
  func testHourIntervalNegative() {
    durationPicker.hourInterval = -1
    XCTAssertEqual(durationPicker.hourInterval, 1)
  }

  /// Tests whether setting the hour interval to zero resets it to 1.
  func testHourIntervalZero() {
    durationPicker.hourInterval = 0
    XCTAssertEqual(durationPicker.hourInterval, 1)
  }

  /// Tests whether setting the hour interval to a value larger than 12 resets it to 1.
  func testHourIntervalLargerThanTwelve() {
    durationPicker.hourInterval = 24
    XCTAssertEqual(durationPicker.hourInterval, 1)
  }

  /// Tests whether setting the hour interval to a non-divisible value resets it to 1.
  func testHourIntervalNonDivisibility() {
    durationPicker.hourInterval = 13
    XCTAssertEqual(durationPicker.hourInterval, 1)
  }

  /// Tests whether the current duration is rounded down to the nearest allowed hour when setting an hour interval.
  func testHourInterval() {
    durationPicker.pickerMode = .hour
    durationPicker.duration = oneHour
    durationPicker.hourInterval = 2
    XCTAssertEqual(durationPicker.duration, 0)
  }

  /// Tests whether setting a duration which is not a multiple of the hour interval rounds down to the nearest allowed hour.
  func testHourIntervalNonMultipleDuration() {
    durationPicker.pickerMode = .hour
    durationPicker.hourInterval = 12
    durationPicker.duration = twelveHours + 1
    XCTAssertEqual(durationPicker.duration, twelveHours)
  }

  // MARK: Minute Interval Date Picker Comparison

  /// Tests whether the rounding behavior of a duration picker when setting a negative minute interval matches that of a `UIDatePicker`.
  func testMinuteIntervalDatePickerComparisonNegative() {
    durationPicker.pickerMode = .hourMinute
    durationPicker.minuteInterval = -1
    datePicker.minuteInterval = -1
    XCTAssertEqual(
      durationPicker.secondInterval,
      datePicker.minuteInterval)
  }

  /// Tests whether the rounding behavior of a duration picker when setting a zero minute interval matches that of a `UIDatePicker`.
  func testMinuteIntervalDatePickerComparisonZero() {
    durationPicker.pickerMode = .hourMinute
    durationPicker.minuteInterval = 0
    datePicker.minuteInterval = 0
    XCTAssertEqual(
      durationPicker.secondInterval,
      datePicker.minuteInterval)
  }

  /// Tests whether the rounding behavior of a duration picker when setting a minute interval larger than 30 matches that of a `UIDatePicker`.
  func testMinuteIntervalDatePickerComparisonLargerThirty() {
    durationPicker.pickerMode = .hourMinute
    durationPicker.minuteInterval = 60
    datePicker.minuteInterval = 60
    XCTAssertEqual(
      durationPicker.secondInterval,
      datePicker.minuteInterval)
  }

  /// Tests whether the rounding behavior of a duration picker when setting a non-divisible minute interval matches that of a `UIDatePicker`.
  func testMinuteIntervalDatePickerComparisonNonDivisible() {
    durationPicker.pickerMode = .hourMinute
    durationPicker.minuteInterval = 59
    datePicker.minuteInterval = 59
    XCTAssertEqual(
      durationPicker.secondInterval,
      datePicker.minuteInterval)
  }

  /// Tests whether the rounding behavior of the duration property is the same as a `UIDatePicker` when setting a minute interval.
  func testMinuteIntervalDatePickerComparison() {
    durationPicker.pickerMode = .hourMinute
    durationPicker.minuteInterval = 15
    durationPicker.duration = thirtyMinutes
    datePicker.minuteInterval = 15
    datePicker.countDownDuration = thirtyMinutes

    XCTAssertEqual(
      durationPicker.duration,
      datePicker.countDownDuration)
  }

  /// Tests whether the behavior of a duration picker matches that of a `UIDatePicker` when setting a duration which is not a multiple of the minute interval.
  func testMinuteIntervalNonMultipleDurationDatePickerComparison() {
    durationPicker.pickerMode = .hour
    durationPicker.hourInterval = 12
    durationPicker.duration = twelveHours + 1
    XCTAssertEqual(
      durationPicker.duration,
      twelveHours)
  }

  // MARK: - Minute Interval

  /// Tests whether setting the minute interval to a negative value resets it to 1.
  func testMinuteIntervalNegative() {
    durationPicker.minuteInterval = -1
    XCTAssertEqual(durationPicker.minuteInterval, 1)
  }

  /// Tests whether setting the minute interval to zero resets it to 1.
  func testMinuteIntervalZero() {
    durationPicker.minuteInterval = 0
    XCTAssertEqual(durationPicker.minuteInterval, 1)
  }

  /// Tests whether setting the minute interval to a value larger than 30 resets it to 1.
  func testMinuteIntervalLargerThanThirty() {
    durationPicker.minuteInterval = 60
    XCTAssertEqual(durationPicker.minuteInterval, 1)
  }

  /// Tests whether setting a minute interval properly rounds the current duration down to the nearest allowed minute.
  func testMinuteIntervalNonDivisibility() {
    durationPicker.minuteInterval = 59
    XCTAssertEqual(durationPicker.minuteInterval, 1)
  }

  /// Tests whether the current duration is rounded down to the nearest allowed minute when setting a minute interval.
  func testMinuteInterval() {
    durationPicker.pickerMode = .minute
    durationPicker.duration = oneMinute
    durationPicker.minuteInterval = 2
    XCTAssertEqual(durationPicker.duration, 0)
  }

  /// Tests whether setting a duration which is not a multiple of the minute interval rounds down to the nearest allowed minute.
  func testMinuteIntervalNonMultipleDuration() {
    durationPicker.pickerMode = .minute
    durationPicker.minuteInterval = 15
    durationPicker.duration = thirtyMinutes + 1
    XCTAssertEqual(durationPicker.duration, thirtyMinutes)
  }

  // MARK: Second Interval

  /// Tests whether setting the second interval to a negative value resets it to 1.
  func testSecondIntervalNegative() {
    durationPicker.secondInterval = -1
    XCTAssertEqual(durationPicker.secondInterval, 1)
  }

  /// Tests whether setting the second interval to zero resets it to 1.
  func testSecondIntervalZero() {
    durationPicker.secondInterval = 0
    XCTAssertEqual(durationPicker.secondInterval, 1)
  }

  /// Tests whether setting a second interval to a value larger than 30 resets it to 1.
  func testSecondIntervalLargerThanThirty() {
    durationPicker.secondInterval = 60
    XCTAssertEqual(durationPicker.secondInterval, 1)
  }

  /// Tests whether setting a second interval properly rounds the current duration down to the nearest allowed second.
  func testSecondIntervalNonDivisibility() {
    durationPicker.secondInterval = 59
    XCTAssertEqual(durationPicker.secondInterval, 1)
  }

  /// Tests whether the current duration is rounded down to the nearest allowed second when setting a second interval.
  func testSecondInterval() {
    durationPicker.pickerMode = .second
    durationPicker.duration = oneSecond
    durationPicker.secondInterval = 2
    XCTAssertEqual(durationPicker.duration, 0)
  }

  /// Tests whether setting a duration which is not a multiple of the second interval rounds down to the nearest allowed second.
  func testSecondIntervalNonMultipleDuration() {
    durationPicker.pickerMode = .second
    durationPicker.secondInterval = 15
    durationPicker.duration = thirtySeconds + 1
    XCTAssertEqual(durationPicker.duration, thirtySeconds)
  }
}
