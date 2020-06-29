//
//  IssueListRepository.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift

private struct IssueListRequest: DecodableRequestConfig {
    typealias Response = [Issue]
    var urlRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/repos/Carthage/Carthage/issues?filter=all&page=1")!)
        request.httpMethod = "GET"
        return request
    }
}

struct IssueListRepository {
    func fetch() -> Single<[Issue]> {
        API().connect(config: IssueListRequest())
    }
}
