# HashBrown MoonBit Tutorial

Welcome to the HashBrown MoonBit tutorial! This guide will teach you how to use high-performance hash maps and hash sets in MoonBit, based on Google's SwissTable algorithm.

## What is HashBrown?

HashBrown is a high-performance hash map and hash set implementation ported from the Rust hashbrown library. It provides:

- **Fast operations**: O(1) average case for insert, lookup, and remove
- **Memory efficient**: Minimal overhead per entry
- **Collision resistant**: Robust handling of hash collisions
- **Generic support**: Works with any types that implement `Hash` and `Eq`

## Getting Started

### Creating Your First HashMap

Let's start with a simple example of creating and using a HashMap:

```mbt
test "basic_hashmap_usage" {
  let map : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()

  // Insert some key-value pairs
  ignore(map.insert("apples", 5))
  ignore(map.insert("bananas", 3))
  ignore(map.insert("oranges", 8))

  println("Map has \{map.len()} items")
}
```

### Basic Operations

#### Inserting and Retrieving Values

```mbt
test "insert_and_retrieve" {
  let scores : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()

  // Insert returns the previous value if key existed
  match scores.insert("Alice", 95) {
    Some(old_score) => println("Updated Alice's score from \{old_score}")
    None => println("Added new score for Alice")
  }

  // Get a value by key
  match scores.get("Alice") {
    Some(score) => println("Alice's score: \{score}")
    None => println("Alice not found")
  }
}
```

#### Checking for Keys

```mbt
test "checking_keys" {
  let inventory : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  ignore(inventory.insert("widgets", 42))

  if inventory.contains_key("widgets") {
    println("We have widgets in stock!")
  }

  if not(inventory.contains_key("gadgets")) {
    println("No gadgets available")
  }
}
```

#### Removing Items

```mbt
test "removing_items" {
  let items : @hashbrown.HashMap[String, String] = @hashbrown.HashMap::new()
  ignore(items.insert("key1", "value1"))
  ignore(items.insert("key2", "value2"))

  match items.remove("key1") {
    Some(value) => println("Removed: \{value}")
    None => println("Key not found")
  }

  println("Items remaining: \{items.len()}")
}
```

## Working with Different Types

### String Keys and Values

```mbt
test "string_translations" {
  let translations : @hashbrown.HashMap[String, String] = @hashbrown.HashMap::new()
  ignore(translations.insert("hello", "你好"))
  ignore(translations.insert("goodbye", "再见"))
  ignore(translations.insert("thank you", "谢谢"))

  match translations.get("hello") {
    Some(chinese) => println("Hello in Chinese: \{chinese}")
    None => println("Translation not found")
  }
}
```

### Integer Keys

```mbt
test "fibonacci_sequence" {
  let fibonacci : @hashbrown.HashMap[Int, Int] = @hashbrown.HashMap::new()
  ignore(fibonacci.insert(1, 1))
  ignore(fibonacci.insert(2, 1))
  ignore(fibonacci.insert(3, 2))
  ignore(fibonacci.insert(4, 3))
  ignore(fibonacci.insert(5, 5))

  match fibonacci.get(4) {
    Some(value) => println("4th Fibonacci number: \{value}")
    None => println("Not computed")
  }
}
```

## Advanced HashMap Features

### Iterating Over Collections

```mbt
test "iteration_example" {
  let colors : @hashbrown.HashMap[String, String] = @hashbrown.HashMap::new()
  ignore(colors.insert("red", "#FF0000"))
  ignore(colors.insert("green", "#00FF00"))
  ignore(colors.insert("blue", "#0000FF"))

  // Get all keys
  let color_names = colors.keys()
  println("Available colors:")
  for i = 0; i < color_names.length(); i = i + 1 {
    println("  - \{color_names[i]}")
  }

  // Get all values
  let hex_codes = colors.values()
  println("Hex codes:")
  for i = 0; i < hex_codes.length(); i = i + 1 {
    println("  - \{hex_codes[i]}")
  }

  // Get all key-value pairs
  let entries = colors.entries()
  println("Color mappings:")
  for i = 0; i < entries.length(); i = i + 1 {
    let (name, hex) = entries[i]
    println("  \{name}: \{hex}")
  }
}
```

### Capacity Management

```mbt
test "capacity_management" {
  // Create with specific initial capacity
  let large_map : @hashbrown.HashMap[Int, String] = @hashbrown.HashMap::with_capacity(1000)
  println("Initial capacity: \{large_map.capacity()}")

  // The map automatically resizes as needed
  for i = 0; i < 500; i = i + 1 {
    ignore(large_map.insert(i, "value_\{i}"))
  }

  println("After 500 insertions:")
  println("  Length: \{large_map.len()}")
  println("  Capacity: \{large_map.capacity()}")
}
```

### Clearing the Map

