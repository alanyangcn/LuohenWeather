//
//  City.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import HandyJSON

import SwiftUI

struct City: Identifiable, Hashable, HandyJSON {
    var adm1 = ""
    var adm2 = ""
    var country = ""
    var fxLink = ""
    var id = ""
    var isDst = ""
    var lat = ""
    var lon = ""
    var name = ""
    var rank = ""
    var type = ""
    var tz = ""
    var utcOffset = ""
    var isLocation = false
    var addTime = Date()
    
    
    init() {
    }

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

//    init(adm1: String, adm2: String, country: String, fxLink: String, id: String, isDst: String, lat: String, lon: String, name: String, rank: String, type: String, tz: String, utcOffset: String, isLocation: Bool = false) {
//        self.id = id
//        self.adm1 = adm1
//        self.adm2 = adm2
//        self.country = country
//        self.fxLink = fxLink
//        self.isDst = isDst
//        self.lat = lat
//        self.lon = lon
//        self.name = name
//        self.rank = rank
//        self.type = type
//        self.tz = tz
//        self.utcOffset = utcOffset
//        self.isLocation = isLocation
//    }

    static var defaultCity: City {
        var model = hotCities[0]
        model.isLocation = true
        return model
    }

    static var cities: [City] = [defaultCity]

    static let hotCities: [City] = {
        var result = [City]()

        if let path = Bundle.main.path(forResource: "hot_city", ofType: "json") {
            if let jsonString = try? String(contentsOfFile: path) {
                result = [City].deserialize(from: jsonString)?.compactMap({ $0 }) ?? []
            }
        }

        return result
    }()
}


extension CityModel {
    
    func update(city: City) {
        self.id = city.id
        
    }
}
