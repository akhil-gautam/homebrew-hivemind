class Hivemind < Formula
  desc "Run CLI agents on several Macs over the home WiFi"
  homepage "https://github.com/akhil-gautam/hivemind"
  url "git@github.com:akhil-gautam/hivemind.git", tag: "v0.2.0"
  version "0.2.0"
  license "MIT"

  depends_on "rust" => :build

  def install
    # Keep the build out of the user's ~/.cargo
    ENV["CARGO_HOME"] = buildpath/".cargo-home"
    system "cargo", "install", "--path", ".", "--locked", "--root", staging_dir
    bin.install Dir["#{staging_dir}/bin/hivemind"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hivemind version")
  end
end
