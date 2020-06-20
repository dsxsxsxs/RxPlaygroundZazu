//
//  IssueDetailViewModel.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/21.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//
import RxSwift
import RxCocoa

final class IssueDetailViewModel {
    private let issueRelay = PublishRelay<Issue>()
    private let fetchTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    var issue: Driver<Issue> {
        issueRelay.asDriver(onErrorDriveWith: .empty())
    }

    init(number: Int) {
        fetchTrigger
            .flatMapFirst { API().connect(config: IssueDetailRequest(number: number)) }
            .bind(to: issueRelay)
            .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        fetch()
    }

    private func fetch() {
        fetchTrigger.accept(())
    }
}
