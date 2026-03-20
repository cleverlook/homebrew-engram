class Engram < Formula
  desc "Persistent structured memory for AI agents"
  homepage "https://github.com/cleverlook/engram"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-aarch64-apple-darwin.tar.xz"
      sha256 "ec2665280191eccfc9aac79e4188cd9612b8dbaaeb5d78da5bcf7a0d7fc4d936"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-x86_64-apple-darwin.tar.xz"
      sha256 "dd663ad14dc4e90402255ceb847ecf68ddc8203e5aedc9d0d838e5be0e11fa12"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62c49d5de4f7d228959d1e4e2df0a9579464542c11f4a69434678bd9f799319c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cleverlook/engram/releases/download/v0.2.2/engram-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d37de0d54d287bcadb40e89441a4e24c66cef5a8b1047008dad9f9f6ecd26b8"
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

    generate_completions_from_executable(bin/"engram", "completion")
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

    generate_completions_from_executable(bin/"engram", "completion")

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
