terraform {
    required_version = "~>1.0"
    required_providers {
    google = {
        source = "hashicorp/google"
        version = ">= 3.39.0, <4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.10, != 1.11.0"
    }
    }
}