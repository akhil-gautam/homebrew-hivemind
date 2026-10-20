class Hivemind < Formula
  desc "Run CLI agents on several Macs over the home WiFi"
  homepage "https://github.com/akhil-gautam/hivemind"
  # The repository is public, so the source is cloned over plain HTTPS: no
  # token, no SSH key, no credential helper.
  url "https://github.com/akhil-gautam/hivemind.git", tag: "v0.4.1"
  version "0.4.1"
  license "MIT"

  def install
    # Homebrew builds with a trimmed PATH that hides brew itself, which the
    # rustc shim needs to find the real compiler.
    ENV["PATH"] = "#{HOMEBREW_PREFIX}/bin:#{ENV["PATH"]}"

    # Homebrew also points HOME at a temp dir during the build, so look up the
    # real home to find a rustup install in ~/.cargo.
    real_home = Etc.getpwuid.dir

    candidates = [
      ENV["CARGO"],
      File.join(HOMEBREW_PREFIX.to_s, "bin", "cargo"),
      File.join(real_home, ".cargo", "bin", "cargo"),
    ].compact
    candidates.concat(ENV["PATH"].to_s.split(File::PATH_SEPARATOR).map { |dir| File.join(dir, "cargo") })
    cargo = candidates.find { |path| File.executable?(path) }
    raise "cargo not found — install Rust first (brew install rust)" if cargo.nil?

    # Homebrew's rustc wrapper execs `rustc` from PATH; keep it beside cargo.
    ENV.prepend_path "PATH", File.dirname(cargo)

    # rustup's proxies locate toolchains via RUSTUP_HOME, which defaults to
    # $HOME/.rustup and so misses the real install under the temp HOME.
    rustup_home = File.join(real_home, ".rustup")
    ENV["RUSTUP_HOME"] ||= rustup_home if File.directory?(rustup_home)

    # Keep the build out of the user's ~/.cargo
    ENV["CARGO_HOME"] = buildpath/".cargo-home"
    system cargo, "install", "--path", ".", "--locked", "--root", buildpath/"cargo-install"
    bin.install Dir["#{buildpath}/cargo-install/bin/hivemind"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hivemind version")
  end
end
