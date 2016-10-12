# See https://docs.chef.io/aws_marketplace.html/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "eugenzyx"
client_key               "#{current_dir}/eugenzyx.pem"
chef_server_url          "https://ec2-54-175-81-229.compute-1.amazonaws.com/organizations/home"
cookbook_path            ["#{current_dir}/../cookbooks"]
