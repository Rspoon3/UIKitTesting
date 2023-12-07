//
//  ISO8601DateFormatStyleWrapper.swift
//
//
//  Created by Patrick Stephen on 11/17/23.
//

import Foundation

/// A date formatter which uses `Date.iSO8601DateFormatStyle` to parse dates
/// from strings.
///
/// Do not mutate properties of this class. All properties of this object are
/// ignored.
///
/// Before using this object, consider using `Date.iSO8601DateFormatStyle`
/// or `ISO8601DateFormatter` directly. This object only exists to support
/// legacy flows which expect a `DateFormatter`.
public final class ISO8601DateFormatStyleWrapper: DateFormatter {

    /// The style used to parse a date from a string.
    private let formatStyle = Date.ISO8601FormatStyle()

    // MARK: DateFormatter

    public override func date(from string: String) -> Date? {
        return try? formatStyle.parse(string)
    }
}
