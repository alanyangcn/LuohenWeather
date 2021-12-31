//
//  CitySelectView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI

let hotCity = [
    City(id: "", name: "北京"), City(id: "", name: "上海"), City(id: "", name: "广州"),
    City(id: "", name: "深圳"), City(id: "", name: "天津"), City(id: "", name: "重庆"),
    City(id: "", name: "西安"), City(id: "", name: "成都"), City(id: "", name: "杭州"),
    City(id: "", name: "南京"), City(id: "", name: "苏州"), City(id: "", name: "武汉"),
    City(id: "", name: "东莞"), City(id: "", name: "宁波"), City(id: "", name: "厦门"),

    City(id: "", name: "北京"), City(id: "", name: "北京"), City(id: "", name: "北京"),
    City(id: "", name: "北京"), City(id: "", name: "北京"), City(id: "", name: "北京"),
    City(id: "", name: "北京"), City(id: "", name: "北京"), City(id: "", name: "北京"),
    City(id: "", name: "北京"), City(id: "", name: "北京"), City(id: "", name: "北京"),
    City(id: "", name: "北京"), City(id: "", name: "北京"), City(id: "", name: "北京"),
]

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {
        HStack {
            TextField("请输入城市名称", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
//                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                    }

                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("取消")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct CitySelectView: View {
    @State var searchText: String = ""
    var rows: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @StateObject var dataModel = CitySelectViewModel()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                SearchBar(text: $searchText)
                    .onChange(of: searchText) { newValue in
                        YLPLog(newValue)
                        dataModel.requestCities(keyword: newValue)
                    }

                Text("当前位置")
                    .foregroundColor(Color.subTextColor)
                HStack {
                    HStack {
                        Image(systemName: "location")
                        Text("昌平区")
                        Spacer()
                        Button {
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
                                Text(city.name)
                                    .font(.system(size: 15))
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
        }
        .foregroundColor(Color.textColor)
    }
}

struct CitySelectView_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectView()
    }
}
