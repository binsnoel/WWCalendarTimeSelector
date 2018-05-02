//
//  WWCalendarTimeSelector.swift
//  WWCalendarTimeSelector
//
//  Created by Weilson Wonder on 18/4/16.
//  Copyright © 2016 Wonder. All rights reserved.
//

import UIKit

@objc public final class WWCalendarTimeSelectorStyle: NSObject {
    fileprivate(set) public var showDateMonth: Bool = true
    fileprivate(set) public var showMonth: Bool = false
    fileprivate(set) public var showYear: Bool = true
    fileprivate(set) public var showTime: Bool = true
    fileprivate var isSingular = false
    
    public func showDateMonth(_ show: Bool) {
        showDateMonth = show
        showMonth = show ? false : showMonth
        if show && isSingular {
            showMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showMonth(_ show: Bool) {
        showMonth = show
        showDateMonth = show ? false : showDateMonth
        if show && isSingular {
            showDateMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showYear(_ show: Bool) {
        showYear = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showTime = false
        }
    }
    
    public func showTime(_ show: Bool) {
        showTime = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showYear = false
        }
    }
    
    fileprivate func countComponents() -> Int {
        return (showDateMonth ? 1 : 0) +
            (showMonth ? 1 : 0) +
            (showYear ? 1 : 0) +
            (showTime ? 1 : 0)
    }
    
    fileprivate convenience init(isSingular: Bool) {
        self.init()
        self.isSingular = isSingular
        showDateMonth = true
        showMonth = false
        showYear = false
        showTime = false
    }
}

/// Set `optionSelectionType` with one of the following:
///
/// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
///
/// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// - Note:
/// Selection styles will only affect date selection. It is currently not possible to select multiple/range
@objc public enum WWCalendarTimeSelectorSelection: Int {
    /// Single Selection.
    case single
    /// Multiple Selection. Year and Time interface not available.
    case multiple
    /// Range Selection. Year and Time interface not available.
    case range
}

/// Set `optionMultipleSelectionGrouping` with one of the following:
///
/// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
///
/// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
///
/// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
@objc public enum WWCalendarTimeSelectorMultipleSelectionGrouping: Int {
    /// Displayed as individual circular selection
    case simple
    /// Rounded rectangular grouping
    case pill
    /// Individual circular selection with a bar between adjacent dates
    case linkedBalls
}

/// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
///
/// - Note:
/// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
/// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
///
/// - Note:
/// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
@objc public enum WWCalendarTimeSelectorTimeStep: Int {
    /// 1 Minute interval, but clock will display intervals of 5 minutes.
    case oneMinute = 1
    /// 5 Minutes interval.
    case fiveMinutes = 5
    /// 10 Minutes interval.
    case tenMinutes = 10
    /// 15 Minutes interval.
    case fifteenMinutes = 15
    /// 30 Minutes interval.
    case thirtyMinutes = 30
    /// Disables the selection of minutes.
    case sixtyMinutes = 60
}

@objc open class WWCalendarTimeSelectorDateRange: NSObject {
    fileprivate(set) open var start: Date = Date().beginningOfDay
    fileprivate(set) open var end: Date = Date().beginningOfDay
    open var array: [Date] {
        var dates: [Date] = []
        var i = start.beginningOfDay
        let j = end.beginningOfDay
        while i.compare(j) != .orderedDescending {
            dates.append(i)
            i = i + 1.day
        }
        return dates
    }
    
    open func setStartDate(_ date: Date) {
        start = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            end = start
        }
    }
    
    open func setEndDate(_ date: Date) {
        end = date.beginningOfDay
        if start.compare(end) == .orderedDescending {
            start = end
        }
    }
}

/// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
///
/// `WWCalendarTimeSelectorDone:selector:dates:`
/// `WWCalendarTimeSelectorDone:selector:date:`
/// `WWCalendarTimeSelectorCancel:selector:dates:`
/// `WWCalendarTimeSelectorCancel:selector:date:`
/// `WWCalendarTimeSelectorWillDismiss:selector:`
/// `WWCalendarTimeSelectorDidDismiss:selector:`
@objc public protocol WWCalendarTimeSelectorProtocol {
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, dates: [Date])
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    @objc optional func WWCalendarTimeSelectorCancel(_ selector: WWCalendarTimeSelector, date: Date)
    
    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    @objc optional func WWCalendarTimeSelectorWillDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    @objc optional func WWCalendarTimeSelectorDidDismiss(_ selector: WWCalendarTimeSelector)
    
    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    @objc optional func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool
}

open class WWCalendarTimeSelector: UIViewController, WWClockProtocol {
    
    /// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    /// `WWCalendarTimeSelectorDone:selector:date:`
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    open weak var delegate: WWCalendarTimeSelectorProtocol?
    
    /// A convenient identifier object. Not used by `WWCalendarTimeSelector`.
    open var optionIdentifier: AnyObject?
    
    /// Set `optionPickerStyle` with one or more of the following:
    ///
    /// `DateMonth`: This shows the the date and month.
    ///
    /// `Year`: This shows the year.
    ///
    /// `Time`: This shows the clock, users will be able to select hour and minutes as well as am or pm.
    ///
    /// - Note:
    /// `optionPickerStyle` should contain at least 1 of the following style. It will default to all styles should there be none in the option specified.
    ///
    /// - Note:
    /// Defaults to all styles.
    open var optionStyles: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle()
    
