terraform {
  backend "gcs" {
    bucket      = "xdg-task-terraform-state" 
    prefix      = "terraform" 
  }
}