//
//  API.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/15.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift


protocol RequestConfig {
    associatedtype Response
    var urlRequest: URLRequest { get }
    func decode(from data: Data) throws -> Response
}

protocol DecodableRequestConfig: RequestConfig where Response: Decodable {
}

extension JSONDecoder {
    static let dateSafeDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
}
extension DecodableRequestConfig {
    func decode(from data: Data) throws -> Response {
        try JSONDecoder.dateSafeDecoder.decode(Response.self, from: data)
    }
}

struct API {
    enum Error: Swift.Error {
        case networkError(Swift.Error)
        case httpError(code: Int, body: String?)
        case responseError(Swift.Error)
        case unknown(Swift.Error)
    }
    private let authHeaderGetter: () -> String

    init(authHeaderGetter: @escaping () -> String = { Config.authHeader }) {
        self.authHeaderGetter = authHeaderGetter
    }

    @discardableResult
    func connect<Request: RequestConfig>(config: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) -> URLSessionTask {
        var request = config.urlRequest
        request.setValue(authHeaderGetter(), forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown(NSError(domain: "\(String(describing: type(of: response))) is not HTTPURLResponse", code: 0, userInfo: nil))))
                return
            }

            switch httpResponse.statusCode {
            case 400...:
                let body = data.flatMap { String(data: $0, encoding: .utf8) }
                completion(.failure(.httpError(code: httpResponse.statusCode, body: body)))
            case 200..<400:
                do {
                    if let data = data {
                        let result =  try config.decode(from: data)
                        completion(.success(result))
                    } else {
                        completion(.failure(.responseError(NSError(domain: "data is nil", code: 0, userInfo: nil))))
                    }
                } catch let error {
                    completion(.failure(.responseError(error)))
                }
            case _:
                assertionFailure("unsupported http response(\(httpResponse.statusCode))")
            }
        }
        task.resume()
        return task
    }
}

import RxSwift
extension API {
    func connect<Request: RequestConfig>(config: Request) -> Single<Request.Response> {
        Single.create { emitter in
            let task = self.connect(config: config) {
                switch $0 {
                case .success(let response):
                    emitter(.success(response))
                case .failure(let error):
                    emitter(.error(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}
