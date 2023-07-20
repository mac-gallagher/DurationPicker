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
import UIKit

final class DemoDurationPickerContentView: UIView, UIContentView {

  var configuration: UIContentConfiguration {
    didSet {
      updateConfiguration(durationPickerConfiguration)
    }
  }

  private var durationPickerConfiguration: DemoDurationPickerContentConfiguration! {
    configuration as? DemoDurationPickerContentConfiguration
  }

  private let durationPicker = DurationPicker()

  init(configuration: DemoDurationPickerContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)

    addSubview(durationPicker)
    durationPicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      durationPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
      durationPicker.topAnchor.constraint(equalTo: topAnchor),
      durationPicker.trailingAnchor.constraint(equalTo: trailingAnchor),
      durationPicker.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    let action = UIAction { [weak self] action in
      guard let self else { return }
      if durationPicker.duration != durationPickerConfiguration.duration {
        configuration.durationUpdateHandler?(durationPicker.duration)
      }
    }

    durationPicker.addAction(
      action,
      for: .valueChanged)
  }

  required init?(coder: NSCoder) {
    return nil
  }

  private func updateConfiguration(_ configuration: DemoDurationPickerContentConfiguration) {
    if durationPicker.pickerMode != configuration.pickerMode {
      durationPicker.pickerMode = configuration.pickerMode
    }

    if durationPicker.hourInterval != configuration.hourInterval {
      durationPicker.hourInterval = configuration.hourInterval
    }

    if durationPicker.minuteInterval != configuration.minuteInterval {
      durationPicker.minuteInterval = configuration.minuteInterval
    }

    if durationPicker.secondInterval != configuration.secondInterval {
      durationPicker.secondInterval = configuration.secondInterval
    }

    if durationPicker.minimumDuration != configuration.minimumDuration {
      durationPicker.minimumDuration = configuration.minimumDuration
    }

    if durationPicker.maximumDuration != configuration.maximumDuration {
      durationPicker.maximumDuration = configuration.maximumDuration
    }

    if durationPicker.duration != configuration.duration {
      durationPicker.setDuration(
        configuration.duration,
        animated: true)
    }
  }
}
