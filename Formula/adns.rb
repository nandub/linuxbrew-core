class Adns < Formula
  desc "C/C++ resolver library and DNS resolver utilities"
  homepage "https://www.chiark.greenend.org.uk/~ian/adns/"
  url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-1.6.0.tar.gz"
  sha256 "fb427265a981e033d1548f2b117cc021073dc8be2eaf2c45fd64ab7b00ed20de"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.0-or-later"]
  head "https://www.chiark.greenend.org.uk/ucgi/~ianmdlvl/githttp/adns.git", branch: "master"

  livecheck do
    url "https://www.chiark.greenend.org.uk/~ian/adns/ftp/"
    regex(/href=.*?adns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "12b6d675f6ca3782b27be8c241f104435f649c84aa91e9173914ec79542ea01b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8801de53f606e09e09a2bf27a17d0724cc54557328b859ed337315104eadbcc3"
    sha256 cellar: :any_skip_relocation, catalina:      "d9cc50eec8ac243148a121049c236cba06af4a0b1156ab397d0a2850aa79c137"
    sha256 cellar: :any_skip_relocation, mojave:        "7cf73e25044783cd93ecd28e2e8bfb84f0b2fff3343acf39dff3c5fe68d1c5be"
    sha256 cellar: :any_skip_relocation, high_sierra:   "6cbe64a32b077c9abd61337c51c4e17a2286f9bee04b33f24a5dd762125798d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd38f96459e3ebeaef84eb335a08e2a9fe0d8fe37d4f621bed4b11d35a919b5c" # linuxbrew-core
  end

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dynamic"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/adnsheloex", "--version"
  end
end
