module Google
  module Helpers
    # Mime decode for ruby 1.9 (can´t find a ruby lib or gem for this)
    def self.mime_decode( input, out_charset = 'utf-8' )
      begin
        input.sub!(/(=\?[A-Za-z0-9_-]+\?[BQbq]\?[^\?]+\?=)(?:(?:\r\n)?[\s\t])+(=\?[A-Za-z0-9_-]+\?[BQbq]\?[^\?]+\?=)/, '\1\2')
        input.gsub!(/_/, " ")
        ret = input.sub!( /=\?([A-Za-z0-9_-]+)\?([BQbq])\?([^\?]+)\?=/ ) {
          charset = $1
          enc = $2.upcase
          word = $3
          word = word.unpack( { "B"=>"m*", "Q"=>"M*" }[enc] ).first
          # Iconv.conv( out_charset + "//IGNORE", charset, word )
          word.encode( out_charset, charset, :undef=>:replace, :invalid=>:replace )
        }
        return ret ? mime_decode( input ) : input
      rescue
        # "Error while converting MIME string."
        return input
      end
    end
  end
end