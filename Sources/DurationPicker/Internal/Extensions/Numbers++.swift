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

extension TimeInterval? {

  var asInteger: Int? {
    switch self {
    case .some(let value): Int(value)
    case .none: nil
    }
  }
}

extension Int? {

  var asTimeInterval: TimeInterval? {
    switch self {
    case .some(let value): TimeInterval(value)
    case .none: nil
    }
  }
}

extension Comparable {

  /// Clamps the value within the provided range, returning the value if it falls within the range or the nearest bound if it exceeds the range.
  ///
  /// - Parameter bounds: A closed range within which the value should be clamped.
  ///
  /// - Returns: The clamped value within the specified closed range.
  func clamped(to bounds: ClosedRange<Self>) -> Self {
    min(max(self, bounds.lowerBound), bounds.upperBound)
  }
}

extension Double {

  /// Rounds the receiver to the nearest multiple of the specified value using the provided rounding rule.
  ///
  /// - Parameters:
  ///   - value: The value to which the receiver should be rounded.
  ///   - roundingRule: The rounding rule to use; the default is `toNearestOrAwayFromZero`.
  ///
  /// - Returns: The rounded value.
  func rounded(toNearest value: Self,
               roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
    (self / value).rounded(roundingRule) * value
  }
}

extension Int {

  /// Rounds the receiver to the nearest multiple of the specified value using the provided rounding rule.
  ///
  /// - Parameters:
  ///   - value: The value to which the receiver should be rounded.
  ///   - roundingRule: The rounding rule to use; the default is `toNearestOrAwayFromZero`.
  ///
  /// - Returns: The rounded value.
  func rounded(toNearest value: Self,
               roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
    let roundedValue = Double(self).rounded(
      toNearest: Double(value),
      roundingRule: roundingRule)
    return Int(roundedValue)
  }
}
