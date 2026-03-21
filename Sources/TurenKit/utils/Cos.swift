//
//  Cos.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

public extension String {

    /// 添加腾讯云COS图片处理参数前缀
    /// 用于开始图片处理操作，必须在使用其他图片处理方法前调用
    /// - Returns: 添加了imageMogr2参数的URL字符串
    func imageMogr2() -> String {
        return self + "?imageMogr2"
    }

    /// 将图片转换为WebP格式
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Returns: 添加了WebP格式转换参数的URL字符串
    func asWebP() -> String {
        return self + "/format/webp"
    }

    /// 按比例缩放图片（宽高同时缩放）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameter scale: 缩放比例，1-1000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(scale: Int) -> String {
        return self + "/thumbnail/!\(scale)p"
    }

    /// 按宽度比例缩放图片（高度不变）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameter scale: 宽度缩放比例，1-1000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(widthScale: Int) -> String {
        return self + "/thumbnail/!\(widthScale)px"
    }

    /// 按高度比例缩放图片（宽度不变）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameter scale: 高度缩放比例，1-1000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(heightScale: Int) -> String {
        return self + "/thumbnail/!x\(heightScale)p"
    }

    /// 按指定宽度缩放图片（高度等比缩放）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameter width: 目标宽度，1-10000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(width: Int) -> String {
        return self + "/thumbnail/\(width)x"
    }

    /// 按指定高度缩放图片（宽度等比缩放）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameter height: 目标高度，1-10000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(height: Int) -> String {
        return self + "/thumbnail/x\(height)"
    }

    /// 限制最大宽高（等比缩放，取较小缩放比）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameters:
    ///   - width: 最大宽度，1-10000之间的整数
    ///   - height: 最大高度，1-10000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(maxWidth: Int, maxHeight: Int) -> String {
        return self + "/thumbnail/\(maxWidth)x\(maxHeight)t"
    }

    /// 限制最小宽高（等比缩放，取较大缩放比）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameters:
    ///   - width: 最小宽度，1-10000之间的整数
    ///   - height: 最小高度，1-10000之间的整数
    /// - Returns: 处理后的URL字符串
    func thumbnail(minWidth: Int, minHeight: Int) -> String {
        return self + "/thumbnail/!\(minWidth)x\(minHeight)r"
    }

    /// 限制最大宽高（可选择是否仅缩小）
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameters:
    ///   - width: 最大宽度，1-10000之间的整数
    ///   - height: 最大高度，1-10000之间的整数
    ///   - onlyShrink: 是否仅缩小（true=仅缩小，false=可放大）
    /// - Returns: 处理后的URL字符串
    func thumbnail(maxWidth: Int, maxHeight: Int, onlyShrink: Bool = true) -> String {
        if onlyShrink {
            return self + "/thumbnail/\(maxWidth)x\(maxHeight)>"
        } else {
            return self + "/thumbnail/\(maxWidth)x\(maxHeight)<"
        }
    }

    /// 等比缩放图片，缩放后的图像，总像素数量不超过 Area
    /// 必须在imageMogr2()方法后调用才能生效
    /// - Parameter area: 像素数量
    /// - Returns: 处理后的URL字符串
    func thumbnail(area: Int) -> String {
        return self + "/thumbnail/\(area)@"
    }
}
