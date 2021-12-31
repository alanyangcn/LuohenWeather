//
//  Location.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/31.
//

import SwiftUI
import KakaJSON
struct LocationResult: Convertible {
    var code = ""
    var location = [Location]()
    var refer: Refer!
}

struct Location: Convertible, Identifiable {
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
}
