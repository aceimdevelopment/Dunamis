@@ -49,7 +49,12 @@ def self.setup_rvm(app_name)
  abort "Rvm version 1.10.2 or greater is required. Run 'rvm get stable'"
end

if rvm_version < Gem::Version.new('1.12.0')

  # RVM's ruby drivers were factored out into a gem
  # in 1.12.0, so you don't use this trick anymore.
  # $LOAD_PATH.unshift "#{ENV['rvm_path']}/lib"
  $LOAD_PATH.unshift rvm_lib_path
end
require 'rvm'
env = RVM::Environment.current