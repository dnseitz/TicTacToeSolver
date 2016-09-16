use std::collections::HashMap;
use rand::random;
use board::{Transformation,Board};

pub struct Zobrist {
  table: Vec<Vec<u32>>,
  calculated: HashMap<u32, i32>,
}

impl Zobrist {
  pub fn new(n: u32) -> Zobrist {
    Zobrist {
      table: (0..(n*n)).map(|_| {
          let mut vec = Vec::with_capacity(3 as usize);
          for _ in 0..3 {
            vec.push(random::<u32>());
          }
          vec
        }).collect(),
      calculated: HashMap::new(),
    }
  }

  pub fn store(&mut self, value: i32, board: &Board) {
    let hash = self.hash(board);
    self.calculated.insert(hash, value);
  }

  pub fn check_symmetry(&self, board: &Board) -> Option<i32> {
    let mut hash = self.hash(board);
    if let Some(value) = self.calculated.get(&hash) {
      return Some(*value);
    }
    for transformation in Transformation::iterator() {
      let transformed = board.transformed(transformation);
      hash = self.hash(&transformed);
      if let Some(value) = self.calculated.get(&hash) {
        return Some(*value);
      }
    }
    None
  }

  fn hash(&self, board: &Board) -> u32 {
    let n = board.n as usize;
    let mut hash = 0;
    for i in 0..(n*n) {
      let row = i / n;
      let col = i % n;
      let val = (board.value_at(row, col) + 1) as usize;
      //println!("row: {} col: {} has value: {}", row, col, val);
      //println!("In hash, i: {}", i);
      hash = hash ^ self.table[i][val];
    }
    hash
  }
}
