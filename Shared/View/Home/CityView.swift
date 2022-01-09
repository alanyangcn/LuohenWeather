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

    @StateObject var dataModel = HomeViewModel()
    var city: CityModel

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
                    .contentBackground(height: topItemHeight)

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
                    .foregroundColor(.textColor)
                    .contentBackground(height: dayWeatherHeight)

                    FifteenDailyWeatherView(dailyWeather: dataModel.dailyWeather)
                        .contentBackground(height: 400)
                    AirQualityView(air: dataModel.currentAir)
                        .contentBackground(height: 180)
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("太阳和月亮").padding(8)
                            HStack(spacing: 0) {
                                ForEach(0 ..< 2) { _ in
                                    VStack {
                                        Canvas { context, size in
                                            var path = Path()
                                            path.move(to: CGPoint(x: 0, y: size.height))
                                            path.addLine(to: CGPoint(x: size.width, y: size.height))

                                            context.stroke(path, with: .color(.subTextColor), lineWidth: 3)

                                            var circle = Path()
                                            circle.addArc(center: CGPoint(x: size.width / 2, y: size.height), radius: size.width / 3, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true, transform: .identity)

                                            context.stroke(circle, with: .color(Color.subTextColor), lineWidth: 2)
                                        }
                                        HStack(spacing: 0) {
                                            VStack {
                                                Text("日出")
                                                Text("07:36")
                                            }
                                            Spacer()
                                            VStack {
                                                Text("日出")
                                                Text("19:36")
                                            }
                                        }
                                        .font(.system(size: 14))
                                    }
//                                    .background(.blue)
                                    .padding(2)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .frame(maxHeight: .infinity)
                        }
                    }
                    .contentBackground(height: 150)

                    HStack {
                        Text("Powered by Luohen")
                            .foregroundColor(.subTextColor)
                    }
                    .contentBackground(height: 40)
                }
                .padding(.bottom, 10)
            }
        }
//        .frame(maxHeight: .infinity)
        .padding(.horizontal, 16)

        .task {
            dataModel.refreshData(cityId: city.id ?? "")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("indexChanged"), object: nil)) { _ in

            NotificationCenter.default.post(name: NSNotification.Name("CurrentCityWeather"), object: nil, userInfo: [
                "currentWeather": dataModel.currentWeather,
//                "city": city!.id,
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

struct HomeContentBackground: ViewModifier {
    var height: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(Color.themeWhite.opacity(0.8))
            .cornerRadius(10)
    }
}

extension View {
    func contentBackground(height: CGFloat) -> some View {
        modifier(HomeContentBackground(height: height))
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        getHomeViewPreviews()
    }
}
