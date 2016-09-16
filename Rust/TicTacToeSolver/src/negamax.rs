use board::Board;
use zobrist::Zobrist;

pub fn negamax(onmove: i32, board: &mut Board) -> i32 {
  let n = board.n as usize;
  let mut value = board.gamevalue(onmove);
  if value == -2 {
    value = -1;
    for row in 0..n {
      for col in 0..n {
        board.try_move(onmove, row, col, |b| {
            let v0 = -negamax(-onmove, b);
            if v0 > value {
              value = v0;
            }
          });
      }
    }
  }
  value
}

pub fn negamax_symmetry(onmove: i32, board: &mut Board, zobrist: &mut Zobrist) -> i32 {
  let n = board.n as usize;
  if let Some(value) = zobrist.check_symmetry(board) {
    return value;
  }
  let mut value = board.gamevalue(onmove);
  if value == -2 {
    value = -1;
    for row in 0..n {
      for col in 0..n {
        board.try_move(onmove, row, col, |b| {
          let v0 = -negamax_symmetry(-onmove, b, zobrist);
          if v0 > value {
            value = v0;
          }
        });
      }
    }
  }
  zobrist.store(value, board);
  value
}

pub fn negamax_alpha_beta(onmove: i32, board: &mut Board, mut alpha: i32, beta: i32) -> i32 {
  let n = board.n as usize;
  let mut value = board.gamevalue(onmove);
  if value == -2 {
    for row in 0..n {
      for col in 0..n {
        board.try_move(onmove, row, col, |b| {
          let v0 = -negamax_alpha_beta(-onmove, b, -beta, -alpha);
          if v0 > value {
            value = v0;
          }
          if v0 > alpha {
            alpha = v0;
          }
        });
        if alpha >= beta {
          return alpha;
        }
      }
    }
  }
  value
}

pub fn negamax_both(onmove: i32, board: &mut Board, mut alpha: i32, beta: i32, zobrist: &mut Zobrist) -> i32 {
  let n = board.n as usize;
  if let Some(value) = zobrist.check_symmetry(board) {
    return value;
  }
  let mut value = board.gamevalue(onmove);
  if value == -2 {
    for row in 0..n {
      for col in 0..n {
        board.try_move(onmove, row, col, |b| {
          let v0 = -negamax_both(-onmove, b, -beta, -alpha, zobrist);
          if v0 > value {
            value = v0;
          }
          if v0 > alpha {
            alpha = v0;
          }
          if alpha >= beta {
            zobrist.store(alpha, b);
          }
        });
        if alpha >= beta {
          return alpha;
        }
      }
    }
  }
  zobrist.store(value, board);
  value
}
