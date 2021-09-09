class Sqlc < Formula
  desc "Generate type safe Go from SQL"
  homepage "https://sqlc.dev/"
  url "https://github.com/kyleconroy/sqlc/archive/v1.10.0.tar.gz"
  sha256 "04a52021bc11bc0c8a6f600e2c2c49c644e0f8ea2a77d9bf7f5c4339f9e717cb"
  license "MIT"
  head "https://github.com/kyleconroy/sqlc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3cb9142b29b5be3a4a051918c0f7105a54777ba34aab756e3ec30c32d4e54936"
    sha256 cellar: :any_skip_relocation, big_sur:       "57822dbcd38cd5835b0e8d5ae8bed2ed010e925563b47cd0b406cc64f4055ef6"
    sha256 cellar: :any_skip_relocation, catalina:      "7359588cc4700484e7a12867f93a289424100114d9d8af037f36d1a3231091ba"
    sha256 cellar: :any_skip_relocation, mojave:        "4093ef305a8d00ad0acf13a87cd31340f17219560c58ac98b1d4ad2213e8fc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b471dfc087b5eeda437067489e39cb5093467238be5b83125006fa808586058d" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/sqlc"
  end

  test do
    (testpath/"sqlc.json").write <<~SQLC
      {
        "version": "1",
        "packages": [
          {
            "name": "db",
            "path": ".",
            "queries": "query.sql",
            "schema": "query.sql",
            "engine": "postgresql"
          }
        ]
      }
    SQLC

    (testpath/"query.sql").write <<~EOS
      CREATE TABLE foo (bar text);

      -- name: SelectFoo :many
      SELECT * FROM foo;
    EOS

    system bin/"sqlc", "generate"
    assert_predicate testpath/"db.go", :exist?
    assert_predicate testpath/"models.go", :exist?
    assert_match "// Code generated by sqlc. DO NOT EDIT.", File.read(testpath/"query.sql.go")
  end
end
