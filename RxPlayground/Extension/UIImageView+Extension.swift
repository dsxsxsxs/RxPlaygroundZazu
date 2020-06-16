//
//  UIImageView+Extension.swift
//  GitHubIssueBrowser
//
//  Created by dsxs on 2019/01/07.
//  Copyright © 2019 dsxs. All rights reserved.
//

import UIKit

private struct TaskHolder {
    static var map: [Int: URLSessionTask] = [:]
}

extension UIImageView {
    @discardableResult
    func addIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        indicator.addConstraints([
            NSLayoutConstraint(item: indicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: indicator, attribute: .height, relatedBy: .equal, toItem: indicator, attribute: .width, multiplier: 1, constant: 0)
        ])
        indicator.startAnimating()
        return indicator
    }

    func removeAllIndicators() {
        for view in subviews where view is UIActivityIndicatorView {
            view.removeFromSuperview()
        }
    }

    func image(from url: String, completion: @escaping (Result<UIImage?, Error>) -> Void = { _ in }) {
        guard let u = URL(string: url) else {
            return
        }
        image = UIImage()
        let indicator = addIndicator()
        let hash = self.hashValue
        TaskHolder.map[hash]?.cancel()
        TaskHolder.map[hash] = nil
        let task = URLSession.shared.dataTask(with: u) { data, _, err in
            DispatchQueue.main.async {
                if let e = err {
                    completion(.failure(e))
                } else if let d = data {
                    let img = UIImage(data: d)
                    self.image = img
                    completion(.success(img))
                }
                if let _ = indicator.superview {
                    indicator.removeFromSuperview()
                }
            }
            TaskHolder.map[hash] = nil
        }
        TaskHolder.map[hash] = task
        task.resume()
    }
}
