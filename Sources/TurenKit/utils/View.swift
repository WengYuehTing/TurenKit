//
//  View.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation

#if canImport(UIKit)
import UIKit

public extension UIView {

    /// 截取视图的当前内容为图片
    /// - Returns: 截取的图片
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
        return image
    }
}

#endif
