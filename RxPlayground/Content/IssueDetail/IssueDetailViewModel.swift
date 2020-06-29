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
    private let issueDetailUseCase = IssueDetailUseCase(repository: IssueDetailRepository())
    private let disposeBag = DisposeBag()
    private let number: Int
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
        self.number = number
        issueDetailUseCase.issues
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
        issueDetailUseCase.fetch(number: number)
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
