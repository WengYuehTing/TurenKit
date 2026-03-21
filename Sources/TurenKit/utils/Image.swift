//
//  Image.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation
import UIKit

public extension UIImage {
    /// 等比缩小图片，使其总像素面积小于指定值
    func fitToArea(_ maxArea: CGFloat) -> UIImage? {
        let originalWidth = size.width
        let originalHeight = size.height
        let originalArea = originalWidth * originalHeight

        // 如果图片面积已经合规，就直接返回
        if originalArea <= maxArea {
            return self
        }

        // 计算缩放比例（根据面积）
        let scaleFactor = sqrt(maxArea / originalArea)
        let newWidth = originalWidth * scaleFactor
        let newHeight = originalHeight * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)

        // 使用 UIGraphics 缩放图片
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }

    /// 缩放图片到指定宽度，保持宽高比
    /// - Parameter targetWidth: 目标宽度
    /// - Returns: 缩放后的图片，如果失败则返回 nil
    func fitToWidth(_ targetWidth: CGFloat) -> UIImage? {
        let originalWidth = size.width
        let originalHeight = size.height

        // 如果原图宽度已经等于目标宽度，直接返回
        if abs(originalWidth - targetWidth) < 0.1 {
            return self
        }

        // 计算缩放比例
        let scaleFactor = targetWidth / originalWidth
        let newWidth = targetWidth
        let newHeight = originalHeight * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)

        // 使用 UIGraphics 缩放图片
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }

    /// 缩放图片到指定高度，保持宽高比
    /// - Parameter targetHeight: 目标高度
    /// - Returns: 缩放后的图片，如果失败则返回 nil
    func fitToHeight(_ targetHeight: CGFloat) -> UIImage? {
        let originalWidth = size.width
        let originalHeight = size.height

        // 如果原图高度已经等于目标高度，直接返回
        if abs(originalHeight - targetHeight) < 0.1 {
            return self
        }

        // 计算缩放比例
        let scaleFactor = targetHeight / originalHeight
        let newWidth = originalWidth * scaleFactor
        let newHeight = targetHeight
        let newSize = CGSize(width: newWidth, height: newHeight)

        // 使用 UIGraphics 缩放图片
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }
    
    /// 将图片缩放到确切的像素尺寸，忽略原图的 scale 属性
    ///
    /// 这个方法会强行将图片缩放到目标尺寸，不保持宽高比，类似于 CSS 的 `object-fit: fill` 行为。
    /// 使用 `UIGraphicsImageRenderer` 并设置 `scale = 1.0` 来确保生成的图片是确切的像素尺寸，
    /// 避免因为原图的 scale 属性导致实际尺寸被放大。
    ///
    /// - Parameters:
    ///   - targetSize: 目标尺寸（像素）
    ///   - opaque: 是否不透明，默认为 false
    /// - Returns: 缩放后的图片，尺寸为确切的 targetSize
    ///
    /// 使用场景：
    /// - 需要发送给后端的确切尺寸图片
    /// - 缩略图生成
    /// - 适配不同屏幕尺寸
    func fillToPixelSize(_ targetSize: CGSize, opaque: Bool = false) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleRatio = max(widthRatio, heightRatio) // 保证覆盖整个目标区域

        // 计算缩放后的尺寸
        let scaledSize = CGSize(
            width: size.width * scaleRatio,
            height: size.height * scaleRatio
        )

        // 计算绘制起点，使其居中
        let origin = CGPoint(
            x: (targetSize.width - scaledSize.width) / 2,
            y: (targetSize.height - scaledSize.height) / 2
        )

        // 创建 renderer 并绘图
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0 // 强制设置为 1.0，确保生成确切的像素尺寸
        format.opaque = opaque

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: origin, size: scaledSize))
        }
    }

    /// Resizes the image to the specified size without maintaining the original aspect ratio.
    ///
    /// - Parameters:
    ///   - targetSize: The size to which the image will be resized.
    /// - Returns: A new `UIImage` resized to the specified size, possibly distorting the image to fit.
    func resize(to targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }

    /// Resizes the image to fit within the bucket size with preserving the original aspect ratio.
    /// The image is centered within the bounds and any empty space is filled with a specified color.
    ///
    /// - Parameters:
    ///   - targetSize: The size of the output image (the target resolution or bucket size).
    ///   - supplementalColor: The color used to fill any empty space around the image to achieve the target size.
    /// - Returns: A new `UIImage` that fits within the target size, maintaining the original aspect ratio and centering the image in the target bounds with the specified background color filling the remaining space.
    func resizeWithRatioKeeping(_ targetSize: CGSize, _ supplementalColor: UIColor) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let rect = CGRect(
            x: (targetSize.width - newSize.width) / 2.0,
            y: (targetSize.height - newSize.height) / 2.0,
            width: newSize.width,
            height: newSize.height
        )
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0)
        supplementalColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: targetSize))
        self.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }

    /// Returns a Base-64 encoded string.
    func base64EncodedString(compressQuality: CGFloat = 1.0) -> String? {
        if compressQuality == 1.0 {
            return self.pngData()?.base64EncodedString()
        } else {
            return self.jpegData(compressionQuality: compressQuality)?.base64EncodedString()
        }
    }

    func masking(_ mask: UIImage) -> UIImage? {
        guard let cgImage = self.cgImage, let maskImage = mask.cgImage else {
            return nil
        }
        guard let result = cgImage.masking(maskImage) else {
            return nil
        }
        return UIImage(cgImage: result)
    }

    /// 水平翻转图片
    func flipHorizontally() -> UIImage {
        /// 创建一个变换矩阵，水平翻转
        let transform = CGAffineTransform(scaleX: -1.0, y: 1.0) // 水平翻转
        /// 获取图像的原始尺寸
        let size = self.size
        /// 创建一个渲染上下文
        let renderer = UIGraphicsImageRenderer(size: size)
        /// 绘制翻转后的图像
        let flippedImage = renderer.image { context in
            // 在上下文中应用翻转变换
            context.cgContext.concatenate(transform)
            // 将图像绘制到翻转后的上下文中
            self.draw(at: CGPoint(x: -size.width, y: 0)) // 绘制图像时，X坐标偏移负宽度
        }
        return flippedImage
    }

    /// Resizes the image to fit within the closest matching aspect ratio from a given list.
    ///
    /// - Note: This function assumes that the `aspectRatios` array is non-empty. Passing an empty array will cause crash.
    ///
    /// - Parameters:
    ///   - aspectRatios: An array of `CGSize` representing potential target aspect ratios (or buckets).
    ///   - supplementalColor: The background color to fill any empty space around the image to achieve the target aspect ratio.
    ///
    /// - Returns: A new `UIImage` resized with the closest aspect ratio from the list, keeping the original aspect ratio.
    func unsafeFit(_ aspectRatios: [CGSize], _ supplementalColor: UIColor = .white) -> UIImage {
        let closestSize = aspectRatios.min { a, b in
            abs((a.width / a.height) - (self.size.width / self.size.height)) <
            abs((b.width / b.height) - (self.size.width / self.size.height))
        }!
        return self.resizeWithRatioKeeping(closestSize, supplementalColor)
    }

    /// Resizes the image to fit within the closest matching aspect ratio from a given list.
    ///
    /// - Parameters:
    ///   - aspectRatios: An array of `CGSize` representing potential target aspect ratios (or buckets).
    ///   - supplementalColor: The background color to fill any empty space around the image to achieve the target aspect ratio.
    ///
    /// - Returns: A new `UIImage` resized with the closest aspect ratio from the list, keeping the original aspect ratio.
    func fit(_ aspectRatios: [CGSize], _ supplementalColor: UIColor = .white) -> UIImage? {
        guard let closestSize = aspectRatios.min(by: { a, b in
            abs((a.width / a.height) - (self.size.width / self.size.height)) <
            abs((b.width / b.height) - (self.size.width / self.size.height))
        }) else {
            return nil
        }
        return self.resizeWithRatioKeeping(closestSize, supplementalColor)
    }

    /// Recover the fitting image to its original aspect ratio, by firstly removing the supplementalColor.
    ///
    /// - Parameters:
    ///   - originalSize: The original image aspect ratio before fitting.
    ///
    /// - Returns: A new `UIImage` resized to its original aspect ratio.
    func recover(_ originalSize: CGSize) -> UIImage? {
        let widthRatio = self.size.width / originalSize.width
        let heightRatio = self.size.height / originalSize.height
        let ratio = min(widthRatio, heightRatio)
        let newWidth = originalSize.width * ratio
        let newHeight = originalSize.height * ratio
        let rect = CGRect(
            x: (self.size.width - newWidth) / 2.0,
            y: (self.size.height - newHeight) / 2.0,
            width: newWidth,
            height: newHeight
        )
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0)
        self.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let extractedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return extractedImage
    }
}

public extension String {

    /// Returns an UIImage from a Base-64 encoded string.
    func base64DecodedImage() -> UIImage? {
        guard let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: data)
    }
}

public func handleGenerateImage(fromSize: CGSize, andColor: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(fromSize, false, 0)
    andColor.setFill()
    let rect = CGRect(origin: .zero, size: fromSize)
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}
