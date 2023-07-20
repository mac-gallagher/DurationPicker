# Localization

Learn how DurationPicker supports multiple languages and regions.

Locales encapsulate information about facets of a language or culture, including the way duration measurements are formatted. For apps which target iOS 13 and above, explictily setting a locale is discouraged by Apple in favor of using [per-app language settings](https://developer.apple.com/news/?id=u2cfuj88). Hence, the language that ``DurationPicker`` uses for display is determined entirely by the system locale. This is unlike [`UIDatePicker`](https://developer.apple.com/documentation/uikit/uidatepicker) whose [locale](https://developer.apple.com/documentation/uikit/uidatepicker/1615995-locale) can be overridden.

## Supported locales
Below is a list of locales supported by the library.

| Locale | Identifier | Supported | 
|--|--|--|
| Arabic | `ar` | No |
| Catalan | `ca` | Yes |
| Chinese (Hong-Kong) | `zh-HK` | Yes |
| Chinese, Simplified | `zh-Hans` | Yes |
| Chinese, Traditional | `zh-Hant` | Yes |
| Croatian | `hr` | Yes |
| Czech | `cs` | Yes |
| Danish | `da` | Yes |
| Dutch | `nl` | Yes |
| English | `en` | Yes |
| English (Australia) | `en-AU` | Yes |
| English (India) | `en-IN` | Yes |
| English (United Kingdom) | `en-UK` | Yes |
| Finnish | `fi` | Yes |
| French | `fr` | Yes |
| French (Canada) | `fr-CA` | Yes\* |
| German | `de` | Yes |
| Greek | `el` | Yes |
| Hebrew | `he` | No |
| Hindi | `hi` | Yes |
| Hungarian | `hu` | Yes |
| Indonesian | `id` | Yes |
| Italian | `it` | Yes |
| Japanese | `ja` | Yes |
| Korean | `ko` | Yes |
| Malay | `ms` | Yes |
| Norwegian Bokmål | `nb` | Yes |
| Polish | `pl` | Yes |
| Portuguese (Brazil) | `pt-BR` | Yes |
| Portuguese (Portugal) | `pt-PT` | Yes |
| Romainian | `ro` | Yes |
| Russian | `ru` | Yes |
| Slovak | `sk` | Yes |
| Spanish | `es` | Yes\* |
| Spanish (Latin America) | `es-419` | Yes\* |
| Swedish | `sv` | Yes |
| Thai | `th` | Yes |
| Turkish | `tr` | Yes |
| Ukrainian | `uk` | Yes |
| Vietnamese | `vi` | Yes |

> Support with an asterisk \* indicates that at least one string varies from what is shown on `UIDatePicker` with `countDownTimer` mode. This is done to ensure that the unit labels fit within the duration picker's bounds with `hourMinuteSecond` mode.

If your app includes a language which is not supported, iOS will instead localize using the next language in the user's language preferences. See [How iOS Determines the Language For Your App](https://developer.apple.com/library/archive/qa/qa1828/_index.html) for more information.

For more general information, see [Internationalization and Localization Guide](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/Introduction/Introduction.html#//apple_ref/doc/uid/10000171i).

## How we localized DurationPicker

The only localized strings in the library are the _hour_, _minute_, and _second_ unit strings displayed between the picker rows on ``DurationPicker``. The _hour_ and _minute_ unit strings are observed directly from [UIDatePicker](https://developer.apple.com/documentation/uikit/uidatepicker) with [countDownTimer]([countDownTimer](https://developer.apple.com/documentation/uikit/uidatepicker/mode/countdowntimer)) mode. The _second_ unit strings are localized based on the localized strings returned by [string(from:)](https://developer.apple.com/documentation/foundation/measurementformatter/1642059-string) on [MeasurementFormatter](https://developer.apple.com/documentation/foundation/measurementformatter) when formatting 0, 1, and 2 seconds (zero, singular, and plural). These strings are compared against the localized _hour_ and _minute_ strings from [UIDatePicker](https://developer.apple.com/documentation/uikit/uidatepicker) to determine which [unitStyle](https://developer.apple.com/documentation/foundation/measurementformatter/1642067-unitstyle) is most apppropriate. In general, we observed that the _hour_ [unitStyle](https://developer.apple.com/documentation/foundation/measurementformatter/1642067-unitstyle) was longer than the _minute_ unit style and never shorter. To this end, we assume that _minutes_ and _seconds_ share the same unit style.

For example, to determine the unit string for _one second_ in German, we would write

```swift
let formatter = MeasurementFormatter()
formatter.unitOptions = .providedUnit
formatter.locale = Locale(identifier: "de")

let oneHour = Measurement<UnitDuration>(value: 1, unit: . hours)
let oneMinute = Measurement<UnitDuration>(value: 1, unit: .minutes)
let oneSecond = Measurement<UnitDuration>(value: 1, unit: .seconds)

formatter.unitStyle = .long
formatter.string(from: oneHour) // "1 Stunde"
formatter.string(from: oneMinute) // "1 Minute"
formatter.string(from: oneSecond) // "1 Sekunde"

formatter.unitStyle = .medium
formatter.string(from: oneHour) // "1 Std."
formatter.string(from: oneMinute) // "1 Min."
formatter.string(from: oneSecond) // "1 Sek."

formatter.unitStyle = .short
formatter.string(from: oneHour) // "1h"
formatter.string(from: oneMinute) // "1min"
formatter.string(from: oneSecond) // "1s"
```
The observed _minute_ and _second_ unit strings on `UIDatePicker` are "Stunde" and "Min.", corresponding to the [long](https://developer.apple.com/documentation/foundation/formatter/unitstyle/long) and [medium](https://developer.apple.com/documentation/foundation/formatter/unitstyle/medium) unit styles for hours and minutes, respectively. Hence, we would choose the [medium](https://developer.apple.com/documentation/foundation/formatter/unitstyle/medium) unit style for seconds, or "Sek.".

> If you believe there is a localization error, please [open an issue](https://github.com/mac-gallagher/DurationPicker/issues/new) on GitHub.
