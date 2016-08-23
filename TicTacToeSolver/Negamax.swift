//
//  Negamax.swift
//  TicTacToeSolver
//
//  Created by Daniel Seitz on 8/8/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

func negamax(onmove: Int, board: Board) -> Int {
  let n = board.count
  var value = gamevalue(onmove, board: board)
  if value != -2 {
    return value
  }
  value = -1
  for row in 0..<n {
    for col in 0..<n {
      if board[row][col] == 0 {
        board[row][col] = onmove
        let v0 = -negamax(-onmove, board: board)
        if v0 > value {
          value = v0
        }
        board[row][col] = 0
      }
    }
  }
  return value
}

func negamax_symmetry(onmove: Int, board: Board, zobrist: Zobrist) -> Int {
  let n = board.count
  if let calculated = zobrist.checkSymmetry(board) {
    return calculated
  }
  var value = gamevalue(onmove, board: board)
  if value != -2 {
    return value
  }
  for row in 0..<n {
    for col in 0..<n {
      if board[row][col] == 0 {
        board[row][col] = onmove
        let v0 = -negamax_symmetry(-onmove, board: board, zobrist: zobrist)
        if v0 > value {
          value = v0
        }
        board[row][col] = 0
      }
    }
  }
  zobrist.store(value: value, for: board)
  return value
}

func negamax_alpha_beta(onmove: Int, board: Board, alpha: Int, beta: Int) -> Int {
  let n = board.count
  var value = gamevalue(onmove, board: board)
  if value != -2 {
    return value
  }
  var alpha = alpha
  for row in 0..<n {
    for col in 0..<n {
      if board[row][col] == 0 {
        board[row][col] = onmove
        let v0 = -negamax_alpha_beta(-onmove, board: board, alpha: -beta, beta: -alpha)
        if v0 > value {
          value = v0
        }
        if v0 > alpha {
          alpha = v0
        }
        board[row][col] = 0
        if alpha >= beta {
          return alpha
        }
      }
    }
  }
  return value
}

func negamax_both(onmove: Int, board: Board, alpha: Int, beta: Int, zobrist: Zobrist) -> Int {
  let n = board.count
  if let calculated = zobrist.checkSymmetry(board) {
    return calculated
  }
  var value = gamevalue(onmove, board: board)
  if value != -2 {
    zobrist.store(value: value, for: board)
    return value
  }
  var alpha = alpha
  for row in 0..<n {
    for col in 0..<n {
      if board[row][col] == 0 {
        board[row][col] = onmove
        let v0 = -negamax_both(-onmove, board: board, alpha: -beta, beta: -alpha, zobrist: zobrist)
        if v0 > value {
          value = v0
        }
        if v0 > alpha {
          alpha = v0
        }
        if alpha >= beta {
          zobrist.store(value: alpha, for: board)
          board[row][col] = 0
          return alpha
        }
        board[row][col] = 0
      }
    }
  }
  zobrist.store(value: value, for: board)
  return value
}
