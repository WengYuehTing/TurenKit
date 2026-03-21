//
//  Array.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public extension Array {

    // MARK: - Safe Access

    /// 安全地获取数组元素，避免越界崩溃
    /// - Parameter index: 索引
    /// - Returns: 元素，如果索引越界则返回 nil
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /// 安全地获取数组元素，如果越界则返回默认值
    /// - Parameters:
    ///   - index: 索引
    ///   - defaultValue: 默认值
    /// - Returns: 元素或默认值
    func element(at index: Int, default defaultValue: Element) -> Element {
        return indices.contains(index) ? self[index] : defaultValue
    }

    // MARK: - Array Manipulation

    /// 移除数组中的重复元素，保持原有顺序
    /// - Returns: 去重后的数组
    func removingDuplicates() -> [Element] where Element: Equatable {
        var result: [Element] = []
        for element in self {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }

    /// 移除数组中的重复元素，保持原有顺序（使用 Hashable）
    /// - Returns: 去重后的数组
    func removingDuplicates() -> [Element] where Element: Hashable {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }

    /// 将数组分割成指定大小的块
    /// - Parameter size: 每块的大小
    /// - Returns: 分割后的二维数组
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }

    /// 随机打乱数组
    /// - Returns: 打乱后的新数组
    func shuffled() -> [Element] {
        var result = self
        for index in stride(from: result.count - 1, through: 1, by: -1) {
            let randomIndex = Int.random(in: 0...index)
            result.swapAt(index, randomIndex)
        }
        return result
    }

    /// 随机获取数组中的一个元素
    /// - Returns: 随机元素，如果数组为空则返回 nil
    func randomElement() -> Element? {
        guard !isEmpty else { return nil }
        return self[Int.random(in: 0..<count)]
    }

    /// 随机获取数组中的多个元素
    /// - Parameter count: 要获取的元素数量
    /// - Returns: 随机元素数组
    func randomElements(count: Int) -> [Element] {
        let actualCount = Swift.min(count, self.count)
        guard actualCount > 0 else { return [] }

        var result: [Element] = []
        var indices = Swift.Array(0..<self.count)

        for _ in 0..<actualCount {
            let randomIndex = Int.random(in: 0..<indices.count)
            let selectedIndex = indices.remove(at: randomIndex)
            result.append(self[selectedIndex])
        }

        return result
    }

    // MARK: - Array Information

    /// 检查数组是否为空或 nil
    /// - Returns: 是否为空
    var isNotEmpty: Bool {
        return !isEmpty
    }

    // MARK: - Array Filtering

    /// 过滤掉空字符串
    /// - Returns: 过滤后的数组
    func filterEmpty() -> [Element] where Element == String {
        return filter { !$0.isEmpty }
    }

    /// 过滤掉空集合
    /// - Returns: 过滤后的数组
    func filterEmpty() -> [Element] where Element: Collection {
        return filter { !$0.isEmpty }
    }
}

// MARK: - UIImage Array Extensions

public extension Array where Element: UIImage {

