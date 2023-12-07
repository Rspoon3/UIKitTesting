//
//  DateCalculator.swift
//  
//
//  Created by Richard Witherspoon on 8/29/23.
//

import Foundation

public protocol DateCalculating {
    var startOfMonth: Date? { get }
    var endOfMonth: Date? { get }
    func adding(_ value: Int, _ component: Calendar.Component, to date: Date) -> Date?
    func subtracting(_ value: Int, _ component: Calendar.Component, to date: Date) -> Date?
    func interval(of component: Calendar.Component, from date: Date, since: Date) -> Int
    func interval(of component: Calendar.Component, until date: Date, since: Date) -> Int
}

public struct DateCalculator: DateCalculating {
    public let calendar: Calendar
    
    public var startOfMonth: Date? {
        calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: calendar.startOfDay(for: .now)
            )
        )
    }
    
    public var endOfMonth: Date? {
        guard let startOfMonth = startOfMonth else { return nil }
        
        return calendar.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: startOfMonth
        )
    }
    
    // MARK: - Initializer
    
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    // MARK: - Public Helpers
    
    public func adding(_ value: Int, _ component: Calendar.Component, to date: Date) -> Date? {
        calendar.date(byAdding: component, value: value, to: date)
    }
    
    public func subtracting(_ value: Int, _ component: Calendar.Component, to date: Date) -> Date? {
        adding(-value, component, to: date)
    }
    
    public func interval(of component: Calendar.Component, from date: Date, since: Date = .now) -> Int {
        guard
            let start = calendar.ordinality(of: component, in: .era, for: date),
            let end = calendar.ordinality(of: component, in: .era, for: since)
        else {
            return 0
        }
        
        return end - start
    }
    
    public func interval(of component: Calendar.Component, until date: Date, since: Date = .now) -> Int {
        -interval(of: component, from: date)
    }
}