    /// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
    /// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
    ///
    /// - Note:
    /// Defaults to `OneMinute`.
    open var optionTimeStep: WWCalendarTimeSelectorTimeStep = .oneMinute
    
    /// Set to `true` will show the entire selector at the top. If you only wish to hide the *title bar*, see `optionShowTopPanel`. Set to `false` will hide the entire top container.
    ///
    /// - Note:
    /// Defaults to `true`.
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`.
    open var optionShowTopContainer: Bool = true
    
    /// Set to `true` to show the weekday name *or* `optionTopPanelTitle` if specified at the top of the selector. Set to `false` will hide the entire panel.
    ///
    /// - Note:
    /// Defaults to `true`.
    open var optionShowTopPanel = true
    
    /// Set to nil to show default title. Depending on `privateOptionStyles`, default titles are either **Select Multiple Dates**, **(Capitalized Weekday Full Name)** or **(Capitalized Month Full Name)**.
    ///
    /// - Note:
    /// Defaults to `nil`.
    open var optionTopPanelTitle: String? = nil
    
    /// Set `optionSelectionType` with one of the following:
    ///
    /// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
    ///
    /// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// - Note:
    /// Selection styles will only affect date selection. It is currently not possible to select multiple/range
    open var optionSelectionType: WWCalendarTimeSelectorSelection = .single
    
    /// Set to default date when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDates`
    ///
    /// - Note:
    /// Defaults to current date and time, with time rounded off to the nearest hour.
    open var optionCurrentDate = Date().minute < 30 ? Date().beginningOfHour : Date().beginningOfHour + 1.hour
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDates: Set<Date> = []
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    open var optionCurrentDateRange: WWCalendarTimeSelectorDateRange = WWCalendarTimeSelectorDateRange()
    
    /// Set the background blur effect, where background is a `UIVisualEffectView`. Available options are as `UIBlurEffectStyle`:
    ///
    /// `Dark`
    ///
    /// `Light`
    ///
    /// `ExtraLight`
    open var optionStyleBlurEffect: UIBlurEffectStyle = .dark
    
    /// Set `optionMultipleSelectionGrouping` with one of the following:
    ///
    /// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
    ///
    /// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
    ///
    /// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
    open var optionMultipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .pill
    
    
    // Fonts & Colors
    open var optionCalendarFontMonth = UIFont.systemFont(ofSize: 14)
    open var optionCalendarFontDays = UIFont.systemFont(ofSize: 13)
    open var optionCalendarFontToday = UIFont.boldSystemFont(ofSize: 13)
    open var optionCalendarFontTodayHighlight = UIFont.boldSystemFont(ofSize: 14)
    open var optionCalendarFontPastDates = UIFont.systemFont(ofSize: 12)
    open var optionCalendarFontPastDatesHighlight = UIFont.systemFont(ofSize: 13)
    open var optionCalendarFontFutureDates = UIFont.systemFont(ofSize: 12)
    open var optionCalendarFontFutureDatesHighlight = UIFont.systemFont(ofSize: 13)
    
    open var optionCalendarFontColorMonth = UIColor.black
    open var optionCalendarFontColorDays = UIColor.black
    open var optionCalendarFontColorToday = UIColor.darkGray
    open var optionCalendarFontColorTodayHighlight = UIColor.white
    open var optionCalendarBackgroundColorTodayHighlight = UIColor.brown
    open var optionCalendarBackgroundColorTodayFlash = UIColor.white
    open var optionCalendarFontColorPastDates = UIColor.darkGray
    open var optionCalendarFontColorPastDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorPastDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorPastDatesFlash = UIColor.white
    open var optionCalendarFontColorFutureDates = UIColor.darkGray
    open var optionCalendarFontColorFutureDatesHighlight = UIColor.white
    open var optionCalendarBackgroundColorFutureDatesHighlight = UIColor.brown
    open var optionCalendarBackgroundColorFutureDatesFlash = UIColor.white
    
    open var optionCalendarFontCurrentYear = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontCurrentYearHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorCurrentYear = UIColor.darkGray
    open var optionCalendarFontColorCurrentYearHighlight = UIColor.black
    open var optionCalendarFontPastYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontPastYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorPastYears = UIColor.darkGray
    open var optionCalendarFontColorPastYearsHighlight = UIColor.black
    open var optionCalendarFontFutureYears = UIFont.boldSystemFont(ofSize: 18)
    open var optionCalendarFontFutureYearsHighlight = UIFont.boldSystemFont(ofSize: 20)
    open var optionCalendarFontColorFutureYears = UIColor.darkGray
    open var optionCalendarFontColorFutureYearsHighlight = UIColor.black
    
    open var optionClockFontAMPM = UIFont.systemFont(ofSize: 18)
    open var optionClockFontAMPMHighlight = UIFont.systemFont(ofSize: 20)
    open var optionClockFontColorAMPM = UIColor.black
    open var optionClockFontColorAMPMHighlight = UIColor.white
    open var optionClockBackgroundColorAMPMHighlight = UIColor.brown
    open var optionClockFontHour = UIFont.systemFont(ofSize: 16)
    open var optionClockFontHourHighlight = UIFont.systemFont(ofSize: 18)
    open var optionClockFontColorHour = UIColor.black
    open var optionClockFontColorHourHighlight = UIColor.white
    open var optionClockBackgroundColorHourHighlight = UIColor.brown
    open var optionClockBackgroundColorHourHighlightNeedle = UIColor.brown
    open var optionClockFontMinute = UIFont.systemFont(ofSize: 12)
    open var optionClockFontMinuteHighlight = UIFont.systemFont(ofSize: 14)
    open var optionClockFontColorMinute = UIColor.black
    open var optionClockFontColorMinuteHighlight = UIColor.white
    open var optionClockBackgroundColorMinuteHighlight = UIColor.brown
    open var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.brown
    open var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
    open var optionClockBackgroundColorCenter = UIColor.black
    
