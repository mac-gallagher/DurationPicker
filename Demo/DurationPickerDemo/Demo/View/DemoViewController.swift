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

final class DemoViewController: UICollectionViewController, DemoCellDelegate {

  private let viewModel = DemoViewModel()

  private lazy var dataSource = DemoDataSource(
    collectionView: collectionView,
    cellProvider: DemoAdapter.makeCellProvider(
      viewModel: viewModel,
      delegate: self))

  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers

  init() {
    let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    let layout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
    super.init(collectionViewLayout: layout)
  }

  required init?(coder: NSCoder) {
    return nil
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "DurationPicker Demo"

    collectionView.dataSource = dataSource
    collectionView.keyboardDismissMode = .onDrag
    collectionView.delegate = self

    setupModelSubscriptions()

    dataSource.reload(showDatePicker: viewModel.showDatePicker)
  }

  // MARK: - Model Subscriptions

  private func setupModelSubscriptions() {
    setupDurationSubscription()
    setupMinimumDurationSubscription()
    setupMaximumDurationSubscription()
    setupPickerModeSubscription()
    setupHourIntervalSubscription()
    setupMinuteIntervalSubscription()
    setupSecondIntervalSubscription()
    setupShowDatePickerSubscription()
    setupCountDownDurationSubscription()
  }

  private func setupDurationSubscription() {
    viewModel.$duration
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] duration in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupMinimumDurationSubscription() {
    viewModel.$minimumDuration
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] duration in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerMinimumDuration,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupMaximumDurationSubscription() {
    viewModel.$maximumDuration
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] duration in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerMaximumDuration,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupPickerModeSubscription() {
    viewModel.$pickerMode
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] pickerMode in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerMaximumDuration,
          .durationPickerMinimumDuration,
          .durationPickerPickerMode,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupHourIntervalSubscription() {
    viewModel.$hourInterval
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] interval in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerHourInterval,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupMinuteIntervalSubscription() {
    viewModel.$minuteInterval
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] interval in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerMinuteInterval,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupSecondIntervalSubscription() {
    viewModel.$secondInterval
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] interval in
        self?.dataSource.reconfigureItems([
          .durationPicker,
          .durationPickerSecondInterval,
          .durationPickerValue
        ])
      }
      .store(in: &disposeBag)
  }

  private func setupShowDatePickerSubscription() {
    viewModel.$showDatePicker
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] shouldShow in
        guard let self else { return }
        dataSource.reload(
          showDatePicker: shouldShow,
          animatingDifferences: true)
        dataSource.reconfigureItems([.datePickerToggle])
      }
      .store(in: &disposeBag)
  }

  private func setupCountDownDurationSubscription() {
    viewModel.$countDownDuration
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] duration in
        self?.dataSource.reconfigureItems([.datePicker])
      }
      .store(in: &disposeBag)
  }

  // MARK: - UICollectionViewDelegate

  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    guard let item = dataSource.itemIdentifier(for: indexPath) else {
      return
    }

    switch item {
    case .datePickerToggle:
      viewModel.showDatePicker.toggle()
    default:
      break
    }
  }

  override func collectionView(_ collectionView: UICollectionView,
                               shouldSelectItemAt indexPath: IndexPath) -> Bool {
    guard let item = dataSource.itemIdentifier(for: indexPath) else {
      return true
    }
    return shouldSelectItem(item)
  }

  override func collectionView(_ collectionView: UICollectionView,
                               shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    guard let item = dataSource.itemIdentifier(for: indexPath) else {
      return true
    }
    return shouldSelectItem(item)
  }

  private func shouldSelectItem(_ item: DemoDataSource.Item) -> Bool {
    switch item {
    case .datePickerToggle:
      return true
    default:
      return false
    }
  }

  // MARK: - DemoCellDelegate

  func textFieldCell(textDidChangeForItem item: DemoDataSource.Item,
                     text: String?) {
    switch item {
    case .durationPickerHourInterval:
      if let text,
         let interval = Int(text) {
        viewModel.hourInterval = interval
      } else {
        viewModel.hourInterval = 1
      }
    case .durationPickerMaximumDuration:
      if let text,
         let duration = Double(text) {
        viewModel.maximumDuration = duration
      } else {
        viewModel.maximumDuration = nil
      }
    case .durationPickerMinimumDuration:
      if let text,
         let duration = Double(text) {
        viewModel.minimumDuration = duration
      } else {
        viewModel.minimumDuration = nil
      }
    case .durationPickerMinuteInterval:
      if let text,
         let interval = Int(text) {
        viewModel.minuteInterval = interval
      } else {
        viewModel.minuteInterval = 1
      }
    case .durationPickerSecondInterval:
      if let text,
         let interval = Int(text) {
        viewModel.secondInterval = interval
      } else {
        viewModel.secondInterval = 1
      }
    case .durationPickerValue:
      if let text,
         let duration = Double(text) {
        viewModel.duration = duration
      } else {
        viewModel.duration = 0
      }
    default:
      break
    }
  }

  func durationPickerCell(durationDidChangeForItem item: DemoDataSource.Item,
                          duration: TimeInterval) {
    switch item {
    case .durationPicker:
      viewModel.duration = duration
    default:
      break
    }
  }


  func datePickerCell(countDownDurationDidChangeForItem item: DemoDataSource.Item,
                      countDownDuration: TimeInterval) {
    switch item {
    case .datePicker:
      viewModel.countDownDuration = countDownDuration
    default:
      break
    }
  }

  func menuButtonCell(didSelectMenuItemForItem item: DemoDataSource.Item,
                      menuItem: UIAction.Identifier) {
    switch item {
    case .durationPickerPickerMode:
      let selectedMode = DurationPicker.Mode(rawValue: menuItem.rawValue)
      viewModel.pickerMode = selectedMode
    default:
      break
    }
  }
}