```mbt
test "clearing_map" {
  let temp_data : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  ignore(temp_data.insert("a", 1))
  ignore(temp_data.insert("b", 2))
  ignore(temp_data.insert("c", 3))

  println("Before clear: \{temp_data.len()} items")
  temp_data.clear()
  println("After clear: \{temp_data.len()} items")
}
```

## Working with HashSet

HashSet is perfect for storing unique values without duplicates:

### Creating and Using HashSet

```mbt
test "basic_hashset" {
  let unique_words : @hashbrown.HashSet[String] = @hashbrown.HashSet::new()

  // Insert returns true if value was newly added
  if unique_words.insert_set("hello") {
    println("Added 'hello'")
  }

  // Trying to insert the same value again
  if not(unique_words.insert_set("hello")) {
    println("'hello' already exists")
  }

  println("Set size: \{unique_words.len_set()}")
}
```

### Set Operations

```mbt
test "set_operations" {
  let programming_languages : @hashbrown.HashSet[String] = @hashbrown.HashSet::new()

  // Add languages
  ignore(programming_languages.insert_set("Rust"))
  ignore(programming_languages.insert_set("MoonBit"))
  ignore(programming_languages.insert_set("JavaScript"))
  ignore(programming_languages.insert_set("Python"))

  // Check membership
  if programming_languages.contains("Rust") {
    println("Rust is in our set")
  }

  if not(programming_languages.contains("Java")) {
    println("Java is not in our set")
  }

  // Remove a language
  if programming_languages.remove_set("JavaScript") {
    println("Removed JavaScript")
  }

  println("Languages remaining: \{programming_languages.len_set()}")
}
```

### Converting Set to Array

```mbt
test "set_to_array" {
  let numbers : @hashbrown.HashSet[Int] = @hashbrown.HashSet::new()
  ignore(numbers.insert_set(1))
  ignore(numbers.insert_set(3))
  ignore(numbers.insert_set(5))
  ignore(numbers.insert_set(7))

  let number_array = numbers.values_set()
  println("Set contains \{number_array.length()} numbers:")
  for i = 0; i < number_array.length(); i = i + 1 {
    println("  \{number_array[i]}")
  }
}
```

## Practical Examples

### Word Frequency Counter

```mbt
fn count_words(text : Array[String]) -> @hashbrown.HashMap[String, Int] {
  let word_count : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  
  for i = 0; i < text.length(); i = i + 1 {
    let word = text[i]
    match word_count.get(word) {
      Some(count) => ignore(word_count.insert(word, count + 1))
      None => ignore(word_count.insert(word, 1))
    }
  }
  
  word_count
}

test "word_frequency_counter" {
  let sample_text = ["the", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog", "the"]
  let frequencies = count_words(sample_text)

  println("Word frequencies:")
  let entries = frequencies.entries()
  for i = 0; i < entries.length(); i = i + 1 {
    let (word, count) = entries[i]
    println("  '\{word}': \{count}")
  }
}
```

### Caching System

```mbt
struct Cache[K, V] {
  data : @hashbrown.HashMap[K, V]
  max_size : Int
}

fn[K, V] Cache::new(max_size : Int) -> Cache[K, V] {
  { data: @hashbrown.HashMap::new(), max_size }
}

fn[K : @hashbrown.Hash + Eq, V] get_cached(self : Cache[K, V], key : K) -> V? {
  self.data.get(key)
}

fn[K : @hashbrown.Hash + Eq, V] put_cached(self : Cache[K, V], key : K, value : V) -> Unit {
  if self.data.len() >= self.max_size {
    // Simple eviction: clear cache when full
    self.data.clear()
  }
  ignore(self.data.insert(key, value))
}

test "caching_system" {
  let cache : Cache[String, Int] = Cache::new(3)
  cache.put_cached("a", 1)
  cache.put_cached("b", 2)
  cache.put_cached("c", 3)

  match cache.get_cached("b") {
    Some(value) => println("Cached value: \{value}")
    None => println("Cache miss")
  }
}
```

### Unique Visitor Tracker

```mbt
struct VisitorTracker {
  visitors : @hashbrown.HashSet[String]
  visit_count : @hashbrown.HashMap[String, Int]
}

fn VisitorTracker::new() -> VisitorTracker {
  { visitors: @hashbrown.HashSet::new(), visit_count: @hashbrown.HashMap::new() }
}

fn record_visit(self : VisitorTracker, user_id : String) -> Unit {
  // Track unique visitors
  ignore(self.visitors.insert_set(user_id))
  
  // Count visits per user
  match self.visit_count.get(user_id) {
    Some(count) => ignore(self.visit_count.insert(user_id, count + 1))
    None => ignore(self.visit_count.insert(user_id, 1))
  }
}

fn get_visitor_stats(self : VisitorTracker) -> (Int, Int) {
  let unique_visitors = self.visitors.len_set()
  let total_visits = {
    let mut total = 0
    let counts = self.visit_count.values()
    for i = 0; i < counts.length(); i = i + 1 {
      total = total + counts[i]
    }
    total
  }
  (unique_visitors, total_visits)
}

test "visitor_tracker" {
  let tracker = VisitorTracker::new()
  tracker.record_visit("user1")
  tracker.record_visit("user2")
  tracker.record_visit("user1") // repeat visitor

  let (unique, total) = tracker.get_visitor_stats()
  println("Unique visitors: \{unique}, Total visits: \{total}")
}
```

