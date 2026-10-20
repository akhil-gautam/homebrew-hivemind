class Hivemind < Formula
  desc "Run CLI agents on several Macs over the home WiFi"
  homepage "https://github.com/akhil-gautam/hivemind"
  url "https://github.com/akhil-gautam/hivemind/archive/refs/tags/v0.2.0.tar.gz"
  version "0.2.0"
  sha256 "48fb24250609e160379018d56dc84e57342ab569c94d3b39dd4441dbd3a56efc"
  license "MIT"

  on_linux do
    depends_on "rust" => :build
  end

  on_arm do
    # Apple silicon: install the published binary, no toolchain needed.
    # The asset is fetched through the API because the repository is private.
    on_macos do
      url "https://api.github.com/repos/akhil-gautam/hivemind/releases/assets/659872562"
      sha256 "aa7f2412a4b414471b751ce59e00fcf2ea6270eb931a76afc584cde67cf54280"
    end
  end

  on_intel do
    on_macos do
      depends_on "rust" => :build
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install Dir["*"].find { |f| File.file?(f) } => "hivemind"
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
