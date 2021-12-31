//
//  HomeView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import CoreLocation
import SwiftUI


struct HomeView: View {
    @State var cities = [City(id: "101010100"), City(id: "101310101"), City(id: "101060101")]
    @State var selectedIndex = 0
    @State var bgName = "bg_1_d"
    @State var isCitySelectViewPresent = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    isCitySelectViewPresent = true
                } label: {
                    Image(systemName: "plus")
                }
                .fullScreenCover(isPresented: $isCitySelectViewPresent, onDismiss: nil) {
                    CitySelectView()
                        
                }
                
                HStack(spacing: 0) {
                    Text("北京")
                    Text("-")
                    Text("昌平")
                }

                Spacer()

                Button {
                } label: {
                    Image(systemName: "line.3.horizontal.circle")
                }
            }
            .frame(height: 44)
            .font(.system(size: 18))
            .foregroundColor(.white)
            .padding(.horizontal, 16)

            TabView(selection: $selectedIndex) {
                ForEach(cities.indices) { index in
                    CityView(city: cities[index]).tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }

        .background(
            Image(bgName)
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CurrentCityWeather"), object: nil), perform: { noti in
                    if let currentWeather = noti.userInfo?["currentWeather"] as? CurrentWeather,
                       let city = noti.userInfo?["city"] as? City {
                        if city.id == cities[selectedIndex].id {
                            switch currentWeather.text {
                            case "多云":
                                bgName = "bg_2_d"
                            default:
                                bgName = "bg_1_d"
                            }
                        }
                    }

                })
        )

        .onChange(of: selectedIndex) { _ in

            NotificationCenter.default.post(name: NSNotification.Name("indexChanged"), object: nil)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
