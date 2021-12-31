//
//  CitySelectViewModel.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/31.
//

import KakaJSON
import SwiftUI
class CitySelectViewModel: ObservableObject {
    @Published var cities = [Location]()

    func requestCities(keyword: String) {
        NetworkManager.shared.request(target: .searchCity(keyword: keyword)) { data in

            if let model = model(from: data, LocationResult.self) {
                
                self.cities = model.location
            }
        }
    }
}
