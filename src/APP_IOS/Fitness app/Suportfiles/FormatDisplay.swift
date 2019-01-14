//
//  FormatDisplay.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 10/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation

struct FormatDisplay {
    
    //recives a distance as a double and converts it to a measurement and then returns it as string after the return of func distance under this one.
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return FormatDisplay.distance(distanceMeasurement)
    }
    
    //returns distance as a string so its ready to be shown on screen.
    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }
    
    //format the seconds from int to a stirng as a time in hour, minutes and seconds.
    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    //convert pase from a measurement unit to a string to be showen on screen.
    static func pace(distance: Measurement<UnitLength>, seconds: Int, outputUnit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = [.providedUnit] // 1
        let speedMagnitude = seconds != 0 ? distance.value / Double(seconds) : 0
        let speed = Measurement(value: speedMagnitude, unit: UnitSpeed.metersPerSecond)
        return formatter.string(from: speed.converted(to: outputUnit))
    }
    
    //formats the date to a sring from a type date.
    static func date(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    static func datejson(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else { return "" }
        let formatter = DateFormatter()
        return formatter.string(from: timestamp)
    }
}
