module PhoneGapRepo
  @@BASE_URL = "http://github.com/phonegap/phonegap-PLATFORM.git".freeze
  
  def self.url_for name
    @@BASE_URL.sub("PLATFORM", name.to_s) 
  end
end

class PhoneGapVersionNumber
  include Comparable
  attr_accessor :string_rep, :major, :global, :minor, :patch
  
  def initialize version_string
    @string_rep = version_string
    components = @string_rep.split(".")
    
    @major    = components.shift.to_i
    @global   = components.shift.to_i
    @minor    = components.shift.to_i
    @patch    = components.shift.to_i
  end
  
  def <=> other
    val = major   <=> other.major
    val = global  <=> other.global  if val == 0
    val = minor   <=> other.minor   if val == 0
    val = patch   <=> other.patch   if val == 0
    val
  end
  
  def same_global other
    major == other.major && global == other.global
  end
end

# when called directly
if $*.length >= 2
  directory = $*.shift
  `mkdir #{directory}`

  target_version = PhoneGapVersionNumber.new $*.shift

  %w(iphone android blackberry symbian.wrt palm winmo).each do |platform|
    `git clone #{PhoneGapRepo.url_for platform} #{directory}/#{platform}`
    tags = `cd #{directory}/#{platform} && git tag`
    
    versions = []
    tags.each { |tag| versions.push PhoneGapVersionNumber.new tag.rstrip }

    puts platform
    p versions
  end

  p target_version
end