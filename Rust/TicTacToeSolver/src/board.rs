use std::slice::Iter;

pub enum Transformation {
  Rotate90,
  Rotate180,
  Rotate270,
  FlipHorizontal,
  FlipVertical,
  ForwardDiagonal,
  BackwardDiagonal,
}

impl Transformation {
  pub fn iterator() -> Iter<'static, Transformation> {
    static TRANSFORMATIONS: [Transformation;  7] = [Transformation::Rotate90, Transformation::Rotate180, Transformation::Rotate270, Transformation::FlipHorizontal,
    Transformation::FlipVertical, Transformation::ForwardDiagonal, Transformation::BackwardDiagonal];
    TRANSFORMATIONS.into_iter()
  }
}

pub enum Player {
  X,
  Y,
}

pub enum Space {
  X,
  Y,
  Empty,
}

pub enum GameResult {
  X,
  Y,
  Draw,
  InProgress,
}

pub struct Board {
  board: Vec<Vec<Space>>,
  pub n: u32,
}

impl Board {
  pub fn new(n: u32) -> Board {
    Board {
      n: n,
      board: (0..n).map(|_| {
          let mut vec = Vec::with_capacity(n as usize); 
          for _ in 0..n { 
            vec.push(Space::Empty) 
          }
          vec 
        }).collect(),
    }
  }

  pub fn gamevalue(&self, onmove: Player) -> GameResult {
    let mut value: GameResult;
    for _ in 0..2 {
      value = self.check_diagonals();
      if value != GameResult::InProgress {
        return value * onmove;
      }
      value = self.check_rows();
      if value != GameResult::InProgress {
        return value * onmove;
      }
      value = self.check_cols();
      if value != Player::Empty {
        return value * onmove;
      }

      // Game not over
      if !self.game_over() {
        return Player::Empty;
      }
    }
    // Game is a draw
    0
  }

  pub fn try_move<F>(&mut self, onmove: i32, row: usize, col: usize, mut algorithm: F) where F
  : FnMut(&mut Board) {
    if self.board[row][col] == 0 {
      self.board[row][col] = onmove;
      algorithm(self);
      self.board[row][col] = 0;
    }
  }

  pub fn value_at(&self, row: usize, col: usize) -> i32 {
    self.board[row][col]
  }

  pub fn print(&self) {
    let n = self.n as usize;
    for row in 0..n {
      println!("Row {}: {:?}", row, self.board[row]);
    }
  }

  fn check_diagonals(&self) -> i32 {
    let n = self.n as usize;
    let mut value: i32 = 0;
    for i in 0..n {
      value += self.board[i][i]
    }
    if value.abs() == n as i32 {
      return if value > 0 { 1 } else { -1 };
    }

    value = 0;
    for i in 0..n {
      value += self.board[i][(n-1)-i]
    }
    if value.abs() == n as i32 {
      return if value > 0 { 1 } else { -1 };
    }
    0
  }

  fn check_rows(&self) -> i32 {
    let n = self.n as usize;
    let mut value: i32 = 0;
    for row in 0..n {
      for col in 0..n {
        value += self.board[row][col]
      }
      if value.abs() == n as i32 {
        return if value > 0 { 1 } else { -1 };
      }
      value = 0;
    }
    0
  }

  fn check_cols(&self) -> i32 {
    let n = self.n as usize;
    let mut value: i32 = 0;
    for col in 0..n {
      for row in 0..n {
        value += self.board[row][col]
      }
      if value.abs() == n as i32 {
        return if value > 0 { 1 } else { -1 };
      }
      value = 0;
    }
    0
  }

  fn game_over(&self) -> bool {
    let n = self.n as usize;
    for row in 0..n {
      for col in 0..n {
        if self.board[row][col] == 0 { return false };
      }
    }
    true
  }

  pub fn transformed(&self, transformation: &Transformation) -> Board {
    let n = self.n as usize;
    let mut board = Board::new(self.n);
    match *transformation {
      Transformation::Rotate90 => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[(n-1)-col][row];
          }
        }
      },
      Transformation::Rotate180 => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[(n-1)-row][(n-1)-col];
          }
        }
      },
      Transformation::Rotate270 => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[col][(n-1)-row];
          }
        }
      },
      Transformation::FlipVertical => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[(n-1)-row][col];
          }
        }
      },
      Transformation::FlipHorizontal => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[row][(n-1)-col];
          }
        }
      },
      Transformation::BackwardDiagonal => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[col][row];
          }
        }
      },
      Transformation::ForwardDiagonal => {
        for row in 0..n {
          for col in 0..n {
            board.board[row][col] = self.board[(n-1)-col][(n-1)-row];
          }
        }
      },
    };
    board
  }
}
