#
# Cookbook:: dotnetcore
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#

if node['os'] == 'linux' do
    case node['platform_family']
    when 'rhel' do
        case node['platform']
        when 'centos','oracle' do
            remote_file "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.rpm" do
                source "https://packages.microsoft.com/config/rhel/<%= node.platform_version.split('.')[0] %>/packages-microsoft-prod.rpm"
                action :create
            end        
            rpm_package "ms-repo-prod-rpm" do
                source "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.rpm"
                action :install
                notifies :run, 'execute[update-yum-cache]', :immediate
            end
            execute 'update-yum-cache' do
                command 'yum makecache -y'
                action :nothing
            end
        end
    end
    when  'debian' do
        case node['platform']
        when 'ubuntu' do
            remote_file "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.rpm" do
            source "https://packages.microsoft.com/config/ubuntu/<%= node.platform_version %>/packages-microsoft-prod.deb"
            action :create
        end        
        dpkg_package "ms-repo-prod-deb" do
            source "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.deb"
            action :install
            notifies :run, 'execute[update-apt-cache]', :immediate
        end
        execute 'update-apt-cache' do
            command 'apt-get update -y'
            action :nothing
        end
        when 'debian' do
        end
    end
end