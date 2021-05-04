//
//  Enums.swift
//  Logic Puzzle
//
//  Created by Johnny Owayed on 10/14/20.
//  Copyright © 2020 Johnny Owayed. All rights reserved.
//

import UIKit

enum Answer:Int {
    case Correct = 1
    case Wrong = 0
    case Empty = -1
    case AutomaticWrong = 2
}

enum GridSize: Int {
    case grid4x4 = 4
    case grid5x5 = 5
    case grid6x6 = 6
    case grid7x7 = 7
    case grid8x8 = 8
}
enum EquationVariables:String {
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
}

enum GridLetterToValue:Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case G = 6
    case H = 7
}

enum EquationType {
    case Equal
    case NotEqual
    case Greater
    case Less
    case GreaterOrEqual
    case LessOrEqual
}
