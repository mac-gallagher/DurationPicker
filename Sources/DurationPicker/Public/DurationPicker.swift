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

/// A customizable control for inputting time values ranging between 0 and 24 hours. It serves as a drop-in replacement of [UIDatePicker](https://developer.apple.com/documentation/uikit/uidatepicker) with [countDownTimer](https://developer.apple.com/documentation/uikit/uidatepicker/mode/countdowntimer) mode with additional functionality for time input.
///
/// You can use a duration picker to allow a user to enter a time interval between 0 and 24 hours. The duration picker reports interactions to its associated target object.
///
/// To add a duration picker to your interface:
///
/// * Set the duration picker mode at creation time.
/// * Supply additional configuration options such as minimum and maximum durations if required.
/// * Connect an action method to the duration picker.
/// * Set up Auto Layout rules to govern the position of the duration picker in your interface.
///
/// You use a duration picker only for handling the selection of times between 0 and 24 hours. If you want to handle the selection of dates from a list, use a [`UIDatePicker`](https://developer.apple.com/documentation/uikit/uidatepicker) object.
///
/// ### Configure a DurationPicker
///
/// The ``DurationPicker/pickerMode`` property determines the configuration of a duration picker. The ``DurationPicker/duration`` property represents the currently selected duration in seconds. The duration picker uses locale information when formatting duration values for the current user, and defaults to the app's preferred language setting.
///
/// To limit the duration that the user can select, assign values to the ``DurationPicker/minimumDuration`` and ``DurationPicker/maximumDuration`` properties. You can also use the ``DurationPicker/hourInterval``, ``DurationPicker/minuteInterval``, and ``DurationPicker/secondInterval`` properties to allow only specific time increments.
///
/// The figure below shows a duration picker configured with the ``DurationPicker/pickerMode`` property set to ``DurationPicker/Mode/hourMinuteSecond``, the ``DurationPicker/minuteInterval`` property set to 10, and the ``DurationPicker/secondInterval`` property set to 15. The value of ``DurationPicker/duration`` is currently 5445.
///
/// ![A screenshot of a duration picker showing the selected value of 1 hour, 30 minutes, and 45 seconds.](duration_picker)
///
/// >  When used as a countdown timer, you can use a ``DurationPicker`` object for the selection of a time interval, but you must use a [Timer](https://developer.apple.com/documentation/foundation/timer) object to implement the actual timer behavior. For more information, see [Timer](https://developer.apple.com/documentation/foundation/timer).
///
/// ### Respond to user interaction
/// Duration pickers use the target-action design pattern to notify your app when the user changes the selected duration. To be notified when the duration picker’s value changes, register your action method with the either the [valueChanged](https://developer.apple.com/documentation/uikit/uicontrol/event/1618238-valuechanged) or [primaryActionTriggered](https://developer.apple.com/documentation/uikit/uicontrol/event/1618222-primaryactiontriggered) event. At runtime the duration picker calls your methods in response to the user selecting a duration.
///
/// You connect a date picker to your action method using the [addTarget(_:action:for:)](https://developer.apple.com/documentation/uikit/uicontrol/1618259-addtarget) method. The signature of an action method takes one of three forms, as shown in the following code. Choose the form that provides the information that you need to respond to the value change in the duration picker.
///
/// ```swift
/// @objc func doSomething()
/// @objc func doSomething(sender: DurationPicker)
/// @objc func doSomething(sender: DurationPicker, forEvent event: UIEvent)
/// ```
///
/// Alternatively, you can react to changes in the duration's picker value using [UIActions](https://developer.apple.com/documentation/uikit/uiaction). The code below shows how an action can be registered during initialization or later with the [addAction(_:for:)](https://developer.apple.com/documentation/uikit/uicontrol/3600490-addaction) method.
///
/// ```swift
/// let picker = DurationPicker(
///     frame: .zero,
///     primaryAction: UIAction { _ in
///         // Do something
///     })
/// ```
///
/// ```swift
/// let picker = DurationPicker()
/// picker.addAction(
///     UIAction { _ in
///         // Do something
///     },
///     for: .primaryActionTriggered)
/// ```
///
/// ### Debug duration pickers
/// When debugging issues with duration pickers, watch for these common pitfalls:
///
/// - **The minimum duration must be at most the maximum duration.** Check the bounds of your ``DurationPicker/minimumDuration`` and ``DurationPicker/maximumDuration`` properties. If the maximum duration is less than the minimum duration, both properties are ignored, and the duration picker allows the selection of any duration value.
/// - **There must be at least one value defined between the minimum duration and maximum duration.** Check that the range of values determined by the ``DurationPicker/hourInterval``, ``DurationPicker/minuteInterval``, and ``DurationPicker/secondInterval`` properties includes at least one value between the minimum and maximum durations. Otherwise, the ``DurationPicker/minimumDuration`` and ``DurationPicker/maximumDuration`` properties are ignored.
///- **The hour, minute, and second intervals must evenly divide their respective totals.** Check that the ``DurationPicker/minuteInterval``  and ``DurationPicker/secondInterval`` values can be evenly divided into 60, and that the ``DurationPicker/hourInterval`` value can be evenly divided into 24. Otherwise, the default value is used (1).
///
/// ### Support accessibility and VoiceOver
/// Duration pickers are accessible by default. Each time component in the duration picker is its own accessibility element and has the Adjustable ([adjustable](https://developer.apple.com/documentation/uikit/uiaccessibilitytraits/1620177-adjustable)) trait.
///
/// The device reads the accessibility value, traits, and hint out loud for each date picker when the user enables VoiceOver. VoiceOver speaks this information when a user taps on a picker wheel. For example, when a user taps the hours column, VoiceOver speaks the following:
///
/// ```swift
///  "2 hours. Picker Item. Adjustable. 1 of 24. Swipe up or down with one finger to adjust the value."
///  ```
///
///For further information about making iOS controls accessible, see [Building accessible apps](https://developer.apple.com/accessibility/).
///
/// ## Topics
///
/// ### Managing the duration and locale
/// - <doc:Localization>
/// - ``DurationPicker/duration``
/// - ``DurationPicker/setDuration(_:animated:)``
///
/// ### Configuring the duration picker mode
/// - ``DurationPicker/pickerMode``
/// - ``DurationPicker/Mode``
///
/// ### Configuring the temporal attributes
/// - ``DurationPicker/minimumDuration``
/// - ``DurationPicker/maximumDuration``
/// - ``DurationPicker/secondInterval``
/// - ``DurationPicker/minuteInterval``
/// - ``DurationPicker/hourInterval``
open class DurationPicker: UIControl {

