class CiteprocJava < Formula
  desc "A Citation Style Language (CSL) processor for Java"
  homepage "https://michel-kraemer.github.io/citeproc-java/"
  url "https://github.com/michel-kraemer/citeproc-java/releases/download/2.0.0/citeproc-java-tool-2.0.0.zip"
  sha256 "9c07cf0fbb6858398ed361ef1060aa7812b309e89f9d57f515dc878af9e1e41b"

  bottle :unneeded

  resource "j2v8" do
    url "https://search.maven.org/remotecontent?filepath=com/eclipsesource/j2v8/j2v8_macosx_x86_64/4.6.0/j2v8_macosx_x86_64-4.6.0.jar", :using => :nounzip
    sha256 "7d944fb89aa16ac50edc1914307cfba9af41f8cfd2882a00bdafe837f08404ab"
  end

  def install
    # delete windows batch file
    rm_f Dir["bin/*.bat"]

    # copy required directories
    libexec.install %w[bin lib]

    # make symlink
    binfile = "#{libexec}/bin/citeproc-java"
    bin.install_symlink binfile

    # copy J2V8 library
    resource("j2v8").stage { cp "j2v8_macosx_x86_64-4.6.0.jar", "#{libexec}/lib/" }

    # add J2V8 library to classpath
    text = File.read(binfile)
    text = text.gsub(/^(CLASSPATH)=(.+)/, '\1=$APP_HOME/lib/j2v8_macosx_x86_64-4.6.0.jar:\2')
    File.open(binfile, "w") { |file| file.puts text }
  end

  test do
    (testpath/"references.bib").write <<-EOS.undent
      @inproceedings{kraemer-2014,
        author    = {Kraemer, Michel},
        title     = {Controlling the Processing of Smart City Data in the Cloud with Domain-Specific Languages},
        booktitle = {Proceedings of the 7th International Conference on Utility and Cloud Computing (UCC)},
        series    = {UCC '14},
        year      = {2014},
        isbn      = {978-1-4799-7881-6},
        location  = {London, UK},
        pages     = {824},
        numpages  = {6},
        publisher = {IEEE}
      }
    EOS
    output = shell_output("#{bin}/citeproc-java bibliography -i references.bib -s acm-siggraph -l en-GB")
    assert_equal "Kraemer, M. 2014. Controlling the Processing of Smart City Data in the Cloud with Domain-Specific Languages. Proceedings of the 7th International Conference on Utility and Cloud Computing (UCC), IEEE, 824.\n\n", output
  end
end
