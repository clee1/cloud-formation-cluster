name "ambari-agent"
description "A role for the ambari server."
run_list "recipe[selinux::disabled]",
         "recipe[common::default]",
         "recipe[ambari-agent::default]",
         "recipe[selinux::enforcing]"
override_attributes({
  "starter_name" => "Eugen Prokhorenko",
})