    open var optionButtonShowCancel: Bool = false
    open var optionButtonTitleDone: String = "Done"
    open var optionButtonTitleCancel: String = "Cancel"
    open var optionButtonFontCancel = UIFont.systemFont(ofSize: 16)
    open var optionButtonFontDone = UIFont.boldSystemFont(ofSize: 16)
    open var optionButtonFontColorCancel = UIColor.brown
    open var optionButtonFontColorDone = UIColor.brown
    open var optionButtonFontColorCancelHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonFontColorDoneHighlight = UIColor.brown.withAlphaComponent(0.25)
    open var optionButtonBackgroundColorCancel = UIColor.clear
    open var optionButtonBackgroundColorDone = UIColor.clear
    
    open var optionTopPanelBackgroundColor = UIColor.brown
    open var optionTopPanelFont = UIFont.systemFont(ofSize: 16)
    open var optionTopPanelFontColor = UIColor.white
    
    open var optionSelectorPanelFontMonth = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontDate = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontYear = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontTime = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelection = UIFont.systemFont(ofSize: 16)
    open var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFont(ofSize: 17)
    open var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorMonthHighlight = UIColor.white
    open var optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorDateHighlight = UIColor.white
    open var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorYearHighlight = UIColor.white
    open var optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
    open var optionSelectorPanelFontColorTimeHighlight = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelection = UIColor.white
    open var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
    open var optionSelectorPanelBackgroundColor = UIColor.brown.withAlphaComponent(0.9)
    
    open var optionMainPanelBackgroundColor = UIColor.white
    open var optionBottomPanelBackgroundColor = UIColor.white
    
    /// Set global tint color.
    open var optionTintColor : UIColor! {
        get{
            return tintColor
        }
        set(color){
            tintColor = color;
            optionCalendarFontColorMonth = UIColor.black
            optionCalendarFontColorDays = UIColor.black
            optionCalendarFontColorToday = UIColor.darkGray
            optionCalendarFontColorTodayHighlight = UIColor.white
            optionCalendarBackgroundColorTodayHighlight = tintColor
            optionCalendarBackgroundColorTodayFlash = UIColor.white
            optionCalendarFontColorPastDates = UIColor.darkGray
            optionCalendarFontColorPastDatesHighlight = UIColor.white
            optionCalendarBackgroundColorPastDatesHighlight = tintColor
            optionCalendarBackgroundColorPastDatesFlash = UIColor.white
            optionCalendarFontColorFutureDates = UIColor.darkGray
            optionCalendarFontColorFutureDatesHighlight = UIColor.white
            optionCalendarBackgroundColorFutureDatesHighlight = tintColor
            optionCalendarBackgroundColorFutureDatesFlash = UIColor.white
            
            optionCalendarFontColorCurrentYear = UIColor.darkGray
            optionCalendarFontColorCurrentYearHighlight = UIColor.black
            optionCalendarFontColorPastYears = UIColor.darkGray
            optionCalendarFontColorPastYearsHighlight = UIColor.black
            optionCalendarFontColorFutureYears = UIColor.darkGray
            optionCalendarFontColorFutureYearsHighlight = UIColor.black
            
            optionClockFontColorAMPM = UIColor.black
            optionClockFontColorAMPMHighlight = UIColor.white
            optionClockBackgroundColorAMPMHighlight = tintColor
            optionClockFontColorHour = UIColor.black
            optionClockFontColorHourHighlight = UIColor.white
            optionClockBackgroundColorHourHighlight = tintColor
            optionClockBackgroundColorHourHighlightNeedle = tintColor
            optionClockFontColorMinute = UIColor.black
            optionClockFontColorMinuteHighlight = UIColor.white
            optionClockBackgroundColorMinuteHighlight = tintColor
            optionClockBackgroundColorMinuteHighlightNeedle = tintColor
            optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
            optionClockBackgroundColorCenter = UIColor.black
            
            optionButtonFontColorCancel = tintColor
            optionButtonFontColorDone = tintColor
            optionButtonFontColorCancelHighlight = tintColor.withAlphaComponent(0.25)
            optionButtonFontColorDoneHighlight = tintColor.withAlphaComponent(0.25)
            optionButtonBackgroundColorCancel = UIColor.clear
            optionButtonBackgroundColorDone = UIColor.clear
            
            optionTopPanelBackgroundColor = tintColor
            optionTopPanelFontColor = UIColor.white
            
            optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorMonthHighlight = UIColor.white
            optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorDateHighlight = UIColor.white
            optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorYearHighlight = UIColor.white
            optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
            optionSelectorPanelFontColorTimeHighlight = UIColor.white
            optionSelectorPanelFontColorMultipleSelection = UIColor.white
            optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.white
            optionSelectorPanelBackgroundColor = tintColor.withAlphaComponent(0.9)
            
            optionMainPanelBackgroundColor = UIColor.white
            optionBottomPanelBackgroundColor = UIColor.white
        }
    }

    
    /// This is the month's offset when user is in selection of dates mode. A positive number will adjusts the month higher, while a negative number will adjust the month lower.
    ///
    /// - Note:
    /// Defaults to 30.
    open var optionSelectorPanelOffsetHighlightMonth: CGFloat = 30
    
