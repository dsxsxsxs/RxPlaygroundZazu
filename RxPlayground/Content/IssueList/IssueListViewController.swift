//
//  IssueListViewController.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/16.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import UIKit

final class IssueListViewController: UITableViewController {
    var issues: [Issue] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: IssueListViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IssueListViewCell.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        API().connect(config: IssueListRequest()) {
            switch $0 {
            case .success(let issues):
                DispatchQueue.main.async {
                    self.issues = issues
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IssueListViewCell.self), for: indexPath) as! IssueListViewCell
        cell.configure(entity: issues[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = issues[indexPath.row]
        self.navigationController?.pushViewController(IssueDetailViewController(issueNumber: selected.number), animated: true)
    }
}
