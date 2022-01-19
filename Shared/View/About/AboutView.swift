//
//  AboutView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/14.
//

import SwiftUI

struct AboutView: View {
    @State var isWarningShow = false
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
                    Button {
                        if !isWarningShow {
                            withAnimation {
                                isWarningShow = true
                            }
                        }
                        

                    } label: {
                        Text("免责声明")

                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .frame(height: 44)

                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .background(.white)
                .padding(.top, 60)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if isWarningShow {
                VStack {
                    Spacer()
                    VStack {
                        Text("本应用仅用于交流学习，天气数据来源于和风天气，数据准确性仅供参考，本app不承担任何法律责任。")
                    }
                    .frame(width: 300)
                    .padding(20)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.bottom, 100)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            isWarningShow = false
                        }
                    }
                }
            }
        }
        .background(Color.themeWhite)
        .navigationSetting(title: "关于")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView()
        }
    }
}
