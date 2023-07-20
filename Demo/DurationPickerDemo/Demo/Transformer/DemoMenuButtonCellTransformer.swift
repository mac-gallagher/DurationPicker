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

enum DemoMenuButtonCellTransformer {

  static func makeCellRegistration(viewModel: DemoViewModel,
                                   delegate: DemoCellDelegate?) -> DemoCellRegistration {
    DemoCellRegistration { [weak delegate] cell, indexPath, item in
      var configuration = UIListContentConfiguration.valueCell()
      configuration.text = makeText(for: item)
      cell.contentConfiguration = configuration
      UIView.performWithoutAnimation {
        cell.accessories = makeAccessories(
          for: item,
          pickerMode: viewModel.pickerMode,
          delegate: delegate)
      }
    }
  }

  // MARK: - Private

  private static func makeText(for item: DemoDataSource.Item) -> String? {
    switch item {
    case .durationPickerPickerMode:
      return "Picker Mode"
    case .durationPickerValue:
      return "Selected Duration"
    default:
      return nil
    }
  }

  private static func makeAccessories(for item: DemoDataSource.Item,
                                      pickerMode: DurationPicker.Mode,
                                      delegate: DemoCellDelegate?) -> [UICellAccessory] {
    switch item {
    case .durationPickerPickerMode:
      let button = makePickerModeButton(
        for: item,
        pickerMode: pickerMode,
        delegate: delegate)
      let configuration = UICellAccessory.CustomViewConfiguration(
        customView: button,
        placement: .trailing())
      return [.customView(configuration: configuration)]
    default:
      return []
    }
  }

  private static func makePickerModeButton(for item: DemoDataSource.Item,
                                           pickerMode: DurationPicker.Mode,
                                           delegate: DemoCellDelegate?) -> UIButton {
    let actions = DurationPicker.Mode.allCases.map {
      UIAction(
        title: $0.rawValue,
        identifier: $0.asActionIdentifier) { [weak delegate] action in
          delegate?.menuButtonCell(
            didSelectMenuItemForItem: item,
            menuItem: action.identifier)
        }
    }
    var buttonConfiguration: UIButton.Configuration = .plain()
    buttonConfiguration.title = pickerMode.rawValue

    let button = UIButton(configuration: buttonConfiguration)
    button.showsMenuAsPrimaryAction = true
    button.menu = UIMenu(children: actions)
    return button
  }
}
