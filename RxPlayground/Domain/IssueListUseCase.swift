//
//  IssueListUseCase.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift
import RxRelay

protocol IssueListRepositoryProtocol {
    func fetch() -> Single<[Issue]>
}

final class IssueListUseCase {
    private let fetchTrigger = PublishRelay<Void>()
    let issues: Observable<[Issue]>

    init(repository: IssueListRepositoryProtocol) {
        issues = fetchTrigger.flatMapFirst {
            repository.fetch()
        }
    }

    func fetch() {
        fetchTrigger.accept(())
    }
}
