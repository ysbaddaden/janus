module Janus
  def self.version
    Gem::Version.new File.read(File.expand_path('../../../VERSION', __FILE__))
  end

  module VERSION
    MAJOR, MINOR, TINY, PRE = Janus.version.segments
    STRING = Janus.version.to_s
  end
end
