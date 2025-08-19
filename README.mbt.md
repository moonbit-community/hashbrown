# hashbrown-moonbit

A MoonBit port of Google's high-performance SwissTable hash map, adapted to make it a drop-in replacement for standard `HashMap` and `HashSet` types.

This is a port of the Rust [hashbrown](https://github.com/rust-lang/hashbrown) library to MoonBit, bringing the same high-performance hash table implementation to the MoonBit ecosystem.

## Features

* High-performance hash map and hash set implementations
* Based on Google's SwissTable algorithm
* SIMD-optimized lookups for parallel hash entry scanning
* Memory-efficient design with minimal overhead
* Compatible with MoonBit's garbage collection
* Comprehensive test suite with edge cases and performance tests

## Usage

```moonbit
test {
  let map : HashMap[Int, String] = HashMap::new()
  map.insert(1, "one")|>ignore
  map.insert(2, "two")|>ignore
  match map.get(1) {
    Some(value) => println("Found: \{value}")
    None => println("Not found")
  }
}
```

## API

### HashMap[K, V]

Core hash map implementation with the following methods:
- `new()` - Create a new empty hash map
- `insert(key, value)` - Insert a key-value pair
- `get(key)` - Get a value by key
- `remove(key)` - Remove a key-value pair
- `contains_key(key)` - Check if key exists
- `len()` - Get number of entries
- `is_empty()` - Check if map is empty
- `clear()` - Remove all entries

### HashSet[T]

Hash set implementation built on top of HashMap:
- `new()` - Create a new empty hash set
- `insert(value)` - Insert a value
- `contains(value)` - Check if value exists
- `remove(value)` - Remove a value
- `len()` - Get number of entries
- `is_empty()` - Check if set is empty
- `clear()` - Remove all entries

## License

Licensed under Apache License, Version 2.0