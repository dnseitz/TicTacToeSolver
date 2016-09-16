extern crate time;
extern crate rand;

mod negamax;
mod board;
mod zobrist;

fn main() {
  let n = 4;
  let mut board = board::Board::new(n);
  let mut zobrist = zobrist::Zobrist::new(n);

  let mut start;
  let mut value;
  let mut end;

  //let start = time::PreciseTime::now();
  //let mut start = time::precise_time_ns();
  //let mut value = negamax::negamax(1, &mut board);
  //let mut end = time::precise_time_ns();
  //let end = time::PreciseTime::now();
  //println!("{}", value);
  //println!("Average time no optimization: {}", ((end-start) as f64 * 1e-9));

  start = time::precise_time_ns();
  value = negamax::negamax_symmetry(1, &mut board, &mut zobrist);
  end = time::precise_time_ns();
  println!("{}", value);
  println!("Average time symmetry: {}", ((end-start) as f64 * 1e-9));

  start = time::precise_time_ns();
  value = negamax::negamax_alpha_beta(1, &mut board, -2, 2);
  end = time::precise_time_ns();
  println!("{}", value);
  println!("Average time alpha-beta: {}", ((end-start) as f64 * 1e-9));

  zobrist = zobrist::Zobrist::new(n);
  start = time::precise_time_ns();
  value = negamax::negamax_both(1, &mut board, -2, 2, &mut zobrist);
  end = time::precise_time_ns();
  println!("{}", value);
  println!("Average time both: {}", ((end-start) as f64 * 1e-9));
}


