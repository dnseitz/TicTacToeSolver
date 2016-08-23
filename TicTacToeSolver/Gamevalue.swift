//
//  Gamevalue.swift
//  TicTacToeSolver
//
//  Created by Daniel Seitz on 8/8/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

func gamevalue(onmove: Int, board: Board) -> Int {
  let n = board.board.count
  var value: Int
  var side = -1
  for _ in 0..<2 {
    side = -side
    value = side * onmove
    /* scan for diagonal */
    var filled = 0
    for d in 0..<n {
      if board[d][d] == side {
        filled += 1
      }
    }
    if filled == n {
      return value
    }
    /* scan for opposite diagonal */
    filled = 0
    for d in 0..<n {
      if board[d][(n-1)-d] == side {
        filled += 1
      }
    }
    if filled == n {
      return value
    }
    /* scan for rows */
    for row in 0..<n {
      filled = 0
      for col in 0..<n {
        if board[row][col] == side {
          filled += 1
        }
      }
      if filled == n {
        return value
      }
    }
    /* scan for columns */
    for col in 0..<n {
      filled = 0
      for row in 0..<n {
        if board[row][col] == side {
          filled += 1
        }
      }
      if filled == n {
        return value
      }
    }
  }
  /* scan for blanks */
  for row in 0..<n {
    for col in 0..<n {
      if board[row][col] == 0 {
        /* game not over */
        return -2
      }
    }
  }
  /* game is a draw */
  return 0
}