//
//   NSDateUtils.swift
//  FetchHop
//
//  Created by Glenda Adams on 10/23/19.
//  Copyright © 2019 Fetch Rewards, LLC. All rights reserved.
//

import Foundation

/// SEE `Date+Additions.swift` before adding anything here!
@objc extension NSDate {

    public func localTimeZoneString(style: DateFormatter.Style) -> String? {
        return (self as Date).localTimeZoneString(style: style)
    }

    public func year() -> NSInteger {
        return (self as Date).year()
    }

    public func month() -> NSInteger {
        return (self as Date).month()
    }

    public func day() -> NSInteger {
        return (self as Date).day()
    }

    public func stringWithDashedFullDate() -> String? {
        return (self as Date).stringWithDashedFullDate()
    }
    
    public func stringWithUTCZFormat() -> String? {
        return (self as Date).stringWithUTCZFormat()
    }
    
    public func monthStringShort() -> String? {
        return (self as Date).monthStringShort()
    }

    public func stringWithMonthShortYearFull() -> String {
        return (self as Date).stringWithMonthShortYearFull()
    }
    
    public func daysUntil(_ date: Date?) -> NSInteger {
        return (self as Date).daysUntil(date)
    }
}
