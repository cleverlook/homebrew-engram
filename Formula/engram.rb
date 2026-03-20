class Engram < Formula
  desc "Persistent structured memory for AI agents"
  homepage "https://github.com/cleverlook/engram"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-aarch64-apple-darwin.tar.xz"
      sha256 "cf1c3ce43f39672bf411541b1f467ab21ca3fc70fa3f2a4962b4df8ec8179d0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-x86_64-apple-darwin.tar.xz"
      sha256 "419725c1c8be7811ae343905b3914cbcc371f4d0e7ebfe0f241db9cc7ac0df5a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dbb2817189700fab4eafa0d22776edf376695faceb4f9b3751cdcb3e8b9d2958"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7576e1347f829164f56346c7332928f963d7837d4e9dd6dc25868fa46149216e"
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
