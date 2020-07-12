self: super:
rec {

  python38 = with super; super.python38.override { };

  pythonPackages = python38.pkgs;

  rfd = with self; pythonPackages.buildPythonApplication rec {
    pname = "rfd";
    version = "v0.3.5";

    src = fetchFromGitHub {
      owner = "davegallant";
      repo = "rfd";
      rev = version;
      hash = "sha256:0hg9mgb0hf8ddxbnnrd28a7fxngld7m0fadzidjbj99j0gxvzq6g";
    };

    postPatch = ''
      substituteInPlace requirements.txt --replace "soupsieve<=2.0" "soupsieve"
      substituteInPlace requirements.txt --replace "beautifulsoup4<=4.8.2" "beautifulsoup4"
    '';

    # No tests included
    doCheck = false;

    propagatedBuildInputs = with pythonPackages; [
      beautifulsoup4
      click
      colorama
      requests
      soupsieve
    ];

    passthru.python3 = python3;

    meta = with super.lib; {
      homepage = "https://www.redflagdeals.com/";
      description = "View RedFlagDeals from the command line";
      license = licenses.asl20;
      maintainers = [ ];
    };
  };
}
