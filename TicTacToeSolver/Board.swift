//
//  Board.swift
//  TicTacToeSolver
//
//  Created by Daniel Seitz on 8/13/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

class Board {
  enum Transformation {
    case Rotate90, Rotate180, Rotate270, FlipHorizontal, FlipVertical, ForwardDiagonal, BackwardDiagonal
    
    static let allValues = [Rotate90, Rotate180, Rotate270, FlipHorizontal, FlipVertical, ForwardDiagonal, BackwardDiagonal]
  }
  
  var board: [[Int]]
  
  var count: Int {
    return board.count
  }
  
  init(n: Int) {
    self.board = [[Int]](count: n, repeatedValue: [Int](count: n, repeatedValue: 0))
  }
  
  init(matrix: [[Int]]) {
    self.board = matrix
  }
  
  init(copy: Board) {
    self.board = copy.board
  }
  
  subscript(index: Int) -> [Int] {
    get {
      return self.board[index]
    }
    set {
      self.board[index] = newValue
    }
  }
  
  func transformed(transformation: Transformation) -> Board {
    let transformed = Board(copy: self)
    let n = board.count
    var temp = [[Int]](count: n, repeatedValue: [Int](count: n, repeatedValue: 0))
    switch transformation {
    case .Rotate90:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[(n-1)-col][row]
        }
      }
      break
    case .Rotate180:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[(n-1)-row][(n-1)-col]
        }
      }
      break
    case .Rotate270:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[col][(n-1)-row]
        }
      }
      break
    case .FlipVertical:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[(n-1)-row][col]
        }
      }
      break
    case .FlipHorizontal:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[row][(n-1)-col]
        }
      }
      break
    case .BackwardDiagonal:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[col][row]
        }
      }
      break
    case .ForwardDiagonal:
      for row in 0..<n {
        for col in 0..<n {
          temp[row][col] = board[(n-1)-col][(n-1)-row]
        }
      }
      break
    }
    transformed.board = temp
    return transformed
  }
}

extension Board: CustomStringConvertible {
  var description: String {
    var printableBoard = [[String]](count: board.count, repeatedValue:[String](count: board.count, repeatedValue: " "))
    for row in 0..<board.count {
      for col in 0..<board.count {
        if board[row][col] == 1 {
          printableBoard[row][col] = "X"
        }
        else if board[row][col] == -1 {
          printableBoard[row][col] = "Y"
        }
      }
    }
    var rows: [String] = [String](count: board.count, repeatedValue:"")
    for row in 0..<board.count {
      rows[row] = printableBoard[row].joinWithSeparator("|")
    }
    let count = 2*board.count-1
    let string = rows.joinWithSeparator("\n" + String(count: count, repeatedValue: ("_" as Character)) + "\n")
    return string
  }
}