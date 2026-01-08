test_that("u64_to_hex works correctly", {
  # Test with small values
  hex <- u64_to_hex(1)
  expect_equal(hex, "1")

  # Test zero
  hex <- u64_to_hex(0)
  expect_equal(hex, "0")

  # Test with a cell obtained from lon_lat_to_cell (round-trip safe)
  cell <- lon_lat_to_cell(4.4260, 50.8433, 10)
  hex <- u64_to_hex(cell)
  expect_type(hex, "character")
  expect_true(nchar(hex) > 0)
})

test_that("u64_to_hex and hex_to_u64 are inverses", {
  # Round-trip test with cell from lon_lat_to_cell
  cell <- lon_lat_to_cell(4.4260, 50.8433, 14)
  hex <- u64_to_hex(cell)
  back <- hex_to_u64(hex)
  expect_equal(back, cell)

  # Round-trip with another location
  cell2 <- lon_lat_to_cell(-0.16, 51.51, 10)
  hex2 <- u64_to_hex(cell2)
  back2 <- hex_to_u64(hex2)
  expect_equal(back2, cell2)
})