  /// The mode of the duration picker.
  ///
  /// Use this property to change the type of information displayed by the duration picker. It determines whether the duration picker allows selection of hours, minutes, and/or seconds. The default mode is ``DurationPicker/Mode/hourMinuteSecond``. See ``DurationPicker/Mode`` for a list of mode constants.
  public var pickerMode: Mode {
    get { pickerView.pickerMode }
    set { pickerView.pickerMode = newValue }
  }

  /// The minimum duration that the picker can show.
  ///
  /// Use this property to configure the minimum duration that is selected in the duration picker interface. The property is an integer measured in seconds or `nil` (the default), which means no minimum duration. This property, along with the ``maximumDuration`` property, lets you specify a valid duration range. The range must contains at least one allowed value as determined by the ``DurationPicker/hourInterval``, ``DurationPicker/minuteInterval``, and ``DurationPicker/secondInterval`` properties. If the minimum duration value is greater than the maximum duration value, or if the time range contains no allowed values, both properties are ignored.
  public var minimumDuration: TimeInterval? {
    get { pickerView.minimumDuration.asTimeInterval }
    set { pickerView.minimumDuration = newValue.asInteger }
  }

  /// The maximum duration that the picker can show.
  ///
  /// Use this property to configure the maximum duration that is selected in the duration picker interface. The property is an integer measured in seconds or `nil` (the default), which means no maximum duration. This property, along with the ``minimumDuration`` property, lets you specify a valid duration range. The range must contains at least one allowed value as determined by the ``DurationPicker/hourInterval``, ``DurationPicker/minuteInterval``, and ``DurationPicker/secondInterval`` properties. If the minimum duration value is greater than the maximum duration value, or if the time range contains no allowed values, both properties are ignored.
  public var maximumDuration: TimeInterval? {
    get { pickerView.maximumDuration.asTimeInterval }
    set { pickerView.maximumDuration = newValue.asInteger }
  }

