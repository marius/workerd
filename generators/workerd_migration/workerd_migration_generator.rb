class WorkerdMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'migration_template.rb', 'db/migrate', :assigns => {
        :migration_name => "CreateWorkpieces"
      }, :migration_file_name => "create_workpieces"
    end
  end
end
