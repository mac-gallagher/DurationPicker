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

typealias DemoCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, DemoDataSource.Item>

enum DemoAdapter {

  static func makeCellProvider(viewModel: DemoViewModel,
                               delegate: DemoCellDelegate?) -> DemoDataSource.CellProvider {
    let titleCellTransformer = DemoTitleCellTransformer.makeCellRegistration(viewModel: viewModel)

    let datePickerCellRegistration = DemoDatePickerCellTransformer.makeCellRegistration(
      viewModel: viewModel,
      delegate: delegate)

    let durationPickerCellRegistration = DemoDurationPickerCellTransformer.makeCellRegistration(
      viewModel: viewModel,
      delegate: delegate)

    let menuButtonCellRegistration = DemoMenuButtonCellTransformer.makeCellRegistration(
      viewModel: viewModel,
      delegate: delegate)

    let textFieldRegistration = DemoTextFieldCellTransformer.makeCellRegistration(
      viewModel: viewModel,
      delegate: delegate)

    return { collectionView, indexPath, item in
      switch item {
      case .datePicker:
        collectionView.dequeueConfiguredReusableCell(
          using: datePickerCellRegistration,
          for: indexPath,
          item: item)
      case .datePickerToggle:
        collectionView.dequeueConfiguredReusableCell(
          using: titleCellTransformer,
          for: indexPath,
          item: item)
      case .durationPicker:
        collectionView.dequeueConfiguredReusableCell(
          using: durationPickerCellRegistration,
          for: indexPath,
          item: item)
      case .durationPickerHourInterval,
          .durationPickerMaximumDuration,
          .durationPickerMinimumDuration,
          .durationPickerMinuteInterval,
          .durationPickerSecondInterval,
          .durationPickerValue:
        collectionView.dequeueConfiguredReusableCell(
          using: textFieldRegistration,
          for: indexPath,
          item: item)
      case .durationPickerPickerMode:
        collectionView.dequeueConfiguredReusableCell(
          using: menuButtonCellRegistration,
          for: indexPath,
          item: item)
      }
    }
  }
}
