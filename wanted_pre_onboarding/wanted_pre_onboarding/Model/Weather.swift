//
//  Weather.swift
//  wanted_pre_onboarding
//
//  Created by AirM2 on 2022/09/12.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
    let feels_like: Double
    let pressure: Int
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Decodable {
    let speed: Double
}
