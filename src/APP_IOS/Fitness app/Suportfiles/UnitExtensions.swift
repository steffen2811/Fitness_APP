//
//  UnitExtensions.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 10/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation


// denne unitConverter tager sig af matematikken med at omregne vores Unit speeds.
class UnitConverterPace: UnitConverter {
    private let coefficient: Double
    
    init(coefficient: Double) {
        self.coefficient = coefficient
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double {
        return reciprocal(value * coefficient)
    }
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    private func reciprocal(_ value: Double) -> Double {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
}

//her laver vi en extension af apples Unitspeed sådan vi kan få min/km.
extension UnitSpeed {
    
    class var minutesPerKilometer: UnitSpeed {
        return UnitSpeed(symbol: "min/km", converter: UnitConverterPace(coefficient: 60.0 / 1000.0))
    }
}

