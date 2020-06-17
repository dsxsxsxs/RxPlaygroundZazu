//
//  IssueRequests.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/16.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//
import Foundation

struct User: Decodable {
    let login: String
    let avatarURL: String
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}

struct Issue: Decodable {
    let number: Int
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let user: User // 一覧画面にアバター画像と名前を表示
    let updatedAt: Date // 一覧画面・詳細画面に表示
    enum CodingKeys: String, CodingKey {
        case number, title, body, user
        case url = "html_url"
        case updatedAt = "updated_at"
    }

}

struct IssueListRequest: DecodableRequestConfig {
    typealias Response = [Issue]
    var urlRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/repos/Carthage/Carthage/issues?filter=all&page=1")!)
        request.httpMethod = "GET"
        return request
    }
}

struct IssueDetailRequest: DecodableRequestConfig {
    typealias Response = Issue
    let urlRequest: URLRequest

    init(number: Int) {
        var request = URLRequest(url: URL(string: "https://api.github.com/repos/Carthage/Carthage/issues/\(number)")!)
        request.httpMethod = "GET"
        self.urlRequest = request
    }

}