//
//  HomeNavBar.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/3.
//

import SwiftUI

struct HomeNavBar: View {
    @State var isCitySelectViewPresent = false

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \CityModel.sort, ascending: true)],
//        animation: .default)
    var result: FetchedResults<CityModel>

    @Binding var selectedIndex: Int
    var body: some View {
        HStack {
            Button {
                isCitySelectViewPresent = true

            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 22))
            }
            .fullScreenCover(isPresented: $isCitySelectViewPresent, onDismiss: nil) {
                CitySelectView()
            }

            HStack(spacing: 5) {
                if let model = result[safe: selectedIndex] {
                    if let name = model.name, let adm2 = model.adm2 {
                        Text("\(adm2)-\(name)")
                    }
                    if let isLocation = model.isLocation, isLocation {
                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                } else {
                    Text("N/A")
                }
            }
            .overlay(
                HStack {
                    ForEach(result) { model in
                        let index = result.firstIndex(of: model) ?? 0
                        Circle()
                            .frame(width: 5, height: 5, alignment: .center)
                            .foregroundColor(index == selectedIndex ? .white : .white.opacity(0.5))
                    }
                }.offset(y: 10)
                , alignment: .bottomLeading)

            Spacer()

            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "line.3.horizontal.circle")
                    .font(.system(size: 22))
            }

        }
        .frame(height: 44)
        .font(.system(size: 18))
        .foregroundColor(.white)
        .padding(.horizontal, 16)
    }
}
