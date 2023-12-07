//
//  Task+AsyncHelpers.swift
//
//
//  Created by Richard Witherspoon on 10/10/23.
//

import Foundation

extension Task where Success == Failure, Failure == Never {
    public static func megaYield(count: Int = 20) async {
        let maxCount = max(0, min(count, 10_000))
        
        for _ in 0..<maxCount {
            await Task<Void, Never>.detached(priority: .background) {
                await Task.yield()
                
            }.value
        }
    }
}

@available(iOS, deprecated: 16, obsoleted: 16, message: "This extension can be removed and the built in iOS 16 API will just work instead.")
extension Task where Success == Never, Failure == Never {
    public enum TaskDuration: Sendable {
        case seconds(Double)
        case milliseconds(Double)
        case microseconds(Double)
        case nanoseconds(Int)
    }
}

