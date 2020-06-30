//
//  IssueDetailRepository.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//
import RxSwift

private struct IssueDetailRequest: DecodableRequestConfig {
    typealias Response = Issue
    let urlRequest: URLRequest

    init(number: Int) {
        var request = URLRequest(url: URL(string: "https://api.github.com/repos/Carthage/Carthage/issues/\(number)")!)
        request.httpMethod = "GET"
        self.urlRequest = request
    }
}

struct IssueDetailRepository: IssueDetailRepositoryProtocol {
    func fetch(number: Int) -> Single<Issue> {
        API().connect(config: IssueDetailRequest(number: number))
    }
}
