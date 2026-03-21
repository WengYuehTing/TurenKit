import Moya
import Foundation

public protocol APIProvider {

    var configuration: NetworkConfiguration { get }
}

public extension APIProvider {

    /// 使用固定 domain 的 provider，URL = domainUrl + path
    func createDomainProvider<T: TargetType>(for _: T.Type) -> MoyaProvider<T> {
        let endpointClosure = { (target: T) -> Endpoint in
            Endpoint(
                url: self.configuration.domainUrl.urlConcat(target.path),
                sampleResponseClosure: { .networkResponse(200, Data()) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        return MoyaProvider<T>(
            endpointClosure: endpointClosure,
            plugins: [RequestLoggerPlugin(), AccessTokenPlugin()]
        )
    }

    /// 使用动态 endpoint 的 provider，URL 直接取 path（path 已含完整地址）
    func createEndpointProvider<T: TargetType>(for _: T.Type) -> MoyaProvider<T> {
        let endpointClosure = { (target: T) -> Endpoint in
            Endpoint(
                url: target.path,
                sampleResponseClosure: { .networkResponse(200, Data()) },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        return MoyaProvider<T>(
            endpointClosure: endpointClosure,
            plugins: [RequestLoggerPlugin(), AccessTokenPlugin()]
        )
    }
}
