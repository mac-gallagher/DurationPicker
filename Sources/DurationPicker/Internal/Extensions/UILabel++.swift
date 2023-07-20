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

import UIKit

extension UILabel {

  /// Sets the text on the label animating between the old and new values.
  ///
  /// - Parameter text: The text to set on the label
  ///
  /// - Note: The animation style matches that of the unit labels on `UIDatePicker` with `countDownTimer` mode.
  func setAnimatedText(_ text: String) {
    UIView.transition(
      with: self,
      duration: 0.3,
      options: [.transitionCrossDissolve, .curveEaseInOut]) { [weak self] in
        self?.text = text
      }
  }

  /// Adjusts the size of the label to fit its content, considering the nearest pixel accuracy for rendering.
  ///
  /// - Parameter baselineOffset: An optional offset applied to the baseline of the text, defaults to 0.
  func sizeToFitNearestPixel(baselineOffset: CGFloat = 0) {
    let boundingRect = (text ?? "").boundingRectRoundedToNearestPixel(
      font: font,
      baselineOffset: baselineOffset)
    frame.size = boundingRect.size
  }
}
