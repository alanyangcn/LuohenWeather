//
//  LuohenWeatherApp.swift
//  Shared
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI

@main
struct LuohenWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
//        AMapLocationManager.updatePrivacyAgree(.didAgree)
        
        AMapServices.shared().apiKey = "47727c1ee5c3e28459eab6abdf891d56"
//        AMapServices.shared().enableHTTPS = true
        AMapLocationManager.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        AMapLocationManager.updatePrivacyAgree(.didAgree)
        return WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
