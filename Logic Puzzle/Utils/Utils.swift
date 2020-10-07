//
//  Utils.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 8/7/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

enum Answer:Int {
    case Correct = 1
    case Wrong = 0
    case Empty = -1
}

class Utils {
    
    final class func isAllWrongExceptOne(_ indexpath:IndexPath, puzzleModel:PuzzleModel) -> Bool{
        let row = fetchRowAt(indexpath.section, puzzleModel: puzzleModel)
        let column = fetchColumnAt(indexpath.row, puzzleModel: puzzleModel)
        var array_numberRows = [Int]()
        var array_numberColumns = [Int]()
        
        for item in row {
            if item == Answer.Wrong.rawValue {
                array_numberRows.append(item)
            }
        }
        
        for item in column {
            if item == Answer.Wrong.rawValue {
                array_numberColumns.append(item)
            }
        }
        
        if (array_numberRows.count == row.count-1 || array_numberColumns.count == column.count-1) && (!row.contains(Answer.Correct.rawValue) || !column.contains(Answer.Correct.rawValue)) {
            return true
        }else {
            return false
        }
    }
    
    final class func fetchRowAt(_ index:Int, puzzleModel:PuzzleModel) -> [Int] {
        var row = [Int]()
        for i in 0...puzzleModel.gridSize-1 {
            row.append(puzzleModel.puzzleProgress[i][index])
        }
        return row
    }
    
    final class func fetchColumnAt(_ index:Int, puzzleModel:PuzzleModel) -> [Int] {
        var column = [Int]()
        for i in 0...puzzleModel.gridSize-1 {
            column.append(puzzleModel.puzzleProgress[index][i])
        }
        return column
    }
    
    final class func indicesOf(_ x: Int, puzzleModel:PuzzleModel) -> [IndexPath] {
        var array_Indices = [IndexPath]()
        let array:[[Int]] = puzzleModel.puzzleProgress
        for i in 0 ... puzzleModel.gridSize - 1{
            for j in 0...array[i].count - 1 {
                if array[i][j] == x {
                    array_Indices.append(IndexPath.init(row: i, section: j))
                }
            }
        }
        return array_Indices
    }
    
    final class func exIndicesRemain(correctIndices:[IndexPath], removedIndex:IndexPath) -> [IndexPath] {
        var array_Xs = [IndexPath]()
        var index1 = IndexPath()
        var index2 = IndexPath()
        for correctIndex in correctIndices {
            index1 = IndexPath.init(row: correctIndex.row, section: removedIndex.section)
            index2 = IndexPath.init(row: removedIndex.row, section: correctIndex.section)
            
            array_Xs.append(index1)
            array_Xs.append(index2)
        }
        
        return array_Xs
    }
    
    final class func exIndicesToBeRemoved(wrongIndices:[IndexPath], correctIndices:[IndexPath], removedIndex:IndexPath) -> [IndexPath] {
        
        var array_Xs:[IndexPath] = wrongIndices
        var sections = Set<Int>()
        var rows = Set<Int>()
        
        if !correctIndices.isEmpty {
            for correctIndex in correctIndices {
                rows.insert(correctIndex.row)
                sections.insert(correctIndex.section)
            }
            for i in 0...wrongIndices.count-1 {
                for row in rows {
                    if wrongIndices[i].row == row {
                        if let index = array_Xs.firstIndex(of: wrongIndices[i]) {
                            array_Xs.remove(at: index)
                        }
                    }
                }
                for section in sections {
                    if wrongIndices[i].section == section {
                        if let index = array_Xs.firstIndex(of: wrongIndices[i]) {
                            array_Xs.remove(at: index)
                        }
                    }
                }
            }
        } else {
            array_Xs = [IndexPath]()
        }
        return array_Xs
    }
    
    final class func createDummyData() -> PuzzleModel {
        let puzzleModel = PuzzleModel()
        
        puzzleModel.equations = ["2C = B", "B + D > 4C", "4C = D"]
        puzzleModel.correctAnswerIndices = [["row":0,"section":2], ["row":1,"section":1], ["row":2,"section":0], ["row":3,"section":3]]
        puzzleModel.gridSize = 4
        
        return puzzleModel
    }
    
    final class func fromDictionaryToArrayOfIntegers(puzzleModel:PuzzleModel) -> [[Int]]{
        var indices = [IndexPath]()
        
        for answerIndex in puzzleModel.correctAnswerIndices {
            indices.append(IndexPath.init(row: answerIndex["row"] ?? 0, section: answerIndex["section"] ?? 0))
        }
        
        var array:[[Int]] = [[Int]]()
        for _ in 0..<puzzleModel.gridSize {
            var array_NumberofRows = [Int]()
            for _ in 0...puzzleModel.gridSize-1 {
                array_NumberofRows.append(Answer.Wrong.rawValue)
            }
            array.append(array_NumberofRows)
        }
        
        for index in indices {
            array[index.row][index.section] = Answer.Correct.rawValue
        }
        
        return array
    }
}
