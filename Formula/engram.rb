class Engram < Formula
  desc "Persistent structured memory for AI agents"
  homepage "https://github.com/cleverlook/engram"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.3.0/engram-aarch64-apple-darwin.tar.xz"
      sha256 "776182237fcf4eb3f66474e30513926d5b2870fc1ac2bc5deada08c84fc11983"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.3.0/engram-x86_64-apple-darwin.tar.xz"
      sha256 "3e98ccef1e8cefebc81324b0d355f9fe3b0307a6e4e5d8bca92c65768499082f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.3.0/engram-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a155f8cacf092818afe1d0570d617387b7e3c51ff3501814a467752b1f31585a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.3.0/engram-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a13124d18e705868b885d092d15c0a2bc677360bda6cbcdfb9a252e54595249b"
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
