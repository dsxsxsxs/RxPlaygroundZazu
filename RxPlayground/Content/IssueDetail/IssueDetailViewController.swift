//
//  IssueDetailViewController.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/16.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift
import RxRelay

final class IssueDetailViewController: UIViewController {
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()

    @IBOutlet private weak var issueTitleLabel: UILabel!
    @IBOutlet private weak var updatedAtLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    @IBOutlet private weak var urlButton: UIButton!

    @IBOutlet private weak var bodyTextView: UITextView!
    @IBOutlet private weak var hudView: UIView!

    private let issueNumber: Int
    private let disposeBag = DisposeBag()
    private let viewModel: IssueDetailViewModel

    init(number: Int) {
        issueNumber = number
        viewModel = .init(number: number)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.viewDidLoad()
    }

    private func setupBindings() {
        viewModel.issue
            .drive(onNext: { [weak self] in
                self?.configureUI(entity: $0)
            })
            .disposed(by: disposeBag)

        viewModel.error
            .emit(onNext: {[weak self] _ in
                let alert = UIAlertController(title: "An error occured", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
                }))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self?.viewModel.didRequestForRetry()
                }))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        urlButton.rx.tap
            .withLatestFrom(Observable.just(self)) { $1.urlLabel.text }
            .compactMap { $0.flatMap(URL.init) }
            .subscribe(onNext: {[weak self] in
                self?.navigationController?.pushViewController(SFSafariViewController(url: $0), animated: true)
            })
            .disposed(by: disposeBag)
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
