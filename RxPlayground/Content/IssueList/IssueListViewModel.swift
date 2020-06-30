//
//  IssueListViewModel.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/21.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift
import RxCocoa



final class IssueListViewModel {
    private let issueListUseCase = IssueListUseCase(repository: IssueListRepository())
    let issues: Driver<[ViewData]>

    init() {
        issues = issueListUseCase.issues
            .map { $0.map(ViewData.init) }
            .asDriver(onErrorDriveWith: .empty())
    }

    func viewWillAppear() {
        fetch()
    }

    private func fetch() {
        issueListUseCase.fetch()
    }
}

extension IssueListViewModel {
    struct ViewData {
        let number: Int
        let title: String
        let name: String
        let avatarURL: String
        let updatedAt: Date
    }
}

extension IssueListViewModel.ViewData {
    init (domainObject: Issue) {
        self.init(
            number: domainObject.number,
            title: domainObject.title,
            name: domainObject.user.login,
            avatarURL: domainObject.user.avatarURL,
            updatedAt: domainObject.updatedAt
        )
    }
}
