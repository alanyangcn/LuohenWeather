//
//  HomeView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import CoreData
import CoreLocation
import SwiftUI

struct HomeNavBar: View {
    @State var isCitySelectViewPresent = false

    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CityModel.addTime, ascending: true)],
        animation: .default)
    private var result: FetchedResults<CityModel>

    
    
    var body: some View {
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
            .overlay(
                HStack {
                    ForEach(result) { model in
                        let index = result.firstIndex(of: model) ?? 0
                        Circle()
                            .frame(width: 5, height: 5, alignment: .center)
//                            .foregroundColor(index == selectedIndex ? .white : .white.opacity(0.5))
                    }
                }.offset(y: 10)
                , alignment: .bottomLeading)

            Spacer()

            Button {
            } label: {
                Image(systemName: "line.3.horizontal")
            }
        }
        .frame(height: 44)
        .font(.system(size: 18))
        .foregroundColor(.white)
        .padding(.horizontal, 16)
    }
}

struct HomeView: View {
    @State var cities = [City.defaultCity]
    @State var selectedIndex = 0

    @State var bgName = "bg_1_d"

    @StateObject var dataModel = HomeViewModel()

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CityModel.addTime, ascending: true)],
        animation: .default)
    private var result: FetchedResults<CityModel>

    var body: some View {
        VStack(spacing: 0) {
            HomeNavBar()
            
            TabView(selection: $selectedIndex) {
                ForEach(result) { city in
                    CityView(city: nil, fecthedData: city).tag(city.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            
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

        .onChange(of: selectedIndex) { newValue in
            print(newValue)
            NotificationCenter.default.post(name: NSNotification.Name("indexChanged"), object: nil)
        }
//
//        .onAppear {
//            withAnimation {
//                if result.count == 0 {
//                    let model = dataModel.cityModel(context: viewContext)
//                    try? viewContext.save()
//                }
//
//                print(result.count)
//            }
//        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
