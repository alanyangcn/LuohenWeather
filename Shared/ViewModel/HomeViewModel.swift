//
//  HomeViewModel.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import KakaJSON
import SwiftUI
class HomeViewModel: ObservableObject, Equatable {
    static func == (lhs: HomeViewModel, rhs: HomeViewModel) -> Bool {
        lhs.currentWeather == rhs.currentWeather && lhs.currentAir == rhs.currentAir
    }

    @Published var currentWeather = CurrentWeather()
    @Published var currentAir = CurrentAir()
    let locationManager = AMapLocationManager()

    func refreshData(city: City) {
        requestCurrentWeather(city: city)
        requestCurrentAir(city: city)
    }

    func requestCurrentWeather(city: City) {
        NetworkManager.shared.request(target: .current(location: city.id)) { data in

            if let model = model(from: data, CurrentWeatherResult.self) {
                self.currentWeather = model.now
            }
        }
    }

    func requestCurrentAir(city: City) {
        NetworkManager.shared.request(target: .currentAir(location: city.id)) { data in

            if let model = model(from: data, CurrentAirResult.self) {
                self.currentAir = model.now
            }
        }
    }

    func requesetLocation() {
        locationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in

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
                NSLog("location:%@", location)

                CLGeocoder().reverseGeocodeLocation(location) { places, _ in

                    guard let places = places else { return }
                }
            }

            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
            }
        })
    }
}
