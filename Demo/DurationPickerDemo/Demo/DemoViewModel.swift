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

import Combine
import DurationPicker
import Foundation

final class DemoViewModel: ObservableObject {

  @Published var countDownDuration: TimeInterval = 0 {
    didSet {
      print("Set countDownDuration to \(countDownDuration) seconds")
    }
  }

  @Published var duration: TimeInterval = 0 {
    didSet {
      print("Set duration to \(duration) seconds")
    }
  }

  @Published var pickerMode: DurationPicker.Mode = .hourMinuteSecond {
    didSet {
      print("Set pickerMode to \(pickerMode)")
    }
  }

  @Published var hourInterval: Int = 1 {
    didSet {
        print("Set hour interval to \(hourInterval)")
    }
  }

  @Published var minuteInterval: Int = 1 {
    didSet {
        print("Set minute interval to \(minuteInterval)")
    }
  }

  @Published var secondInterval: Int = 1 {
    didSet {
      print("Set second interval to \(secondInterval)")
    }
  }

  @Published var minimumDuration: TimeInterval? {
    didSet {
      if let minimumDuration {
        print("Set minimum duration to \(minimumDuration) seconds")
      } else {
        print("Cleared minimum duration")
      }
    }
  }

  @Published var maximumDuration: TimeInterval? {
    didSet {
      if let maximumDuration {
        print("Set maximum duration to \(maximumDuration) seconds")
      } else {
        print("Cleared maximum duration")
      }
    }
  }

  @Published var showDatePicker = false {
    didSet {
      print("Set showDatePicker to \(showDatePicker)")
    }
  }
}
