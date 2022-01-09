//
//  LocationManager.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/3.
//

import SwiftUI

import CoreData
import HandyJSON

typealias LocatingCompletion = (City?, Error?) -> Void


class LocationManager: NSObject, AMapLocationManagerDelegate {
    static let shared = LocationManager()

    var currentCity = City()

    let locationManager = AMapLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

        locationManager.locationTimeout = 2

        locationManager.reGeocodeTimeout = 2
    }

    func requesetLocation(completion: LocatingCompletion? = nil) {
        YLPLog("开始定位")
        locationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, _: AMapLocationReGeocode?, error: Error?) in
            YLPLog("定位结束")
            if let error = error {
                completion?(nil, error)
            }

            if let location = location {
                let lat = (location.coordinate.latitude * 100).rounded() / 100
                let lon = (location.coordinate.longitude * 100).rounded() / 100

                YLPLog("开始请求城市")
                NetworkManager.shared.request(target: .searchCity(keyword: "\(lon),\(lat)")) { jsonString in
                    YLPLog("结束请求城市")
                    if let model = LocationResult.deserialize(from: jsonString), model.location.count > 0 {
                        
                        var currentCity = model.location[0]
                        currentCity.isLocation = true
                        
                        self.currentCity = currentCity
                        
                        completion?(currentCity, nil)

                    } else {
                        
                        completion?(nil, DataError.dataError)
                    }
                } failure: { error in
                    completion?(nil, error)
                }
            }

        })
    }

    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
}
