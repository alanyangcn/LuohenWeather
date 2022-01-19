//
//  Api.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import Moya
import SwiftUI

let weatherKey = "38653fc6ddab4b14b8450a45337c5410"

enum API {
    case current(location: String)
    case currentAir(location: String)
    case searchCity(keyword: String)
    case dailyWeather(dayCount: Int, location: String)
}

extension API: TargetType {
    var baseURL: URL {
        switch self {
        case .current, .currentAir, .dailyWeather:
            return URL(string: "https://devapi.qweather.com")!
            
        case .searchCity:
            return URL(string: "https://geoapi.qweather.com")!
        }
        
    }

    var path: String {
        switch self {
        case .current:
            return "/v7/weather/now"
        case .currentAir:
            return "/v7/air/now"
        case .searchCity:
            return "/v2/city/lookup"
        case let .dailyWeather(dayCount, _):
            return "/v7/weather/\(dayCount)d"
        }
    }

    var method: Moya.Method {
        return Method.get
    }

    var task: Task {
        switch self {
        case let .current(location), let .currentAir(location), let .dailyWeather(_, location):
            return .requestParameters(parameters: [
                "key": weatherKey,
                "location": location,
            ], encoding: URLEncoding.default)
        case let .searchCity(location):
            return .requestParameters(parameters: [
                "key": weatherKey,
                "location": location,
            ], encoding: URLEncoding.default)
        }
        
    }

    var headers: [String: String]? {
        return nil
    }
}
