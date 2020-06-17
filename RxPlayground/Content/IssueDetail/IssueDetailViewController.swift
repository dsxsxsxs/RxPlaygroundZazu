//
//  IssueDetailViewController.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/16.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import UIKit
import SafariServices

final class IssueDetailViewController: UIViewController {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()

    @IBOutlet private weak var issueTitleLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var bodyTextView: UITextView!
    @IBOutlet private weak var hudView: UIView!

    private let issueNumber: Int

    init(issueNumber: Int) {
        self.issueNumber = issueNumber
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchIssueDetail()
    }

    private func fetchIssueDetail() {
        hudView.isHidden = false
        API().connect(config: IssueDetailRequest(number: issueNumber)) {
            switch $0 {
            case .success(let issue):
                DispatchQueue.main.async {
                    self.configureUI(entity: issue)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func configureUI(entity: Issue) {
        hudView.isHidden = true
        issueTitleLabel.text = entity.title
        updatedAtLabel.text = Self.dateFormatter.string(from: entity.updatedAt)
        urlLabel.text = entity.url.absoluteString
        bodyTextView.text = entity.body
    }

    @IBAction private func didTapURLButton(sender: UIButton) {
        guard let url = urlLabel.text.flatMap(URL.init) else { return }
        self.navigationController?.pushViewController(SFSafariViewController(url: url), animated: true)
    }
}
