// Comprehensive test suite for HashBrown MoonBit
// Tests for HashMap and HashSet implementations

// Basic functionality tests
///|
test "hello function" {
  if @hashbrown.hello() != "HashBrown MoonBit - High Performance Hash Maps" {
    fail("hello() returned unexpected value")
  }
}

// HashMap Basic Tests

///|
test "hashmap_new_empty" {
  let map : @hashbrown.HashMap[Int, String] = @hashbrown.HashMap::new()
  if not(map.is_empty()) {
    fail("New HashMap should be empty")
  }
  if map.len() != 0 {
    fail("New HashMap should have length 0")
  }
  if map.capacity() < 16 {
    fail("New HashMap should have initial capacity >= 16")
  }
}

///|
test "hashmap_insert_and_get" {
  let map : @hashbrown.HashMap[Int, String] = @hashbrown.HashMap::new()

  // Test insert new key
  match map.insert(1, "one") {
    Some(_) => fail("Insert of new key should return None")
    None => ()
  }
  if map.len() != 1 {
    fail("Length should be 1 after insert")
  }

  // Test get existing key
  match map.get(1) {
    Some(value) => if value != "one" { fail("Got wrong value from get") }
    None => fail("Should find inserted key")
  }

  // Test get non-existing key
  match map.get(2) {
    Some(_) => fail("Should not find non-existing key")
    None => ()
  }
}

///|
test "hashmap_contains_key" {
  let map : @hashbrown.HashMap[Int, String] = @hashbrown.HashMap::new()
  if map.contains_key(1) {
    fail("Empty map should not contain any keys")
  }
  ignore(map.insert(1, "one"))
  if not(map.contains_key(1)) {
    fail("Map should contain inserted key")
  }
  if map.contains_key(2) {
    fail("Map should not contain non-inserted key")
  }
}

///|
test "hashmap_remove" {
  let map : @hashbrown.HashMap[Int, String] = @hashbrown.HashMap::new()

  // Test remove from empty map
  match map.remove(1) {
    Some(_) => fail("Remove from empty map should return None")
    None => ()
  }

  // Insert and remove
  ignore(map.insert(1, "one"))
  ignore(map.insert(2, "two"))
  match map.remove(1) {
    Some(value) =>
      if value != "one" {
        fail("Remove should return correct value")
      }
    None => fail("Remove of existing key should return Some")
  }
  if map.len() != 1 {
    fail("Length should decrease after remove")
  }
  if map.contains_key(1) {
    fail("Removed key should not exist")
  }
}

// HashSet Basic Tests

///|
test "hashset_new_empty" {
  let set : @hashbrown.HashSet[Int] = @hashbrown.HashSet::new()
  if not(set.is_empty_set()) {
    fail("New HashSet should be empty")
  }
  if set.len_set() != 0 {
    fail("New HashSet should have length 0")
  }
}

///|
test "hashset_insert_and_contains" {
  let set : @hashbrown.HashSet[Int] = @hashbrown.HashSet::new()

  // Test insert new value
  if not(set.insert_set(1)) {
    fail("Insert of new value should return true")
  }
  if set.len_set() != 1 {
    fail("Length should be 1 after insert")
  }
  if set.is_empty_set() {
    fail("Set should not be empty after insert")
  }

  // Test contains
  if not(set.contains(1)) {
    fail("Set should contain inserted value")
  }
  if set.contains(2) {
    fail("Set should not contain non-inserted value")
  }

  // Test insert duplicate
  if set.insert_set(1) {
    fail("Insert of existing value should return false")
  }
  if set.len_set() != 1 {
    fail("Length should stay 1 after duplicate insert")
  }
}

///|
test "hashset_remove" {
  let set : @hashbrown.HashSet[Int] = @hashbrown.HashSet::new()

  // Test remove from empty set
  if set.remove_set(1) {
    fail("Remove from empty set should return false")
  }

  // Insert and remove
  ignore(set.insert_set(1))
  ignore(set.insert_set(2))
  if not(set.remove_set(1)) {
    fail("Remove of existing value should return true")
  }
  if set.len_set() != 1 {
    fail("Length should decrease after remove")
  }
  if set.contains(1) {
    fail("Removed value should not exist")
  }
  if not(set.contains(2)) {
    fail("Other values should still exist")
  }

  // Test remove same value again
  if set.remove_set(1) {
    fail("Remove of non-existing value should return false")
  }
}

// String key tests

///|
test "hashmap_string_keys" {
  let map : @hashbrown.HashMap[String, Int] = @hashbrown.HashMap::new()
  ignore(map.insert("hello", 1))
  ignore(map.insert("world", 2))
  ignore(map.insert("", 3)) // empty string
  match map.get("hello") {
    Some(value) => if value != 1 { fail("Wrong value for 'hello'") }
    None => fail("Missing key 'hello'")
  }
  match map.get("") {
    Some(value) => if value != 3 { fail("Wrong value for empty string") }
    None => fail("Missing empty string key")
  }
  if map.len() != 3 {
    fail("Should have 3 string keys")
  }
}

// Stress test

///|
test "hashmap_stress_test" {
  let map : @hashbrown.HashMap[Int, Int] = @hashbrown.HashMap::new()

  // Insert many values
  for i = 0; i < 100; i = i + 1 {
    ignore(map.insert(i, i * 2))
  }
  if map.len() != 100 {
    fail("Should have 100 entries after bulk insert")
  }

  // Verify all values
  for i = 0; i < 100; i = i + 1 {
    match map.get(i) {
      Some(value) => if value != i * 2 { fail("Wrong value for key \{i}") }
      None => fail("Missing key \{i}")
    }
  }

  // Remove half the values
  for i = 0; i < 50; i = i + 1 {
    match map.remove(i) {
      Some(value) =>
        if value != i * 2 {
          fail("Wrong value removed for key \{i}")
        }
      None => fail("Failed to remove key \{i}")
    }
  }
  if map.len() != 50 {
    fail("Should have 50 entries after partial removal")
  }
}
