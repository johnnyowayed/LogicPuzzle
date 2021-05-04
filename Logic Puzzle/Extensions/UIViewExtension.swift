//
//  UIViewExtension.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 10/23/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import Foundation
import UIKit

final class OnTapListner: UITapGestureRecognizer {
    private var action: () -> Void

    init(_ action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}

extension UIView {
    func setOnTapListner(_ action: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let click = OnTapListner(action)
        self.addGestureRecognizer(click)
    }
}
