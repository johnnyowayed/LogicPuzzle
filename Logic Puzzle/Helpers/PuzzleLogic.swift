//
//  PuzzleLogic.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 8/7/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

class PuzzleLogic {
    
    final class func isAllWrongExceptOne(_ indexpath:IndexPath, puzzleModel:PuzzleModel) -> Bool{
        let row = fetchRowAt(indexpath.section, puzzleModel: puzzleModel)
        let column = fetchColumnAt(indexpath.row, puzzleModel: puzzleModel)
        var array_numberRows = [Int]()
        var array_numberColumns = [Int]()
        
        for item in row {
            if item == Answer.Wrong.rawValue || item == Answer.AutomaticWrong.rawValue{
                array_numberRows.append(item)
            }
        }
        
        for item in column {
            if item == Answer.Wrong.rawValue || item == Answer.AutomaticWrong.rawValue {
                array_numberColumns.append(item)
            }
        }
        
        if (array_numberRows.count == row.count-1 || array_numberColumns.count == column.count-1) && (!row.contains(Answer.Correct.rawValue) || !column.contains(Answer.Correct.rawValue)) {
            return true
        } else {
            return false
        }
    }
    
    final class func fetchRowAt(_ index:Int, puzzleModel:PuzzleModel) -> [Int] {
        var row = [Int]()
        let gridSize = fetchGridSize(puzzleModel: puzzleModel)
        for i in 0...gridSize-1 {
            row.append(puzzleModel.puzzleProgress[i][index])
        }
        return row
    }
    
    final class func fetchColumnAt(_ index:Int, puzzleModel:PuzzleModel) -> [Int] {
        var column = [Int]()
        let gridSize = fetchGridSize(puzzleModel: puzzleModel)
        for i in 0...gridSize-1 {
            column.append(puzzleModel.puzzleProgress[index][i])
        }
        return column
    }
    
    final class func indicesOf(_ x: Int, puzzleModel:PuzzleModel) -> [IndexPath] {
        var array_Indices = [IndexPath]()
        let array:[[Int]] = puzzleModel.puzzleProgress
        let gridSize = fetchGridSize(puzzleModel: puzzleModel)
        for i in 0...gridSize-1 {
            for j in 0...array[i].count - 1 {
                if array[i][j] == x {
                    array_Indices.append(IndexPath.init(row: i, section: j))
                }
            }
        }
        return array_Indices
    }
    
    final class func clearPuzzleProgress(puzzleModel:PuzzleModel) -> [[Int]]{
        var progress = puzzleModel.puzzleProgress ?? [[Int]]()
        
        for i in 0...progress.count-1 {
            for j in 0...progress.count-1 {
                progress[i][j] = -1
            }
        }
        return progress
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
    
    final class func exIndicesToBeRemoved(wrongIndices:[IndexPath], automaticWrongIndices:[IndexPath], correctIndices:[IndexPath], emptyIndices:[IndexPath], removedIndex:IndexPath) -> [IndexPath] {
        
        var array_Xs:[IndexPath] = automaticWrongIndices
        var sections = Set<Int>()
        var rows = Set<Int>()
        
        if (!correctIndices.isEmpty || !automaticWrongIndices.isEmpty) && !emptyIndices.isEmpty{
            for correctIndex in correctIndices {
                rows.insert(correctIndex.row)
                sections.insert(correctIndex.section)
            }
            for i in 0...automaticWrongIndices.count-1 {
                for row in rows {
                    if automaticWrongIndices[i].row == row {
                        
                        if let index = array_Xs.firstIndex(of: automaticWrongIndices[i]) {
                            array_Xs.remove(at: index)
                        }
                    }
                }
                for section in sections {
                    if automaticWrongIndices[i].section == section {
                        if let index = array_Xs.firstIndex(of: automaticWrongIndices[i]) {
                            array_Xs.remove(at: index)
                        }
                    }
                }
            }
        }else {
            array_Xs = [IndexPath]()
        }
        
        let filteredArray = array_Xs.filter {
            $0.row == removedIndex.row || $0.section == removedIndex.section
        }
        
        return filteredArray
    }
    
    final class func createDummyData() -> PuzzleModel {
        let puzzleModel = PuzzleModel()
//        puzzleModel.equations = ["B*C < 4", "C*D > 9"]
        puzzleModel.equations = ["C + G + H = 17","C + G = 14","A + E + G = 13", "C + F = 11", "C + D + E = 9"]
        
        return puzzleModel
    }
    
    final class func calculateGridDimentions(gridSize:GridSize) -> Int{
        var gridDimentions:Int = 0
        
