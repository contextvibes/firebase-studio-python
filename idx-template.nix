{
  pkgs,
  environment ? "python-quick-script",
  ...
}: {
  # Add git to the environment so the bootstrap script can use it.
  packages = [ pkgs.git ];

  bootstrap = ''
    # 1. Copy the selected template directory to a new directory named after the workspace.
    cp -rf ./ ""
    chmod -R +w ""

    # 2. Initialize a git repository inside the new directory.
    (
      cd ""
      echo "--> Initializing Git repository in /home/user/firebase-studio-python..."
      git init -b main
      git config user.email "template@example.com"
      git config user.name "Template Initializer"
      git add .
      git commit -m "feat: initial commit from python-quick-script template"
    )

    # 3. Move the prepared directory to the final output location.
    mv "" ""

    echo "✅ Python script project initialized."
  '';
}
