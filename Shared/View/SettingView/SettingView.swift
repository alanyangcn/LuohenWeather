//
//  SettingView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/5.
//

import SwiftUI

struct SettingView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            Form {
                Section {
                    NavigationLink {
                        CityManageView()
                    }label: {
                        HStack {
                            Text("城市管理")
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    }label: {
                        HStack {
                            Text("关于")
                        }
                    }
                }
            }
        }
//        .navigationBarHidden(true)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        SettingView()
        }
    }
}
