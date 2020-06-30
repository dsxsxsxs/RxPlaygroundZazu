//
//  IssueListViewCell.swift
//  GitHubIssueBrowser
//
//  Created by dsxs on 2019/01/06.
//  Copyright © 2019 dsxs. All rights reserved.
//

import UIKit

class IssueListViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!

    func configure(viewData: IssueListViewModel.ViewData) {
        titleLabel.text = viewData.title
        updatedAtLabel.text = dateToString(viewData.updatedAt)
        nameLabel.text = viewData.name
        avatarImageView.image(from: viewData.avatarURL)
    }

    private func dateToString(_ date: Date) -> String {
        DateFormatterHolder.dateFormatter.string(from: date)
    }
}

private struct DateFormatterHolder {
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()
}


