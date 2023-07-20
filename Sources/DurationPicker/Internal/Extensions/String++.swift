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
import UIKit

extension String {

  /// Creates a localized string instance from a specified localization key or string, using the default localization bundle associated with the module.
  ///
  /// - Parameter localized: A value representing the localization key or string to be localized.
  init(localizedFromModule localized: String.LocalizationValue) {
    self.init(
      localized: localized,
      bundle: .module)
  }

  /// Calculates and returns the bounding rectangle for a given text string when rendered with a specified font and baseline offset, rounded to the nearest pixel.
  ///
  /// - Parameters:
  ///   - font: The font applied to the text.
  ///   - baselineOffset: An optional offset applied to the baseline of the text, defaults to 0.
  ///
  /// - Returns: The bounding rectangle that encloses the given text, rounded to the nearest pixel.
  func boundingRectRoundedToNearestPixel(font: UIFont,
                                         baselineOffset: CGFloat = 0) -> CGRect {
    let boundingRect = boundingRect(
      font: font,
      baselineOffset: baselineOffset)
    return CGRect(
      origin: boundingRect.origin,
      size: CGSize(
        width: boundingRect.width.roundedToNearestPixel(roundingRule: .up),
        height: boundingRect.height.roundedToNearestPixel(roundingRule: .up)))
  }

  /// Calculates and returns the bounding rectangle for a given text string when rendered with a specified font and baseline offset.
  ///
  /// - Parameters:
  ///   - font: The font applied to the text.
  ///   - baselineOffset: An optional offset applied to the baseline of the text, defaults to 0.
  ///
  /// - Returns: The bounding rectangle that encloses the given text.
  func boundingRect(font: UIFont,
                    baselineOffset: CGFloat = 0) -> CGRect {
    boundingRect(
      with: CGSize.infinity,
      options: [],
      attributes: [
        .font: font,
        .baselineOffset: baselineOffset],
      context: nil)
  }
}
