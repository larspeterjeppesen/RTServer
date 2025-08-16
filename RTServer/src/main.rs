#[macro_use] extern crate rocket;
use rocket::{Rocket, Build};


#[get("/")]
fn index() -> &'static str {
"Peer
Prerequisites: Fellowship 30
Talent Groups: Academics, Adeptus Arbites, Adeptus Mechanicus, Administratum, Astropaths, Ecclesiarchy, Feral Worlders, Government, Hivers, Inquisition, Middle Classes, Military, Nobility, the Insane, Underworld, Void Born, Workers.
The Explorer is adept at dealing with a particular social group or organisation. He gains a +10 bonus to all Fellowship Tests when interacting with the chosen group.
"
    
}

#[launch]
fn rocket() -> Rocket<Build> {
    rocket::build().mount("/", routes![index])
}
