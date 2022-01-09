//
//  LoadingView.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2022/1/4.
//

import SwiftUI

struct LoadingState {
    var title = "正在加载"
}

class LoadingViewManager: ObservableObject {
    static let shared = LoadingViewManager()

    @Published var tags: [AnyHashable: LoadingState] = [:]

    func show(tag: AnyHashable) {
        tags[tag] = LoadingState()
    }

    func dismiss(tag: AnyHashable) {
        tags.removeValue(forKey: tag)
    }
}

struct LoadingView: ViewModifier {
    @ObservedObject var loadingManager = LoadingViewManager.shared

    @State var tag: AnyHashable

    func body(content: Content) -> some View {
        let loadingState = loadingManager.tags[tag]
        ZStack {
            content

            ZStack(alignment: .center) {
                VStack(spacing: 20) {
                    ProgressView()
                        .frame(width: 40, height: 40, alignment: .center)
                    Text(loadingState?.title ?? "")
                }
                .foregroundColor(.textColor)
                .padding()
                .background(.white)
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.3))
            .opacity(loadingState == nil ? 0 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension View {
    func loading(tag: AnyHashable) -> some View {
        modifier(LoadingView(tag: tag))
    }
}
