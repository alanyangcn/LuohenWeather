//
//  LuohenWeatherApp.swift
//  Shared
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI

@main
struct LuohenWeatherApp: SwiftUI.App {
    let persistenceController = PersistenceController.shared

    init() {
        setupAMap()
    }

    private func setupAMap() {
        AMapServices.shared().apiKey = "47727c1ee5c3e28459eab6abdf891d56"
        AMapServices.shared().enableHTTPS = true
        AMapLocationManager.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        AMapLocationManager.updatePrivacyAgree(.didAgree)
    }

    var body: some Scene {
        return WindowGroup {
            HomeView()

                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension LuohenWeatherApp {
    static var currentVersion: String {
        if let info = Bundle.main.infoDictionary {
            if let currentVersion = info["CFBundleShortVersionString"] as? String {
                return currentVersion
            }
        }

        return ""
    }
}
