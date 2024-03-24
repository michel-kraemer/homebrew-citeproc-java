class CiteprocJava < Formula
  desc "A Citation Style Language (CSL) processor for Java"
  homepage "https://github.com/michel-kraemer/citeproc-java"
  url "https://github.com/michel-kraemer/citeproc-java/releases/download/3.0.0/citeproc-java-tool-3.0.0.zip"
  sha256 "40da6788b5c7d7101a2fcf3940d5252a8c353851f5bcf05a450deb9c30185028"

  def install
    # delete windows batch file
    rm_f Dir["bin/*.bat"]

    # copy required directories
    libexec.install %w[bin lib]

    # make symlink
    binfile = "#{libexec}/bin/citeproc-java"
    bin.install_symlink binfile
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