        let screenWidth = UIScreen.main.bounds.width
        print("Screen Width = \(screenWidth)")
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
            switch gridSize.rawValue {
                case 4:
                    gridDimentions = Int(screenWidth)/(gridSize.rawValue+1)
                case 5:
                    gridDimentions = Int(screenWidth)/(gridSize.rawValue+1)
                case 6:
                    gridDimentions = Int(screenWidth)/(gridSize.rawValue+1)
                case 7:
                    gridDimentions = Int(screenWidth)/(gridSize.rawValue+1)
                case 8:
                    gridDimentions = Int(screenWidth)/(gridSize.rawValue+1)
                default:
                    break
            }
            case .pad:
                switch gridSize.rawValue {
                    case 4:
                        gridDimentions = Int(screenWidth)/(2*(gridSize.rawValue+1))
                    case 5:
                        gridDimentions = Int(screenWidth)/(2*(gridSize.rawValue+1))
                    case 6:
                        gridDimentions = Int(screenWidth)/(2*(gridSize.rawValue+1))
                    case 7:
                        gridDimentions = Int(screenWidth)/(2*(gridSize.rawValue+1))
                    case 8:
                        gridDimentions = Int(screenWidth)/(2*(gridSize.rawValue+1))
                    default:
                        break
                }
                
            default:
                break
        }
        return gridDimentions
    }
    
    final class func fetchPuzzleTitle(gridSize:GridSize) -> String {
        var title:String = ""
        switch gridSize.rawValue {
            case 4:
                title = "4x4"
            case 5:
                title = "5x5"
            case 6:
                title = "6x6"
            case 7:
                title = "7x7"
            case 8:
                title = "8x8"
            default:
                break
        }
        return title
    }
    
    private final class func initEmptyDictionary(gridSize:Int) -> [String:Int]{
        var dictionary = [String:Int]()
        switch gridSize {
            case GridSize.grid4x4.rawValue:
                dictionary = ["A":-100,"B":-100,"C":-100,"D":-100]
            case GridSize.grid5x5.rawValue:
                dictionary = ["A":-100,"B":-100,"C":-100,"D":-100,"E":-100]
            case GridSize.grid6x6.rawValue:
                dictionary = ["A":-100,"B":-100,"C":-100,"D":-100,"E":-100,"F":-100]
            case GridSize.grid7x7.rawValue:
                dictionary = ["A":-100,"B":-100,"C":-100,"D":-100,"E":-100,"F":-100,"G":-100]
            case GridSize.grid8x8.rawValue:
                dictionary = ["A":-100,"B":-100,"C":-100,"D":-100,"E":-100,"F":-100,"G":-100,"H":-100]
            default:
                break
        }
        return dictionary
    }
    
    final class func fromCorrectIndicesToEquationVariables(correctIndices:[IndexPath],puzzleModel:PuzzleModel) -> [String:Int] {
        let gridSize = fetchGridSize(puzzleModel: puzzleModel)
        var variableValues = PuzzleLogic.initEmptyDictionary(gridSize: gridSize)
        for correctIndex in correctIndices {
            var letter = EquationVariables.A
            var value = 0
            switch correctIndex.section {
                case 0:
                    letter = EquationVariables.A
                case 1:
                    letter = EquationVariables.B
                case 2:
                    letter = EquationVariables.C
                case 3:
                    letter = EquationVariables.D
                case 4:
                    letter = EquationVariables.E
                case 5:
                    letter = EquationVariables.F
                case 6:
                    letter = EquationVariables.G
                case 7:
                    letter = EquationVariables.H
                default:
                    break
            }
            
            switch correctIndex.row {
                case 0:
                    value = 1
                case 1:
                    value = 2
                case 2:
                    value = 3
                case 3:
                    value = 4
                case 4:
                    value = 5
                case 5:
                    value = 6
                case 6:
                    value = 7
                case 7:
                    value = 8
                    
                default:
                    break
            }
            
            variableValues.updateValue(value, forKey: letter.rawValue)
        }
        
        return variableValues
    }
    
    final class func detectEquationType(equation:String) -> EquationType{
        var equation = equation
        
        if equation.contains("≥") {
            equation = equation.replacingOccurrences(of: "≥", with: ">=", options: .literal, range: nil)
        }else if equation.contains("≤") {
            equation = equation.replacingOccurrences(of: "≤", with: "<=", options: .literal, range: nil)
        }else if equation.contains("≠") {
            equation = equation.replacingOccurrences(of: "≠", with: "!=", options: .literal, range: nil)
        }
        
