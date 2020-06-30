//
//  IssueDetailUseCaseTest.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//
import XCTest
import RxSwift
import RxTest
@testable import RxPlayground

let sharedURL = URL(string: "foo://baz")!
let sharedDate = Date()
func makeIssue(number: Int) -> Issue {
    Issue(number: number, title: "", body: "", url: sharedURL, user: .init(login: "", avatarURL: ""), updatedAt: sharedDate)
}

class IssueDetailUseCaseTest: XCTestCase {

    func testIssueResult() {
        let scheduler = TestScheduler(initialClock: 0)
        let repository = StubRepository(source: [
            .failure, .failure, .failure, .success
        ])

        let useCase = IssueDetailUseCase(repository: repository)
        let resultObserver = scheduler.createObserver(ObservedResult.self)
        _ = useCase.issue.map {
            switch $0 {
            case .success(let issue):
                return .success(issue)
            case .failure:
                return .failure
            }
        }.bind(to: resultObserver)
        scheduler.scheduleAt(300, action: { useCase.fetch(number: 0) })
        scheduler.scheduleAt(301, action: { useCase.fetch(number: 1) })
        scheduler.scheduleAt(302, action: { useCase.fetch(number: 2) })
        scheduler.scheduleAt(303, action: { useCase.fetch(number: 3) })
        scheduler.scheduleAt(304, action: { useCase.fetch(number: 4) })

        scheduler.start()
        print(makeIssue(number: 3) == makeIssue(number: 3))
        XCTAssertEqual(resultObserver.events, [
            .next(300, .failure),
            .next(301, .failure),
            .next(302, .failure),
            .next(303, .success(makeIssue(number: 3))),
            .next(304, .failure)
        ])
    }

}

extension IssueDetailUseCaseTest {
    enum Source {
        case success
        case failure
    }

    enum ObservedResult: Equatable {
        case success(Issue)
        case failure
    }
    struct SomeError: Swift.Error, Hashable {
    }

    class StubRepository: IssueDetailRepositoryProtocol {
        var source: [Source]
        init(source: [Source]) {
            self.source = source
        }
        func fetch(number: Int) -> Single<Issue> {
            guard !source.isEmpty else {
                return .error(SomeError())
            }
            switch source.removeFirst() {
            case .success:
                return .just(makeIssue(number: number))
            case .failure:
                return .error(SomeError())
            }
        }
    }
}
