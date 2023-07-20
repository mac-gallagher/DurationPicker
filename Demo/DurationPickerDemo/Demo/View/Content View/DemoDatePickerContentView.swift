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

final class DemoDatePickerContentView: UIView, UIContentView {

  var configuration: UIContentConfiguration

  private var datePickerConfiguration: DemoDatePickerContentConfiguration! {
    configuration as? DemoDatePickerContentConfiguration
  }

  private let datePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.datePickerMode = .countDownTimer
    // Unlike DurationPicker, UIDatePicker is not locale-aware on a per-app basis,
    // so setting the locale explicitly as the user's first preferred language
    if let languageIdentifier = Locale.preferredLanguages.first {
      picker.locale = Locale(identifier: languageIdentifier)
    } else {
      picker.locale = nil
    }
    return picker
  }()

  init(configuration: DemoDatePickerContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)

    addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
      datePicker.topAnchor.constraint(equalTo: topAnchor),
      datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
      datePicker.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    let action = UIAction { [weak self] _ in
      guard let self else { return }
      datePickerConfiguration.countDownDurationUpdateHandler?(datePicker.countDownDuration)
    }

    datePicker.addAction(
      action,
      for: .valueChanged)
  }

  required init?(coder: NSCoder) {
    return nil
  }
}
