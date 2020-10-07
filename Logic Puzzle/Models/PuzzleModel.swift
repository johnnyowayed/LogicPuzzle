//
//  PuzzleModel.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 8/3/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import Foundation

class PuzzleModel {
    
    var gridSize:Int! = 0
    var puzzleProgress:[[Int]]! = [[Int]]()
    var correctAnswer:[[Int]] = [[Int]]()
    var equations:[String]! = [String]()
    var correctAnswerIndices:[[String:Int]] = [[String:Int]]()
    
    convenience init(data:[String:Any]) {
        self.init()
        
        if let gridSize = data["gridSize"] as? Int {
            self.gridSize = gridSize
        }
        
        if let correctAnswerIndices = data["correctAnswerIndices"] as? [[String:Int]] {
            self.correctAnswerIndices = correctAnswerIndices
        }
        
        self.correctAnswer = Utils.fromDictionaryToArrayOfIntegers(puzzleModel: self)
        
        if let equations = data["equations"] as? [String] {
            self.equations = equations
        }
        
        
    }
}
