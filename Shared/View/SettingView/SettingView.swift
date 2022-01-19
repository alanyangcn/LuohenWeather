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
        .navigationSetting(title: "设置")
        
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        SettingView()
        }
    }
}


struct NavigationSetting: ViewModifier {
    @Environment(\.presentationMode) private var presentationMode
    @State var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        print("back action...")
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    })
                }
            })
    }
}
extension View {
    func navigationSetting(title: String) -> some View {
        return  self.modifier(NavigationSetting(title: title))
    }
}
