//
//  HomeView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import CoreData
import CoreLocation
import SwifterSwift
import SwiftUI

extension CityModel {
    override public var description: String {
        String("\(name) == \(sort)")
    }
}

struct HomeView: View {
    @State var cities = [City.defaultCity]
    @State var selectedIndex = 0

    @State var bgName = "bg_1_d"

    @StateObject var dataModel = HomeViewModel()

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CityModel.sort, ascending: true)],
        animation: .default)
    private var result: FetchedResults<CityModel>

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HomeNavBar(result: result, selectedIndex: $selectedIndex)

                TabView(selection: $selectedIndex) {
                    ForEach(result) { city in
//                    print("-----\(city.id)")
                        let index = result.firstIndex(of: city) ?? 0
                        CityView(city: city).tag(index)
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
//                        if city.id == cities[selectedIndex].id {
//                            switch currentWeather.text {
//                            case "多云":
//                                bgName = "bg_2_d"
//                            default:
//                                bgName = "bg_1_d"
//                            }
//                        }
                        }

                    })
            )
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onChange(of: selectedIndex) { newValue in
                print(newValue)
                NotificationCenter.default.post(name: NSNotification.Name("indexChanged"), object: nil)
            }
            .onReceive(NotificationCenter.default.publisher(for: Constants.citySelected, object: nil), perform: { noti in
                if let city = noti.userInfo?["city"] as? City {
                    result.forEach { m in
                        YLPLog(m.description)
                    }

                    if city.isLocation {
                        // 是定位城市 - 更新定位城市
                        if let localCity = result.filter({ $0.isLocation }).first {
                            dataModel.update(localCity, by: city)
                            localCity.sort = 0
                            try? viewContext.save()
                            selectedIndex = 0
                        }

                    } else {
                        if let index = result.firstIndex(where: { $0.id == city.id }) {
                            selectedIndex = index
                        } else {
                            let model = dataModel.cityModel(context: viewContext, city: city)
                            model.sort = Int64(result.count)

                            try? viewContext.save()
                            selectedIndex = result.count - 1
                        }
                    }
                }

            })

            .onAppear {
                if result.count == 0 {
                    dataModel.cityModel(context: viewContext)
                    try? viewContext.save()
                }
            }
            .task {
                LocationManager.shared.requesetLocation()
            }
            .navigationBarHidden(true)
        }

        .loading(tag: "Home")
    }
}

func getHomeViewPreviews() -> some View {
    let viewContext = PersistenceController.shared.container.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityModel")

    if let result = try? viewContext.fetch(request) {
        result.forEach({ viewContext.delete($0 as! NSManagedObject) })
    }

    HomeViewModel().cityModel(context: viewContext)
    try? viewContext.save()

    return HomeView()
        .environment(\.managedObjectContext, viewContext)
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        getHomeViewPreviews()
    }
}
