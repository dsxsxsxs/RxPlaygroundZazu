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
    private let issueResultRelay = PublishRelay<Result<Issue, Error>>()
    private let fetchTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    var issue: Driver<Issue> {
        issueResultRelay
            .compactMap { $0.value }
            .asDriver(onErrorDriveWith: .empty())
    }
    var error: Signal<Error> {
        issueResultRelay
            .compactMap { $0.error }
            .asSignal(onErrorSignalWith: .empty())
    }

    init(number: Int) {
        fetchTrigger
            .flatMapFirst {
                IssueDetailRepository().fetch(number: number)
                    .map { .success($0) }
                    .catchError { .just(.failure($0)) }
            }
            .bind(to: issueResultRelay)
            .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        fetch()
    }

    func didRequestForRetry() {
        fetch()
    }

    private func fetch() {
        fetchTrigger.accept(())
    }
}

extension Result {
    var value: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
