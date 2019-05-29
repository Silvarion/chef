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
        when 'centos','oracle','rhel'
            case node['platform_version'].split('.')[0]
            when '6'
                remote_file "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.rpm" do
                    source "https://packages.microsoft.com/config/rhel/6/packages-microsoft-prod.rpm"
                    action :create
                end        
            when '7'
                remote_file "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.rpm" do
                    source "https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm"
                    action :create
                end        
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
            case node['platform_version']
            when '27'
                remote_file "/etc/yum.repos.d/microsoft-prod.repo" do
                    source "https://packages.microsoft.com/config/fedora/27/prod.repo"
                    action :create
                end
            when '28'
                remote_file "/etc/yum.repos.d/microsoft-prod.repo" do
                    source "https://packages.microsoft.com/config/fedora/28/prod.repo"
                    action :create
                end
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
            source "https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb"
            action :create
            end        
            dpkg_package "ms-repo-prod-deb" do
                source "#{Chef::Config[:file_cache_path]}/packages-microsoft-prod.deb"
                action :install
                notifies :update, 'apt_update[update-apt-cache]', :immediate
            end
            apt_update 'update-apt-cache' do
                ignore_failure true
                action :nothing
            end
        end
    end
    # Every Distro
    package 'dotnet-sdk-2.1' do
        action :install
    end
end
