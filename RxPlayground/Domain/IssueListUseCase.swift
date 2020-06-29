//
//  IssueListUseCase.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift

final class IssueListUseCase {

    func fetch() -> Single<[Issue]> {
        IssueListRepository().fetch()
    }
}
