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
    let issues: Driver<[Issue]>

    init() {
        issues = issueListUseCase.issues.asDriver(onErrorDriveWith: .empty())
    }

    func viewWillAppear() {
        fetch()
    }

    private func fetch() {
        issueListUseCase.fetch()
    }
}
