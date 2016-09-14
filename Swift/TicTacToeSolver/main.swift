//
//  main.swift
//  TicTacToeSolver
//
//  Created by Daniel Seitz on 8/8/16.
//  Copyright © 2016 Daniel Seitz. All rights reserved.
//

import Foundation

let n = 4
let matrix3x3 = [[1, 0, -1],
              [0, 1, 0],
              [0, 0, -1]]
let matrix4x4 = [[0, 0, 0, -1],
              [0, 1, -1, 0],
              [0, 0, 0, 0],
              [1, 0, 0, 0]]
//let board = Board(n: n)
let board = Board(matrix: matrix4x4)

let reps = 10
var sumDraws = 0
let zobrist = Zobrist(n: n)
var start: NSDate
var total: NSTimeInterval
var elapsed: Double = 0.0
var times = [NSTimeInterval]()

for i in 0..<reps {
  start = NSDate()
  sumDraws += negamax(1, board: board)
  total = -start.timeIntervalSinceNow
  times.append(total)
  zobrist.flush()
}
elapsed = times.reduce(0, combine: +) / Double(reps)
print(sumDraws)
print("Average time no optimization: \(elapsed)")
times.removeAll()
sumDraws = 0

for i in 0..<reps {
  start = NSDate()
  sumDraws += negamax_symmetry(1, board: board, zobrist: zobrist)
  total = -start.timeIntervalSinceNow
  times.append(total)
  zobrist.flush()
}
elapsed = times.reduce(0, combine: +) / Double(reps)
print(sumDraws)
print("Average time symmetry: \(elapsed)")
times.removeAll()
sumDraws = 0

for i in 0..<reps {
  start = NSDate()
  sumDraws += negamax_alpha_beta(1, board: board, alpha: -2, beta: 2)
  total = -start.timeIntervalSinceNow
  times.append(total)
  zobrist.flush()
}
elapsed = times.reduce(0, combine: +) / Double(reps)
print(sumDraws)
print("Average time alpha-beta: \(elapsed)")
times.removeAll()
sumDraws = 0

for i in 0..<reps {
  start = NSDate()
  sumDraws += negamax_both(1, board: board, alpha: -2, beta: 2, zobrist: zobrist)
  total = -start.timeIntervalSinceNow
  times.append(total)
  zobrist.flush()
}
elapsed = times.reduce(0, combine: +) / Double(reps)
print(sumDraws)
print("Average time both optimizations: \(elapsed)")
times.removeAll()
sumDraws = 0