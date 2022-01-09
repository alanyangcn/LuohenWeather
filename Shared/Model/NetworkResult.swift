//
//  NetworkResult.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import HandyJSON
import SwiftUI

struct CurrentWeatherResult: HandyJSON {
    var code = ""
    var fxLink = ""
    var refer = Refer()
    var updateTime = ""
    var now = CurrentWeather()
}

struct CurrentAirResult: HandyJSON {
    var code = ""
    var fxLink = ""
    var refer = Refer()
    var updateTime = ""
    var now = CurrentAir()
}

struct DailyWeatherResult: HandyJSON {
    var code = ""
    var fxLink = ""
    var refer = Refer()
    var updateTime = ""
    var daily: [DailyWeather] = []
}

struct Refer: HandyJSON {
    var license = [String]()
    var sources = [String]()
}

struct CurrentWeather: HandyJSON, Equatable {
    var cloud = ""
    var dew = ""
    var feelsLike = ""
    var humidity = ""
    var obsTime = ""
    var precip = ""
    var pressure = ""
    var temp = ""
    var text = ""
    var vis = ""
    var wind360 = ""
    var windDir = ""
    var windScale = ""
    var windSpeed = ""
}

struct CurrentAir: HandyJSON, Equatable {
    var aqi = ""
    var category = ""
    var co = ""
    var level = ""
    var no2 = ""
    var o3 = ""
    var pm10 = ""
    var pm2p5 = ""
    var primary = ""
    var pubTime = ""
    var so2 = ""
}

struct DailyWeather: HandyJSON, Identifiable, Equatable {
    var cloud = ""
    var fxDate = ""
    var humidity = ""
    var iconDay = ""
    var iconNight = ""
    var moonPhase = ""
    var moonPhaseIcon = ""
    var moonrise = ""
    var moonset = ""
    var precip = ""
    var pressure = ""
    var sunrise = ""
    var sunset = ""
    var tempMax = ""
    var tempMin = ""
    var textDay = ""
    var textNight = ""
    var uvIndex = ""
    var vis = ""
    var wind360Day = ""
    var wind360Night = ""
    var windDirDay = ""
    var windDirNight = ""
    var windScaleDay = ""
    var windScaleNight = ""
    var windSpeedDay = ""
    var windSpeedNight = ""
    
    var id = UUID().uuidString
}
