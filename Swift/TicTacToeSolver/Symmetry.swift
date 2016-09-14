//
//  Symmetry.swift
//  TicTacToeSolver
//
//  Created by Daniel Seitz on 8/13/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

class Zobrist {
  enum Space: Int {
    case Y = -1, Empty, X
    
    func toIndex() -> Int {
      switch self {
      case .Empty:
        return 0
      case .X:
        return 1
      case .Y:
        return 2
      }
    }
  }
  var table: [[UInt32]]
  var calculated: [UInt32:Int] = [UInt32:Int]()
  init(n: Int) {
    self.table = [[UInt32]](count: n*n, repeatedValue: [UInt32](count: 3, repeatedValue: 0))
    for i in 0..<(n*n) {
      for j in 0..<3 {
        self.table[i][j] = arc4random()
      }
    }
  }
  
  func store(value value: Int, for board: Board) {
    let hash = self.hash(board)
    calculated[hash] = value
  }
  
  func checkSymmetry(board: Board) -> Int? {
    var hash = self.hash(board)
    if let storedValue = calculated[hash] {
      return storedValue
    }
    for transformation in Board.Transformation.allValues {
      let transformed = board.transformed(transformation)
      hash = self.hash(transformed)
      if let storedValue = calculated[hash] {
        return storedValue
      }
    }
    return nil
  }
  
  func hash(board: Board) -> UInt32 {
    var hash: UInt32 = 0
    let board = Array(board.board.flatten())
    for i in 0..<board.count {
      let space = Space(rawValue: board[i])!
      let j = space.toIndex()
      hash = hash ^ table[i][j]
    }
    return hash
  }
  
  func flush() {
    calculated.removeAll()
  }
}