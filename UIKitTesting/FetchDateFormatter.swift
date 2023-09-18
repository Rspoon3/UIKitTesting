//
//  FetchDateFormatter.swift
//  UIKitTesting
//
//  Created by Richard Witherspoon on 8/31/23.
//

import Foundation

class FetchDateFormatter: DateFormatter {
    public override init() {
        super.init()
        locale = Locale(identifier: "en_US_POSIX")
    }

    @objc public convenience init(dateformat: String? = nil) {
        self.init()
        if dateFormat != nil {
            dateFormat = dateformat
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