    /// This is the date's offset when user is in selection of dates mode. A positive number will adjusts the date lower, while a negative number will adjust the date higher.
    ///
    /// - Note:
    /// Defaults to 24.
    open var optionSelectorPanelOffsetHighlightDate: CGFloat = 24
    
    /// This is the scale of the month when it is in active view.
    open var optionSelectorPanelScaleMonth: CGFloat = 2.5
    open var optionSelectorPanelScaleDate: CGFloat = 4.5
    open var optionSelectorPanelScaleYear: CGFloat = 4
    open var optionSelectorPanelScaleTime: CGFloat = 2.75
    
    /// This is the height calendar's "title bar". If you wish to hide the Top Panel, consider `optionShowTopPanel`
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`
    open var optionLayoutTopPanelHeight: CGFloat = 28
    
    /// The height of the calendar in portrait mode. This will be translated automatically into the width in landscape mode.
    open var optionLayoutHeight: CGFloat?
    
    /// The width of the calendar in portrait mode. This will be translated automatically into the height in landscape mode.
    open var optionLayoutWidth: CGFloat?
    
    /// If optionLayoutHeight is not defined, this ratio is used on the screen's height.
    open var optionLayoutHeightRatio: CGFloat = 0.9
    
    /// If optionLayoutWidth is not defined, this ratio is used on the screen's width.
    open var optionLayoutWidthRatio: CGFloat = 0.85
    
    /// When calendar is in portrait mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 7 / 20
    open var optionLayoutPortraitRatio: CGFloat = 7/20
    
    /// When calendar is in landscape mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 3 / 8
    open var optionLayoutLandscapeRatio: CGFloat = 3/8
    
    // All Views
    @IBOutlet fileprivate weak var selTimeView: UIView!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var clockView: WWClock!
    @IBOutlet weak var amButton: UIButton!
    @IBOutlet weak var pmButton: UIButton!
  
    // Private Variables
    fileprivate let selAnimationDuration: TimeInterval = 0.4
    fileprivate let selInactiveHeight: CGFloat = 48
    fileprivate var portraitContainerWidth: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var portraitTopContainerHeight: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutPortraitRatio : 0 }
    fileprivate var portraitBottomContainerHeight: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - portraitTopContainerHeight }
    fileprivate var landscapeContainerHeight: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    fileprivate var landscapeTopContainerWidth: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutLandscapeRatio : 0 }
    fileprivate var landscapeBottomContainerWidth: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - landscapeTopContainerWidth }
    fileprivate var selCurrrent: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle(isSingular: true)
    fileprivate var isFirstLoad = false
    fileprivate var selTimeStateHour = true
    fileprivate var calRow1Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow2Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow3Type: WWCalendarRowType = WWCalendarRowType.date
    fileprivate var calRow1StartDate: Date = Date()
    fileprivate var calRow2StartDate: Date = Date()
    fileprivate var calRow3StartDate: Date = Date()
    fileprivate var yearRow1: Int = 2016
    fileprivate var multipleDates: [Date] { return optionCurrentDates.sorted(by: { $0.compare($1) == ComparisonResult.orderedAscending }) }
    fileprivate var multipleDatesLastAdded: Date?
    fileprivate var flashDate: Date?
    fileprivate let defaultTopPanelTitleForMultipleDates = "Select Multiple Dates"
    fileprivate var viewBoundsHeight: CGFloat {
        return view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length
    }
    fileprivate var viewBoundsWidth: CGFloat {
        return view.bounds.width
    }
    fileprivate var portraitHeight: CGFloat {
        return max(viewBoundsHeight, viewBoundsWidth)
    }
    fileprivate var portraitWidth: CGFloat {
        return min(viewBoundsHeight, viewBoundsWidth)
    }
    fileprivate var shouldResetRange: Bool = true
    fileprivate var tintColor : UIColor! = UIColor.brown
    
    /// Only use this method to instantiate the selector. All customization should be done before presenting the selector to the user.
    /// To receive callbacks from selector, set the `delegate` of selector and implement `WWCalendarTimeSelectorProtocol`.
    ///
    ///     let selector = WWCalendarTimeSelector.instantiate()
    ///     selector.delegate = self
    ///     presentViewController(selector, animated: true, completion: nil)
    ///
    open static func instantiate() -> WWCalendarTimeSelector {
        let podBundle = Bundle(for: self.classForCoder())
        let bundleURL = podBundle.url(forResource: "WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        var bundle: Bundle?
        if let bundleURL = bundleURL {
            bundle = Bundle(url: bundleURL)
        }
        return UIStoryboard(name: "WWCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! WWCalendarTimeSelector
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Take up the whole view when pushed from a navigation controller
        if navigationController != nil {
            optionLayoutWidthRatio = 1
            optionLayoutHeightRatio = 1
        }
        
        // Add background
        let background: UIView
        if navigationController != nil {
            background = UIView()
            background.backgroundColor = UIColor.white
        } else {
            background = UIVisualEffectView(effect: UIBlurEffect(style: optionStyleBlurEffect))
        }
        background.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(background, at: 0)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bg]|", options: [], metrics: nil, views: ["bg": background]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bg]|", options: [], metrics: nil, views: ["bg": background]))
        
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        
        yearRow1 = optionCurrentDate.year - 5
        
       view.layoutIfNeeded()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotateOrNot), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
      
        let firstMonth = Date().beginningOfYear
        
        clockView.delegate = self
        clockView.minuteStep = optionTimeStep
        clockView.backgroundColorClockFace = optionClockBackgroundColorFace
        clockView.backgroundColorClockFaceCenter = optionClockBackgroundColorCenter
        clockView.fontAMPM = optionClockFontAMPM
        clockView.fontAMPMHighlight = optionClockFontAMPMHighlight
        clockView.fontColorAMPM = optionClockFontColorAMPM
        clockView.fontColorAMPMHighlight = optionClockFontColorAMPMHighlight
        clockView.backgroundColorAMPMHighlight = optionClockBackgroundColorAMPMHighlight
        clockView.fontHour = optionClockFontHour
        clockView.fontHourHighlight = optionClockFontHourHighlight
        clockView.fontColorHour = optionClockFontColorHour
        clockView.fontColorHourHighlight = optionClockFontColorHourHighlight
        clockView.backgroundColorHourHighlight = optionClockBackgroundColorHourHighlight
        clockView.backgroundColorHourHighlightNeedle = optionClockBackgroundColorHourHighlightNeedle
        clockView.fontMinute = optionClockFontMinute
        clockView.fontMinuteHighlight = optionClockFontMinuteHighlight
        clockView.fontColorMinute = optionClockFontColorMinute
        clockView.fontColorMinuteHighlight = optionClockFontColorMinuteHighlight
        clockView.backgroundColorMinuteHighlight = optionClockBackgroundColorMinuteHighlight
        clockView.backgroundColorMinuteHighlightNeedle = optionClockBackgroundColorMinuteHighlightNeedle
        
        updateDate()
        
        isFirstLoad = true
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?
            clockView.setNeedsDisplay()
            self.didRotateOrNot(animated: false)
          
          if optionStyles.showTime {
                showTime(true, animated: false)
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstLoad = false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    internal func didRotateOrNot(animated: Bool = true) {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .landscapeLeft || orientation == .landscapeRight || orientation == .portrait || orientation == .portraitUpsideDown {
            let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
            let size = CGSize(width: viewBoundsWidth, height: viewBoundsHeight)
            
            if isPortrait {
                let width = min(size.width, size.height)
                let height = max(size.width, size.height)
            }
            else {
                let width = max(size.width, size.height)
                let height = min(size.width, size.height)
            }
            
            if animated {
                UIView.animate(
                    withDuration: selAnimationDuration,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction],
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: nil
                )
            } else {
                self.view.layoutIfNeeded()
            }
            
            if selCurrrent.showTime {
                showTime(false, animated: animated)
            }
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func selectMonth(_ sender: UIButton) {
        let date = (optionCurrentDate.beginningOfYear + sender.tag.months).beginningOfDay
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day).beginningOfDay
            updateDate()
        }
    }
  
    
    @IBAction func showTime() {
        showTime(true)
    }
    
    @IBAction func cancel() {
        let picker = self
        let del = delegate
        if optionSelectionType == .single {
            del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        }
        else {
            del?.WWCalendarTimeSelectorCancel?(picker, dates: multipleDates)
        }
        dismiss()
    }
    
    @IBAction func done() {
        let picker = self
        let del = delegate
        switch optionSelectionType {
        case .single:
            del?.WWCalendarTimeSelectorDone?(picker, date: optionCurrentDate)
        case .multiple:
            del?.WWCalendarTimeSelectorDone?(picker, dates: multipleDates)
        case .range:
            del?.WWCalendarTimeSelectorDone?(picker, dates: optionCurrentDateRange.array)
        }
        dismiss()
    }
    
    fileprivate func dismiss() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        } else if presentingViewController != nil {
            dismiss(animated: true) {
                del?.WWCalendarTimeSelectorDidDismiss?(picker)
            }
        }
    }
    
    fileprivate func showTime(_ userTap: Bool, animated: Bool = true) {
        if userTap {
            if selCurrrent.showTime {
                selTimeStateHour = !selTimeStateHour
            }
            else {
                selTimeStateHour = true
            }
        }
        
        if optionTimeStep == .sixtyMinutes {
            selTimeStateHour = true
        }
        
        changeSelTime(animated: animated)
        
        if userTap {
            clockView.showingHour = selTimeStateHour
        }
        clockView.setNeedsDisplay()
        
        if animated {
            UIView.transition(
                with: clockView,
                duration: selAnimationDuration / 2,
                options: [UIViewAnimationOptions.transitionCrossDissolve],
                animations: {
                    self.clockView.layer.displayIfNeeded()
                },
                completion: nil
            )
        } else {
            self.clockView.layer.displayIfNeeded()
        }
        
        let animations = {
            self.clockView.alpha = 1
        }
        if animated {
            UIView.animate(
                withDuration: selAnimationDuration,
                delay: 0,
                options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.curveEaseOut],
                animations: animations,
                completion: nil
            )
        } else {
            animations()
        }
    }
    
  fileprivate func updateDate() {
    
    let timeText = optionCurrentDate.stringFromFormat("h':'mm").lowercased()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.center
    let attrText = NSMutableAttributedString(string: timeText, attributes: [NSFontAttributeName: optionSelectorPanelFontTime, NSForegroundColorAttributeName: optionSelectorPanelFontColorTime, NSParagraphStyleAttributeName: paragraph])
    
    if selCurrrent.showTime {
      
      let colonIndex = timeText.characters.distance(from: timeText.startIndex, to: timeText.range(of: ":")!.lowerBound)
      let hourRange = NSRange(location: 0, length: colonIndex)
      let minuteRange = NSRange(location: colonIndex + 1, length: 2)
      
      if selTimeStateHour {
        attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: hourRange)
      }
      else {
        attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: minuteRange)
      }
    }
    timeLabel.attributedText = attrText
    print(timeLabel)
  }
  
    fileprivate func changeSelTime(animated: Bool = true) {
      
      
      //timeLabel.contentScaleFactor = UIScreen.main.scale * optionSelectorPanelScaleTime
      let animations = {
        //self.timeLabel.transform = CGAffineTransform.identity.scaledBy(x: self.optionSelectorPanelScaleTime, y: self.optionSelectorPanelScaleTime)
        self.view.layoutIfNeeded()
      }
      let completion = { (_: Bool) in
        if self.selCurrrent.showTime {
        }
      }
      if animated {
        UIView.animate(
          withDuration: selAnimationDuration,
          delay: 0,
          usingSpringWithDamping: 0.8,
          initialSpringVelocity: 0,
          options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.allowUserInteraction],
          animations: animations,
          completion: completion
        )
      } else {
        animations()
        completion(true)
      }
      selCurrrent.showTime(true)
      updateDate()
    }
  
  
  
    internal func WWClockGetTime() -> Date {
        return optionCurrentDate
    }
    
    internal func WWClockSwitchAMPM(isAM: Bool, isPM: Bool) {
        var newHour = optionCurrentDate.hour
        if isAM && newHour >= 12 {
            newHour = newHour - 12
        }
        if isPM && newHour < 12 {
            newHour = newHour + 12
        }
        
        optionCurrentDate = optionCurrentDate.change(hour: newHour)
        updateDate()
        clockView.setNeedsDisplay()
        UIView.transition(
            with: clockView,
            duration: selAnimationDuration / 2,
            options: [UIViewAnimationOptions.transitionCrossDissolve, UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState],
            animations: {
                self.clockView.layer.displayIfNeeded()
            },
            completion: nil
        )
    }
    
    internal func WWClockSetHourMilitary(_ hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        updateDate()
        clockView.setNeedsDisplay()
    }
    
    internal func WWClockSetMinute(_ minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        updateDate()
        clockView.setNeedsDisplay()
    }
}

@objc internal enum WWCalendarRowType: Int {
    case month, day, date
}
internal protocol WWClockProtocol: NSObjectProtocol {
    func WWClockGetTime() -> Date
    func WWClockSwitchAMPM(isAM: Bool, isPM: Bool)
    func WWClockSetHourMilitary(_ hour: Int)
    func WWClockSetMinute(_ minute: Int)
}

internal class WWClock: UIView {
  
  open weak var delegate: WWClockProtocol!
  internal var backgroundColorClockFace: UIColor!
  internal var backgroundColorClockFaceCenter: UIColor!
  internal var fontAMPM: UIFont!
  internal var fontAMPMHighlight: UIFont!
  internal var fontColorAMPM: UIColor!
  internal var fontColorAMPMHighlight: UIColor!
  internal var backgroundColorAMPMHighlight: UIColor!
  internal var fontHour: UIFont!
  internal var fontHourHighlight: UIFont!
  internal var fontColorHour: UIColor!
  internal var fontColorHourHighlight: UIColor!
  internal var backgroundColorHourHighlight: UIColor!
  internal var backgroundColorHourHighlightNeedle: UIColor!
  internal var fontMinute: UIFont!
  internal var fontMinuteHighlight: UIFont!
  internal var fontColorMinute: UIColor!
  internal var fontColorMinuteHighlight: UIColor!
  internal var backgroundColorMinuteHighlight: UIColor!
  internal var backgroundColorMinuteHighlightNeedle: UIColor!
  
  internal var showingHour = true
  internal var minuteStep: WWCalendarTimeSelectorTimeStep! {
    didSet {
      minutes = []
      let iter = 60 / minuteStep.rawValue
      for i in 0..<iter {
        minutes.append(i * minuteStep.rawValue)
      }
    }
  }
  
  fileprivate let border: CGFloat = 8
  fileprivate let ampmSize: CGFloat = 0
  fileprivate var faceSize: CGFloat = 0
  fileprivate var faceX: CGFloat = 0
  fileprivate let faceY: CGFloat = 8
  fileprivate let amX: CGFloat = 8
  fileprivate var pmX: CGFloat = 0
  fileprivate var ampmY: CGFloat = 0
  fileprivate let numberCircleBorder: CGFloat = 12
  fileprivate let centerPieceSize = 4
  fileprivate let hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
  fileprivate var minutes: [Int] = []
  
  internal override func draw(_ rect: CGRect) {
    
    // update frames
    faceSize = min(rect.width - border * 2, rect.height - border * 2 - ampmSize / 3 * 2)
    faceX = (rect.width - faceSize) / 2
    pmX = rect.width - border - ampmSize
    ampmY = 100 //rect.height - border - ampmSize
    
    let time = delegate.WWClockGetTime()
    let ctx = UIGraphicsGetCurrentContext()
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.center
    
    ctx?.setFillColor(backgroundColorClockFace.cgColor)
    ctx?.fillEllipse(in: CGRect(x: faceX, y: faceY, width: faceSize, height: faceSize))
    
    
    /*
     ctx?.setFillColor(backgroundColorAMPMHighlight.cgColor)
     if time.hour < 12 { //AM selected
     ctx?.fill(CGRect(x: amX, y: ampmY, width: ampmSize, height: ampmSize))
     var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
     var ampmHeight = fontAMPMHighlight.lineHeight
     str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     
     str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
     ampmHeight = fontAMPM.lineHeight
     str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     }
     else { //PM selected
     ctx?.fill(CGRect(x: pmX, y: ampmY, width: ampmSize, height: ampmSize))
     var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
     var ampmHeight = fontAMPM.lineHeight
     str.draw(in: CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     
     str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
     ampmHeight = fontAMPMHighlight.lineHeight
     str.draw(in: CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
     }
     */
    if showingHour {
      let textAttr : [String : Any] = [NSFontAttributeName: fontHour, NSForegroundColorAttributeName: fontColorHour, NSParagraphStyleAttributeName: paragraph]
      let textAttrHighlight : [String : Any] = [NSFontAttributeName: fontHourHighlight, NSForegroundColorAttributeName: fontColorHourHighlight, NSParagraphStyleAttributeName: paragraph]
      
      let templateSize = NSAttributedString(string: "12", attributes: textAttr).size()
      let templateSizeHighlight = NSAttributedString(string: "12", attributes: textAttrHighlight).size()
      let maxSize = max(templateSize.width, templateSize.height)
      let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
      let highlightCircleSize = maxSizeHighlight + numberCircleBorder
      let radius = faceSize / 2 - maxSize
      let radiusHighlight = faceSize / 2 - maxSizeHighlight
      
      ctx?.saveGState()
      ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
      
      let degreeIncrement = 360 / CGFloat(hours.count)
      let currentHour = get12Hour(time)
      
      for (index, element) in hours.enumerated() {
        let angle = getClockRad(CGFloat(index) * degreeIncrement)
        
        if element == currentHour {
          // needle
          ctx?.saveGState()
          ctx?.setStrokeColor(backgroundColorHourHighlightNeedle.cgColor)
          ctx?.setLineWidth(2)
          ctx?.move(to: CGPoint(x: 0, y: 0))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleSize / 2) * sin(angle))))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.strokePath()
          ctx?.restoreGState()
          
          // highlight
          ctx?.saveGState()
          ctx?.setFillColor(backgroundColorHourHighlight.cgColor)
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.fillEllipse(in: CGRect(x: -highlightCircleSize / 2, y: -highlightCircleSize / 2, width: highlightCircleSize, height: highlightCircleSize))
          ctx?.restoreGState()
          
          // numbers
          let hour = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
          ctx?.saveGState()
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
          hour.draw(at: CGPoint.zero)
          ctx?.restoreGState()
        }
        else {
          // numbers
          let hour = NSAttributedString(string: "\(element)", attributes: textAttr)
          ctx?.saveGState()
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: -hour.size().width / 2, y: -hour.size().height / 2)
          hour.draw(at: CGPoint.zero)
          ctx?.restoreGState()
        }
      }
    }
    else {
      let textAttr : [String : Any] = [NSFontAttributeName: fontMinute, NSForegroundColorAttributeName: fontColorMinute, NSParagraphStyleAttributeName: paragraph]
      let textAttrHighlight : [String : Any] = [NSFontAttributeName: fontMinuteHighlight, NSForegroundColorAttributeName: fontColorMinuteHighlight, NSParagraphStyleAttributeName: paragraph]
      let templateSize = NSAttributedString(string: "60", attributes: textAttr).size()
      let templateSizeHighlight = NSAttributedString(string: "60", attributes: textAttrHighlight).size()
      let maxSize = max(templateSize.width, templateSize.height)
      let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
      let minSize: CGFloat = 0
      let highlightCircleMaxSize = maxSizeHighlight + numberCircleBorder
      let highlightCircleMinSize = minSize + numberCircleBorder
      let radius = faceSize / 2 - maxSize
      let radiusHighlight = faceSize / 2 - maxSizeHighlight
      
      ctx?.saveGState()
      ctx?.translateBy(x: faceX + faceSize / 2, y: faceY + faceSize / 2) // everything starts at clock face center
      
      let degreeIncrement = 360 / CGFloat(minutes.count)
      let currentMinute = get60Minute(time)
      
      for (index, element) in minutes.enumerated() {
        let angle = getClockRad(CGFloat(index) * degreeIncrement)
        
        if element == currentMinute {
          // needle
          ctx?.saveGState()
          ctx?.setStrokeColor(backgroundColorMinuteHighlightNeedle.cgColor)
          ctx?.setLineWidth(2)
          ctx?.move(to: CGPoint(x: 0, y: 0))
          ctx?.scaleBy(x: -1, y: 1)
          if minuteStep.rawValue < 5 && element % 5 != 0 {
            ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMinSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMinSize / 2) * sin(angle))))
          }
          else {
            ctx?.addLine(to: CGPoint(x: (radiusHighlight - highlightCircleMaxSize / 2) * cos(angle), y: -((radiusHighlight - highlightCircleMaxSize / 2) * sin(angle))))
          }
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.strokePath()
          ctx?.restoreGState()
          
          // highlight
          ctx?.saveGState()
          ctx?.setFillColor(backgroundColorMinuteHighlight.cgColor)
          ctx?.scaleBy(x: -1, y: 1)
          ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
          ctx?.scaleBy(x: -1, y: 1)
          if minuteStep.rawValue < 5 && element % 5 != 0 {
            ctx?.fillEllipse(in: CGRect(x: -highlightCircleMinSize / 2, y: -highlightCircleMinSize / 2, width: highlightCircleMinSize, height: highlightCircleMinSize))
          }
          else {
            ctx?.fillEllipse(in: CGRect(x: -highlightCircleMaxSize / 2, y: -highlightCircleMaxSize / 2, width: highlightCircleMaxSize, height: highlightCircleMaxSize))
          }
          ctx?.restoreGState()
          
          // numbers
          if minuteStep.rawValue < 5 {
            if element % 5 == 0 {
              let min = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
              ctx?.saveGState()
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
              min.draw(at: CGPoint.zero)
              ctx?.restoreGState()
            }
          }
          else {
            let min = NSAttributedString(string: "\(element)", attributes: textAttrHighlight)
            ctx?.saveGState()
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: radiusHighlight * cos(angle), y: -(radiusHighlight * sin(angle)))
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
            min.draw(at: CGPoint.zero)
            ctx?.restoreGState()
          }
        }
        else {
          // numbers
          if minuteStep.rawValue < 5 {
            if element % 5 == 0 {
              let min = NSAttributedString(string: "\(element)", attributes: textAttr)
              ctx?.saveGState()
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
              ctx?.scaleBy(x: -1, y: 1)
              ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
              min.draw(at: CGPoint.zero)
              ctx?.restoreGState()
            }
          }
          else {
            let min = NSAttributedString(string: "\(element)", attributes: textAttr)
            ctx?.saveGState()
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: radius * cos(angle), y: -(radius * sin(angle)))
            ctx?.scaleBy(x: -1, y: 1)
            ctx?.translateBy(x: -min.size().width / 2, y: -min.size().height / 2)
            min.draw(at: CGPoint.zero)
            ctx?.restoreGState()
          }
        }
      }
    }
    
    // center piece
    ctx?.setFillColor(backgroundColorClockFaceCenter.cgColor)
    ctx?.fillEllipse(in: CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
    ctx?.restoreGState()
  }
  
  fileprivate func get60Minute(_ date: Date) -> Int {
    return date.minute
  }
  
  fileprivate func get12Hour(_ date: Date) -> Int {
    let hr = date.hour
    return hr == 0 || hr == 12 ? 12 : hr < 12 ? hr : hr - 12
  }
  
  fileprivate func getClockRad(_ degrees: CGFloat) -> CGFloat {
    let radOffset = 90.degreesToRadians // add this number to get 12 at top, 3 at right
    return degrees.degreesToRadians + radOffset
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
      let pt = touch.location(in: self)
      
      // see if tap on AM or PM, making the boundary bigger
      /*
       let amRect = CGRect(x: 0, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
       let pmRect = CGRect(x: bounds.width - ampmSize - border, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
       
       if amRect.contains(pt) {
       delegate.WWClockSwitchAMPM(isAM: true, isPM: false)
       }
       else if pmRect.contains(pt) {
       delegate.WWClockSwitchAMPM(isAM: false, isPM: true)
       }
       else {*/
      touchClock(pt: pt)
      //}
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.sorted(by: { $0.timestamp < $1.timestamp }).last {
      let pt = touch.location(in: self)
      touchClock(pt: pt)
    }
  }
  
  fileprivate func touchClock(pt: CGPoint) {
    let touchPoint = CGPoint(x: pt.x - faceX - faceSize / 2, y: pt.y - faceY - faceSize / 2) // this means centerpoint will be 0, 0
    
    if showingHour {
      let degreeIncrement = 360 / CGFloat(hours.count)
      
      var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
      if angle < 0 {
        angle = 0
      }
      angle = angle - degreeIncrement / 2
      var index = Int(floor(angle / degreeIncrement)) + 1
      
      if index < 0 || index > (hours.count - 1) {
        index = 0
      }
      
      let hour = hours[index]
      let time = delegate.WWClockGetTime()
      if hour == 12 {
        delegate.WWClockSetHourMilitary(time.hour < 12 ? 0 : 12)
      }
      else {
        delegate.WWClockSetHourMilitary(time.hour < 12 ? hour : 12 + hour)
      }
    }
    else {
      let degreeIncrement = 360 / CGFloat(minutes.count)
      
      var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
      if angle < 0 {
        angle = 0
      }
      angle = angle - degreeIncrement / 2
      var index = Int(floor(angle / degreeIncrement)) + 1
      
      if index < 0 || index > (minutes.count - 1) {
        index = 0
      }
      
      let minute = minutes[index]
      delegate.WWClockSetMinute(minute)
    }
  }
}

private extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

private extension Int {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}
