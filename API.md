# HashBrown MoonBit API Documentation

## Overview

HashBrown MoonBit is a high-performance hash map and hash set implementation for MoonBit, ported from the Rust hashbrown library which is based on Google's SwissTable algorithm.

## Core Features

- **High Performance**: Based on Google's SwissTable algorithm with SIMD-optimized lookups
- **Memory Efficient**: Minimal overhead per entry compared to standard implementations
- **Generic Support**: Works with any types that implement `Hash` and `Eq` traits
- **Comprehensive API**: Full-featured HashMap and HashSet implementations
- **Collision Resistant**: Robust handling of hash collisions through linear probing

## Types

### HashMap[K, V]

A generic hash map that stores key-value pairs.

#### Type Parameters
- `K`: Key type (must implement `Hash + Eq`)
- `V`: Value type

#### Constructors

```moonbit
HashMap::new[K, V]() -> HashMap[K, V]
```
Creates a new empty HashMap with default initial capacity (16).

```moonbit
HashMap::with_capacity[K, V](capacity : Int) -> HashMap[K, V]
```
Creates a new HashMap with the specified initial capacity (rounded up to next power of 2).

#### Methods

```moonbit
len(self : HashMap[K, V]) -> Int
```
Returns the number of key-value pairs in the map.

```moonbit
is_empty(self : HashMap[K, V]) -> Bool
```
Returns `true` if the map contains no elements.

```moonbit
capacity(self : HashMap[K, V]) -> Int
```
Returns the current capacity of the map.

```moonbit
clear(self : HashMap[K, V]) -> Unit
```
Removes all key-value pairs from the map.

```moonbit
insert(self : HashMap[K, V], key : K, value : V) -> Option[V]
```
Inserts a key-value pair into the map. Returns the previous value if the key already existed, or `None` if it was a new key.

```moonbit
get(self : HashMap[K, V], key : K) -> Option[V]
```
Gets the value associated with a key. Returns `Some(value)` if found, `None` otherwise.

```moonbit
contains_key(self : HashMap[K, V], key : K) -> Bool
```
Returns `true` if the map contains the specified key.

```moonbit
remove(self : HashMap[K, V], key : K) -> Option[V]
```
Removes a key-value pair from the map. Returns the removed value if the key existed, `None` otherwise.

```moonbit
keys(self : HashMap[K, V]) -> Array[K]
```
Returns an array containing all keys in the map.

```moonbit
values(self : HashMap[K, V]) -> Array[V]
```
Returns an array containing all values in the map.

```moonbit
entries(self : HashMap[K, V]) -> Array[(K, V)]
```
Returns an array containing all key-value pairs in the map.

### HashSet[T]

A generic hash set that stores unique values.

#### Type Parameters
- `T`: Element type (must implement `Hash + Eq`)

#### Constructors

```moonbit
HashSet::new[T]() -> HashSet[T]
```
Creates a new empty HashSet with default initial capacity.

```moonbit
HashSet::with_capacity[T](capacity : Int) -> HashSet[T]
```
Creates a new HashSet with the specified initial capacity.

#### Methods

```moonbit
len_set(self : HashSet[T]) -> Int
```
Returns the number of elements in the set.

```moonbit
is_empty_set(self : HashSet[T]) -> Bool
```
Returns `true` if the set contains no elements.

```moonbit
capacity_set(self : HashSet[T]) -> Int
```
Returns the current capacity of the set.

```moonbit
clear_set(self : HashSet[T]) -> Unit
```
Removes all elements from the set.

```moonbit
insert_set(self : HashSet[T], value : T) -> Bool
```
Inserts a value into the set. Returns `true` if the value was newly inserted, `false` if it already existed.

```moonbit
contains(self : HashSet[T], value : T) -> Bool
```
Returns `true` if the set contains the specified value.

```moonbit
remove_set(self : HashSet[T], value : T) -> Bool
```
Removes a value from the set. Returns `true` if the value was present and removed, `false` otherwise.

```moonbit
values_set(self : HashSet[T]) -> Array[T]
```
Returns an array containing all values in the set.

## Traits

### Hash

The `Hash` trait defines how types can be hashed for use as keys in HashMap or elements in HashSet.

```moonbit
pub trait Hash {
  hash(Self) -> UInt
}
```

#### Built-in Implementations

The library provides `Hash` implementations for common types:

- `Int`: Uses a simple multiplicative hash
- `String`: Uses FNV-1a hash algorithm  
- `UInt`: Uses a simple multiplicative hash

#### Custom Implementations

To use custom types as keys or set elements, implement the `Hash` trait:

```moonbit
struct Point {
  x : Int
  y : Int
}

impl Hash for Point with hash(self : Point) -> UInt {
  let x_hash = self.x.hash()
  let y_hash = self.y.hash()
  x_hash ^ (y_hash << 1)  // Simple combination
}

impl Eq for Point with op_equal(self : Point, other : Point) -> Bool {
  self.x == other.x && self.y == other.y
}
```

## Usage Examples

### Basic HashMap Usage

```moonbit
let map : HashMap[String, Int] = HashMap::new()

// Insert key-value pairs
ignore(map.insert("apple", 5))
ignore(map.insert("banana", 3))

// Get values
match map.get("apple") {
  Some(count) => println("Apples: \{count}")
  None => println("No apples found")
}

// Check existence
if map.contains_key("banana") {
  println("We have bananas!")
}

// Update value
match map.insert("apple", 7) {
  Some(old_value) => println("Updated apples from \{old_value} to 7")
  None => println("Added new apple entry")
}

// Remove key
match map.remove("banana") {
  Some(count) => println("Removed \{count} bananas")
  None => println("No bananas to remove")
}
```

### Basic HashSet Usage

```moonbit
let set : HashSet[String] = HashSet::new()

// Insert values
if set.insert_set("rust") {
  println("Added 'rust' to set")
}

// Check membership
if set.contains("rust") {
  println("Set contains 'rust'")
}

// Remove values
if set.remove_set("rust") {
  println("Removed 'rust' from set")
}
```

### Iteration

```moonbit
let map : HashMap[Int, String] = HashMap::new()
ignore(map.insert(1, "one"))
ignore(map.insert(2, "two"))

// Iterate over keys
let keys = map.keys()
for i = 0; i < keys.length(); i = i + 1 {
  println("Key: \{keys[i]}")
}

// Iterate over values  
let values = map.values()
for i = 0; i < values.length(); i = i + 1 {
  println("Value: \{values[i]}")
}

// Iterate over entries
let entries = map.entries()
for i = 0; i < entries.length(); i = i + 1 {
  let (k, v) = entries[i]
  println("\{k} -> \{v}")
}
```

## Performance Characteristics

- **Insert**: O(1) average case, O(n) worst case during resize
- **Lookup**: O(1) average case, O(n) worst case
- **Remove**: O(1) average case, O(n) worst case  
- **Space**: O(n) where n is the number of entries

The implementation automatically resizes when the load factor exceeds 87.5%, maintaining good performance characteristics.

## Memory Layout

The implementation uses the SwissTable design:
- Separate control bytes array for fast SIMD lookups
- Linear probing for collision resolution
- Power-of-2 sizing for efficient modulo operations
- Minimal memory overhead per entry

## Thread Safety

The HashMap and HashSet implementations are **not** thread-safe. External synchronization is required for concurrent access.
