//
//  IssueListUseCaseTest.swift
//  RxPlaygroundTests
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxPlayground

class IssueListUseCaseTest: XCTestCase {

    func testIssueResult() {
        let scheduler = TestScheduler(initialClock: 0)
        let useCase = IssueListUseCase(repository: StubRepository())
        let resultObserver = scheduler.createObserver([Issue].self)
        _ = useCase.issues.bind(to: resultObserver)
        scheduler.scheduleAt(300, action: { useCase.fetch() })
        scheduler.scheduleAt(305, action: { useCase.fetch() })
        scheduler.start()

        XCTAssertEqual(resultObserver.events, [
            .next(300, []),
            .next(305, [])
        ])
    }

}

extension IssueListUseCaseTest {
    struct StubRepository: IssueListRepositoryProtocol {
        func fetch() -> Single<[Issue]> {
            Single.just([])
        }
    }
}
