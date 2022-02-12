//
//  SwiftDate
//  Toolkit to parse, validate, manipulate, compare and display dates, time & timezones in Swift.
//
//  Created by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2022 Daniele Margutti. All rights reserved.
//  Licensed under MIT License.
//

import Foundation

/// A region is used to define the geographic and cultural settings
/// associated with a `Clock` object. 
public struct Region: Equatable, Codable, Hashable, CustomStringConvertible {
    
    // MARK: - Public Properties
    
    /// Default region.
    public static var `default`: Region = .local
    
    /// Represented calendar settings for this region.
    public private(set) var calendar: Calendar
    
    /// Represented locale settings for this region.
    public var locale: Locales? {
        get {
            guard let locale = calendar.locale else { return nil }
            return Locales(rawValue: locale.identifier)!
        }
        set {
            calendar.locale = newValue?.locale
        }
    }
    
    /// Represented timezone settings for this region.
    public var timeZone: TimeZones {
        get {
            TimeZones(rawValue: calendar.timeZone.identifier)!
        }
        set {
            calendar.timeZone = newValue.timeZone
        }
    }
    
    // MARK: - Initialization
    
    /// Create a new region with current settings.
    /// Settings will not auto-updating when timezone/calendar/locale changes.
    /// If you need auto-updating region refer to `localAutoUpdating` variable.
    ///
    /// - Current (local) Calendar
    /// - Current (local) TimeZone
    /// - Current (local) Locale
    public static var local: Region {
        .init(calendar: .autoupdatingCurrent) {
            $0.timeZone = .current
            $0.locale = .current
        }
    }
    
    /// Create a new region with local (auto-updating) settings:
    /// - Auto-updating local Calendar
    /// - Auto-updating TimeZone
    /// - Auto-updating Locale
    public static var localAutoUpdating: Region {
        .init(calendar: .autoupdatingCurrent) {
            $0.timeZone = .autoUpdating
            $0.locale = .autoUpdating
        }
    }
    
    /// Create a new UTC Region which is defined by:
    /// - Gregorian Calendar
    /// - GMT TimeZone
    /// - Current (non-updating) locale
    public static var UTC: Region {
        .init(calendarId: .gregorian) {
            $0.timeZone = .gmt
            $0.locale = .current
        }
    }
    
    /// Create a new ISO Region which is defined by:
    /// - Gregorian Calendar
    /// - GMT TimeZone
    /// - English POSIX Locale
    public static var ISO: Region {
        .init(calendarId: .gregorian) {
            $0.timeZone = .gmt
            $0.locale = .englishUnitedStatesComputer
        }
    }
    
    /// Initialize a new region with a given calendar identifier and configuration callback.
    ///
    /// - Parameters:
    ///   - calendarId: calendar identifier.
    ///   - callback: (optional) configuration callback.
    public init(calendarId: Calendar.Identifier = .gregorian, _ callback: ((inout Self) -> Void)? = nil) {
        self.init(calendar: Calendar(identifier: calendarId), callback)
    }
    
    /// Initialize a new region with a given calendar instance and configuration callback.
    ///
    /// - Parameters:
    ///   - calendar: calendar instance.
    ///   - callback: (optional) configuration callback.
    public init(calendar: Calendar, _ callback: ((inout Self) -> Void)? = nil) {
        self.calendar = calendar
        callback?(&self)
    }
    
    /// Initialize a new region from date components.
    public init?(dateComponents: DateComponents) {
        guard let calendar = dateComponents.calendar else {
            return nil
        }
        
        self.init(calendar: calendar)
    }
    
    // MARK: - Public Properties
    
    public var description: String {
        """
        Region {
            calendar: \(calendar.identifier)
            timezone: \(timeZone.rawValue.lowercased())
            locale: \(locale?.rawValue.lowercased() ?? "-")
        }
        """
    }
    
}