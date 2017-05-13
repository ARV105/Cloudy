//
//  WeatherVC.swift
//  Cloudy
//
//  Created by Auriel on 4/10/17.
//  Copyright © 2017 Sphexis. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningLabel:UILabel!
    
    var locationManager: CLLocationManager!

    var currentWeather: CurrentWeather!

    var forecasts = [Forecast]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        warningLabel.isHidden = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
     //   locationManager.requestWhenInUseAuthorization()
     //   locationManager.startMonitoringSignificantLocationChanges()
        

        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        print(CURRENT_WEATHER_URL)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //locationAuthStatus()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Runs when locations are found after .requestLocation()
        
        manager.stopUpdatingLocation()
        warningLabel.isHidden = true
        
        if (Location.sharedInstance.latitude == nil ) || (Location.sharedInstance.longitude == nil) {
            // This validation prevents Forecasts array to be populated multiple times
            
            if let currentLocation = locations.first {
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                currentWeather.downloadWeatherDetails {
                    // Runs when .downloadWeatherDetails is completed
                    self.downloadForecastData {
                        // Runs when .downloadForecastData is completed
                        self.updateMainUI()
                    }
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Runs when CLLocationManager is instanciated (viewDidLoad)
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            manager.requestLocation()
            break
        default:
            // Other cases: .denied .restricted and .authorizedAlways
            // Not relevant to deal with .authorizedAlways because we won't ask it in this app
            showWarning(text: "Please authorize access to your location in order to use the app")
        }
    }

    
//    func locationAuthStatus() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            currentLocation = locationManager.location
//            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
//            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
//            currentWeather.downloadWeatherDetails {
//                self.downloadForecastData {
//                    self.updateMainUI()
//                }
//            }
//
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//            locationAuthStatus()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showWarning(text: "Failed to find user's location:\n \(error.localizedDescription)")
    }
    
    
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading the forecast weather data for TableView
        let forecastURL = URL(string: CURRENT_FORECAST_URL)
        
        Alamofire.request(forecastURL!).responseJSON { response in
            switch response.result {
            case .success:
            let result = response.result
            // forecast dict in the correct format
            if let dict = result.value as? Dictionary<String, AnyObject> {
                // fetches the list with the forecast dictionaries
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    // Looping through each day and fetching the weather dictionary
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                      // Removing the current day from the forecast array
                    self.forecasts.remove(at: 0)
                    
                    self.tableView.reloadData()
                } else {
                    self.showWarning(text: "Failed to convert data from Weather API")
                }
                
            } else {
                 self.showWarning(text: "Failed to convert data from Weather API")
            }
            break
        case .failure(let error):
            self.showWarning(text: "Cannot connect to API: \(error)")
            break
        }
            completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
        
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
    } else {
            return WeatherCell()
    }
}
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    func showWarning(text: String) {
        warningLabel.text = "\(text)"
        warningLabel.isHidden = false
    }

}

