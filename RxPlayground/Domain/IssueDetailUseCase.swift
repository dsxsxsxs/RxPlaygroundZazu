//
//  IssueDetailUseCase.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/29.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import RxSwift

final class IssueDetailUseCase {

    func fetch(number: Int) -> Single<Issue> {
        IssueDetailRepository().fetch(number: number)
    }
}
