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

final class DemoTextFieldContentView: UIView, UIContentView, UITextFieldDelegate {

  var configuration: UIContentConfiguration {
    didSet {
      updateConfiguration(textFieldConfiguration)
    }
  }

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
    return label
  }()

  private let textField: UITextField = {
    let textField = UITextField()
    textField.clearButtonMode = .whileEditing
    textField.keyboardType = .decimalPad

    let doneAction = UIAction(title: "Done") { _ in
      textField.endEditing(true)
    }
    let doneButton = UIBarButtonItem(
      systemItem: .done,
      primaryAction: doneAction)

    let toolbar = UIToolbar()
    // Set explicit size to prevent broken constraints in the console
    toolbar.frame.size.height = 44
    toolbar.frame.size.width = 100
    toolbar.items = [.flexibleSpace(), doneButton]
    textField.inputAccessoryView = toolbar

    return textField
  }()

  private var textFieldConfiguration: DemoTextFieldContentConfiguration! {
    configuration as? DemoTextFieldContentConfiguration
  }

  private static let horizontalPadding: CGFloat = 20

  private static let verticalPadding: CGFloat = 12

  private static let titleLabelToTextFieldPadding: CGFloat = 12

  init(configuration: DemoTextFieldContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)

    textField.delegate = self

    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Self.horizontalPadding),
      titleLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Self.verticalPadding),
      titleLabel.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Self.verticalPadding),
    ])

    addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.leadingAnchor.constraint(
        equalTo: titleLabel.trailingAnchor,
        constant: Self.titleLabelToTextFieldPadding),
      textField.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Self.verticalPadding),
      textField.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Self.verticalPadding),
      textField.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Self.horizontalPadding),
    ])
  }

  required init?(coder: NSCoder) {
    return nil
  }

  private func updateConfiguration(_ textFieldConfiguration: DemoTextFieldContentConfiguration) {
    if titleLabel.text != textFieldConfiguration.title {
      titleLabel.text = textFieldConfiguration.title
    }

    if textField.text != textFieldConfiguration.text {
      textField.text = textFieldConfiguration.text
    }

    if textField.placeholder != textFieldConfiguration.placeholder {
      textField.placeholder = textFieldConfiguration.placeholder
    }
  }

  // MARK: - UITextFieldDelegate

  func textFieldDidEndEditing(_ textField: UITextField) {
    textFieldConfiguration.textUpdateHandler?(textField.text)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
