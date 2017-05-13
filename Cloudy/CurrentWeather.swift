//
//  CurrentWeather.swift
//  Cloudy
//
//  Created by Auriel on 4/12/17.
//  Copyright © 2017 Sphexis. All rights reserved.
//

import Foundation
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
          //format of the dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        // removes the time
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
        
        
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
            
        }
        return _weatherType
    }
    
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    //function to doownload the weather data
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Download current weather data
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        //the alamofire request
        Alamofire.request(currentWeatherURL).responseJSON { response in
            //no completion block, instead there is a response in so it can specify the response
            let result = response.result
            //create a dictionary that will contain the result value
            // casted in a dictionary from the API in <String, AnyObject>
            if let dict = result.value as? Dictionary<String, AnyObject> {
                //city names is capitalized
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                //fectehs the weather dictionary from inside the dict and casts as an array of dictionaries
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    //onky need the first entry and "main" is the key for the weather type
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                //accesses the main dictionary not in th weather array
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemperature = main["temp"] as? Double {
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        
                        self._currentTemp = kelvinToFarenheit
                        print(self._currentTemp)
                    }
                }
                
            }
            
            completed()
            print("Current Weather Data Downloaded")
        }
    }
}
