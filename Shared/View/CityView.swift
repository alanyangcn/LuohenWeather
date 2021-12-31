//
//  CityView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import SwiftUI


struct CityView: View {
    var topItemHeight: CGFloat = 70
    var dayWeatherHeight: CGFloat = 140
    @State var index = 0
    @StateObject var dataModel = HomeViewModel()
    @State var city: City
    var body: some View {
        GeometryReader { proxy in

            ScrollView(showsIndicators: false) {
                let height = proxy.size.height - 10 - topItemHeight - 10 - dayWeatherHeight - 30 - 10
                VStack(spacing: 10) {
                    currentWeather(height: height)
                    currentAir()

                    HStack {
                        GeometryReader { proxy in
                            let width = proxy.size.width
                            let itemWidth = width / 4

                            topItem(title: "体感", value: "\(dataModel.currentWeather.feelsLike)℃")
                                .frame(width: itemWidth)

                            topItem(title: "湿度", value: "\(dataModel.currentWeather.humidity)%")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth)

                            topItem(title: "风力", value: "\(dataModel.currentWeather.windDir)\(dataModel.currentWeather.windScale)级")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth * 2)

                            topItem(title: "气压", value: "\(dataModel.currentWeather.pressure)hPa")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth * 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: topItemHeight)
                    .background(Color.themeWhite.opacity(0.8))
                    .cornerRadius(10)

                    HStack {
                        GeometryReader { proxy in
                            let width = proxy.size.width
                            let itemWidth = width / 3

                            dayWeatherItem(day: "今天", weather: "晴", temperature: "-2~11℃")
                                .frame(width: itemWidth)

                            dayWeatherItem(day: "明天", weather: "晴转多云", temperature: "-10~1℃")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth)

                            dayWeatherItem(day: "后天", weather: "小雪", temperature: "-10~-1℃")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth * 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: dayWeatherHeight)
                    .background(Color.themeWhite.opacity(0.8))
                    .cornerRadius(10)

                    HStack {
                        GeometryReader { proxy in
                            let width = proxy.size.width
                            let itemWidth = width / 3

                            topItem(title: "体感", value: "\(dataModel.currentWeather.feelsLike)℃")
                                .frame(width: itemWidth)

                            topItem(title: "湿度", value: "\(dataModel.currentWeather.humidity)%")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth)

                            topItem(title: "风力", value: "\(dataModel.currentWeather.windDir)\(dataModel.currentWeather.windScale)级")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth * 2)

                            topItem(title: "气压", value: "\(dataModel.currentWeather.pressure)hPa")
                                .frame(width: itemWidth)
                                .offset(x: itemWidth * 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .background(Color.themeWhite.opacity(0.8))
                    .cornerRadius(10)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 16)

        .onAppear {
            //            CLLocationManager().requestAlwaysAuthorization()
            //            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            //
            //            locationManager.locationTimeout = 2
            //
            //            locationManager.reGeocodeTimeout = 2
            //
            //            requesetLocation()
        }
        .task {
            dataModel.refreshData(city: city)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("indexChanged"), object: nil)) { _ in

            NotificationCenter.default.post(name: NSNotification.Name("CurrentCityWeather"), object: nil, userInfo: [
                "currentWeather": dataModel.currentWeather,
                "city": city,
            ])
        }
    }

    @ViewBuilder
    func currentWeather(height: CGFloat) -> some View {
        VStack {
            HStack {
                Text(dataModel.currentWeather.temp)
                    .font(.system(size: 100, weight: .medium, design: .default))
                VStack {
                    Text("℃")
                        .offset(y: -15)
                    Text(dataModel.currentWeather.text)
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .offset(y: 15)
                }
            }
            Text("12月30日 农历十一月廿七")
        }
        .foregroundColor(.white)
        .frame(height: height)
    }

    @ViewBuilder
    func currentAir() -> some View {
        HStack {
            Spacer()
            HStack {
                Image(systemName: "leaf")
                    .foregroundColor(.green)
                Text("\(dataModel.currentAir.aqi) 空气\(dataModel.currentAir.category)")
                    .foregroundColor(.white)
            }
            .font(.footnote)
            .frame(height: 30)
            .padding(.horizontal, 10)
            .background(.black.opacity(0.5))
            .cornerRadius(15)
        }
    }

    @ViewBuilder
    func topItem(title: String, value: String) -> some View {
        VStack(spacing: 0) {
            Text(value)
                .padding(.top, 10)
                .font(.system(size: 18))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
            Text(title)
                .padding(.top, 5)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                .opacity(0.7)
        }
    }

    @ViewBuilder
    func dayWeatherItem(day: String, weather: String, temperature: String) -> some View {
        VStack(spacing: 0) {
            Text(day)
                .padding(.top, 10)
            Image(systemName: "sun.max")
                .font(.system(size: 20))
            Text(weather)
                .padding(.top, 10)
            Text(temperature)
                .padding(.top, 5)
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
