require 'rails/generators'
require 'rails/generators/migration'

module Statusable
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("templates", __dir__)
      argument :name, type: :string, default: ''

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def build_model
        # template   "create_dynamic_model.erb","app/models/#{namespace}_dynamic_model.rb"
        if !name.empty?
          create_file "app/models/#{name.downcase}/status.rb","class #{name.capitalize}::Status < ApplicationRecord
end"
        else
          create_file "app/models/status.rb","class Status < ApplicationRecord
end"
        end
      end
      def copy_migrations
        ERB.new(File.read(File.expand_path("../..", __FILE__) + '/install/templates/create_status.erb')).run(binding())
        if !name.empty?
          migration_template "create_status.erb", "db/migrate/create_#{name.downcase}_statuses.rb"
        else
          migration_template "create_status.erb", "db/migrate/create_statuses.rb"
        end
      end
    end
  end
end