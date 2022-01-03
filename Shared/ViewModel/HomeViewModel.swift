//
//  HomeViewModel.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import HandyJSON
import SwiftUI
import CoreData
class HomeViewModel: ObservableObject, Equatable {
    static func == (lhs: HomeViewModel, rhs: HomeViewModel) -> Bool {
        lhs.currentWeather == rhs.currentWeather && lhs.currentAir == rhs.currentAir
    }

    @Published var currentWeather = CurrentWeather()
    @Published var currentAir = CurrentAir()
    @Published var currentCity = City()

    let locationManager = AMapLocationManager()

    func refreshData(cityId: String) {
        requestCurrentWeather(cityId: cityId)
        requestCurrentAir(cityId: cityId)
    }

    func requestCurrentWeather(cityId: String) {
        NetworkManager.shared.request(target: .current(location: cityId)) { jsonString in

            if let model = CurrentWeatherResult.deserialize(from: jsonString) {
                self.currentWeather = model.now
            }
        }
    }

    func requestCurrentAir(cityId: String) {
        NetworkManager.shared.request(target: .currentAir(location: cityId)) { jsonString in

            if let model = CurrentAirResult.deserialize(from: jsonString) {
                self.currentAir = model.now
            }
        }
    }

    func requesetLocation() {
        locationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, _: AMapLocationReGeocode?, error: Error?) in

            if let error = error {
                let error = error as NSError

                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    // 定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                } else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    // 逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                } else {
                    // 没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }

            if let location = location {
                let lat = (location.coordinate.latitude * 100).rounded() / 100
                let lon = (location.coordinate.longitude * 100).rounded() / 100

                NetworkManager.shared.request(target: .searchCity(keyword: "\(lon),\(lat)")) { jsonString in
                    if let model = LocationResult.deserialize(from: jsonString) {
                        if let currentCity = model.location.first {
//                            self.currentCity = currentCity
                            print(currentCity)
                        }
                    }
                }
            }

        })
    }
    
    func cityModel(context: NSManagedObjectContext, city: City = .defaultCity) -> CityModel {
        
        let cityModel = CityModel(context: context)
        
        cityModel.adm1 = city.adm1
        cityModel.adm2 = city.adm2
        cityModel.country = city.country
        cityModel.fxLink = city.fxLink
        cityModel.id = city.id
        cityModel.isDst = city.isDst
        cityModel.lat = city.lat
        cityModel.lon = city.lon
        cityModel.name = city.name
        cityModel.rank = city.rank
        cityModel.type = city.type
        cityModel.tz = city.tz
        cityModel.utcOffset = city.utcOffset
        cityModel.isLocation = city.isLocation
        cityModel.addTime = city.addTime
        
        return cityModel
    }
}
