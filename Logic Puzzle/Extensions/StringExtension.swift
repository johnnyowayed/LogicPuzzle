//
//  StringExtensions.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 7/31/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

extension String {
    func numbersToLetters() -> String {
        var str:String = self
        let map = ["1": "A",
                   "2": "B",
                   "3": "C",
                   "4": "D",
                   "5": "E",
                   "6": "F",
                   "7": "G",
                   "8": "H",
                   "9": "I"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    var expression: NSExpression {
        return NSExpression(format: self)
    }
}
