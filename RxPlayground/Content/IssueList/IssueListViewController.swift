//
//  IssueListViewController.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/16.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssueListViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = IssueListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: IssueListViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IssueListViewCell.self))
        tableView.dataSource = nil
        setupBindings()
    }

    private func setupBindings() {
        viewModel.issues
            .drive(tableView.rx.items(
                cellIdentifier: String(describing: IssueListViewCell.self),
                cellType: IssueListViewCell.self)) { _, issue, cell in
                cell.configure(entity: issue)
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Issue.self)
            .subscribe(onNext: { [weak self] issue in
                self?.navigationController?.pushViewController(IssueDetailViewController(number: issue.number), animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}
