// Examples demonstrating the HashBrown MoonBit library usage

// Basic HashMap usage example

///|
pub fn example_hashmap_basic() -> Unit {
  println("=== HashMap Basic Usage ===")

  // Create a new HashMap
  let map : HashMap[String, Int] = HashMap::new()

  // Insert some key-value pairs
  ignore(map.insert("apple", 5))
  ignore(map.insert("banana", 3))
  ignore(map.insert("orange", 8))
  println("Map length: \{map.len()}")
  println("Map capacity: \{map.capacity()}")

  // Get values
  match map.get("apple") {
    Some(count) => println("Apples: \{count}")
    None => println("No apples found")
  }

  // Check if key exists
  if map.contains_key("banana") {
    println("We have bananas!")
  }

  // Update a value
  match map.insert("apple", 7) {
    Some(old_value) => println("Updated apples from \{old_value} to 7")
    None => println("Added new apple entry")
  }

  // Remove a key
  match map.remove("banana") {
    Some(count) => println("Removed \{count} bananas")
    None => println("No bananas to remove")
  }
  println("Final map length: \{map.len()}")
  println("")
}

// HashMap with custom types example

///|
pub fn example_hashmap_custom() -> Unit {
  println("=== HashMap with Different Types ===")

  // String to String mapping
  let names : HashMap[String, String] = HashMap::new()
  ignore(names.insert("john", "John Doe"))
  ignore(names.insert("jane", "Jane Smith"))

  // Integer to Boolean mapping
  let flags : HashMap[Int, Bool] = HashMap::new()
  ignore(flags.insert(1, true))
  ignore(flags.insert(2, false))
  ignore(flags.insert(3, true))
  println("Name mappings:")
  match names.get("john") {
    Some(full_name) => println("  john -> \{full_name}")
    None => ()
  }
  println("Flag mappings:")
  match flags.get(2) {
    Some(flag) => println("  2 -> \{flag}")
    None => ()
  }
  println("")
}

// HashSet basic usage example

///|
pub fn example_hashset_basic() -> Unit {
  println("=== HashSet Basic Usage ===")

  // Create a new HashSet
  let set : HashSet[String] = HashSet::new()

  // Insert some values
  if set.insert_set("rust") {
    println("Added 'rust' to set")
  }
  if set.insert_set("moonbit") {
    println("Added 'moonbit' to set")
  }
  if set.insert_set("javascript") {
    println("Added 'javascript' to set")
  }

  // Try to insert duplicate
  if not(set.insert_set("rust")) {
    println("'rust' already exists in set")
  }
  println("Set length: \{set.len_set()}")

  // Check membership
  if set.contains("moonbit") {
    println("Set contains 'moonbit'")
  }
  if not(set.contains("python")) {
    println("Set does not contain 'python'")
  }

  // Remove a value
  if set.remove_set("javascript") {
    println("Removed 'javascript' from set")
  }
  println("Final set length: \{set.len_set()}")
  println("")
}

// Demonstrating iteration over collections

///|
pub fn example_iteration() -> Unit {
  println("=== Iteration Examples ===")
  let map : HashMap[Int, String] = HashMap::new()
  ignore(map.insert(1, "one"))
  ignore(map.insert(2, "two"))
  ignore(map.insert(3, "three"))

  // Get all keys
  let keys = map.keys()
  println("Keys: [\{keys.length()}]")
  for i = 0; i < keys.length(); i = i + 1 {
    println("  \{keys[i]}")
  }

  // Get all values
  let values = map.values()
  println("Values: [\{values.length()}]")
  for i = 0; i < values.length(); i = i + 1 {
    println("  \{values[i]}")
  }

  // Get all entries
  let entries = map.entries()
  println("Entries: [\{entries.length()}]")
  for i = 0; i < entries.length(); i = i + 1 {
    let (k, v) = entries[i]
    println("  \{k} -> \{v}")
  }
  println("")
}

// Performance demonstration

