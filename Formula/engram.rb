class Engram < Formula
  desc "Persistent structured memory for AI agents"
  homepage "https://github.com/cleverlook/engram"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.0/engram-aarch64-apple-darwin.tar.xz"
      sha256 "e76e21d0af60e73ba6888e1a968032e90e4ec0543cef03ddfcc075369dcb07d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.0/engram-x86_64-apple-darwin.tar.xz"
      sha256 "9215fdc2905a6722b967ee0d1eac08e6adae2d39d94765a80e88d1396074445a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.0/engram-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46981e03d59767ea2ec40aa8a6a48ce927420b509b3c62a70cafdd9078893161"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.0/engram-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "61eae300405bcc53919c727ac500e624c779b2e4b4443aa024035bd4c74365dc"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "engram" if OS.mac? && Hardware::CPU.arm?
    bin.install "engram" if OS.mac? && Hardware::CPU.intel?
    bin.install "engram" if OS.linux? && Hardware::CPU.arm?
    bin.install "engram" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
