#
# Cookbook:: dotnetcore
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#

if node['platform_family'] == 'rhel' do
    case node['platform']
    when 'centos' do
        
    end
elsif node['platform_family'] ==  'debian' do
elsif node['platform_family'] ==  'windows' do
end