    /// 合并多张图像为一张图像
    /// - Parameters:
    ///   - backgroundColor: 背景颜色，默认为透明
    ///   - alignment: 图像对齐方式，默认为居中
    /// - Returns: 合并后的图像
    func merge(
        backgroundColor: UIColor = .clear,
        alignment: ImageAlignment = .center
    ) -> UIImage {
        guard !isEmpty else { fatalError("Cannot merge empty image array") }

        let size = self[0].size

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        // 设置背景颜色
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        // 计算每张图像的位置和大小
        let imageInfos = calculateImageLayouts(
            images: self,
            containerSize: size,
            alignment: alignment
        )

        // 绘制每张图像
        for (index, image) in self.enumerated() {
            if index < imageInfos.count {
                let info = imageInfos[index]
                image.draw(in: info.rect)
            }
        }

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    /// 垂直合并图像
    /// - Parameters:
    ///   - spacing: 图像之间的间距
    ///   - backgroundColor: 背景颜色
    /// - Returns: 合并后的图像
    func mergeVertically(
        spacing: CGFloat = 0,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        guard !isEmpty else { return nil }

        let maxWidth = self.map { $0.size.width }.max() ?? 0
        let totalHeight = self.map { $0.size.height }.reduce(0, +) + CGFloat(count - 1) * spacing

        let size = CGSize(width: maxWidth, height: totalHeight)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        var currentY: CGFloat = 0
        for image in self {
            let xPosition = (maxWidth - image.size.width) / 2
            let rect = CGRect(x: xPosition, y: currentY, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
            currentY += image.size.height + spacing
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 水平合并图像
    /// - Parameters:
    ///   - spacing: 图像之间的间距
    ///   - backgroundColor: 背景颜色
    /// - Returns: 合并后的图像
    func mergeHorizontally(
        spacing: CGFloat = 0,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        guard !isEmpty else { return nil }

        let maxHeight = self.map { $0.size.height }.max() ?? 0
        let totalWidth = self.map { $0.size.width }.reduce(0, +) + CGFloat(count - 1) * spacing

        let size = CGSize(width: totalWidth, height: maxHeight)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        var currentX: CGFloat = 0
        for image in self {
            let yPosition = (maxHeight - image.size.height) / 2
            let rect = CGRect(x: currentX, y: yPosition, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
            currentX += image.size.width + spacing
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 网格合并图像
    /// - Parameters:
    ///   - columns: 列数
    ///   - spacing: 图像之间的间距
    ///   - backgroundColor: 背景颜色
    /// - Returns: 合并后的图像
    func mergeInGrid(
        columns: Int,
        spacing: CGFloat = 0,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        guard !isEmpty, columns > 0 else { return nil }

        let rows = (count + columns - 1) / columns
        let maxWidth = self.map { $0.size.width }.max() ?? 0
        let maxHeight = self.map { $0.size.height }.max() ?? 0

        let totalWidth = CGFloat(columns) * maxWidth + CGFloat(columns - 1) * spacing
        let totalHeight = CGFloat(rows) * maxHeight + CGFloat(rows - 1) * spacing

        let size = CGSize(width: totalWidth, height: totalHeight)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        for (index, image) in self.enumerated() {
            let row = index / columns
            let col = index % columns

            let xPosition = CGFloat(col) * (maxWidth + spacing)
            let yPosition = CGFloat(row) * (maxHeight + spacing)

            let rect = CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height)
            image.draw(in: rect)
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - Supporting Types

/// 图像对齐方式
public enum ImageAlignment {
    case center
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

// MARK: - Private Helper Functions

private func calculateImageLayouts(
    images: [UIImage],
    containerSize: CGSize,
    alignment: ImageAlignment
) -> [(rect: CGRect, image: UIImage)] {
    var layouts: [(rect: CGRect, image: UIImage)] = []

    for image in images {
        let imageSize = image.size
        let rect = calculateImageRect(
            imageSize: imageSize,
            containerSize: containerSize,
            alignment: alignment
        )
        layouts.append((rect: rect, image: image))
    }

    return layouts
}

private func calculateImageRect(
    imageSize: CGSize,
    containerSize: CGSize,
    alignment: ImageAlignment
) -> CGRect {
    let xPosition: CGFloat
    let yPosition: CGFloat

    switch alignment {
    case .center:
        xPosition = (containerSize.width - imageSize.width) / 2
        yPosition = (containerSize.height - imageSize.height) / 2
    case .top:
        xPosition = (containerSize.width - imageSize.width) / 2
        yPosition = 0
    case .bottom:
        xPosition = (containerSize.width - imageSize.width) / 2
        yPosition = containerSize.height - imageSize.height
    case .left:
        xPosition = 0
        yPosition = (containerSize.height - imageSize.height) / 2
    case .right:
        xPosition = containerSize.width - imageSize.width
        yPosition = (containerSize.height - imageSize.height) / 2
    case .topLeft:
        xPosition = 0
        yPosition = 0
    case .topRight:
        xPosition = containerSize.width - imageSize.width
        yPosition = 0
    case .bottomLeft:
        xPosition = 0
        yPosition = containerSize.height - imageSize.height
    case .bottomRight:
        xPosition = containerSize.width - imageSize.width
        yPosition = containerSize.height - imageSize.height
    }

    return CGRect(x: xPosition, y: yPosition, width: imageSize.width, height: imageSize.height)
}
