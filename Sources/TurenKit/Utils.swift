//
//  Device.swift
//  XFoundation
//
//  Created by YueTing Weng on 2025/10/4.
//

import UIKit

public func getKeyWindow() -> UIWindow? {
    guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
          let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow })
    else {
        return nil
    }
    return keyWindow
}

public func getVersion() -> String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    return "\(version)"
}

public func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
    impactFeedbackGenerator.prepare()
    impactFeedbackGenerator.impactOccurred()
}

public func generateQRCode(from string: String, size: CGFloat = 200) -> UIImage? {
    let data = string.data(using: .utf8)

    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel") // 容错率：L/M/Q/H

        guard let ciImage = filter.outputImage else { return nil }

        let baseSize = ciImage.extent.size.width
        let scale = size / baseSize

        let sparseScale = scale * 0.5 // 比原始缩放更小（稀疏）
        let transform = CGAffineTransform(scaleX: sparseScale, y: sparseScale)
        let scaledImage = ciImage.transformed(by: transform)

        return UIImage(ciImage: scaledImage)
    }

    return nil
}

public func getDeviceModel() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
}

public func formatTime(time: TimeInterval, format: String = "yyyy/MM/dd HH:mm:ss") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let date = Date(timeIntervalSince1970: time)
    return dateFormatter.string(from: date)
}

public func formatToK(number: Int) -> String {
    if number < 1000 {
        return "\(number)" // 小于 1000 直接返回
    }

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 1 // 最少 1 位小数
    formatter.maximumFractionDigits = 1 // 最多 1 位小数

    let formatted = formatter.string(from: NSNumber(value: Double(number) / 1000)) ?? "\(number)"
    return "\(formatted)k"
}
