terraform {
  backend "http" {
    address = "http://127.0.0.1:3000/state"
  }
}
