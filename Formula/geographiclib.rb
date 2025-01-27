class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.52.tar.gz"
  sha256 "5d4145cd16ebf51a2ff97c9244330a340787d131165cfd150e4b2840c0e8ac2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "302202edfb516879e561d78a6cf81a3476aba292f1a6cf23bb272c9a60bc301c"
    sha256 cellar: :any,                 big_sur:       "13facfd20eec2fe0a6ad291a0090a4e66b38e74830306b69cca5ac54674c0072"
    sha256 cellar: :any,                 catalina:      "beeca9653f64dc20bdd907fdeae179d53c9b1cf58590b452f5f02f1d70a7905b"
    sha256 cellar: :any,                 mojave:        "c10d4bb46beafe818efa240b7dd7916e0dc2a9567dcef0a26823e564e1e679b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accb1d1f54f636d5a410f4d0ec9ce6a268e74f20d8d428dcf1acc95fcc8d5b37" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
