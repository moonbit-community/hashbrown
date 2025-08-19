// MoonBit port of Google's SwissTable hash map
// Based on the Rust hashbrown library implementation

///|
let load_factor = 0.875

// Control byte values for SwissTable

///|
enum Control {
  Empty
  Deleted
  Full(UInt)
} derive(Show)

// Core hash map structure using SwissTable algorithm

///|
pub struct HashMap[K, V] {
  mut buckets : Array[(K, V)?]
  mut ctrl : Array[Control]
  mut len : Int
  mut capacity : Int
} derive(Show)

// Hash set built on top of HashMap

///|
pub struct HashSet[T] {
  map : HashMap[T, Unit]
}

// Hash trait for types that can be hashed

///|
pub trait Hash {
  hash(Self) -> UInt
}

// Default hash implementations for common types

///|
pub impl Hash for Int with hash(self : Int) -> UInt {
  let x = self.reinterpret_as_uint()
  let x = x ^ (x >> 16)
  let x = x * 0x85ebca6b_U
  let x = x ^ (x >> 13)
  let x = x * 0xc2b2ae35_U
  x ^ (x >> 16)
}

///|
pub impl Hash for String with hash(self : String) -> UInt {
  let mut hash = 2166136261_U
  let bytes = self.to_bytes()
  for i = 0; i < bytes.length(); i = i + 1 {
    hash = hash ^ bytes[i].to_uint()
    hash = hash * 16777619_U
  }
  hash
}

///|
pub impl Hash for UInt with hash(self : UInt) -> UInt {
  let x = self
  let x = x ^ (x >> 16)
  let x = x * 0x85ebca6b_U
  let x = x ^ (x >> 13)
  let x = x * 0xc2b2ae35_U
  x ^ (x >> 16)
}

// Utility function to find next power of 2

///|
fn next_power_of_2(n : Int) -> Int {
  if n <= 1 {
    return 1
  }
  let mut power = 1
  while power < n {
    power = power * 2
  }
  power
}

// Hash a key and get the control byte

///|
fn[K : Hash] hash_key(key : K) -> (UInt, Control) {
  let hash = key.hash()
  let ctrl_hash = hash & 0x7F_U
  (hash, Control::Full(ctrl_hash))
}

// HashMap implementation

///|
pub fn[K, V] HashMap::new() -> HashMap[K, V] {
  let initial_capacity = 16
  {
    buckets: Array::make(initial_capacity, None),
    ctrl: Array::make(initial_capacity, Control::Empty),
    len: 0,
    capacity: initial_capacity,
  }
}

///|
pub fn[K, V] HashMap::with_capacity(capacity : Int) -> HashMap[K, V] {
  let cap = if capacity < 16 { 16 } else { next_power_of_2(capacity) }
  {
    buckets: Array::make(cap, None),
    ctrl: Array::make(cap, Control::Empty),
    len: 0,
    capacity: cap,
  }
}

///|
pub fn[K, V] len(self : HashMap[K, V]) -> Int {
  self.len
}

///|
pub fn[K, V] is_empty(self : HashMap[K, V]) -> Bool {
  self.len == 0
}

///|
pub fn[K, V] capacity(self : HashMap[K, V]) -> Int {
  self.capacity
}

///|
pub fn[K, V] clear(self : HashMap[K, V]) -> Unit {
  for i = 0; i < self.capacity; i = i + 1 {
    self.buckets[i] = None
    self.ctrl[i] = Control::Empty
  }
  self.len = 0
}

// Find the slot for a key

///|
fn[K : Hash + Eq, V] find_slot(self : HashMap[K, V], key : K) -> Int? {
  let (hash, target_ctrl) = hash_key(key)
  let mask = self.capacity - 1
  let mut pos = (hash & mask.reinterpret_as_uint()).reinterpret_as_int()
  let mut count = 0
  while count < self.capacity {
    match self.ctrl[pos] {
      Control::Empty => return None
      Control::Deleted => pos = (pos + 1) & mask
      Control::Full(ctrl_hash) => {
        match target_ctrl {
          Control::Full(target_hash) =>
            if ctrl_hash == target_hash {
              match self.buckets[pos] {
                Some((k, _)) => if k == key { return Some(pos) }
                None => ()
              }
            }
          _ => ()
        }
        pos = (pos + 1) & mask
      }
    }
    count = count + 1
  }
  None
}

// Find an empty slot for insertion

///|
fn[K, V] find_empty_slot(self : HashMap[K, V], hash : UInt) -> Int {
  let mask = self.capacity - 1
  let mut pos = (hash & mask.reinterpret_as_uint()).reinterpret_as_int()
  let mut count = 0
  while count < self.capacity {
    match self.ctrl[pos] {
      Control::Empty | Control::Deleted => return pos
      Control::Full(_) => {
        pos = (pos + 1) & mask
        count = count + 1
      }
    }
  }
  0 // fallback
}

// Resize the hash map when load factor is exceeded

