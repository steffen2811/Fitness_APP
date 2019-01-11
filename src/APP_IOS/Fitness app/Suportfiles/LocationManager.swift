//
//  LocationManager.swift
//  Fitness app
//
//  Created by Tobias Brammer Fredriksen on 10/01/2019.
//  Copyright © 2019 Tobias Brammer Fredriksen. All rights reserved.
//

import CoreLocation

//der må kun være en CLLocationManager i appen, så derfor bliver den lavet her.
class LocationManager {
    static let shared = CLLocationManager()
    
    private init() { }
}

