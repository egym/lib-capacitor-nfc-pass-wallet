{ pkgs, ... }:

{
  cachix.enable = false;

  packages = [
    pkgs.git
    pkgs.jdk17
  ];

  languages.java = {
    enable = true;
    jdk.package = pkgs.jdk17;
  };

  android = {
    enable = true;
    platforms.version = [ "35" ];
    buildTools.version = [ "35.0.0" ];
    ndk.enable = false;
    systemImages.enable = false;
    sources.enable = false;
    googleAPIs.enable = false;
    googleTVAddOns.enable = false;
    emulator.enable = false;
  };

  scripts.gw.exec = ''
    cd packages/capacitor/android
    gradle "$@"
  '';

  enterShell = ''
    mkdir -p .devenv
    ln -sfn "$JAVA_HOME" .devenv/jdk

    if [ -n "$ANDROID_HOME" ]; then
      export ANDROID_SDK_ROOT="$ANDROID_HOME"
    fi

    echo "lib-capacitor-nfc-pass-wallet development environment"
    echo "Java: $(java -version 2>&1 | head -1)"
    echo "ANDROID_HOME: $ANDROID_HOME"
    echo "ANDROID_SDK_ROOT: $ANDROID_SDK_ROOT"
    echo "Android SDK is project-local via devenv"
    echo "Gradle helper: gw <task>"
  '';
}
