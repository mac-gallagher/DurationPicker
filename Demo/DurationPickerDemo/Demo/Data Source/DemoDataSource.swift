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

final class DemoDataSource: UICollectionViewDiffableDataSource<DemoDataSource.Section, DemoDataSource.Item> {

  func reload(showDatePicker: Bool,
              animatingDifferences: Bool = false) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

    // Date picker section
    snapshot.appendSections([.datePicker])
    snapshot.appendItems([.datePickerToggle])
    if showDatePicker {
      snapshot.appendItems([.datePicker])
    }

    // Duration picker section
    snapshot.appendSections([.durationPicker])
    snapshot.appendItems([
      .durationPicker,
      .durationPickerPickerMode,
      .durationPickerValue,
      .durationPickerMinimumDuration,
      .durationPickerMaximumDuration,
      .durationPickerHourInterval,
      .durationPickerMinuteInterval,
      .durationPickerSecondInterval
    ])

    apply(
      snapshot,
      animatingDifferences: animatingDifferences)
  }

  func reconfigureItems(_ items: [Item]) {
    var snapshot = snapshot()
    snapshot.reconfigureItems(items)
    apply(snapshot)
  }
}
