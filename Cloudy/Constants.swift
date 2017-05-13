//
//  Constants.swift
//  Cloudy
//
//  Created by Auriel on 4/12/17.
//  Copyright © 2017 Sphexis. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let BASE_URL_FORECAST = "http://api.openweathermap.org/data/2.5/forecast/daily?"

let LATITUDE = "lat=\(Location.sharedInstance.latitude!)"
let LONGITUDE = "&lon=\(Location.sharedInstance.longitude!)"

//let APP_ID = "&appid="
let API_KEY = "&appid=86e8df7ba037159c106d8ee8300fe274"

typealias DownloadComplete = () -> ()

var CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)\(LONGITUDE)\(API_KEY)"
var CURRENT_FORECAST_URL = "\(BASE_URL_FORECAST)\(LATITUDE)\(LONGITUDE)&cnt=10&mode=json\(API_KEY)"

//
//let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=86e8df7ba037159c106d8ee8300fe274"
//let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=86e8df7ba037159c106d8ee8300fe274"


