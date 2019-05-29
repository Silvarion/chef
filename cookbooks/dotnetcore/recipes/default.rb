#
# Cookbook:: dotnetcore
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#

if node['os'] == 'linux'
    case node['platform_family']
    # RedHat Based Distros
    when 'rhel'
        case node['platform']
        # CentOS
        when 'centos','oracle'
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
        # Fedora
        when 'fedora' 
            execute 'import-ms-key' do
                command 'rpm --import https://packages.microsoft.com/keys/microsoft.asc'
                action :run
            end
            remote_file "/etc/yum.repos.d/microsoft-prod.repo" do
                source "https://packages.microsoft.com/config/<%= node.platform %>/<%= node.platform_version %>/prod.repo"
                action :create
            end        
            execute 'update-dnf-cache' do
                command 'dnf update'
                action :nothing
            end
        end
    # Debian Based Distros
    when 'debian'
        case node['platform']
        # Ubuntu
        when 'ubuntu'
            remote_file "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.rpm" do
            source "https://packages.microsoft.com/config/ubuntu/<%= node.platform_version %>/packages-microsoft-prod.deb"
            action :create
            end        
            dpkg_package "ms-repo-prod-deb" do
                source "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.deb"
                action :install
                notifies :update, 'apt-update[update-apt-cache]', :immediate
            end
            apt_update 'update-apt-cache' do
                ignore_failure true
                action :nothing
            end
        end
    end
    # Every Distro
    package 'dotnet-core' do
        name 'dotnet-sdk-2.2'
        action :install
    end
end