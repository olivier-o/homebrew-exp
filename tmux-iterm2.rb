require 'formula'
 
class TmuxIterm2 < Formula
  url 'https://github.com/olivier-o/homebrew-exp/blob/master/iTerm2-1_0_0_20130210-tmux.zip'
  sha1 '0a91aea192a3160934a1f17f8a66ffdc0cf07a85'
  head 'git://tmux.git.sourceforge.net/gitroot/tmux/tmux'
 
  depends_on 'pkg-config' => :build
  depends_on 'libevent'
 
  if build.head?
    depends_on :automake
    depends_on :libtool
  end
 
  def install
    puts `pwd`
    system "tar -xvf tmux-for-iTerm2-20130210.tar.gz"
    
    Dir.chdir "tmux" do
      system "sh", "autogen.sh" if build.head?
      
      ENV.append "LDFLAGS", "-lresolv"
      system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--sysconfdir=#{etc}"
      system "make install"
      
      # Install bash completion scripts for use with bash-completion
      (prefix+'etc/bash_completion.d').install "examples/bash_completion_tmux.sh" => 'tmux-iterm2'
      
      # Install addtional meta file
      prefix.install 'NOTES'
    end   
  end
 
  def caveats; <<-EOS.undent
    Additional information can be found in:
      #{prefix}/NOTES
    EOS
  end
 
  def test
    system "#{bin}/tmux", "-V"
  end
end
