//
//  Date+Calculations.swift
//  
//
//  Created by Richard Witherspoon on 7/24/23.
//

import Foundation

@available(*, deprecated, message: "Use DateCalculator instead.")
extension Date {
    
    // MARK: - Additions
    
    public func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    public func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    public func adding(component: Calendar.Component, value: Int) -> Date {
        Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }
    
    // MARK: - Subtractions
    
    public func subtracting(days: Int) -> Date {
        return adding(days: -days)
    }

    public func subtracting(hours: Int) -> Date {
        return adding(days: -hours)
    }
    
    // MARK: - Calculations
    
    public func daysUntil(_ date: Date?) -> Int {
        guard let date else { return 0 }
        
        let calendar = Calendar.current
        
        guard
            let day1 = calendar.ordinality(of: .day, in: .era, for: self),
            let day2 = calendar.ordinality(of: .day, in: .era, for: date)
        else {
            return 0
        }
        
        return day2 - day1
    }

    public var numberOfDaysSince: Int {
        Date().interval(of: .day, fromDate: self)
    }
    
    public func interval(of component: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        
        guard
            let start = currentCalendar.ordinality(of: component, in: .era, for: date),
            let end = currentCalendar.ordinality(of: component, in: .era, for: self)
        else {
            return 0
        }
        
        return end - start
    }
}
