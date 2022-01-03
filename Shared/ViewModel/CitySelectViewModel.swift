//
//  CitySelectViewModel.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/31.
//

import HandyJSON
import SwiftUI
class CitySelectViewModel: ObservableObject {
    @Published var cities = [City]()

    func requestCities(keyword: String) {
        NetworkManager.shared.request(target: .searchCity(keyword: keyword)) { jsonString in

            if let model = LocationResult.deserialize(from: jsonString) {
                self.cities = model.location
            }
        }
    }
}
