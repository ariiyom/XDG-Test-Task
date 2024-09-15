terraform {
  backend "gcs" {
    bucket      = ""            # replace this by bucket name used when running ./helpers/state_bucket.sh
    prefix      = "terraform" 
  }
}