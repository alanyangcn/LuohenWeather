//
//  YLPLog.swift
//  LuohenWeather (iOS)
//
//  Created by 杨立鹏 on 2021/12/30.
//

import Foundation

/// 封装的日志输出功能
/// - Parameters:
///   - input: 输出
///   - file: 调用文件名
///   - function: 调用方法
///   - line: 调用行
func YLPLog(_ input: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        // 获取文件名
        let fileName = file.split(separator: "/").last!

        var log = ""

        for argv in input {
            log += "\t\(argv)\n"
        }

        // 打印日志内容
        print("[Place:] \(fileName) (\(line)) - \(function)\n[Log:]\n\(log)")

    #endif
}
