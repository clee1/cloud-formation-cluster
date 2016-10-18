# See https://docs.chef.io/aws_marketplace.html/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "<NODE_NAME>"
client_key               "#{current_dir}/<CLIENT_KEY>"
chef_server_url          "https://<CHEF_SERVER_URL>/organizations/<ORGANIZATION_NAME>"
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:editor] = "vim"
