class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.5.tar.gz"
  sha256 "3c1d0db7d76ac357bb183f872b71b3534e367b3ee4cfb18109039ed4b3d43623"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "a8e1b2d2cba528d3a8d3bfa6e1cdc970b4c1cd9a026bf244afbdcd25dc7a8aec" => :big_sur
    sha256 "d09504ae0d5898e9c37bd69b6c6789c0dd2b9edc877352a45c4cf92a0cf79e36" => :catalina
    sha256 "bbb8b1961637515db490f813dcbdab24a4d76ea1bcf48344292d74bda072f6d0" => :mojave
    sha256 "4e2713758ecf6fb7154ef49d2e9be0a5d96b0efe270c0d4798afe94fea1ba1f4" => :x86_64_linux
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  # Don't install service files
  on_linux do
    patch :DATA
  end

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 54b3b291..72fd1088 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -316,27 +316,6 @@ if(FLB_BINARY)
     ENABLE_EXPORTS ON)
   install(TARGETS fluent-bit-bin RUNTIME DESTINATION ${FLB_INSTALL_BINDIR})

-  # Detect init system, install upstart, systemd or init.d script
-  if(IS_DIRECTORY /lib/systemd/system)
-    set(FLB_SYSTEMD_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.service")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/systemd.in"
-      ${FLB_SYSTEMD_SCRIPT}
-      )
-    install(FILES ${FLB_SYSTEMD_SCRIPT} DESTINATION /lib/systemd/system)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR})
-  elseif(IS_DIRECTORY /usr/share/upstart)
-    set(FLB_UPSTART_SCRIPT "${PROJECT_SOURCE_DIR}/init/${FLB_OUT_NAME}.conf")
-    configure_file(
-      "${PROJECT_SOURCE_DIR}/init/upstart.in"
-      ${FLB_UPSTART_SCRIPT}
-      )
-    install(FILES ${FLB_UPSTART_SCRIPT} DESTINATION /etc/init)
-    install(DIRECTORY DESTINATION ${FLB_INSTALL_CONFDIR})
-  else()
-    # FIXME: should we support Sysv init script ?
-  endif()
-
   install(FILES
     "${PROJECT_SOURCE_DIR}/conf/fluent-bit.conf"
     DESTINATION ${FLB_INSTALL_CONFDIR}
