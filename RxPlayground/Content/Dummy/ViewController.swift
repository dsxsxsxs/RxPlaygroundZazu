//
//  ViewController.swift
//  RxPlayground
//
//  Created by Jiacheng Shih on 2020/06/13.
//  Copyright © 2020 me.dsxsxsxs.rx.playground. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet private var inputTextField: UITextField!
    @IBOutlet private var resultLabel: UILabel!
    @IBOutlet private var oddEvenLabel: UILabel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        inputTextField.rx.text
            .map { $0 ?? "" }
            .map(Int.init)
            .map { $0.map { "\($0 + 10)" } }
//            .map { $0.flatMap(Int.init).map { "\($0 + 10)" } ?? "NaN" }
//            .map { $0.flatMap(Int.init) }
//            .map { $0.map { "\($0 + 10)" } }
            .map { $0 ?? "NaN" }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)

        inputTextField.rx.text
            .map { $0.flatMap(Int.init).map { $0 % 2 == 0 ? "odd" : "Even" } ?? "NaN" }
            .bind(to: oddEvenLabel.rx.text)
            .disposed(by: disposeBag)
    }

    @IBAction private func didChangeValueOfInputTextField(sender: UITextField) {
//        if let text = sender.text, let integer = Int(text) {
//            resultLabel.text = "\(integer + 10)"
//            oddEvenLabel.text =  integer % 2 == 0 ?  "even" : "odd"
//        } else {
//            resultLabel.text = "NaN"
//            oddEvenLabel.text = "NaN"
//        }
    }
}

