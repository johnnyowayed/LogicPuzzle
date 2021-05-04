//
//  ArrayExtensions.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 8/3/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
