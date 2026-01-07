use a5::{
    // cell_to_boundary,
    // cell_to_lonlat,
    lonlat_to_cell,
    // cell_area,
    // cell_to_children,
    // cell_to_parent,
    // get_num_cells,
    // get_res0_cells,
    // get_resolution,
    // hex_to_u64,
    // u64_to_hex,
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

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod a5r;
    fn lon_lat_to_cell;
}
