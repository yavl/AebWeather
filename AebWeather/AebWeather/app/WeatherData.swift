//
//  WeatherData.swift
//  AebWeather
//
//  Created by Владислав Николаев on 14.01.2021.
//

import UIKit

// Decodables for Yandex.Weather API

struct ResponseData: Decodable {
    let fact: Fact
}

// Current weather data
struct Fact: Decodable {
    let temp: Int
    let feels_like: Int
    let condition: String
}

// Forecast for specific date
struct Forecast: Decodable {
    let date: String
    let temp_avg: Int
    let feels_like: Int
    let condition: String
}

struct Coordinates {
    let lat: String
    let lon: String
}
