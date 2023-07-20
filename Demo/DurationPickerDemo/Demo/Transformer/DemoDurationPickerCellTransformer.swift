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

import DurationPicker
import UIKit

enum DemoDurationPickerCellTransformer {

  static func makeCellRegistration(viewModel: DemoViewModel,
                                   delegate: DemoCellDelegate?) -> DemoCellRegistration {
    DemoCellRegistration { [weak delegate] cell, indexPath, item in
      var configuration = DemoDurationPickerContentConfiguration()
      configuration.pickerMode = viewModel.pickerMode
      configuration.duration = viewModel.duration
      configuration.hourInterval = viewModel.hourInterval
      configuration.minuteInterval = viewModel.minuteInterval
      configuration.secondInterval = viewModel.secondInterval
      configuration.minimumDuration = viewModel.minimumDuration
      configuration.maximumDuration = viewModel.maximumDuration
      configuration.durationUpdateHandler = { duration in
        delegate?.durationPickerCell(
          durationDidChangeForItem: item,
          duration: duration)
      }
      cell.contentConfiguration = configuration
    }
  }
}
