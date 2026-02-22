//
//  String.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation

public extension String {

    // MARK: - Trimming

    /// 去除首尾空白字符（包括空格、换行、制表符等）
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 去除所有空白字符
    var removingWhitespaces: String {
        return replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .replacingOccurrences(of: "\n", with: "")
    }

    // MARK: - Empty Check

    /// 检查字符串是否非空
    var isNotEmpty: Bool {
        return !isEmpty
    }

    /// 检查字符串是否为空或仅包含空白字符
    var isBlank: Bool {
        return trimmed.isEmpty
    }

    /// 检查字符串是否非空且包含非空白字符
    var isNotBlank: Bool {
        return !isBlank
    }

    // MARK: - Substring

    /// 安全地获取子字符串，避免越界
    /// - Parameters:
    ///   - start: 起始索引
    ///   - length: 长度
    /// - Returns: 子字符串，如果越界则返回 nil
    func substring(from start: Int, length: Int) -> String? {
        guard start >= 0, length >= 0, start < count else { return nil }
        let startIndex = index(self.startIndex, offsetBy: start)
        let endIndex = index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
        return String(self[startIndex..<endIndex])
    }

    /// 安全地获取指定范围的子字符串
    /// - Parameters:
    ///   - start: 起始索引
    ///   - end: 结束索引（不包含）
    /// - Returns: 子字符串，如果越界则返回 nil
    func substring(from start: Int, to end: Int) -> String? {
        guard start >= 0, end >= start, start < count else { return nil }
        let startIndex = index(self.startIndex, offsetBy: start)
        let endIndex = index(self.startIndex, offsetBy: min(end, count), limitedBy: self.endIndex) ?? self.endIndex
        return String(self[startIndex..<endIndex])
    }

    /// 安全地通过索引获取字符
    /// - Parameter index: 字符索引
    /// - Returns: 字符，如果越界则返回 nil
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        let stringIndex = self.index(startIndex, offsetBy: index)
        return self[stringIndex]
    }

    // MARK: - Truncation

    /// 截断字符串，超出部分用省略号表示
    /// - Parameters:
    ///   - maxLength: 最大长度
    ///   - trailing: 截断时添加的后缀，默认为 "..."
    /// - Returns: 截断后的字符串
    func truncated(to maxLength: Int, trailing: String = "...") -> String {
        guard count > maxLength else { return self }
        let endIndex = index(startIndex, offsetBy: maxLength - trailing.count)
        return String(self[..<endIndex]) + trailing
    }

    // MARK: - URL

    /// URL 编码
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// URL 解码
    var urlDecoded: String? {
        return removingPercentEncoding
    }

    // MARK: - Validation

    /// 检查是否为有效的邮箱格式
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// 检查是否为有效的 URL
    var isValidURL: Bool {
        return URL(string: self) != nil
    }

    /// 检查是否仅包含数字
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /// 检查是否仅包含字母
    var isAlphabetic: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }

    /// 检查是否仅包含字母和数字
    var isAlphanumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }

    // MARK: - Case

    /// 首字母大写
    var capitalizedFirst: String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst().lowercased()
    }

    /// 驼峰转下划线（camelCase -> snake_case）
    var toSnakeCase: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(startIndex..., in: self)
        let result = regex?.stringByReplacingMatches(
            in: self,
            range: range,
            withTemplate: "$1_$2"
        ) ?? self
        return result.lowercased()
    }

    /// 下划线转驼峰（snake_case -> camelCase）
    var toCamelCase: String {
        return split(separator: "_")
            .enumerated()
            .map { $0.offset == 0 ? String($0.element).lowercased() : String($0.element).capitalizedFirst }
            .joined()
    }

    // MARK: - Conversion

    /// 转为 Int
    var toInt: Int? {
        return Int(self)
    }

    /// 转为 Double
    var toDouble: Double? {
        return Double(self)
    }

    /// 转为 Bool（支持 "true", "false", "1", "0", "yes", "no"）
    var toBool: Bool? {
        let lowercased = self.lowercased()
        switch lowercased {
        case "true", "1", "yes": return true
        case "false", "0", "no": return false
        default: return nil
        }
    }

    /// 转为 Data（UTF-8 编码）
    var toData: Data? {
        return data(using: .utf8)
    }

    // MARK: - Padding

    /// 左侧填充至指定长度
    /// - Parameters:
    ///   - length: 目标长度
    ///   - character: 填充字符，默认为空格
    /// - Returns: 填充后的字符串
    func paddedLeft(to length: Int, with character: Character = " ") -> String {
        guard count < length else { return self }
        return String(repeating: character, count: length - count) + self
    }

    /// 右侧填充至指定长度
    /// - Parameters:
    ///   - length: 目标长度
    ///   - character: 填充字符，默认为空格
    /// - Returns: 填充后的字符串
    func paddedRight(to length: Int, with character: Character = " ") -> String {
        guard count < length else { return self }
        return self + String(repeating: character, count: length - count)
    }
}

// MARK: - Optional String

public extension Optional where Wrapped == String {

    /// 如果为 nil 或空字符串则返回 true
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

    /// 如果为 nil 或空白字符串则返回 true
    var isNilOrBlank: Bool {
        return self?.isBlank ?? true
    }

    /// 返回非空字符串或默认值
    /// - Parameter defaultValue: 默认值
    /// - Returns: 非空字符串或默认值
    func orEmpty(_ defaultValue: String = "") -> String {
        guard let value = self, !value.isEmpty else { return defaultValue }
        return value
    }
}