        var equationType = EquationType.Equal
        if equation.contains("!="){
            equationType = EquationType.NotEqual
        }else if equation.contains(">="){
            equationType = EquationType.GreaterOrEqual
        }else if equation.contains("<="){
            equationType = EquationType.LessOrEqual
        }else if equation.contains("=") {
            equationType = EquationType.Equal
        }else if equation.contains(">"){
            equationType = EquationType.Greater
        }else if equation.contains("<"){
            equationType = EquationType.Less
        }
        return equationType
    }
    
    //Return equation and its index
    final class func resturnSatisfiedEquationIndex(equations:[String], dictionary:[String:Int]) -> [Int]{
        var array_Indices:[Int] = [Int]()
        
        for i in 0...equations.count-1 {
            let equationType = PuzzleLogic.detectEquationType(equation: equations[i])
            var splitEquation = [String.SubSequence]()
            var result1 = 0
            var result2 = 0
            
            switch equationType {
                case EquationType.Equal:
                    splitEquation = equations[i].split(separator: "=")
                    let array_Results = self.calculateResultsOfEquations(splitEquation: splitEquation, dictionary: dictionary)
                    result1 = array_Results.0
                    result2 = array_Results.1
                    
                    if result1 == result2 && (result1 > 0 && result2 > 0){
                        array_Indices.append(i)
                    }
                case EquationType.NotEqual:
                    splitEquation = equations[i].split(separator: "≠")
                    let array_Results = self.calculateResultsOfEquations(splitEquation: splitEquation, dictionary: dictionary)
                    result1 = array_Results.0
                    result2 = array_Results.1
                    
                    if result1 != result2 && (result1 > 0 && result2 > 0){
                        array_Indices.append(i)
                    }
                case EquationType.Greater:
                    splitEquation = equations[i].split(separator: ">")
                    let array_Results = self.calculateResultsOfEquations(splitEquation: splitEquation, dictionary: dictionary)
                    result1 = array_Results.0
                    result2 = array_Results.1
                    
                    if result1 > result2 && (result1 > 0 && result2 > 0){
                        array_Indices.append(i)
                    }
                case EquationType.Less:
                    splitEquation = equations[i].split(separator: "<")
                    let array_Results = self.calculateResultsOfEquations(splitEquation: splitEquation, dictionary: dictionary)
                    result1 = array_Results.0
                    result2 = array_Results.1
                    
                    if result1 < result2 && (result1 > 0 && result2 > 0){
                        array_Indices.append(i)
                    }
                case EquationType.GreaterOrEqual:
                    splitEquation = equations[i].split(separator: "≥")
                    let array_Results = self.calculateResultsOfEquations(splitEquation: splitEquation, dictionary: dictionary)
                    result1 = array_Results.0
                    result2 = array_Results.1
                    
                    if result1 >= result2 && (result1 > 0 && result2 > 0){
                        array_Indices.append(i)
                    }
                case .LessOrEqual:
                    splitEquation = equations[i].split(separator: "≤")
                    let array_Results = self.calculateResultsOfEquations(splitEquation: splitEquation, dictionary: dictionary)
                    result1 = array_Results.0
                    result2 = array_Results.1
                    if result1 <= result2 && (result1 > 0 && result2 > 0){
                        array_Indices.append(i)
                    }
            }
        }
        return array_Indices
    }
    
    final class func calculateResultsOfEquations(splitEquation:[String.SubSequence], dictionary:[String:Int]) -> (Int,Int){
        let eq1:String = String(splitEquation[0])
        let eq2:String = String(splitEquation[1])

        var result1 = eq1.expression.expressionValue(with: dictionary, context: nil) as? Int ?? 0
        var result2 = eq2.expression.expressionValue(with: dictionary, context: nil) as? Int ?? 0
        
        if result1>50 { result1 = 0}
        if result2>50 { result2 = 0}
        
        return (result1,result2)
    }
    
    final class func checkIfWinner(satisfiedEquationsCount:Int, puzzleModel:PuzzleModel) -> Bool{
        var isWinner = false
        
        if satisfiedEquationsCount == puzzleModel.equations.count {
            isWinner = true
        }
        
        return isWinner
    }
    
    final class func fetchGridSize(puzzleModel:PuzzleModel) -> Int{
        var gridSize = 0
        for equation in puzzleModel.equations {
            var newGridSize = 0
            if equation.contains("H"){
                newGridSize = 8
            }else if equation.contains("G"){
                newGridSize = 7
            }else if equation.contains("F"){
                newGridSize = 6
            }else if equation.contains("E"){
                newGridSize = 5
            }else if equation.contains("D"){
                newGridSize = 4
            }
            if newGridSize > gridSize {
                gridSize = newGridSize
            }
        }
        return gridSize
    }
}