///|
pub fn example_performance() -> Unit {
  println("=== Performance Demonstration ===")
  let map : HashMap[Int, Int] = HashMap::new()

  // Insert many items
  let n = 1000
  println("Inserting \{n} items...")
  for i = 0; i < n; i = i + 1 {
    ignore(map.insert(i, i * i))
  }
  println("Map length: \{map.len()}")
  println("Map capacity: \{map.capacity()}")

  // Random access test
  let mut found = 0
  for i = 0; i < 100; i = i + 1 {
    let key = (i * 7 + 13) % n // pseudo-random access
    match map.get(key) {
      Some(_) => found = found + 1
      None => ()
    }
  }
  println("Found \{found}/100 random lookups")

  // Remove half the items
  for i = 0; i < n / 2; i = i + 1 {
    ignore(map.remove(i))
  }
  println("After removing half: length = \{map.len()}")
  println("")
}

// Collision handling demonstration

///|
pub fn example_collision_handling() -> Unit {
  println("=== Collision Handling ===")
  let map : HashMap[Int, String] = HashMap::new()

  // Insert values that might cause hash collisions
  let collision_keys = [0, 16, 32, 48, 64, 80, 96, 112]
  for i = 0; i < collision_keys.length(); i = i + 1 {
    let key = collision_keys[i]
    ignore(map.insert(key, "value_\{key}"))
  }
  println("Inserted \{collision_keys.length()} potentially colliding keys")
  println("Map length: \{map.len()}")

  // Verify all can be retrieved
  let mut all_found = true
  for i = 0; i < collision_keys.length(); i = i + 1 {
    let key = collision_keys[i]
    match map.get(key) {
      Some(value) => if value != "value_\{key}" { all_found = false }
      None => all_found = false
    }
  }
  if all_found {
    println("All collision-prone keys retrieved successfully!")
  } else {
    println("Some keys were lost due to collisions")
  }
  println("")
}

// Word counting example

///|
pub fn example_word_count() -> Unit {
  println("=== Word Counting Example ===")
  let word_count : HashMap[String, Int] = HashMap::new()
  let text = [
    "the", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog", "the",
    "fox",
  ]

  // Count words
  for i = 0; i < text.length(); i = i + 1 {
    let word = text[i]
    match word_count.get(word) {
      Some(count) => ignore(word_count.insert(word, count + 1))
      None => ignore(word_count.insert(word, 1))
    }
  }
  println("Word frequencies:")
  let entries = word_count.entries()
  for i = 0; i < entries.length(); i = i + 1 {
    let (word, count) = entries[i]
    println("  '\{word}': \{count}")
  }
  println("")
}

// Set operations example

///|
pub fn example_set_operations() -> Unit {
  println("=== Set Operations Example ===")
  let languages : HashSet[String] = HashSet::new()
  let frameworks : HashSet[String] = HashSet::new()

  // Add programming languages
  ignore(languages.insert_set("rust"))
  ignore(languages.insert_set("javascript"))
  ignore(languages.insert_set("python"))
  ignore(languages.insert_set("moonbit"))

  // Add frameworks (some overlap with languages conceptually)
  ignore(frameworks.insert_set("react"))
  ignore(frameworks.insert_set("vue"))
  ignore(frameworks.insert_set("django"))
  println("Programming languages: \{languages.len_set()} items")
  println("Frameworks: \{frameworks.len_set()} items")

  // Check membership
  if languages.contains("rust") {
    println("Rust is in the languages set")
  }
  if not(frameworks.contains("rust")) {
    println("Rust is not in the frameworks set")
  }
  println("")
}

// Main function to run all examples

///|
pub fn run_all_examples() -> Unit {
  println("HashBrown MoonBit Library Examples")
  println("==================================")
  println("")
  example_hashmap_basic()
  example_hashmap_custom()
  example_hashset_basic()
  example_iteration()
  example_performance()
  example_collision_handling()
  example_word_count()
  example_set_operations()
  println("All examples completed successfully!")
}
