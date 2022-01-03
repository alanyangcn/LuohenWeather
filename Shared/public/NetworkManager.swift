//
//  NetworkManager.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI
import HandyJSON
import Moya
typealias Success = (String) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    
    private let provider = MoyaProvider<Api>()
    func request(target: Api, success: Success?) {
        provider.request(target) {result in 
            switch result {
            case let .success(resp):

//                YLPLog(String(data: resp.data, encoding: .utf8) ?? "")
                if let jsonString = String(data: resp.data, encoding: .utf8) {
                    success?(jsonString)
                }
                
            case let .failure(error):
                YLPLog(error)
            }
        }
    }
}
