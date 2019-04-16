require 'language_pack/installers/ruby_installer'
require 'language_pack/base'
require 'language_pack/shell_helpers'

class LanguagePack::Installers::HerokuRubyInstaller
  include LanguagePack::ShellHelpers, LanguagePack::Installers::RubyInstaller

  BASE_URL = LanguagePack::Base::VENDOR_URL

  def initialize(stack)
    @fetcher = LanguagePack::Fetcher.new(BASE_URL, stack)
  end

  def fetch_unpack(ruby_version, install_dir, build = false)
    FileUtils.mkdir_p(install_dir)
    Dir.chdir(install_dir) do
      file = "#{ruby_version.version_for_download}.tgz"
      if build
        ruby_vm = "ruby"
        file.sub!(ruby_vm, "#{ruby_vm}-build")
      end
      return @fetcher.fetch_untar(file) unless ruby_version.version_for_download == "ruby-#{ENV['RUBY_VERSION']}"

      # NOTE: use local ruby binary.
      dest_path = "/tmp/build/vendor/#{ruby_version.version_for_download}"
      FileUtils.mkdir_p(dest_path)
      @fetcher.untar("/tmp/binaries/#{file}", dest_path)
    end
  end
end

