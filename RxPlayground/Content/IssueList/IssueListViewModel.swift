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
    private let issuesRelay = PublishRelay<[Issue]>()
    private let fetchTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    var issues: Driver<[Issue]> {
        issuesRelay.asDriver(onErrorDriveWith: .empty())
    }

    init() {
        fetchTrigger
            .flatMapFirst { API().connect(config: IssueListRequest()) }
            .bind(to: issuesRelay)
            .disposed(by: disposeBag)
    }

    func viewWillAppear() {
        fetch()
    }

    private func fetch() {
        fetchTrigger.accept(())
    }
}
