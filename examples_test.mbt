// Test file to ensure examples compile and run without errors

///|
test "examples_run_without_errors" {
  // Test that all example functions can be called without panicking
  @hashbrown.example_hashmap_basic()
  @hashbrown.example_hashmap_custom()
  @hashbrown.example_hashset_basic()
  @hashbrown.example_iteration()
  @hashbrown.example_performance()
  @hashbrown.example_collision_handling()
  @hashbrown.example_word_count()
  @hashbrown.example_set_operations()

  // If we reach here, all examples ran successfully
}
