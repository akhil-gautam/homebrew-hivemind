class Hivemind < Formula
  desc "Run CLI agents on several Macs over the home WiFi"
  homepage "https://github.com/akhil-gautam/hivemind"
  version "0.2.0"
  license "MIT"

  # macOS on Apple silicon: install the published binary, no toolchain needed.
  on_macos do
    on_arm64 do
      url "https://github.com/akhil-gautam/hivemind/releases/download/v#{version}/hivemind-aarch64-apple-darwin"
      sha256 "aa7f2412a4b414471b751ce59e00fcf2ea6270eb931a76afc584cde67cf54280"
    end
  end

  # Everywhere else: build from the tagged source.
  url "https://api.github.com/repos/akhil-gautam/hivemind/tarball/v#{version}"
  sha256 "48fb24250609e160379018d56dc84e57342ab569c94d3b39dd4441dbd3a56efc"

  on_macos do
    on_intel do
      depends_on "rust" => :build
    end
  end

  on_linux do
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hivemind-aarch64-apple-darwin" => "hivemind"
    else
      # Keep the build out of the user's ~/.cargo
      ENV["CARGO_HOME"] = buildpath/".cargo-home"
      system "cargo", "install", "--path", ".", "--locked", "--root", staging_dir
      bin.install Dir["#{staging_dir}/bin/hivemind"]
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hivemind version")
  end
end
