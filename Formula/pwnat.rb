class Pwnat < Formula
  desc "Proxy server that works behind a NAT"
  homepage "https://samy.pl/pwnat/"
  url "https://samy.pl/pwnat/pwnat-0.3-beta.tgz"
  sha256 "d5d6ea14f1cf0d52e4f946be5c3630d6440f8389e7467c0117d1fe33b9d130a2"
  license "GPL-3.0"
  head "https://github.com/samyk/pwnat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25630303a2d2434a840a95274ff3063d8cdc702d00d31907d12cc8f1befb7180"
    sha256 cellar: :any_skip_relocation, big_sur:       "84fa7c77483a6aaeaa15e2b6514478bc0c1a292c001cf1e7a1fa82490a7dfd0c"
    sha256 cellar: :any_skip_relocation, catalina:      "51a038c40431d552b19beb59e14de49984923d216b5d411646a32a2caed1eff8"
    sha256 cellar: :any_skip_relocation, mojave:        "483e476edd037e89dc1c24fbf115132a815a9a4d6fcb987ceea6a4c07a5944da"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3a4bf09acd5eda4e54fbe21d0028948613fa398a3a1272722957079a9f18c836"
    sha256 cellar: :any_skip_relocation, sierra:        "f8319cece67a334c14129e706f9d1b249d7905cf1ad62df9b5ee9553dbb8d001"
    sha256 cellar: :any_skip_relocation, el_capitan:    "0149fc977622f2fd55db5845a377437028df31bb847230d3fd73d548e481e289"
    sha256 cellar: :any_skip_relocation, yosemite:      "cf17568c4053240ffe61594bcc618577c0d0c569abda8b3b956a4e4b441a755e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e574797edcea5484ea15e3c11a273386bcaa84e4b8552914a5eb89bc3b14c27" # linuxbrew-core
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=-lz"
    bin.install "pwnat"
  end

  test do
    shell_output("#{bin}/pwnat -h", 1)
  end
end
