class Swiftlings < Formula
  desc "Small exercises to get you used to reading and writing Swift code"
  homepage "https://github.com/tornikegomareli/swiftlings"
  url "https://github.com/tornikegomareli/swiftlings/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "49832035d1039fdd8862c162db5f6828d7b65df21b53a3ace4edc4134953f90e"
  license "MIT"
  head "https://github.com/tornikegomareli/swiftlings.git", branch: "main"

  depends_on xcode: ["14.0", :build]
  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swiftlings"
  end

  test do
    system "#{bin}/swiftlings", "--version"
  end
end