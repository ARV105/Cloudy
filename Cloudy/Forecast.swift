//
//  Forecast.swift
//  Cloudy
//
//  Created by Auriel on 4/12/17.
//  Copyright © 2017 Sphexis. All rights reserved.
//

import Foundation
import Alamofire


class Forecast {
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
            
        }
        return _weatherType
    }
    
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }

    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        // Inside each day we have the "temp" dictionary that has the the min and max temps
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                
                let kelvinToFahrenheitPreDivision = (min * (9/5) - 459.67)
                
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDivision/10))
                
                self._lowTemp = "\(kelvinToFahrenheit)"
            }
            if let min = temp["max"] as? Double {
                
                let kelvinToFahrenheitPreDivision = (min * (9/5) - 459.67)
                
                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDivision/10))
                
                self._highTemp = "\(kelvinToFahrenheit)"

            
        }
    }
            /// Insde each day we have the "weather" dictionary that has a weather type
        if let weather = weatherDict["weather"] as? Dictionary<String, AnyObject> {
            if let main = weather["main"] as? String {
                self._weatherType = main
    
    }
}

        if let date = weatherDict["dt"] as? Double {
            let unixConvertDate = Date(timeIntervalSince1970: date)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .full
//            dateFormatter.dateFormat = "EEEE"
//            dateFormatter.timeStyle = .none
            self._date = unixConvertDate.dayOfTheWeek()
        }
        
    }
    
}
//Create an extension from the date to extract the day of the week
extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
    
        

















