class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.0.tar.gz"
  sha256 "0d9ade222c64e912d6957b11c923e214e2e010a18f39bec102f572e693ba2867"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e8962c7923904213f312c86372b670b6b5a7ac7103ee63254ab3d1c349913246"
    sha256 cellar: :any,                 big_sur:       "eae17621cfc664d6e527a6d6aa6a000343eced0f60c81b4e2dd9a9aed7b79c3f"
    sha256 cellar: :any,                 catalina:      "571d031a8fe1b96f68c4c50c2e72532adbad273c565420cb0825cf4745f512bc"
    sha256 cellar: :any,                 mojave:        "8089b1b5c398c95af5eaacea6033829dd8d255c9f32d6fa2f0c436821c902087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f3d0c3e35229b4b9d32a2315f061651ee1cf88e2d5216ec259f2aece4dafb3" # linuxbrew-core
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    cd "build/cmake" do
      system "cmake", "-S", ".", "-B", "builddir",
                      "-DZSTD_BUILD_CONTRIB=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "builddir"
      system "cmake", "--install", "builddir"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
