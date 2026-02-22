//
//  Color.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation
import UIKit
import SwiftUI

public extension UIColor {

    // MARK: - Hex Initialization

    /// 通过十六进制字符串初始化 UIColor
    /// - Parameter hex: 十六进制颜色字符串，支持格式：#RGB, #RRGGBB, #ARGB, #AARRGGBB
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }

    /// 通过十六进制数值初始化 UIColor
    /// - Parameters:
    ///   - hex: 十六进制颜色值，例如：0xFF0000 表示红色
    ///   - alpha: 透明度 (0.0-1.0)
    convenience init(hexString: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hexString >> 16) & 0xff) / 255,
            green: CGFloat((hexString >> 08) & 0xff) / 255,
            blue: CGFloat((hexString >> 00) & 0xff) / 255,
            alpha: alpha
        )
    }

    // MARK: - RGB Initialization

    /// 通过 RGB 值初始化 UIColor
    /// - Parameters:
    ///   - red: 红色分量 (0-255)
    ///   - green: 绿色分量 (0-255)
    ///   - blue: 蓝色分量 (0-255)
    ///   - alpha: 透明度 (0.0-1.0)
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    // MARK: - Color Properties

    /// 获取颜色的十六进制字符串表示
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

        return String(format: "#%06x", rgb)
    }

    /// 获取颜色的十六进制字符串表示（包含透明度）
    var hexStringWithAlpha: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgba: Int = (Int)(alpha * 255) << 24 | (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

        return String(format: "#%08x", rgba)
    }

    // MARK: - Image Creation

    /// 通过颜色创建图片
    /// - Parameter size: 图片尺寸
    /// - Returns: 生成的 UIImage
    func image(size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        setFill()
        UIRectFill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 通过颜色创建正方形图片
    /// - Parameter sideLength: 正方形边长
    /// - Returns: 生成的 UIImage
    func image(sideLength: CGFloat) -> UIImage? {
        return image(size: CGSize(width: sideLength, height: sideLength))
    }

    /// 创建动态颜色
    /// - Parameters:
    ///   - light: 浅色模式下的颜色
    ///   - dark: 深色模式下的颜色
    /// - Returns: 动态颜色
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}

// MARK: - SwiftUI Color Extension

public extension Color {

    // MARK: - Hex Initialization

    /// 通过十六进制字符串初始化 Color
    /// - Parameter hex: 十六进制颜色字符串，支持格式：#RGB, #RRGGBB, #ARGB, #AARRGGBB
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// 通过十六进制数值初始化 Color
    /// - Parameters:
    ///   - hex: 十六进制颜色值，例如：0xFF0000 表示红色
    ///   - alpha: 透明度 (0.0-1.0)
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }

    // MARK: - RGB Initialization

    /// 通过 RGB 值初始化 Color
    /// - Parameters:
    ///   - red: 红色分量 (0-255)
    ///   - green: 绿色分量 (0-255)
    ///   - blue: 蓝色分量 (0-255)
    ///   - alpha: 透明度 (0.0-1.0)
    init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: alpha
        )
    }
}
