//
//  FifteenDailyWeatherView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/5.
//

import SwifterSwift
import SwiftUI

extension Date {
    
    func dayname(style: DayNameStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hans")
        dateFormatter.timeZone = TimeZone.current
        
        var format: String {
            switch style {
            case .oneLetter:
                return "EEEEE"
            case .threeLetters:
                return "EEE"
            case .full:
                return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
}

struct FifteenDailyWeatherView: View {
    var dailyWeather: [DailyWeather]

    var itemWidth: CGFloat = 65
    
    var body: some View {
        let maxTemp = dailyWeather.sorted(by: \.tempMax, with: { Int($0)! < Int($1)! }).last?.tempMax.int ?? 0
        let minTemp = dailyWeather.sorted(by: \.tempMin, with: { Int($0)! < Int($1)! }).first?.tempMin.int ?? 0

        VStack(alignment: .leading, spacing: 0) {
            Text("15天预报")
                .frame(height: 40)
                .padding(.leading, 16)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(dailyWeather) { weather in
                        
                        VStack(spacing: 4) {
                            Text(weather.fxDate.date!.dayname(style: .threeLetters))
                                .font(.system(size: 16))
                                .foregroundColor(.textColor)
                            Text(weather.fxDate.date!.string(withFormat: "MM-dd"))
                            Text(weather.textDay)
                                .foregroundColor(.textColor)
                            Image(weather.iconDay)
                                .resizable()
                                .renderingMode(SwiftUI.Image.TemplateRenderingMode.template)
                                .foregroundColor(.orange)
                                .frame(width: 25, height: 25, alignment: .center)
//                                .font(.system(size: 20))/
                            
                            Canvas { context, size in
                                DarwLine(minTemp: minTemp, maxTemp: maxTemp, context: context, size: size, weather: weather, lineColor: .orange, isMax: true)
                                DarwLine(minTemp: minTemp, maxTemp: maxTemp, context: context, size: size, weather: weather, lineColor: .green, isMax: false)
                            }
                            
                            
                            Image(systemName: "sun.max")
                                .resizable()
                                .renderingMode(SwiftUI.Image.TemplateRenderingMode.template)
                                .foregroundColor(.orange)
                                .frame(width: 25, height: 25, alignment: .center)
                            Text(weather.textNight)
                                .foregroundColor(.textColor)
                            Text(weather.windDirNight)
                                .font(.system(size: 14))
                            Text("\(weather.windScaleNight)级")
                        }
                        .frame(width: itemWidth)
                        .font(.system(size: 15))
                        .foregroundColor(.subTextColor)
                    }
                }
                
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
    }

    func DarwLine(minTemp: Int, maxTemp: Int, context: GraphicsContext, size: CGSize, weather: DailyWeather, lineColor: SwiftUI.Color, isMax: Bool) {
        
        let padding: CGFloat = 30
        let circleWH: CGFloat = 6

        let lineWidth: CGFloat = 2

        let originY = padding
        let circleCornerRadius = circleWH * 0.5

        let perHeight = (size.height - padding * 2) / CGFloat(maxTemp - minTemp)

        var temp = 0
        if isMax {
            temp = weather.tempMax.int ?? 0
        } else {
            temp = weather.tempMin.int ?? 0
        }
        
        let y = originY + CGFloat(maxTemp - temp) * perHeight

        var path = Path()

        path.addRoundedRect(in: CGRect(x: size.width / 2 - circleCornerRadius, y: y - circleCornerRadius, width: circleWH, height: circleWH), cornerSize: CGSize(width: circleCornerRadius, height: circleCornerRadius))


        if let dayIndex = dailyWeather.firstIndex(of: weather) {
            if dayIndex > 0 {
                let preDay = dailyWeather[dayIndex - 1]
                
                var preDayTemp = 0
                
                if isMax {
                    preDayTemp = preDay.tempMax.int ?? 0
                } else {
                    preDayTemp = preDay.tempMin.int ?? 0
                }
                
                let preY = originY + CGFloat(maxTemp - preDayTemp) * perHeight
                var path = Path()
                path.move(to: CGPoint(x: size.width / 2 - itemWidth, y: preY))
                path.addLine(to: CGPoint(x: size.width / 2, y: y))

                context.stroke(path, with: .color(lineColor), lineWidth: lineWidth)
            }

            if dayIndex != dailyWeather.count - 1 {
                let nextDay = dailyWeather[dayIndex + 1]

                var nextDayTemp = 0
                
                if isMax {
                    nextDayTemp = nextDay.tempMax.int ?? 0
                } else {
                    nextDayTemp = nextDay.tempMin.int ?? 0
                }
                
                let nextY = originY + CGFloat(maxTemp - nextDayTemp) * perHeight
                
                var path = Path()
                path.move(to: CGPoint(x: size.width / 2, y: y))
                path.addLine(to: CGPoint(x: size.width / 2 + itemWidth, y: nextY))

                context.stroke(path, with: .color(lineColor), lineWidth: lineWidth)
            }
        }
        context.fill(path, with: .color(lineColor))

        let text = "\(isMax ? weather.tempMax : weather.tempMin)℃"
        let textY = isMax ? y - 12 : y + 12
        context.draw(
            Text(text).font(.system(size: 14)).foregroundColor(.textColor),
            at: CGPoint(x: size.width / 2, y: textY))
    }
}

struct FifteenDailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        getHomeViewPreviews()
    }
}
