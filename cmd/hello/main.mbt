fn main {
  let m = @hashbrown.HashMap::new()
  m.insert(1, "one")|>ignore
  println("Hello, World!")
}