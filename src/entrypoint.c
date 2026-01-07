// We need to forward routine registration from C to Rust
// to avoid the linker removing the static library.

void R_init_a5r_extendr(void *dll);

void R_init_a5r(void *dll) {
    R_init_a5r_extendr(dll);
}
