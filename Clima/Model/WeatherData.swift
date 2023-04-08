//
//  WeatherData.swift
//  Clima
//
//  Created by Horst Josef Grenz Meza on 4/6/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation


struct WeatherData : Codable {

    let name: String
    
    let main : Main
    
    let weather : [Weather]
    
}

struct Main : Codable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max : Double
    let pressure : Int
    let humidity : Int
}


struct Weather : Codable {
    let id : Int
}
