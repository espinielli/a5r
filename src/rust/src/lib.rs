use a5::{
    cell_area, cell_to_boundary, cell_to_children as a5_cell_to_children, cell_to_lonlat,
    cell_to_parent as a5_cell_to_parent, compact as a5_compact, core::cell::CellToBoundaryOptions,
    get_num_cells as a5_get_num_cells, get_res0_cells as a5_get_res0_cells,
    get_resolution as a5_get_resolution, hex_to_u64 as a5_hex_to_u64, lonlat_to_cell,
    u64_to_hex as a5_u64_to_hex, uncompact as a5_uncompact,
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

/// Get the boundary of an A5 cell as a list of coordinates
/// @param cell_id ID of the cell.
/// @param closed whether to close the ring by repeating the first point (default: TRUE).
/// @param segments number of segments per edge, or NULL for automatic (default: NULL).
/// @return a list with `lon` and `lat` vectors representing the boundary vertices.
/// @export
#[extendr]
fn get_cell_boundary(cell_id: f64, closed: bool, segments: Nullable<i32>) -> Result<List> {
    let opts = CellToBoundaryOptions {
        closed_ring: closed,
        segments: segments.into_option(),
    };
    let cell_u64 = cell_id as u64;
    match cell_to_boundary(cell_u64, Some(opts)) {
        Ok(boundary) => {
            let lons: Vec<f64> = boundary.iter().map(|ll| ll.longitude.get()).collect();
            let lats: Vec<f64> = boundary.iter().map(|ll| ll.latitude.get()).collect();
            Ok(list!(lon = lons, lat = lats))
        }
        Err(e) => Err(Error::Other(format!("Error getting cell boundary: {}", e))),
    }
}

/// Get the parent cell at a coarser resolution
/// @param cell_id ID of the cell.
/// @param parent_resolution target resolution (must be less than current), or NULL for immediate parent.
/// @return parent cell ID.
/// @export
#[extendr]
fn cell_to_parent(cell_id: f64, parent_resolution: Nullable<i32>) -> Result<f64> {
    let cell_u64 = cell_id as u64;
    match a5_cell_to_parent(cell_u64, parent_resolution.into_option()) {
        Ok(parent_id) => Ok(parent_id as f64),
        Err(e) => Err(Error::Other(format!("Error getting parent cell: {}", e))),
    }
}

/// Get the children cells at a finer resolution
/// @param cell_id ID of the cell.
/// @param child_resolution target resolution (must be greater than current), or NULL for immediate children.
/// @return vector of child cell IDs.
/// @export
#[extendr]
fn cell_to_children(cell_id: f64, child_resolution: Nullable<i32>) -> Result<Vec<f64>> {
    let cell_u64 = cell_id as u64;
    match a5_cell_to_children(cell_u64, child_resolution.into_option()) {
        Ok(children) => Ok(children.iter().map(|&c| c as f64).collect()),
        Err(e) => Err(Error::Other(format!("Error getting children cells: {}", e))),
    }
}

/// Get the number of cells at a given resolution
/// @param resolution resolution level (0-30).
/// @return number of cells at the specified resolution.
/// @export
#[extendr]
fn get_num_cells(resolution: i32) -> f64 {
    a5_get_num_cells(resolution) as f64
}

/// Get all resolution 0 (base) cells
/// @return vector of all 12 base cell IDs.
/// @export
#[extendr]
fn get_res0_cells() -> Result<Vec<f64>> {
    match a5_get_res0_cells() {
        Ok(cells) => Ok(cells.iter().map(|&c| c as f64).collect()),
        Err(e) => Err(Error::Other(format!("Error getting res0 cells: {}", e))),
    }
}

/// Compact a set of cells by merging complete sibling groups into parent cells
/// @param cells vector of cell IDs to compact.
/// @return vector of compacted cell IDs (typically smaller than input).
/// @export
#[extendr]
fn compact(cells: Vec<f64>) -> Result<Vec<f64>> {
    let cells_u64: Vec<u64> = cells.iter().map(|&c| c as u64).collect();
    match a5_compact(&cells_u64) {
        Ok(compacted) => Ok(compacted.iter().map(|&c| c as f64).collect()),
        Err(e) => Err(Error::Other(format!("Error compacting cells: {}", e))),
    }
}

/// Uncompact (expand) cells to a target resolution
/// @param cells vector of cell IDs to expand.
/// @param target_resolution the target resolution for all output cells.
/// @return vector of cell IDs all at the target resolution.
/// @export
#[extendr]
fn uncompact(cells: Vec<f64>, target_resolution: i32) -> Result<Vec<f64>> {
    let cells_u64: Vec<u64> = cells.iter().map(|&c| c as u64).collect();
    match a5_uncompact(&cells_u64, target_resolution) {
        Ok(expanded) => Ok(expanded.iter().map(|&c| c as f64).collect()),
        Err(e) => Err(Error::Other(format!("Error uncompacting cells: {}", e))),
    }
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
    fn get_cell_boundary;
    fn cell_to_parent;
    fn cell_to_children;
    fn get_num_cells;
    fn get_res0_cells;
    fn compact;
    fn uncompact;
}
