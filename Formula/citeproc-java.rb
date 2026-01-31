class CiteprocJava < Formula
  desc "A Citation Style Language (CSL) processor for Java"
  homepage "https://github.com/michel-kraemer/citeproc-java"
  url "https://github.com/michel-kraemer/citeproc-java/releases/download/3.4.1/citeproc-java-tool-3.4.1.zip"
  sha256 "ba638b238c2330cd534e79228e372fe04925d1c7308fa3de96671c443eefb1de"

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
    (testpath/"references.bib").write <<~EOS
      @article{kraemer-bormann-wuerz-kocon-frechen-schmid-2024,
      author   = {Michel Krämer and Pascal Bormann and Hendrik M. Würz and Kevin
        Kocon and Tobias Frechen and Jonas Schmid},
      title    = {A cloud-based data processing and visualization pipeline for the
        fibre roll-out in Germany},
      journal  = {Journal of Systems and Software},
      year     = {2024},
      volume   = {211},
      pages    = {112008},
      issn     = {0164-1212},
      doi      = {10.1016/j.jss.2024.112008}
    }
    EOS
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    output = shell_output("#{bin}/citeproc-java bibliography -i references.bib -s apa -l en-GB")
    assert_equal "Krämer, M., Bormann, P., Würz, H. M., Kocon, K., Frechen, T., & Schmid, J. (2024). A cloud-based data processing and visualization pipeline for the fibre roll-out in Germany. Journal of Systems and Software, 211, 112008. https://doi.org/10.1016/j.jss.2024.112008\n\n", output
  end
end
