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

    init(adm1: String, adm2: String, country: String, fxLink: String, id: String, isDst: String, lat: String, lon: String, name: String, rank: String, type: String, tz: String, utcOffset: String, isLocation: Bool = false) {
        self.id = id
        self.adm1 = adm1
        self.adm2 = adm2
        self.country = country
        self.fxLink = fxLink
        self.isDst = isDst
        self.lat = lat
        self.lon = lon
        self.name = name
        self.rank = rank
        self.type = type
        self.tz = tz
        self.utcOffset = utcOffset
        self.isLocation = isLocation
    }

    static var defaultCity: City {
        City(adm1: "北京", adm2: "北京", country: "中国", fxLink: "http://hfx.link/2ax1", id: "101010100", isDst: "0", lat: "39.90498", lon: "116.40528", name: "北京", rank: "10", type: "city", tz: "Asia/Shanghai", utcOffset: "+08:00", isLocation: true)
    }

    static var cities: [City] = [defaultCity]
}
