//
//  FetchDateFormatter.swift
//  FetchHop
//
//  Created by Glenda Adams on 3/17/21.
//  Copyright © 2021 Fetch Rewards, LLC. All rights reserved.
//

import Foundation

public final class FetchDateFormatter: DateFormatter {
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
