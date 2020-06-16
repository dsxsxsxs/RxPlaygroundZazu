//
//  OB.swift
//  RxPlaygroundTests
//
//  Created by Jiacheng Shih on 2020/06/16.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import XCTest
@testable import RxPlayground

class Observer<E> {
    let handler: (E) -> Void
    init(handler: @escaping (E) -> Void) {
        self.handler = handler
    }
    func on(event: E) {
        handler(event)
    }
}

class Subject<E> {
    private var observers: [Observer<E>] = []
    func notify(event: E) {
        observers.forEach { $0.on(event: event) }
    }

    func subscribe(observer: Observer<E>) {
        observers.append(observer)
    }
}

class OBTest: XCTestCase {


    func testOB() {
        var receievedEvents: [Void] = []
        let subject = Subject<Void>()
        subject.subscribe(observer: .init(handler: {
            receievedEvents.append($0)
        }))
        subject.notify(event: ())
        subject.notify(event: ())
        XCTAssertEqual(receievedEvents.count, 2)
    }

}
