//
//  WheaterManager.swift
//  Clima
//
//  Created by Horst Josef Grenz Meza on 4/6/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherModel: WeatherModel)
    func didFailedWithError(error: Error )
}

struct WeatherManager{
    let APIKEY = "68066065eea44fd8aaf766bf4f646eb5"

    let wurl = "https://api.openweathermap.org/data/2.5/weather"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        var url = "\(wurl)?units=metric&appid=\(APIKEY)&q=\(city)"
        print(url)
        makeHTTPRequest(with: url)
    }
    func fetchWeather(latitude lat: Double, longitude lon:Double){
        var url = "\(wurl)?units=metric&appid=\(APIKEY)&lat=\(lat)&lon=\(lon)"
        print(url)
        makeHTTPRequest(with: url)
    }
    
    func makeHTTPRequest(with url_address: String){
        if let url = URL(string: url_address){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailedWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON( safeData){
                        delegate?.didUpdateWeather(self, weatherModel: weather )
                    }
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder  = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        }catch{
            
            self.delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
}
