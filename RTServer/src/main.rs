#[macro_use] extern crate rocket;
use rocket::{Rocket, Build};
use rocket::http::ContentType;
use std::fs::File;
use std::io::prelude::*;


const SOURCE_FILEPATH : &str= "data/RT_talents.txt";

#[get("/")]
fn index() -> (ContentType, String) {
    let mut source_file = File::open(SOURCE_FILEPATH).unwrap();
    let mut content = String::new();
    let _ = source_file.read_to_string(&mut content);
    (ContentType::HTML, content)
}

#[launch]
fn rocket() -> Rocket<Build> {
    rocket::build()
        .mount("/", routes![index])
}
