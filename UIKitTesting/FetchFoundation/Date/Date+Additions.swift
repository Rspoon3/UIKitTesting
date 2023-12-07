//
//  Date+Additions.swift
//  FetchHop
//
//  Created by Yevhen Strohanov on 4/30/20.
//  Copyright © 2020 Fetch Rewards, LLC. All rights reserved.
//

import Foundation

/**
 Date helper functions.

 For capabilities that need to be bridged to `NSDate`,
 consider refactoring the code to a Swift and/or an extension helper function.
 Alternatively, create the date helper function here and reference
 the function in `NSDateUtils` through casting.

 ie.
 ```
 extension Date {
    public func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
 }

 extension NSDate {
    public func year() -> Int {
        return (self as Date).year()
    }
 }

 ```
 */
extension Date {

    // Converts a time from a given timezone to a desired timezone
    public func convert(to desiredTimeZone: TimeZone, from initialTimeZone: TimeZone) -> Date {
         let delta = TimeInterval(desiredTimeZone.secondsFromGMT(for: self) - initialTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }

    // Convert local time to UTC (or GMT)
     public func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    public func localTimeZoneString(style: DateFormatter.Style) -> String {
        let dateFormatter = FetchDateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    public func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }

    public func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }

    public func day() -> Int {
        return Calendar.current.component(.day, from: self)
    }

    public func stringWithDashedFullDate() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: self)
    }

    public func stringWithMonthDayYear() -> String {
        let formatter = FetchDateFormatter(dateformat: "M/d/y")
        return formatter.string(from: self)
    }
    
    /// DateFormatter that returns date following the format
    /// `"MM/dd/yyyy"`.
    /// An example date:
    ///  `"01/15/2011"`
    public func stringWithFullMonthDayYear() -> String {
        let formatter = FetchDateFormatter(dateformat: "MM/dd/yyyy")
        return formatter.string(from: self)
    }

    public func stringWithUTCZFormat() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: self)
    }

    public func monthString() -> String {
        let formatter = FetchDateFormatter(dateformat: "MMMM")
        return formatter.string(from: self)
    }

    public func monthStringShort() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: self)
    }

    public func stringWithMonthYear() -> String {
        let formatter = FetchDateFormatter(dateformat: "MMMM yyyy")
        return formatter.string(from: self)
    }

    public func stringWithMonthShortYearFull() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: self)
    }

    public func stringWithMonthDay() -> String {
        let formatter = FetchDateFormatter(dateformat: "MMMM d")
        return formatter.string(from: self)
    }

    public var stringWithMonthDayTime: String {
        return DateFormatter.stringWithMonthDayTimeFormatter.string(from: self)
    }

    public func string(style: DateFormatter.Style) -> String {
        let dateFormatter = FetchDateFormatter()
        dateFormatter.dateStyle = style
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }

    public func dayOfWeekMonthDateYearOption(_ isYearIncluded: Bool) -> String {
        let formatter = FetchDateFormatter()
        if isYearIncluded {
            formatter.dateFormat = "EEEE, MMMM d, yyyy"
        } else {
            formatter.dateFormat = "EEEE, MMMM d"
        }

        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: self)
    }}

extension DateFormatter {
    // NOTE: Please use these static dateFormatters with caution!
    // After accessing them (e.g. let formatter = DateFormatter.iso8601Full)
    // do not change any of the formatter properties!
    // Either use them as it is or create a new one
    public static let iso8601Full: DateFormatter = {
        let formatter = FetchDateFormatter(dateformat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /// DateFormatter that returns currentTimeZone (ie -0500 for Central Standard Time)"
    public static let currentTimeZoneOffSet: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "ZZZ")
        dateFormatter.timeZone = .current
        return dateFormatter
    }()

    /// DateFormatter that returns date in following format "2021-03-22T23:34:28.895Z"
    public static let utc: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()

    /// DateFormatter that returns date in following format "2021-03-22T23:34:28Z"
    public static let utcNoMilliseconds: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()

    /// DateFormatter that returns time for the current timezone
    /// in the following format "11:34 pm"
    public static let timeWithMeridiem: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "h:mm a")
        dateFormatter.timeZone = .current
        return dateFormatter
    }()

    /// DateFormatter that returns time for the current timezone
    /// in the following format "11:34:12 pm"
    public static let timeWithSecondsMeridiem: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "h:mm:ss a")
        dateFormatter.timeZone = .current
        return dateFormatter
    }()
    
    /// DateFormatter that returns date following the format
    /// `"yyyy-MM-dd"`.
    /// An example date:
    ///  `"2001-12-21"`
    public static let yearMonthDay: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "yyyy-MM-dd")
        return dateFormatter
    }()

    /// DateFormatter that returns date in following format "Wed Mar 19 16:38:57 UTC 2014". This is a date format from Consumer Service.
    public static let fetchLegacy: DateFormatter = {
        let dateFormatter = FetchDateFormatter(dateformat: "EEE MMM dd HH:mm:ss Z yyyy")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()

    fileprivate static let stringWithMonthDayTimeFormatter: DateFormatter = {
        let formatter = FetchDateFormatter(dateformat: "M/d, h:mm a")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}
