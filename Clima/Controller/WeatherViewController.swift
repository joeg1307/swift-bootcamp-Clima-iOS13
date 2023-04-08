//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherMgr = WeatherManager()
    let locationMgr = CLLocationManager()
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        
        locationMgr.requestLocation()
        
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationMgr.requestWhenInUseAuthorization()
        
        locationMgr.delegate = self
        
        searchTextField.delegate = self
        weatherMgr.delegate = self
    }
    
    
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        let text = searchTextField.text ?? ""
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            print(searchTextField.text!)
        searchTextField.endEditing(true)
            return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let city = searchTextField.text
        weatherMgr.fetchWeather(city: city!)
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            print("Changing icon to: \(weatherModel.conditionName)")
            self.temperatureLabel.text = weatherModel.tempNane
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.cityLabel.text = weatherModel.cityName
        }
        
    }
    
    func didFailedWithError(error: Error) {
        print(error)
    }
}

//MARK: CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
        print("got locations!")
        if let loc = locations.last{
            let lat = loc.coordinate.latitude
            let lon = loc.coordinate.longitude
            weatherMgr.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
