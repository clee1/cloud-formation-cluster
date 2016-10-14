name "ambari-server"
description "A role for the ambari server."
run_list "recipe[postgresql::client]",
         "recipe[selinux::disabled]",
         "recipe[common::default]",
         "recipe[ambari-server::default]",
         "recipe[selinux::enabled]"
override_attributes({
  "starter_name" => "Eugen Prokhorenko",
})
