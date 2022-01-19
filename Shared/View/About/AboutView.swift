//
//  AboutView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/14.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
        VStack {
            Image("app_icon")
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .padding(.top, 80)
                
            VStack(spacing: 0) {
                HStack {
                Text("当前版本")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    Text(LuohenWeatherApp.currentVersion)
                }
                Divider()
                HStack {
                    Text("项目地址")
                        .frame(height: 44)

                    Spacer()
                    Link(destination: URL(string: "https://www.baidu.com")!) {
                        Text("https://www.baidu.com")
                            .underline()
                    }
                }
                
                Divider()
                Text("免责声明")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
            }
            .padding(.horizontal)
            .background(.white)
            .padding(.top, 60)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                VStack {
                Text("本应用仅用于交流学习，天气数据来源于和风天气，数据准确性仅供参考，本app不承担任何法律责任。")
                
                }
                
                .background(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }
        .background(Color.themeWhite)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
