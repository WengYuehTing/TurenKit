//
//  Api+Rx.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

import Factory
import Moya
import RxSwift

/// PrimitiveSequence 扩展，提供响应数据到模型的映射功能
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    /// 将网络响应映射为指定的响应模型
    /// - Parameter _: 目标响应模型类型
    /// - Returns: 包含模型数据的可观察序列
    func mapToModel<T: BaseResponse>(_: T.Type) -> Single<T.Output> {
        return map { response in
            guard let jsonString = String(data: response.data, encoding: .utf8) else {
                throw NetworkError.invalidEncoding
            }
            guard let data = T.deserialize(from: jsonString)?.data else {
                throw NetworkError.deserializationFailed
            }
            return data
        }
    }

    func filterBusinessSuccessfulStatusCode() -> Single<Element> {
        flatMap { response in
            let buninessCode = response.extractBusinessCode()
            if buninessCode == 200 {
                return .just(response)
            } else {
                return .error(MoyaError.statusCode(response))
            }
        }
    }
}

public extension Response {
    func extractBusinessCode() -> Int {
        guard let jsonDict = try? mapJSON() as? [String: Any],
              let code = jsonDict["code"] as? Int
        else {
            return 400
        }
        return code
    }
}
