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
    private let issueDetailUseCase = IssueDetailUseCase(repository: IssueDetailRepository())
    private let disposeBag = DisposeBag()
    private let number: Int
    var issue: Driver<ViewData> {
        issueDetailUseCase.issue
            .compactMap { $0.value }
            .map(ViewData.init)
            .asDriver(onErrorDriveWith: .empty())
    }
    var error: Signal<Error> {
        issueDetailUseCase.issue
            .compactMap { $0.error }
            .asSignal(onErrorSignalWith: .empty())
    }

    init(number: Int) {
        self.number = number
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

extension IssueDetailViewModel {
    struct ViewData {
        let title: String
        let body: String
        let url: URL
        let updatedAt: Date
    }
}

extension IssueDetailViewModel.ViewData {
    init (domainObject: Issue) {
        self.init(
            title: domainObject.title,
            body: domainObject.body,
            url: domainObject.url,
            updatedAt: domainObject.updatedAt
        )
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
