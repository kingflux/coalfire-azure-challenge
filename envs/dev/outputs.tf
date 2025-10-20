output "lb_public_ip" {
  value = module.lb.public_ip
}

output "management_vm_ip" {
  value = module.compute.mgmt_public_ip
}
