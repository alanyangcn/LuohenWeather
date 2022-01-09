//
//  CitySelectView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI

struct CitySelectView: View {
    
    enum Field: Hashable {
        case search
    }

    
    @State var searchText: String = ""
    var rows: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @StateObject var dataModel = CitySelectViewModel()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Environment(\.managedObjectContext) private var viewContext

    @FocusState private var focusedField: Field?

    let hotCity = City.hotCities

  
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { newValue in
                        YLPLog(newValue)
                        dataModel.requestCities(keyword: newValue)
                    }
                    .focused($focusedField, equals: .search)

                Text("当前位置")
                    .foregroundColor(Color.subTextColor)
                HStack {
                    HStack {
                        Image(systemName: "location")
                        Text("\(LocationManager.shared.currentCity.adm2)-\(LocationManager.shared.currentCity.name)")
                        Spacer()
                        Button {
                            LoadingViewManager.shared.show(tag: "City")

                            LocationManager.shared.requesetLocation { city, _ in
                                
                                withAnimation(.easeInOut.delay(1.0)) {
                                    LoadingViewManager.shared.dismiss(tag: "City")
                                    if let city = city {
                                        
                                        presentationMode.wrappedValue.dismiss()
                                        NotificationCenter.default.post(name: Constants.citySelected, object: nil, userInfo: [
                                            "city": city,
                                        ])
                                    }
                                }
                            }
                        } label: {
                            Text("立即定位")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .font(.system(size: 15))
                }
                .padding(5)
                Text("热门城市")

                ScrollView {
                    LazyVGrid(columns: rows, spacing: 10) {
                        ForEach(hotCity, id: \.self) { city in
                            VStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                    NotificationCenter.default.post(name: Constants.citySelected, object: nil, userInfo: [
                                        "city": city,
                                    ])
                                } label: {
                                    Text(city.name)
                                        .font(.system(size: 15))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .padding(5)
            }
            .padding(.horizontal, 16)
            .overlay(
                VStack {
                    List(dataModel.cities) { city in
                        Button {
                            withAnimation {
                                focusedField = nil

                                NotificationCenter.default.post(name: Constants.citySelected, object: nil, userInfo: [
                                    "city": city,
                                ])
                                presentationMode.wrappedValue.dismiss()
                            }

                        } label: {
                            Text("\(city.name),\(city.adm2),\(city.adm1),\(city.country)")
                        }
                    }
                    .listStyle(.plain)
                    .background(.white)
                }
                .offset(y: 40)
                .opacity(dataModel.cities.count > 0 ? 1 : 0)

                , alignment: .bottom
            )

            .navigationTitle("添加城市")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .foregroundColor(Color.textColor)
//        .loading()

        .loading(tag: "City")
    }
}

struct CitySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectView()
    }
}
