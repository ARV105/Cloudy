//
//  Location.swift
//  Cloudy
//
//  Created by Auriel on 4/12/17.
//  Copyright © 2017 Sphexis. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var longitude: Double!
    var latitude: Double!
}

