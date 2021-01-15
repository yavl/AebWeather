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
    let forecasts: [Forecasts]
}

// Current weather data
struct Fact: Decodable {
    let temp: Int
    let feels_like: Int
    let condition: String
    let wind_speed: Float
    let wind_dir: String
    let humidity: Int
    let pressure_mm: Float
}

// Forecast for specific date
struct Forecasts: Decodable {
    let parts: Parts
    let date: String
}

struct Parts: Decodable {
    let day: Day
}

struct Day: Decodable {
    let temp_avg: Int
    let feels_like: Int
    let condition: String
    let wind_speed: Float
    let wind_dir: String
    let humidity: Int
    let pressure_mm: Float
}

struct Coordinates {
    let lat: String
    let lon: String
}
