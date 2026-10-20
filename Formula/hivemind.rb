class Hivemind < Formula
  desc "Run CLI agents on several Macs over the home WiFi"
  homepage "https://github.com/akhil-gautam/hivemind"
  url "https://github.com/akhil-gautam/hivemind.git", tag: "v0.2.0"
  version "0.2.0"
  license "MIT"

  def install
    cargo = ENV["PATH"].to_s.split(File::PATH_SEPARATOR)
                  .map { |dir| File.join(dir, "cargo") }
                  .find { |path| File.executable?(path) }
    raise "cargo not found — install Rust first (brew install rust)" if cargo.nil?

    # Keep the build out of the user's ~/.cargo
    ENV["CARGO_HOME"] = buildpath/".cargo-home"
    system cargo, "install", "--path", ".", "--locked", "--root", staging_dir
    bin.install Dir["#{staging_dir}/bin/hivemind"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hivemind version")
  end
end