## Performance Considerations

### Choosing Initial Capacity

```mbt
test "initial_capacity_performance" {
  // If you know approximately how many items you'll store,
  // pre-allocate capacity to avoid resizing
  let large_dataset : @hashbrown.HashMap[Int, String] = @hashbrown.HashMap::with_capacity(10000)

  // This is more efficient than letting it resize multiple times
  for i = 0; i < 1000; i = i + 1 {
    ignore(large_dataset.insert(i, "data_\{i}"))
  }

  println("Final capacity: \{large_dataset.capacity()}")
  println("Load factor: \{large_dataset.len().to_double() / large_dataset.capacity().to_double()}")
}
```

### Batch Operations

```mbt
fn batch_insert_numbers(map : @hashbrown.HashMap[Int, Int], start : Int, end : Int) -> Unit {
  for i = start; i < end; i = i + 1 {
    ignore(map.insert(i, i * i))
  }
}

test "batch_operations" {
  let numbers : @hashbrown.HashMap[Int, Int] = @hashbrown.HashMap::new()
  batch_insert_numbers(numbers, 0, 1000)
  println("Inserted 1000 numbers efficiently")
}
```

## Best Practices

### 1. Use Appropriate Initial Capacity

```mbt
test "capacity_best_practices" {
  // Good: Pre-allocate if you know the size
  let config : @hashbrown.HashMap[String, String] = @hashbrown.HashMap::with_capacity(50)

  // Less optimal: Let it resize multiple times
  let config2 : @hashbrown.HashMap[String, String] = @hashbrown.HashMap::new()
  
  println("Config capacity: \{config.capacity()}")
  println("Config2 capacity: \{config2.capacity()}")
}
```

### 2. Handle Option Types Properly

```mbt
test "option_handling" {
  let lookup : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  ignore(lookup.insert("key", 42))

  // Good: Handle both cases
  match lookup.get("key") {
    Some(value) => println("Found: \{value}")
    None => println("Not found")
  }

  // Also good: Use default values when appropriate
  let value = match lookup.get("missing_key") {
    Some(v) => v
    None => 0  // default value
  }
  println("Value: \{value}")
}
```

### 3. Choose HashMap vs HashSet Appropriately

```mbt
test "choosing_data_structure" {
  // Use HashMap when you need key-value associations
  let user_scores : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  ignore(user_scores.insert("alice", 95))

  // Use HashSet when you only need unique values
  let seen_items : @hashbrown.HashSet[String] = @hashbrown.HashSet::new()
  ignore(seen_items.insert_set("item1"))
  
  println("User scores: \{user_scores.len()}")
  println("Seen items: \{seen_items.len_set()}")
}
```

## Troubleshooting Common Issues

### Issue: Type Inference Problems

```mbt
// Function showing proper type annotation
fn create_typed_map() -> @hashbrown.HashMap[String, Int] {
  @hashbrown.HashMap::new()  // Type inferred from return type
}

test "type_inference_solutions" {
  // Solution: Provide explicit types
  let map : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  
  // Or use function with explicit return type
  let map2 = create_typed_map()
  
  ignore(map.insert("test", 1))
  ignore(map2.insert("test2", 2))
}
```

### Issue: Forgetting to Handle Return Values

```mbt
test "handling_return_values" {
  let map : @hashbrown.HashMap[String, String] = @hashbrown.HashMap::new()
  
  // Solution: Explicitly handle or ignore
  let old_value = map.insert("key", "value")
  // or
  ignore(map.insert("key2", "value2"))
  
  match old_value {
    Some(v) => println("Previous value: \{v}")
    None => println("New key added")
  }
}
```

## Summary

You've learned how to:

- Create and use HashMap and HashSet
- Perform basic operations (insert, get, remove, contains)
- Iterate over collections
- Handle different data types
- Build practical applications like caches and counters
- Optimize for performance

The HashBrown library provides high-performance, memory-efficient hash tables that are perfect for a wide variety of use cases in MoonBit. Experiment with these examples and adapt them to your specific needs!

## Next Steps

- Try building a more complex application using HashBrown
- Experiment with custom types as keys (remember to implement `Hash` and `Eq`)
- Profile your application to see the performance benefits
- Explore the full API documentation for advanced features