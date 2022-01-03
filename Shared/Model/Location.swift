//
//  Location.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/31.
//

import SwiftUI
import HandyJSON
struct LocationResult: HandyJSON {
    var code = ""
    var location = [City]()
    var refer = Refer()
}
