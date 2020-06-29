//
//  IssueDetailUseCase.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift
import RxRelay

protocol IssueDetailRepositoryProtocol {
    func fetch(number: Int) -> Single<Issue>
}

final class IssueDetailUseCase {
    private let fetchTrigger = PublishRelay<Int>()
    let issues: Observable<Result<Issue, Error>>

    init(repository: IssueDetailRepositoryProtocol) {
        issues = fetchTrigger.flatMapLatest {
            repository.fetch(number: $0)
                .map { .success($0) }
                .catchError { .just(.failure($0)) }
        }
    }

    func fetch(number: Int) {
        fetchTrigger.accept(number)
    }
}
