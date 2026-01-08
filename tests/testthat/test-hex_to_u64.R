test_that("hex_to_u64 works correctly", {
  # Test with small values that fit in R's double precision
  cell_id <- hex_to_u64("1")
  expect_equal(cell_id, 1)

  # Test zero
  cell_id <- hex_to_u64("0")
  expect_equal(cell_id, 0)

  # Test with leading zeros (should work the same)
  cell_id <- hex_to_u64("0000000000000001")
  expect_equal(cell_id, 1)
})

test_that("hex_to_u64 handles invalid input", {
  # Invalid hex characters should error

  expect_error(hex_to_u64("xyz"))
  expect_error(hex_to_u64("ghij"))
})
