use a5::{
    cell_area,
    // cell_to_boundary,
    cell_to_lonlat,
    // cell_to_children,
    // cell_to_parent,
    // get_num_cells,
    // get_res0_cells,
    get_resolution as a5_get_resolution,
    hex_to_u64 as a5_hex_to_u64,
    lonlat_to_cell,
    u64_to_hex as a5_u64_to_hex,
    // compact,
    // uncompact,
    // A5Cell,
    // Degrees,
    // LonLat,
    // Radians,
};
use extendr_api::prelude::*;

/// Convert latitude/longitude to A5 cell ID
/// @param lon longitude in decimal degrees.
/// @param lat latitude in decimal degrees.
/// @param resolution resolution level of the grid
/// @export
#[extendr]
fn lon_lat_to_cell(lon: f64, lat: f64, resolution: i32) -> Result<f64> {
    let lonlat = a5::LonLat::new(lon, lat);
    match lonlat_to_cell(lonlat, resolution) {
        Ok(cell_id) => Ok(cell_id as f64),
        Err(e) => Err(Error::Other(format!("Error converting to cell: {}", e))),
    }
}

/// Convert A5 cell ID to latitude/longitude
/// @param cell_id ID of the cell.
/// @export
#[extendr]
fn cell_to_lon_lat(cell_id: f64) -> Result<List> {
    let cell_u64 = cell_id as u64;
    match cell_to_lonlat(cell_u64) {
        Ok(lonlat) => Ok(list!(
            lon = lonlat.longitude.get(),
            lat = lonlat.latitude.get(),
        )),
        Err(e) => Err(Error::Other(format!(
            "Error converting cell to LatLng: {}",
            e
        ))),
    }
}

/// Convert hexadecimal string to A5 cell ID
/// @param hex hexadecimal string representation of the cell ID.
/// @return A5 cell ID as a numeric value.
/// @export
#[extendr]
fn hex_to_u64(hex: &str) -> Result<f64> {
    match a5_hex_to_u64(hex) {
        Ok(cell_id) => Ok(cell_id as f64),
        Err(e) => Err(Error::Other(format!("Error parsing hex string: {}", e))),
    }
}

/// Convert A5 cell ID to hexadecimal string
/// @param cell_id ID of the cell.
/// @return hexadecimal string representation of the cell ID.
/// @export
#[extendr]
fn u64_to_hex(cell_id: f64) -> String {
    a5_u64_to_hex(cell_id as u64)
}

/// Get the resolution of an A5 cell
/// @param cell_id ID of the cell.
/// @return resolution level (0-30) of the cell.
/// @export
#[extendr]
fn get_resolution(cell_id: f64) -> i32 {
    a5_get_resolution(cell_id as u64)
}

/// Get the area of a cell at a given resolution
/// @param resolution resolution level (0-30).
/// @return area in square meters.
/// @export
#[extendr]
fn get_cell_area(resolution: i32) -> f64 {
    cell_area(resolution)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod a5r;
    fn lon_lat_to_cell;
    fn cell_to_lon_lat;
    fn hex_to_u64;
    fn u64_to_hex;
    fn get_resolution;
    fn get_cell_area;
}
