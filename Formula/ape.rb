class Ape < Formula
  desc "Ajax Push Engine"
  homepage "https://web.archive.org/web/20200810042306/www.ape-project.org/"
  url "https://github.com/APE-Project/APE_Server/archive/v1.1.2.tar.gz"
  sha256 "c5f6ec0740f20dd5eb26c223149fc4bade3daadff02a851e2abb7e00be97db42"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, high_sierra:  "54387a0a2a38314a0def581f67c517d9ff7f82efd431e9811cf774cf235850a3"
    sha256 cellar: :any_skip_relocation, sierra:       "dd095fa1465e0a20613481720e26a5917c08882b340a18ab4d351a95e5eb3a3e"
    sha256 cellar: :any_skip_relocation, el_capitan:   "259b19e211ff6d6ffc376db0b3696a912a6ac48dca83cbcbe525c78e56755c82"
    sha256 cellar: :any_skip_relocation, yosemite:     "3859216e566e6faaccc7183d737527dd4785260a698c8344520e7951baebca76"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "./build.sh"
    # The Makefile installs a configuration file in the bindir which our bot red-flags
    (prefix+"etc").mkdir
    inreplace "Makefile", "bin/ape.conf $(bindir)", "bin/ape.conf $(prefix)/etc"
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats
    <<~EOS
      The default configuration file is stored in #{etc}. You should load aped with:
        aped --cfg #{etc}/ape.conf
    EOS
  end

  test do
    system "#{bin}/aped", "--version"
  end
end
