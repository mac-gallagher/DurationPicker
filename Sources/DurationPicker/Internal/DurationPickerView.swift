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

/// A subclass of `UIPickerView` which to obfuscates the `UIPickerViewDataSource` and `UIPickerViewDelegate` conformance from the public `DurationPicker` interface.
final class DurationPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate, UIPickerViewAccessibilityDelegate {

  // MARK: - Configuration Properties

  var pickerMode: DurationPicker.Mode {
    get { internalPickerMode }
    set { setPickerMode(newValue) }
  }

  private var internalPickerMode: DurationPicker.Mode = .hourMinuteSecond

  var duration: Int {
    get { timeComponents.duration }
    set { setDuration(newValue, animated: false) }
  }

  private var timeComponents = TimeComponents()

  var durationUpdateBlock: ((Int) -> Void)?

  var minimumDuration: Int? {
    set {
      setDurationRange(
        minimumDuration: newValue,
        maximumDuration: maximumDuration)
    }
    get { internalMinimumDuration }
  }

  private var internalMinimumDuration: Int?

  /// The minimum components displayed on the duration picker.
  ///
  /// > Important This may not align with `internalMinimumDuration`, for instance when the minimum duration is larger than the maximum duration
  private lazy var minimumDurationComponents = makeAbsoluteMinimumDurationComponents()

  var maximumDuration: Int? {
    set {
      setDurationRange(
        minimumDuration: minimumDuration,
        maximumDuration: newValue)
    }
    get { internalMaximumDuration }
  }

  private var internalMaximumDuration: Int?

  /// The maimum components displayed on the duration picker.
  ///
  /// > Important This may not align with `internalMaximumDuration`, for instance when the minimum duration is larger than the maximum duration
  private lazy var maximumDurationComponents = makeAbsoluteMaximumDurationComponents()

  var secondInterval: Int {
    get { internalSecondInterval }
    set { setInterval(newValue, forComponentType: .second) }
  }

  private var internalSecondInterval: Int = 1

  var minuteInterval: Int {
    get { internalMinuteInterval }
    set { setInterval(newValue, forComponentType: .minute) }
  }

  private var internalMinuteInterval: Int = 1

  var hourInterval: Int {
    get { internalHourInterval }
    set { setInterval(newValue, forComponentType: .hour) }
  }

  private var internalHourInterval: Int = 1

  // MARK: - Layout Properties

  private let hourUnitLabel = makeUnitLabel()

  private let minuteUnitLabel = makeUnitLabel()

  private let secondUnitLabel = makeUnitLabel()

  private let formatter = DurationFormatter()

  // MARK: - Initializers & View Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    delegate = self
    dataSource = self

    addSubview(hourUnitLabel)
    addSubview(minuteUnitLabel)
    addSubview(secondUnitLabel)

