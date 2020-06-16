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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func configureUI(entity: Issue) {
        hudView.isHidden = true
        issueTitleLabel.text = entity.title
        updatedAtLabel.text = Self.dateFormatter.string(from: entity.updatedAt)
        urlLabel.text = entity.url.absoluteString
        bodyTextView.text = entity.body
    }

    @IBAction private func didTapURLButton(sender: UIButton) {
    }
}
