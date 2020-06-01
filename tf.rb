require 'awesome_print'

def tf11
  '/usr/local/opt/terraform@0.11/bin/terraform'
end

def tf12
  '/usr/local/opt/terraform@0.12/bin/terraform'
end

plan11 = <<END
+ aws_instance.example
      id:                               <computed>
      ami:                              "ami-abc123"
      arn:                              <computed>
      associate_public_ip_address:      <computed>
      availability_zone:                <computed>
      cpu_core_count:                   <computed>
      cpu_threads_per_core:             <computed>
      ebs_block_device.#:               <computed>
      ephemeral_block_device.#:         <computed>
      get_password_data:                "false"
      host_id:                          <computed>
      instance_state:                   <computed>
      instance_type:                    "t2.micro"
      ipv6_address_count:               <computed>
      ipv6_addresses.#:                 <computed>
      key_name:                         <computed>
      metadata_options.#:               <computed>
      network_interface.#:              <computed>
      network_interface_id:             <computed>
      outpost_arn:                      <computed>
      password_data:                    <computed>
      placement_group:                  <computed>
      primary_network_interface_id:     <computed>
      private_dns:                      <computed>
      private_ip:                       <computed>
      public_dns:                       <computed>
      public_ip:                        <computed>
      root_block_device.#:              <computed>
      security_groups.#:                <computed>
      source_dest_check:                "true"
      subnet_id:                        <computed>
      tenancy:                          <computed>
      volume_tags.%:                    <computed>
      vpc_security_group_ids.#:         <computed>

  + aws_vpc.example
      id:                               <computed>
      arn:                              <computed>
      assign_generated_ipv6_cidr_block: "false"
      cidr_block:                       "10.0.0.0/16"
      default_network_acl_id:           <computed>
      default_route_table_id:           <computed>
      default_security_group_id:        <computed>
      dhcp_options_id:                  <computed>
      enable_classiclink:               <computed>
      enable_classiclink_dns_support:   <computed>
      enable_dns_hostnames:             <computed>
      enable_dns_support:               "true"
      instance_tenancy:                 "default"
      ipv6_association_id:              <computed>
      ipv6_cidr_block:                  <computed>
      main_route_table_id:              <computed>
      owner_id:                         <computed>

END


ap TF12Plan.new(File.read('plan12.txt')).to_s