    setUnitLabelsText()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    positionUnitLabels()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    // In the orientation is changed while the picker wheel is still animating,
    // reset it to the original duration
    if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
        || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
      refreshDuration()
    }
  }

  // MARK: - Unit Labels

  /// The font of each unit label.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let unitLabelFont = UIFont.systemFont(
    ofSize: 17,
    weight: .semibold)

  /// The spacing between a row's content view label and its corresponding unit label.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let contentViewLabelToUnitLabelSpacing: CGFloat = 6

  /// The spacing between the columns in `DurationPickerView`.
  ///
  /// Observed from the view hierarchy of `UIDatePicker with `countDownTimer` mode.
  private static let columnSpacing: CGFloat = 5

  /// The baseline offset of the unit label.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let unitLabelBaselineOffset: CGFloat = 1

  /// The vertical offset to align the baseline of the unit label with the label in `DurationPickerContentView`.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let unitLabelVerticalPositionAdjustment: CGFloat = UIScreen.main.scale == 2 ? 2 : 1

  private static func makeUnitLabel() -> UILabel {
    let label = UILabel()
    label.font = unitLabelFont
    label.isOpaque = false
    return label
  }

  private func setUnitLabelsText() {
    UIView.performWithoutAnimation { [weak self] in
      guard let self else { return }

      let hourText = formatter.unitString(
        fromValue: timeComponents.hour,
        unit: .hour)
      hourUnitLabel.setAnimatedText(hourText)
      hourUnitLabel.sizeToFitNearestPixel(baselineOffset: Self.unitLabelBaselineOffset)

      let minuteText = formatter.unitString(
        fromValue: timeComponents.minute,
        unit: .minute)
      minuteUnitLabel.setAnimatedText(minuteText)
      minuteUnitLabel.sizeToFitNearestPixel(baselineOffset: Self.unitLabelBaselineOffset)

      let secondText = formatter.unitString(
        fromValue: timeComponents.second,
        unit: .second)
      secondUnitLabel.setAnimatedText(secondText)
      secondUnitLabel.sizeToFitNearestPixel(baselineOffset: Self.unitLabelBaselineOffset)
    }
  }

  private func positionUnitLabels() {
    UIView.performWithoutAnimation { [weak self] in
      guard let self else { return }

      // Favor shifting labels down if its origin lies between two pixels
      hourUnitLabel.frame.origin.x = unitLabelOriginX(forComponent: pickerMode.hourComponent)
      hourUnitLabel.center.y = center.y + Self.unitLabelVerticalPositionAdjustment
      hourUnitLabel.frame.origin.y.roundToNearestPixel()

      minuteUnitLabel.frame.origin.x = unitLabelOriginX(forComponent: pickerMode.minuteComponent)
      minuteUnitLabel.center.y = center.y + Self.unitLabelVerticalPositionAdjustment
      minuteUnitLabel.frame.origin.y.roundToNearestPixel()

      secondUnitLabel.frame.origin.x = unitLabelOriginX(forComponent: pickerMode.secondComponent)
      secondUnitLabel.center.y = center.y + Self.unitLabelVerticalPositionAdjustment
      secondUnitLabel.frame.origin.y.roundToNearestPixel()
    }
  }

  private func unitLabelOriginX(forComponent component: Int?) -> CGFloat {
    guard let component else {
      return 0
    }
    let numberOfColumns = CGFloat(pickerMode.numberOfComponents)
    let rowWidth = rowWidth()
    let pickerWidth = numberOfColumns * rowWidth
    + (numberOfColumns - 1) * Self.columnSpacing
    let firstRowOriginX = (frame.width - pickerWidth) / 2

    let originX = firstRowOriginX
    + CGFloat(component) * (rowWidth + Self.columnSpacing)
    + DurationPickerContentView.labelBoundingRect().width
    + Self.contentViewLabelToUnitLabelSpacing

    // Favor shifting labels to the right if values lie between two pixels
    return originX.roundedToNearestPixel(roundingRule: .up)
  }

  // MARK: - Duration

  func setDuration(_ duration: Int,
                   animated: Bool) {
    timeComponents = TimeComponents.components(
      fromDuration: duration,
      pickerMode: pickerMode,
      minimumDuration: minimumDurationComponents.duration,
      maximumDuration: maximumDurationComponents.duration,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    // Set unit label text in case the text may have changed, e.g. "hour" to "hours"
    setUnitLabelsText()

    durationUpdateBlock?(timeComponents.duration)

    // Select hour row
    if let hourComponent = pickerMode.hourComponent {
      selectRow(
        timeComponents.hour / hourInterval,
        inComponent: hourComponent,
        animated: animated)
    }

    // Select minute row
    if let minuteComponent = pickerMode.minuteComponent {
      selectRow(
        timeComponents.minute / minuteInterval,
        inComponent: minuteComponent,
        animated: animated)
    }

    // Select second row
    if let secondComponent = pickerMode.secondComponent {
      selectRow(
        timeComponents.second / secondInterval,
        inComponent: secondComponent,
        animated: animated)
    }
  }

  private func refreshDuration() {
    setDuration(
      duration,
      animated: false)
  }

  private func setDurationRange(minimumDuration: Int?,
                                maximumDuration: Int?) {
    internalMinimumDuration = minimumDuration
    internalMaximumDuration = maximumDuration

    switch (minimumDuration, maximumDuration) {
    case (.some(let minimum), .some(let maximum)):
      let absoluteMaximum = TimeUtils.absoluteMaximumDuration(
        forPickerMode: pickerMode,
        hourInterval: hourInterval,
        minuteInterval: minuteInterval,
        secondInterval: secondInterval)
      let isValidRange = maximum >= 0
      && minimum <= absoluteMaximum
      && minimum <= maximum
      if isValidRange {
        minimumDurationComponents = makeMinimumDurationComponents(fromMinimum: minimum)
        maximumDurationComponents = makeMaximumDurationComponents(fromMaximum: maximum)
      } else {
        minimumDurationComponents = makeAbsoluteMinimumDurationComponents()
        maximumDurationComponents = makeAbsoluteMaximumDurationComponents()
      }
    case (.some(let minimum), .none):
      minimumDurationComponents = makeMinimumDurationComponents(fromMinimum: minimum)
      maximumDurationComponents = makeAbsoluteMaximumDurationComponents()
    case (.none, .some(let maximum)):
      minimumDurationComponents = makeAbsoluteMinimumDurationComponents()
      maximumDurationComponents = makeMaximumDurationComponents(fromMaximum: maximum)
    case (.none, .none):
      minimumDurationComponents = makeAbsoluteMinimumDurationComponents()
      maximumDurationComponents = makeAbsoluteMaximumDurationComponents()
    }

    // Reload the components since the muted rows may have changed
    reloadAllComponents()

    // Reset the current duration in case it doesn't fit within the new range
    refreshDuration()
  }

  private func refreshDurationRange() {
    setDurationRange(
      minimumDuration: internalMinimumDuration,
      maximumDuration: internalMaximumDuration)
  }

  private func makeAbsoluteMinimumDurationComponents() -> TimeComponents {
    TimeComponents()
  }

  private func makeMinimumDurationComponents(fromMinimum minimum: Int) -> TimeComponents {
    let absoluteMaximum = TimeUtils.absoluteMaximumDuration(
      forPickerMode: pickerMode,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)

    guard minimum <= absoluteMaximum else {
      return makeAbsoluteMinimumDurationComponents()
    }

    return .components(
      fromDuration: minimum,
      pickerMode: pickerMode,
      roundingMode: .up,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)
  }

  private func makeAbsoluteMaximumDurationComponents() -> TimeComponents {
    TimeComponents(
      uncheckedHour: TimeUtils.maximumNumberOfHours(
        forPickerMode: pickerMode,
        hourInterval: hourInterval),
      uncheckedMinute: TimeUtils.maximumNumberOfMinutes(
        forPickerMode: pickerMode,
        minuteInterval: minuteInterval),
      uncheckedSecond: TimeUtils.maximumNumberOfSeconds(
        forPickerMode: pickerMode,
        secondInterval: secondInterval))
  }

  private func makeMaximumDurationComponents(fromMaximum maximum: Int) -> TimeComponents {
    guard maximum >= 0 else {
      return makeAbsoluteMaximumDurationComponents()
    }
    return .components(
      fromDuration: maximum,
      pickerMode: pickerMode,
      hourInterval: hourInterval,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval)
  }

  // MARK: - Picker Mode

  func setPickerMode(_ pickerMode: DurationPicker.Mode) {
    internalPickerMode = pickerMode

    // Set unit label visibility
    switch pickerMode {
    case .hour:
      hourUnitLabel.isHidden = false
      minuteUnitLabel.isHidden = true
      secondUnitLabel.isHidden = true
    case .hourMinute:
      hourUnitLabel.isHidden = false
      minuteUnitLabel.isHidden = false
      secondUnitLabel.isHidden = true
    case .hourMinuteSecond:
      hourUnitLabel.isHidden = false
      minuteUnitLabel.isHidden = false
      secondUnitLabel.isHidden = false
    case .minute:
      hourUnitLabel.isHidden = true
      minuteUnitLabel.isHidden = false
      secondUnitLabel.isHidden = true
    case .minuteSecond:
      hourUnitLabel.isHidden = true
      minuteUnitLabel.isHidden = false
      secondUnitLabel.isHidden = false
    case .second:
      hourUnitLabel.isHidden = true
      minuteUnitLabel.isHidden = true
      secondUnitLabel.isHidden = false
    }

    reloadAllComponents()

    // UIPickerView does not request the delegate for new row widths when the number of components has not changed.
    // However, we observed that the adding an additional call to layoutIfNeeded() will always fetch the updated widths
    // Calling this will also update the unit labels' positions
    setNeedsLayout()

    // Reset the duration range so that the minimum and maximum components use the new picker mode
    // Note: This will also call setDuration(:animated:) using the new picker mode, so we don't explictly call it here
    refreshDurationRange()
  }

  // MARK: - Intervals

  private func setInterval(_ interval: Int,
                           forComponentType componentType: DurationPickerComponentType) {
    switch componentType {
    case .hour:
      if (1...NumberOfHours / 2).contains(interval)
          && NumberOfHours.isMultiple(of: interval) {
        internalHourInterval = interval
      } else {
        internalHourInterval = 1
      }
    case .minute:
      if (1...NumberOfMinutes / 2).contains(interval)
          && NumberOfMinutes.isMultiple(of: interval) {
        internalMinuteInterval = interval
      } else {
        internalMinuteInterval = 1
      }
    case .second:
      if (1...NumberOfSeconds / 2).contains(interval)
          && NumberOfSeconds.isMultiple(of: interval) {
        internalSecondInterval = interval
      } else {
        internalSecondInterval = 1
      }
    }

    // Reset the duration range so that the minimum and maximum components use the new interval
    // Note: This will also call setDuration(:animated:) using the new interval, so we don't explictly call it here
    refreshDurationRange()
  }

  // MARK: - UIPickerViewDelegate

  /// The height of each row in the picker.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  private static let rowHeight: CGFloat = 32

  func pickerView(_ pickerView: UIPickerView,
                  viewForRow row: Int,
                  forComponent component: Int,
                  reusing view: UIView?) -> UIView {
    let contentView = view as? DurationPickerContentView ?? DurationPickerContentView()

    guard let componentType = pickerMode.componentType(fromComponent: component) else {
      return contentView
    }

    let rowValue = value(
      forRow: row,
      inComponent: component)

    let shouldMuteTitle = shouldMuteTitle(
      forRow: row,
      inComponent: component)

    let accessiblityLabel: String? = {
      switch componentType {
      case .hour:
        formatter.string(
          fromValue: rowValue,
          unit: .hour)
      case .minute:
        formatter.string(
          fromValue: rowValue,
          unit: .minute)
      case .second:
        formatter.string(
          fromValue: rowValue,
          unit: .second)
      }
    }()

    let rowText = formatter.string(fromValue: rowValue)
    contentView.setText(
      rowText,
      muted: shouldMuteTitle,
      accessibilityLabel: accessiblityLabel)

    return contentView
  }

  private func shouldMuteTitle(forRow row: Int,
                               inComponent component: Int) -> Bool {
    guard let componentType = pickerMode.componentType(fromComponent: component) else {
      return false
    }

    let rowValue = value(
      forRow: row,
      inComponent: component)

    switch componentType {
    case .hour:
      let rowAtLeastMinimum = rowValue >= minimumDurationComponents.hour
      let rowAtMostMaximum = rowValue <= maximumDurationComponents.hour
      return !rowAtLeastMinimum || !rowAtMostMaximum
    case .minute:
      let selectedHour = selectedRow(forComponentType: .hour)
      let rowAtLeastMinimum = selectedHour > minimumDurationComponents.hour
      || rowValue >= minimumDurationComponents.minute
      let rowAtMostMaximum = selectedHour < maximumDurationComponents.hour
      || rowValue <= maximumDurationComponents.minute
      return !rowAtLeastMinimum || !rowAtMostMaximum
    case .second:
      let selectedHour = selectedRow(forComponentType: .hour)
      let selectedMinute = selectedRow(forComponentType: .minute)
      let rowAtLeastMinimum = selectedHour > minimumDurationComponents.hour
      || selectedMinute > minimumDurationComponents.minute
      || rowValue >= minimumDurationComponents.second
      let rowAtMostMaximum = selectedHour < maximumDurationComponents.hour
      || selectedMinute < maximumDurationComponents.minute
      || rowValue <= maximumDurationComponents.second
      return !rowAtLeastMinimum || !rowAtMostMaximum
    }
  }

  private func value(forRow row: Int,
                     inComponent component: Int) -> Int {
    guard let componentType = pickerMode.componentType(fromComponent: component) else {
      return 0
    }
    switch componentType {
    case .hour:
      return row * hourInterval
    case .minute:
      return row * minuteInterval
    case .second:
      return row * secondInterval
    }
  }

  private func selectedRow(forComponentType componentType: DurationPickerComponentType) -> Int {
    switch componentType {
    case .hour:
      if let hourComponent = pickerMode.hourComponent {
        return value(
          forRow: selectedRow(inComponent: hourComponent),
          inComponent: hourComponent)
      }
    case .minute:
      if let minuteComponent = pickerMode.minuteComponent {
        return value(
          forRow: selectedRow(inComponent: minuteComponent),
          inComponent: minuteComponent)
      }
    case .second:
      if let secondComponent = pickerMode.secondComponent {
        return value(
          forRow: selectedRow(inComponent: secondComponent),
          inComponent: secondComponent)
      }
    }
    return 0
  }

  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    guard let componentType = pickerMode.componentType(fromComponent: component) else {
      return
    }
    switch componentType {
    case .hour:
      // If hour is selected, reload minute and second components since the mute states may have changed
      if let minuteComponent = pickerMode.minuteComponent {
        reloadComponent(minuteComponent)
      }
      if let secondComponent = pickerMode.secondComponent {
        reloadComponent(secondComponent)
      }

      // Set rows
      let hours = value(
        forRow: row,
        inComponent: component)
      let newDuration = TimeUtils.seconds(
        fromHours: hours,
        minutes: selectedRow(forComponentType: .minute),
        seconds: selectedRow(forComponentType: .second))
      setDuration(
        newDuration,
        animated: true)
    case .minute:
      // If minute is selected, reload second component since the mute state may have changed
      if let secondComponent = pickerMode.secondComponent {
        reloadComponent(secondComponent)
      }

      // Set rows
      let minutes = value(
        forRow: row,
        inComponent: component)
      let newDuration = TimeUtils.seconds(
        fromHours: selectedRow(forComponentType: .hour),
        minutes: minutes,
        seconds: selectedRow(forComponentType: .second))
      setDuration(
        newDuration,
        animated: true)
    case .second:
      // Set rows
      let seconds = value(
        forRow: row,
        inComponent: component)
      let newDuration = TimeUtils.seconds(
        fromHours: selectedRow(forComponentType: .hour),
        minutes: selectedRow(forComponentType: .minute),
        seconds: seconds)
      setDuration(
        newDuration,
        animated: true)
    }
  }

  func pickerView(_ pickerView: UIPickerView,
                  rowHeightForComponent component: Int) -> CGFloat {
    Self.rowHeight
  }

  func pickerView(_ pickerView: UIPickerView,
                  widthForComponent component: Int) -> CGFloat {
    rowWidth()
  }

  /// The width of each row in the picker.
  ///
  /// Observed from the view hierarchy of `UIDatePicker` with `countDownTimer` mode.
  ///
  /// > Important: The row width `UIDatePicker` with `countDownTimer` mode was observed to be smaller for iOS 17 (80) when compared to iOS 16 (106). Because we have up to three components, we elected to use the smaller width for both iOS versions.
  private func rowWidth() -> CGFloat {
    // We observed that UIDatePicker always has an integer row width, hence we round down to the nearest integer.
    // As a result, any pixel rounding will overflow past the bounds of the row
    let width = DurationPickerContentView.labelBoundingRect().width
    + Self.contentViewLabelToUnitLabelSpacing
    +  maximumUnitLabelBoundingWidth()
    return width.rounded(.down)
  }

  private func maximumUnitLabelBoundingWidth() -> CGFloat {
    let unitStrings: [String]
    switch pickerMode {
    case .hour:
      unitStrings = formatter.possibleUnitStrings(forUnit: .hour)
    case .hourMinute:
      unitStrings = formatter.possibleUnitStrings(forUnit: .hour)
      + formatter.possibleUnitStrings(forUnit: .minute)
    case .hourMinuteSecond:
      unitStrings = formatter.possibleUnitStrings(forUnit: .hour)
      + formatter.possibleUnitStrings(forUnit: .minute)
      + formatter.possibleUnitStrings(forUnit: .second)
    case .minute:
      unitStrings = formatter.possibleUnitStrings(forUnit: .minute)
    case .minuteSecond:
      unitStrings = formatter.possibleUnitStrings(forUnit: .minute)
      + formatter.possibleUnitStrings(forUnit: .second)
    case .second:
      unitStrings = formatter.possibleUnitStrings(forUnit: .second)
    }

    return unitStrings.reduce(0) { partialResult, text in
      let boundingRect = text.boundingRectRoundedToNearestPixel(font: Self.unitLabelFont)
      return max(partialResult, boundingRect.width)
    }
  }

  // MARK: - UIPickerViewDataSource

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    pickerMode.numberOfComponents
  }

  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    guard let componentType = pickerMode.componentType(fromComponent: component) else {
      return 0
    }
    switch componentType {
    case .hour:
      return NumberOfHours / hourInterval
    case .minute:
      return NumberOfMinutes / minuteInterval
    case .second:
      return NumberOfSeconds / secondInterval
    }
  }

  // MARK: - UIPickerViewAccessibilityDelegate

  func pickerView(_ pickerView: UIPickerView,
                  accessibilityUserInputLabelsForComponent component: Int) -> [String] {
    guard let componentType = pickerMode.componentType(fromComponent: component) else {
      return []
    }
    switch componentType {
    case .hour:
      return [String(localizedFromModule: "hour_a11y_label")]
    case .minute:
      return [String(localizedFromModule: "minute_a11y_label")]
    case .second:
      return [String(localizedFromModule: "second_a11y_label")]
    }
  }
}
