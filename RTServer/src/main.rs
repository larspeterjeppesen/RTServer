#[macro_use] extern crate rocket;
use rocket::{Rocket, Build};
use rocket::http::ContentType;
use std::fs::File;
use std::io::prelude::*;


const SOURCE_FILEPATH : &str= "data/output.txt";

#[get("/")]
fn index() -> (ContentType, String) {
    let mut source_file = File::open(SOURCE_FILEPATH).unwrap();
    let mut content = String::new();
    source_file.read_to_string(&mut content);
    // println!("{content}");
    // let content = "<h1>Peer</h1>   
// <pre id=\"Peer\">
// Prerequisites: Fellowship 30
// Talent Groups: Academics, Adeptus Arbites, Adeptus Mechanicus, Administratum, Astropaths, Ecclesiarchy, Feral Worlders, Government, Hivers, Inquisition, Middle Classes, Military, Nobility, the Insane, Underworld, Void Born, Workers.
// The Explorer is adept at dealing with a particular social group or organisation. He gains a +10 bonus to all Fellowship Tests when interacting with the chosen group.    
// </pre>";
    (ContentType::HTML, content)
}

#[launch]
fn rocket() -> Rocket<Build> {
    rocket::build()
        .mount("/", routes![index])
}
