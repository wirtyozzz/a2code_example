terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "some_pass"
  auth_url    = "https://external_auth_example:5000"
  region      = "RegionOne"
}

resource "openstack_blockstorage_volume_v3" "test_volume" {
  name     = "test_volume"
  size     = 50
  image_id = "some_uuid"
}

resource "openstack_compute_instance_v2" "test_compute" {
  name            = "test_compute"
  flavor_id       = "some_id"
  user_data       = "user_data_text"

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.test_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    id = "some_uuid"
  }
}


