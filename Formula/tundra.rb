class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.16.3.tar.gz"
  sha256 "25c2649cd415996a5d8fdc4efc39345bd4d44a042a15c93c2a0523703b98f766"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7ab1c12b2e4655c43d05d0a2e3d7c639b0ba3f525ce19ccd63f0c1b5232b139"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6b590396609eca11fc3d11a092d6354ce9ab2b56ac00b0ce19c1066740b67d1"
    sha256 cellar: :any_skip_relocation, catalina:      "5300a0ef420db061926f21228da36eb747c8553cba76e48c86832f86cbbda0fa"
    sha256 cellar: :any_skip_relocation, mojave:        "c2faa7134fd8cebc4a1552c2b5c772ed9f15024b5f8d9c9f7ec2a0123e74a23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92cf1e4b2c39cc0e915a45e445cf4a6eab3035d921172b8907ab4b99009a86c0" # linuxbrew-core
  end

  depends_on "googletest" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["googletest"].opt_include}/googletest/googletest"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS

    os, cc = if OS.mac?
      ["macosx", "clang"]
    else
      ["linux", "gcc"]
    end

    (testpath/"tundra.lua").write <<~EOS
      Build {
        Units = function()
          local test = Program {
            Name = "test",
            Sources = { "test.c" },
          }
          Default(test)
        end,
        Configs = {
          {
            Name = "#{os}-#{cc}",
            DefaultOnHost = "#{os}",
            Tools = { "#{cc}" },
          },
        },
      }
    EOS
    system bin/"tundra2"
    system "./t2-output/#{os}-#{cc}-debug-default/test"
  end
end