///|
fn[K : Hash + Eq, V] resize(self : HashMap[K, V]) -> Unit {
  let old_buckets = self.buckets
  let old_ctrl = self.ctrl
  let old_capacity = self.capacity
  self.capacity = self.capacity * 2
  self.buckets = Array::make(self.capacity, None)
  self.ctrl = Array::make(self.capacity, Control::Empty)
  self.len = 0

  // Rehash all existing entries
  for i = 0; i < old_capacity; i = i + 1 {
    match old_ctrl[i] {
      Control::Full(_) =>
        match old_buckets[i] {
          Some((key, value)) => ignore(self.insert(key, value))
          None => ()
        }
      _ => ()
    }
  }
}

///|
pub fn[K : Hash + Eq, V] insert(self : HashMap[K, V], key : K, value : V) -> V? {
  // Check if we need to resize
  if self.len >= (self.capacity.to_double() * load_factor).to_int() {
    self.resize()
  }

  // Try to find existing key
  match self.find_slot(key) {
    Some(pos) =>
      // Key already exists, update value
      match self.buckets[pos] {
        Some((_, old_value)) => {
          self.buckets[pos] = Some((key, value))
          Some(old_value)
        }
        None => {
          self.buckets[pos] = Some((key, value))
          None
        }
      }
    None => {
      // Insert new key-value pair
      let (hash, ctrl) = hash_key(key)
      let pos = self.find_empty_slot(hash)
      self.buckets[pos] = Some((key, value))
      self.ctrl[pos] = ctrl
      self.len = self.len + 1
      None
    }
  }
}

///|
pub fn[K : Hash + Eq, V] get(self : HashMap[K, V], key : K) -> V? {
  match self.find_slot(key) {
    Some(pos) =>
      match self.buckets[pos] {
        Some((_, value)) => Some(value)
        None => None
      }
    None => None
  }
}

///|
pub fn[K : Hash + Eq, V] contains_key(self : HashMap[K, V], key : K) -> Bool {
  match self.find_slot(key) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[K : Hash + Eq, V] remove(self : HashMap[K, V], key : K) -> V? {
  match self.find_slot(key) {
    Some(pos) =>
      match self.buckets[pos] {
        Some((_, value)) => {
          self.buckets[pos] = None
          self.ctrl[pos] = Control::Deleted
          self.len = self.len - 1
          Some(value)
        }
        None => None
      }
    None => None
  }
}

///|
pub fn[K, V] keys(self : HashMap[K, V]) -> Array[K] {
  let result = []
  for i = 0; i < self.capacity; i = i + 1 {
    match self.ctrl[i] {
      Control::Full(_) =>
        match self.buckets[i] {
          Some((key, _)) => ignore(result.push(key))
          None => ()
        }
      _ => ()
    }
  }
  result
}

///|
pub fn[K, V] values(self : HashMap[K, V]) -> Array[V] {
  let result = []
  for i = 0; i < self.capacity; i = i + 1 {
    match self.ctrl[i] {
      Control::Full(_) =>
        match self.buckets[i] {
          Some((_, value)) => ignore(result.push(value))
          None => ()
        }
      _ => ()
    }
  }
  result
}

///|
pub fn[K, V] entries(self : HashMap[K, V]) -> Array[(K, V)] {
  let result = []
  for i = 0; i < self.capacity; i = i + 1 {
    match self.ctrl[i] {
      Control::Full(_) =>
        match self.buckets[i] {
          Some(entry) => ignore(result.push(entry))
          None => ()
        }
      _ => ()
    }
  }
  result
}

// HashSet implementation built on HashMap

///|
pub fn[T] HashSet::new() -> HashSet[T] {
  { map: HashMap::new() }
}

///|
pub fn[T] HashSet::with_capacity(capacity : Int) -> HashSet[T] {
  { map: HashMap::with_capacity(capacity) }
}

///|
pub fn[T] len_set(self : HashSet[T]) -> Int {
  self.map.len()
}

///|
pub fn[T] is_empty_set(self : HashSet[T]) -> Bool {
  self.map.is_empty()
}

///|
pub fn[T] capacity_set(self : HashSet[T]) -> Int {
  self.map.capacity()
}

///|
pub fn[T] clear_set(self : HashSet[T]) -> Unit {
  self.map.clear()
}

///|
pub fn[T : Hash + Eq] insert_set(self : HashSet[T], value : T) -> Bool {
  match self.map.insert(value, ()) {
    Some(_) => false
    None => true
  }
}

///|
pub fn[T : Hash + Eq] contains(self : HashSet[T], value : T) -> Bool {
  self.map.contains_key(value)
}

///|
pub fn[T : Hash + Eq] remove_set(self : HashSet[T], value : T) -> Bool {
  match self.map.remove(value) {
    Some(_) => true
    None => false
  }
}

///|
pub fn[T] values_set(self : HashSet[T]) -> Array[T] {
  self.map.keys()
}

// Public API exports

///|
pub fn hello() -> String {
  "HashBrown MoonBit - High Performance Hash Maps"
}
