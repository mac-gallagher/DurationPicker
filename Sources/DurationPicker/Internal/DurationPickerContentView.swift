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

/// A view which displays a single monospaced, right-aligned label. Used as a row for `DurationPickerView`.
final class DurationPickerContentView: UIView {

  private let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = labelFont
    return label
  }()

  /// The font of the label.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let labelFont = UIFont.monospacedDigitSystemFont(
    ofSize: 23.5,
    weight: .regular)

  /// The baseline offset of the label.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let labelBaselineOffset = CGFloat(1.5).roundedToNearestPixel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(label)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    addSubview(label)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    label.frame.size = Self.labelBoundingRect().size
    // Vertically center the label but shift up if its origin lies between two pixels
    label.center.y = center.y
    label.frame.origin.y.roundToNearestPixel()
  }

  /// Sets the text on the content view's label.
  /// 
  /// - Parameters:
  ///   - text: The text to set on the label.
  ///   - muted: A boolean indicating if a muted color should be applied to the text.
  ///   - accessibilityLabel: A succinct label in a localized string that identifies the label.
  func setText(_ text: String?,
               muted: Bool,
               accessibilityLabel: String?) {
    label.text = text
    label.textColor = muted ? .tertiaryLabel : .label
    label.accessibilityLabel = accessibilityLabel
  }

  /// Returns the bounding rectangle for the label in the content view, rounded up to the nearest pixel.
  /// 
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  ///
  /// - Returns: The bounding rectangle for the label in the content view, rounded up to the nearest pixel.
  static func labelBoundingRect() -> CGRect {
    "00".boundingRectRoundedToNearestPixel(
      font: Self.labelFont,
      baselineOffset: Self.labelBaselineOffset)
  }
}
