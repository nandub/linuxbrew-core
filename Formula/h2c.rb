class H2c < Formula
  desc "Headers 2 curl"
  homepage "https://curl.se/h2c/"
  url "https://github.com/curl/h2c/archive/refs/tags/1.0.tar.gz"
  sha256 "1c5e4d76131abb5151c89cc54945256509dad9d12cab36205aa5bcd7f8a311af"
  license "MIT"

  def install
    bin.install "h2c"
  end

  test do
    assert_match "h2c.pl [options] < file", shell_output("h2c --help")

    # test if h2c can convert HTTP headers to curl options.
    assert_match "curl --head --http1.1 --header Accept: --header \"Shoesize: 12\" --user-agent \"moo\" https://example.com/",
      shell_output("echo 'HEAD  / HTTP/1.1\nHost: example.com\nUser-Agent: moo\nShoesize: 12' | h2c")
  end
end
