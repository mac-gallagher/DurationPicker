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

/// Tests which cover the functionality of the `TimeComponents` class.
///
/// We test the following functionality:
/// - Rounding mode
/// - PIcker mode
/// - Minimum/maximum
/// - Intervals
final class TimeComponentsTests: XCTestCase {

  // MARK: - General

  /// Tests that the components of a negative duration are `(0, 0, 0)`.
  func testNegativeSeconds() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: -1),
      expectedComponents)
  }

  /// Tests that the components of a negative duration when rounding up are `(0, 0, 0)`.
  func testNegativeSecondsRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: -1,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:00 are `(0, 0, 0)`.
  func testZeroSeconds() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: 0),
      expectedComponents)
  }

  /// Tests that the components of 0:00:00 when rounding up are `(0, 0, 0)`.
  func testZeroSecondsRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: 0,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:01 are `(0, 0, 1)`.
  func testOneSecond() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: oneSecondInt),
      expectedComponents)
  }

  /// Tests that the components of 0:00:01 when rounding up are `(0, 0, 1)`.
  func testOneSecondRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneSecondInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:01:00 are `(0, 1, 0)`.
  func testOneMinute() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: oneMinuteInt),
      expectedComponents)
  }

  /// Tests that the components of 0:01:00 when rounding up are `(0, 1, 0)`.
  func testOneMinuteRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneMinuteInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:02:01 are `(0, 2, 1)`.
  func testTwoMinutesAndOneSecond() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 2,
      uncheckedSecond: 1)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: twoMinutesInt + oneSecondInt),
      expectedComponents)
  }

  /// Tests that the components of 0:02:01 when rounding up are `(0, 2, 1)`.
  func testTwoMinutesAndOneSecondRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoMinutesInt + oneSecondInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 2,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 are `(1, 0, 0)`.
  func testOneHour() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: oneHourInt),
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 when rounding up are `(1, 0, 0)`.
  func testOneHourRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:01 are `(1, 0, 1)`.
  func testOneHourAndOneSecond() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: oneHourInt + oneSecondInt),
      expectedComponents)
  }

  /// Tests that the components of 1:00:01 when rounding up are `(1, 0, 1)`.
  func testOneHourAndOneSecondRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt + oneSecondInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:02:01 are `(1, 2, 1)`.
  func testOneHourTwoMinutesAndOneSecond() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 2,
      uncheckedSecond: 1)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: oneHourInt + twoMinutesInt + oneSecondInt),
      expectedComponents)
  }

  /// Tests that the components of 1:02:01 when rounding up are `(1, 2, 1)`.
  func testOneHourTwoMinutesAndOneSecondRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt + twoMinutesInt + oneSecondInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 2,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 2:00:01 are `(2, 0, 1)`.
  func testTwoHoursAndOneSecond() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: twoHoursInt + oneSecondInt),
      expectedComponents)
  }

  /// Tests that the components of 2:00:01 when rounding up are `(2, 0, 1)`.
  func testTwoHoursAndOneSecondRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoHoursInt + oneSecondInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 2:02:01 are `(2, 2, 1)`.
  func testTwoHoursTwoMinutesAndOneSecond() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 2,
      uncheckedSecond: 1)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: twoHoursInt + twoMinutesInt + oneSecondInt),
      expectedComponents)
  }

  /// Tests that the components of 2:02:01 when rounding up are `(2, 2, 1)`.
  func testTwoHoursTwoMinutesAndOneSecondRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoHoursInt + twoMinutesInt + oneSecondInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 2,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 24:00:00 are `(23, 59, 59)`.
  func testTwentyFourHours() {
    let expectedComponents = TimeComponents(
      uncheckedHour: 23,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      TimeComponents.components(fromDuration: twentyFourHoursInt),
      expectedComponents)
  }

  /// Tests that the components of 24:00:00 when rounding up are `(23, 59, 59)`.
  ///
  /// - Note: This is a special case where we round _down_ to the nearest allowed value even though the rounding mode is `up`.
  func testTwentyFourHoursRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 23,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  // MARK: - Minimum & Maximum

  /// Tests that the components of 1:00:00 with minimum duration 1:00:01 are `(1, 0, 1)`.
  func testMinimum() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      minimumDuration: oneHourInt + 1,
      maximumDuration: nil)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 with minimum duration 1:00:01 and rounding mode up are `(1, 0, 1)`.
  func testMinimumWithRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      minimumDuration: oneHourInt + 1,
      maximumDuration: nil,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 1)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:01 with minimum duration 0:00:01 and minute mode are `(0, 1, 0)`.
  func testMinimumOneSecondWithMinuteMode() {
    let actualComponents = TimeComponents.components(
      fromDuration: 1,
      pickerMode: .hourMinute,
      minimumDuration: 1,
      maximumDuration: nil)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }
  /// Tests that the components of 0:00:01 with minimum duration 0:00:01 and minute mode are `(0, 1, 0)`.
  func testMinimumOneSecondWithMinuteModeAndRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: 1,
      pickerMode: .hourMinute,
      minimumDuration: 1,
      maximumDuration: nil,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 with maximum duration 0:59:59 are `(0, 59, 59)`.
  func testMaximum() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      minimumDuration: nil,
      maximumDuration: oneHourInt - 1)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 with maximum duration 0:59:59 and rounding mode up are `(0, 59, 59)`.
  func testMaximumWithRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      minimumDuration: nil,
      maximumDuration: oneHourInt - 1,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:01:01 with maximum duration 0:01:01 and minute mode are `(0, 1, 0)`.
  func testMaximumOneMinuteAndOneSecondWithMinuteMode() {
    let actualComponents = TimeComponents.components(
      fromDuration: 61,
      pickerMode: .minute,
      minimumDuration: nil,
      maximumDuration: 61)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:01:01 with maximum duration 0:01:01 and minute mode are `(0, 1, 0)`.
  func testMaximumOneMinuteAndOneSecondWithMinuteModeAndRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: 61,
      pickerMode: .minute,
      minimumDuration: nil,
      maximumDuration: 61,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 when the minimum is larger than the maximum are `(1, 0, 0)`, i.e., the minimum and maximum values are ignored.
  func testMinimumLargerThanMaximum() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      minimumDuration: oneHourInt + 1,
      maximumDuration: oneHourInt - 1,
      roundingMode: .up)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  // MARK: - Hour Interval

  /// Tests that the components of 1:00:00 with a two-hour interval are `(0, 59, 59)`.
  func testOneHourWithTwoHourInterval() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      hourInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 1:00:00 with a two-hour interval when rounding up are `(2, 0, 0)`.
  func testOneHourWithTwoHourIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneHourInt,
      roundingMode: .up,
      hourInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 2:00:00 with a two-hour interval are `(2, 0, 0)`.
  func testTwoHoursWithTwoHourInterval() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoHoursInt,
      hourInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 2:00:00 with a two-hour interval when rounding up are `(2, 0, 0)`.
  func testTwoHoursWithTwoHourIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoHoursInt,
      roundingMode: .up,
      hourInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 2,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 23:00:00 with a two-hour interval when rounding up are `(22, 59, 59)`.
  ///
  /// - Note: This is a special case where we round _down_ to the nearest allowed value even though the rounding mode is `up`.
  func testTwentyThreeHoursWithTwoHourIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyThreeHoursInt,
      roundingMode: .up,
      hourInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 22,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 23:00:00 with a two-hour interval and `hour` mode when rounding up are `(22, 0, 0)`
  ///
  /// - Note: This is a special case where we round _down_ to the nearest allowed value even though the rounding mode is `up`.
  func testTwentyThreeHoursWithTwoHourIntervalRoundingModeUpHourMode() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyThreeHoursInt,
      pickerMode: .hour,
      roundingMode: .up,
      hourInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 22,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  // MARK: - Minute Interval

  /// Tests that the components of 0:01:00 with a two-minute interval are `(0, 0, 59)`.
  func testOneMinuteWithTwoMinuteInterval() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneMinuteInt,
      minuteInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:01:00 with a two-minute interval when rounding up are `(0, 2, 0)`.
  func testOneMinuteWithTwoMinuteIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneMinuteInt,
      roundingMode: .up,
      minuteInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 2,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:02:00 with a two-minute interval are `(0, 2, 0)`.
  func testTwoMinutesWithTwoMinuteInterval() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoMinutesInt,
      minuteInterval: 2)

    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 2,
      uncheckedSecond: 0)

    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:02:00 with a two-minute interval when rounding up are `(0, 2, 0)`.
  func testTwoMinutesWithTwoMinuteIntervalWithRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoMinutesInt,
      roundingMode: .up,
      minuteInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 2,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:59:00 with a thirty-minute interval when rounding up are `(1, 0, 0)`.
  func testFiftyNineMinutesWithTwoMinuteIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: fiftyNineMinutesInt,
      roundingMode: .up,
      minuteInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 1,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:59:00 with a two-minute interval and `minute` mode when rounding up are `(0, 58, 0)`
  ///
  /// - Note: This is a special case where we round _down_ to the nearest allowed value even though the rounding mode is `up`.
  func testFiftyNineMinutesWithTwoMinuteIntervalRoundingModeUpMinuteMode() {
    let actualComponents = TimeComponents.components(
      fromDuration: fiftyNineMinutesInt,
      pickerMode: .minute,
      roundingMode: .up,
      minuteInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 58,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  // MARK: - Second Interval

  /// Tests that the components of 0:00:01 with a two-second interval are `(0, 0, 0)`.
  func testOneSecondWithTwoSecondInterval() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneSecondInt,
      secondInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:01 with a two-second interval when rounding up are `(0, 0, 2)`.
  func testOneSecondWithTwoSecondIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: oneSecondInt,
      roundingMode: .up,
      secondInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 2)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:02 with a two-second interval are `(0, 0, 2)`.
  func testTwoSecondsWithTwoSecondInterval() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoSecondsInt,
      secondInterval: 2)

    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 2)

    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:02 with a two-second interval when rounding up are `(0, 0, 2)`.
  func testTwoSecondsWithTwoSecondIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: twoSecondsInt,
      roundingMode: .up,
      secondInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 2)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:59 with a two-second interval when rounding up are `(0, 1, 0)`.
  func testFiftyNineSecondsWithTwoSecondIntervalRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: fiftyNineSecondsInt,
      roundingMode: .up,
      secondInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 1,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 0:00:59 with a two-second interval and `second` mode when rounding up are `(0, 0, 58)`
  ///
  /// - Note: This is a special case where we round _down_ to the nearest allowed value even though the rounding mode is `up`.
  func testFiftyNineSecondsWithTwoSecondIntervalRoundingModeUpSecondMode() {
    let actualComponents = TimeComponents.components(
      fromDuration: fiftyNineSecondsInt,
      pickerMode: .second,
      roundingMode: .up,
      secondInterval: 2)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 58)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  // MARK: - Mixed Intervals

  /// Tests that the components of 13:00:00 with six-hour, fifteen-minute, and ten-second intervals are `(12, 30, 50)`.
  func testMixedIntervals() {
    let actualComponents = TimeComponents.components(
      fromDuration: thirteenHoursInt,
      hourInterval: 6,
      minuteInterval: 15,
      secondInterval: 10)
    let expectedComponents = TimeComponents(
      uncheckedHour: 12,
      uncheckedMinute: 45,
      uncheckedSecond: 50)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the components of 13:00:00 with six-hour, fifteen-minute, and ten-second intervals are `(18, 0, 0)`.
  func testMixedIntervalsRoundingModeUp() {
    let actualComponents = TimeComponents.components(
      fromDuration: thirteenHoursInt,
      roundingMode: .up,
      hourInterval: 6,
      minuteInterval: 15,
      secondInterval: 10)
    let expectedComponents = TimeComponents(
      uncheckedHour: 18,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  // MARK: - Picker Mode

  /// Tests that none of the components are zeroed with `hourMinuteSecond` mode.
  func testHourMinuteSecondModeZeroingBehavior() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      pickerMode: .hourMinuteSecond)
    let expectedComponents = TimeComponents(
      uncheckedHour: 23,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the second component is zeroed with `hourMinute` mode.
  func testHourMinuteModeZeroingBehavior() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      pickerMode: .hourMinute)
    let expectedComponents = TimeComponents(
      uncheckedHour: 23,
      uncheckedMinute: 59,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the second and minute components are zeroed with `hour` mode.
  func testHourModeZeroingBehavior() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      pickerMode: .hour)
    let expectedComponents = TimeComponents(
      uncheckedHour: 23,
      uncheckedMinute: 0,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the hour component is zeroed with `minuteSecond` mode.
  func testMinuteSecondModeZeroingBehavior() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      pickerMode: .minuteSecond)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 59,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the hour and second components are zeroed with `minute` mode.
  func testMinuteModeZeroingBehavior() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      pickerMode: .minute)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 59,
      uncheckedSecond: 0)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }

  /// Tests that the hour and minute components are zeroed with `second` mode.
  func testSecondModeZeroingBehavior() {
    let actualComponents = TimeComponents.components(
      fromDuration: twentyFourHoursInt,
      pickerMode: .second)
    let expectedComponents = TimeComponents(
      uncheckedHour: 0,
      uncheckedMinute: 0,
      uncheckedSecond: 59)
    XCTAssertEqual(
      actualComponents,
      expectedComponents)
  }
}
