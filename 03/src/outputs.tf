output "all_vms_list" {
  description = "A combined list of all VMs with name, id, and fqdn."
  value       = local.combined_vms_data
}