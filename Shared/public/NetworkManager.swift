//
//  NetworkManager.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI
import HandyJSON
import Moya

enum DataError: Error {
    case dataError
}
typealias Success = (String) -> Void
typealias Failure = (Error) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    
    private let provider = MoyaProvider<Api>()
    func request(target: Api, success: Success?, failure: Failure? = nil) {
        provider.request(target) {result in 
            switch result {
            case let .success(resp):

//                YLPLog(String(data: resp.data, encoding: .utf8) ?? "")
                if let jsonString = String(data: resp.data, encoding: .utf8) {
                    success?(jsonString)
                } else {
                    failure?(DataError.dataError)
                }
                
            case let .failure(error):
                failure?(error)
            }
        }
    }
    
    
}
