class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.8.6.tar.gz"
  sha256 "cbe3764afe2148b8047ea7e5cbba5108c298dee3a9a0391028e2980e35beaa2b"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9696e41f85e4be4a6f0ee5de98b5d4806cdce64df2218edab13dfaf6f1a1d1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c0da46e2f2b03f87c132bac4010dcd680ecae94350a28a071bfef996d86d772"
    sha256 cellar: :any_skip_relocation, catalina:      "2baa47d5beedf925d7595174c93491fe87717b891e922c923d9a2e70c1ce2107"
    sha256 cellar: :any_skip_relocation, mojave:        "f11cd09d935549bfe50c61520ae674ff4e5e559b065f11fc731ede96d0952213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5972422a2caae4368304b18b3d289eb25aab80283f9f9327c4179ee2a0cf18" # linuxbrew-core
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/coredns</string>
            <string>-conf</string>
            <string>#{etc}/coredns/Corefile</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/coredns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/coredns.log</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
