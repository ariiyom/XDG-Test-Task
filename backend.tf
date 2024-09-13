terraform {
  backend "gcs" {
    bucket      = "xdg-task-terraform-state"    # replace this by bucket name used when running ./helpers/state_bucket.sh
    prefix      = "terraform" 
  }
}