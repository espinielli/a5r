#' @importFrom bit64 as.integer64
NULL

# Internal helper: convert f64 from Rust to integer64
# bit64 stores integer64 as double with special class
.to_integer64 <- function(x) {

  # The double from Rust is the bit-reinterpreted u64

  # bit64::as.integer64 handles the conversion
  bit64::as.integer64(x)
}

# Internal helper: convert integer64 to f64 for Rust
.from_integer64 <- function(x) {
  as.double(x)
}

#' Convert longitude/latitude to A5 cell ID
#'
#' @param lon Longitude in decimal degrees.
#' @param lat Latitude in decimal degrees.
#' @param resolution Resolution level of the grid (0-30).
#' @return A5 cell ID as an `integer64` value.
#' @examples
#' cell <- a5_from_lonlat(-0.16, 51.51, 10)
#' @export
a5_from_lonlat <- function(lon, lat, resolution) {
  result <- lon_lat_to_cell(lon, lat, as.integer(resolution))
  .to_integer64(result)
}

#' Convert A5 cell ID to longitude/latitude
#'
#' @param cell A5 cell ID as an `integer64` value.
#' @return A list with `lon` and `lat` components.
#' @examples
#' cell <- a5_from_lonlat(-0.16, 51.51, 10)
#' a5_to_lonlat(cell)
#' @export
a5_to_lonlat <- function(cell) {
  cell_to_lon_lat(.from_integer64(cell))
}

#' Get the resolution of an A5 cell
#'
#' @param cell A5 cell ID as an `integer64` value.
#' @return Resolution level (0-30) of the cell.
#' @examples
#' cell <- a5_from_lonlat(-0.16, 51.51, 10)
#' a5_resolution(cell)
#' @export
a5_resolution <- function(cell) {
  get_resolution(.from_integer64(cell))
}

#' Convert A5 cell ID to hexadecimal string
#'
#' @param cell A5 cell ID as an `integer64` value.
#' @return Hexadecimal string representation of the cell ID.
#' @examples
#' cell <- a5_from_lonlat(-0.16, 51.51, 10)
#' a5_to_hex(cell)
#' @export
a5_to_hex <- function(cell) {
  u64_to_hex(.from_integer64(cell))
}

#' Convert hexadecimal string to A5 cell ID
#'
#' @param hex Hexadecimal string representation of the cell ID.
#' @return A5 cell ID as an `integer64` value.
#' @examples
#' a5_from_hex("63611a8000000000")
#' @export
a5_from_hex <- function(hex) {
  result <- hex_to_u64(hex)
  .to_integer64(result)
}
