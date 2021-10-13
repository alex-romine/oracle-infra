terraform {
  backend "http" {
    address       = "https://objectstorage.us-sanjose-1.oraclecloud.com/p/-XgDG5PDoDLr7MmUxgYBLjxzGiSD1sEg63RRkMaqBs2sz1O5h1lvv5cHW1pOm-H0/n/axhhombpfpap/b/terraform-state/o/terraform.tfstate"
    update_method = "PUT"
  }
}