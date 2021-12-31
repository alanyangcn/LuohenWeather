//
//  NetworkResult.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI
import KakaJSON


struct CurrentWeatherResult:  Convertible {
    var code = ""
    var fxLink = ""
    var refer: Refer!
    var updateTime = ""
    var now = CurrentWeather()
}

struct CurrentAirResult: Convertible {
    var code = ""
    var fxLink = ""
    var refer: Refer!
    var updateTime = ""
    var now: CurrentAir!
}



struct Refer: Convertible {
    var license: [String]!
    var sources: [String]!
}

struct CurrentWeather: Convertible, Equatable {
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


struct CurrentAir: Convertible, Equatable {

    var aqi = ""
    var category  = ""
    var co  = ""
    var level  = ""
    var no2  = ""
    var o3  = ""
    var pm10  = ""
    var pm2p5  = ""
    var primary  = ""
    var pubTime  = ""
    var so2  = ""


}