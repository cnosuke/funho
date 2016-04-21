module ::ActionView
  module Helpers
    module TextHelper
      AUTO_LINK_RE = %r{
        (?: ((?:ed2k|ftp|http|https|irc|mailto|news|gopher|nntp|telnet|webcal|xmpp|callto|feed|svn|urn|aim|rsync|tag|ssh|sftp|rtsp|afs|file|quiver):)// | www\. )
        [^\s<\u00A0"]+
      }ix
    end
  end
end
