//
//  String+Extension.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 8/31/23.
//

import Foundation

extension String {
    func dateFromUTCDateTimeString() -> Date? {
        let sharedDateFormatter = FetchDateFormatter(dateformat: "EEE MMM dd HH:mm:ss Z yyyy")
        sharedDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        // example date string from api = "Wed Mar 19 16:38:57 UTC 2014"
        return sharedDateFormatter.date(from: self)
    }
}
