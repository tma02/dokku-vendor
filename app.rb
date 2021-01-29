require 'sinatra'
require 'ap'
require "open-uri"
require 'logger'

set :logger, Logger.new(STDOUT)

DOWNLOAD_DIR = "/tmp/dokku-vendor/"
JVM_VENDOR_URL = "https://buildpacks.s3.amazonaws.com/buildpacks/heroku/jvm.tgz"

get '/jvm.tgz' do
  send_file get_file()
end

def get_file()
  absolute_dir_path = DOWNLOAD_DIR + "/"
  absolute_file_path = absolute_dir_path + "/jvm.tgz"

  if File.exists?(absolute_file_path)
    return absolute_file_path
  else
    logger.info "NO FILE - DOWNLOAD"
    FileUtils.mkdir_p  absolute_dir_path unless File.exists?(absolute_dir_path) # Create dir first
    remote_url = VENDOR_URL
    download_file(absolute_file_path, remote_url)
    get_file()
  end
end

def download_file(local_path, remote_url)
  logger.info "DOWNLOADING FILE"
  logger.info remote_url
  File.open(local_path, "w") do |f|
    IO.copy_stream(open(remote_url), f)
  end

end
