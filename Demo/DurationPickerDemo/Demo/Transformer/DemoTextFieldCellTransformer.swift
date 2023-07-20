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
import UIKit

enum DemoTextFieldCellTransformer {
  
  static func makeCellRegistration(viewModel: DemoViewModel,
                                   delegate: DemoCellDelegate?) -> DemoCellRegistration {
    DemoCellRegistration { [weak delegate] cell, indexPath, item in
      var configuration = DemoTextFieldContentConfiguration()
      configuration.title = makeTitle(for: item)
      configuration.placeholder = makePlaceholder(for: item)
      configuration.text = makeText(
        for: item,
        duration: viewModel.duration,
        hourInterval: viewModel.hourInterval,
        minuteInterval: viewModel.minuteInterval,
        secondInterval: viewModel.secondInterval,
        minimumDuration: viewModel.minimumDuration,
        maximumDuration: viewModel.maximumDuration)
      configuration.textUpdateHandler = { text in
        delegate?.textFieldCell(
          textDidChangeForItem: item,
          text: text)
      }
      cell.contentConfiguration = configuration
    }
  }
  
  // MARK: - Private
  
  private static func makeTitle(for item: DemoDataSource.Item) -> String? {
    switch item {
    case .durationPickerHourInterval:
      return "Hour Interval"
    case .durationPickerMaximumDuration:
      return "Maximum Duration"
    case .durationPickerMinimumDuration:
      return "Minimum Duration"
    case .durationPickerMinuteInterval:
      return "Minute Interval"
    case .durationPickerSecondInterval:
      return "Second Interval"
    case .durationPickerValue:
      return "Selected Duration"
    default:
      return nil
    }
  }
  
  private static func makePlaceholder(for item: DemoDataSource.Item) -> String? {
    switch item {
    case .durationPickerHourInterval:
      return "Hours"
    case .durationPickerMaximumDuration,
        .durationPickerMinimumDuration,
        .durationPickerSecondInterval,
        .durationPickerValue:
      return "Seconds"
    case .durationPickerMinuteInterval:
      return "Minutes"
    default:
      return nil
    }
  }
  
  private static func makeText(for item: DemoDataSource.Item,
                               duration: TimeInterval,
                               hourInterval: Int,
                               minuteInterval: Int,
                               secondInterval: Int,
                               minimumDuration: TimeInterval?,
                               maximumDuration: TimeInterval?) -> String? {
    switch item {
    case .durationPickerHourInterval:
      return String(hourInterval)
    case .durationPickerMinuteInterval:
      return String(minuteInterval)
    case .durationPickerMaximumDuration:
      if let maximumDuration {
        return String(maximumDuration)
      }
      return nil
    case .durationPickerMinimumDuration:
      if let minimumDuration {
        return String(minimumDuration)
      }
      return nil
    case .durationPickerSecondInterval:
      return String(secondInterval)
    case .durationPickerValue:
      return String(duration)
    default:
      return nil
    }
  }
}
