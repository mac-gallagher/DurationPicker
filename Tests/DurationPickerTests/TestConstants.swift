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
import Foundation

// MARK: - Integers

let oneHourInt = TimeUtils.seconds(fromHours: 1)
let twoHoursInt = TimeUtils.seconds(fromHours: 2)
let thirteenHoursInt = TimeUtils.seconds(fromHours: 13)
let twentyThreeHoursInt = TimeUtils.seconds(fromHours: 23)
let twentyFourHoursInt = TimeUtils.seconds(fromHours: 24)

let oneMinuteInt = TimeUtils.seconds(minutes: 1)
let twoMinutesInt = TimeUtils.seconds(minutes: 2)
let fiftyNineMinutesInt = TimeUtils.seconds(minutes: 59)

let oneSecondInt = TimeUtils.seconds(seconds: 1)
let twoSecondsInt = TimeUtils.seconds(seconds: 2)
let fiftyNineSecondsInt = TimeUtils.seconds(seconds: 59)

// MARK: - Time Intervals

let oneHour = TimeInterval(oneHourInt)
let twoHours = TimeInterval(twoHoursInt)
let threeHours = TimeInterval(TimeUtils.seconds(fromHours: 3))
let fourHours = TimeInterval(TimeUtils.seconds(fromHours: 4))
let twelveHours = TimeInterval(TimeUtils.seconds(fromHours: 12))

let oneMinute = TimeInterval(oneMinuteInt)
let twoMinutes = TimeInterval(twoMinutesInt)
let threeMinutes = TimeInterval(TimeUtils.seconds(minutes: 3))
let fourMinutes = TimeInterval(TimeUtils.seconds(minutes: 4))
let thirtyMinutes = TimeInterval(TimeUtils.seconds(minutes: 30))

let oneSecond = TimeInterval(oneSecondInt)
let twoSeconds = TimeInterval(twoSecondsInt)
let threeSeconds = TimeInterval(TimeUtils.seconds(seconds: 3))
let fourSeconds = TimeInterval(TimeUtils.seconds(seconds: 4))
let thirtySeconds = TimeInterval(TimeUtils.seconds(seconds: 30))
let fiftyEightSeconds = TimeInterval(TimeUtils.seconds(seconds: 58))