  /// The interval at which the duration picker should display seconds.
  ///
  /// Use this property to set the interval displayed by the seconds wheel (for example, 15 seconds). The interval value must be evenly divided into 60; if it isn’t, the default value is used. The default and minimum values are 1; the maximum value is 30.
  public var secondInterval: Int {
    get { pickerView.secondInterval }
    set { pickerView.secondInterval = newValue }
  }

  /// The interval at which the duration picker should display minutes.
  ///
  /// Use this property to set the interval displayed by the minutes wheel (for example, 15 minutes). The interval value must be evenly divided into 60; if it isn’t, the default value is used. The default and minimum values are 1; the maximum value is 30.
  public var minuteInterval: Int {
    get { pickerView.minuteInterval }
    set { pickerView.minuteInterval = newValue }
  }

  /// The interval at which the duration picker should display hours.
  ///
  /// Use this property to set the interval displayed by the hours wheel (for example, 4 hours). The interval value must be evenly divided into 24; if it isn’t, the default value is used. The default and minimum values are 1; the maximum value is 12.
  public var hourInterval: Int {
    get { pickerView.hourInterval }
    set { pickerView.hourInterval = newValue }
  }

  /// The value displayed by the duration picker.
  ///
  /// Use this property to get and set the currently selected value. This property is of type `TimeInterval` and therefore is measured in seconds. The default value is 0.0 and the maximum value is 23:59:59 (86,399 seconds).
  public var duration: TimeInterval {
    get { TimeInterval(pickerView.duration) }
    set { setDuration(newValue, animated: false) }
  }

  private let pickerView = DurationPickerView()

  // MARK: - Initializers & View Lifecycle

  @_documentation(visibility: internal)
  public override init(frame: CGRect) {
    super.init(frame: CGRect(
      origin: frame.origin,
      size: pickerView.intrinsicContentSize))
    commonInit()
  }

  @_documentation(visibility: internal)
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    addSubview(pickerView)

    pickerView.durationUpdateBlock = { [weak self] _ in
      guard let self else { return }
      // Objective-C target/action event
      sendActions(for: .valueChanged)
      // UIAction event
      sendActions(for: .primaryActionTriggered)
    }
  }

  @_documentation(visibility: internal)
  open override func layoutSubviews() {
    super.layoutSubviews()
    pickerView.frame = bounds
  }

  // MARK: - Setters

  /// Sets the time to display in the duration picker, with an option to animate the setting.
  ///
  /// Values are rounded down to the closest allowed value, e.g. if the mode is ``DurationPicker/Mode/hourMinute`` the value 119 will be rounded down to 60.
  ///
  /// - Parameters:
  ///   - duration: The new duration (in seconds) to display in the duration picker.
  ///   - animated: `true` to animate the setting of the new time, otherwise `false`. The animation rotates the wheels until the new time is shown under the highlight rectangle.
  open func setDuration(_ duration: TimeInterval,
                        animated: Bool) {
    pickerView.setDuration(
      Int(duration),
      animated: animated)
  }

  // MARK: - Sizing

  @_documentation(visibility: internal)
  open override var intrinsicContentSize: CGSize {
    pickerView.intrinsicContentSize
  }

  @_documentation(visibility: internal)
  open override func invalidateIntrinsicContentSize() {
    super.invalidateIntrinsicContentSize()
    pickerView.invalidateIntrinsicContentSize()
  }

  @_documentation(visibility: internal)
  open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
    pickerView.systemLayoutSizeFitting(targetSize)
  }

  @_documentation(visibility: internal)
  open override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                             withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                             verticalFittingPriority: UILayoutPriority) -> CGSize {
    pickerView.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: horizontalFittingPriority,
      verticalFittingPriority: verticalFittingPriority)
  }

  @_documentation(visibility: internal)
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    pickerView.sizeThatFits(size)
  }

  @_documentation(visibility: internal)
  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    // Invalidate the intrinsic content size since UIPicker has different heights depending on its
    // horizontal and vertical size classes
    if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
        || previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
      invalidateIntrinsicContentSize()
    }
  }
}
