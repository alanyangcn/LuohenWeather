//
//  AirQualityView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/4.
//

import SwiftUI

struct AirQualityView: View {
    
    var air: CurrentAir
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("空气质量")
                .frame(height: 40)
                .padding(.leading, 16)
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    VStack {
                        Text("优")
                            .foregroundColor(.subTextColor.opacity(0.8))
                            .font(.system(size: 15))
                        Text("50")
                            .foregroundColor(.textColor)
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(
                        Canvas { context, size in
                            var circle = Path()

                            let minDegress: CGFloat = -240
                            let maxDegress: CGFloat = 60

                            circle.addArc(center: CGPoint(x: size.width / 2, y: size.height / 2), radius: size.width / 3, startAngle: Angle(degrees: minDegress), endAngle: Angle(degrees: maxDegress), clockwise: false, transform: .identity)

                            context.stroke(circle, with: .color(Color.subTextColor.opacity(0.5)), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))

                            let num = 50
                            let total = 500

                            let degress = minDegress + (maxDegress - minDegress) * (CGFloat(num) / CGFloat(total))

                            var progress = Path()
                            progress.addArc(center: CGPoint(x: size.width / 2, y: size.height / 2), radius: size.width / 3, startAngle: Angle(degrees: minDegress), endAngle: Angle(degrees: degress), clockwise: false, transform: .identity)

                            context.stroke(progress, with: .color(Color.green), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))

                        }
                    )

                    HStack {
                        Text("0")
                        Spacer()
                        Text("500")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.subTextColor)

                    .frame(width: 70)
                    .offset(y: -16)
                }
                .frame(width: 140, height: 140)

                .frame(maxWidth: .infinity)
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PM2.5")
                        Text("SO₂")
                        Text("CO")

                    }.foregroundColor(.subTextColor)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(air.pm2p5)
                        Text(air.so2)
                        Text(air.co)
                    }
                    .foregroundColor(.textColor)
                }
                .frame(maxWidth: .infinity)
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PM10")
                        Text("NO₂")
                        Text("O³")
                    }
                    .foregroundColor(.subTextColor)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(air.pm10)
                        Text(air.no2)
                        Text(air.o3)
                    }
                    .foregroundColor(.textColor)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct AirQualityView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        HomeViewModel().cityModel(context: viewContext)
        try? viewContext.save()

        return HomeView()
            .environment(\.managedObjectContext, viewContext)
    }
}
