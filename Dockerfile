FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && \
    apt-get install -yq \
    xz-utils \
    curl \
    sudo \
    wget \
    git \
    jq \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Create user rick and add to sudo
RUN useradd -m -s /bin/bash rick && \
    adduser rick sudo && \
    echo "rick ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rick

# Switch to rick user, for the env $USER to be set
USER rick
ENV USER=rick
WORKDIR /home/rick

# Setup local bin directory and PATH
RUN mkdir -p ~/.local/bin && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile

# Install Nix
SHELL ["/bin/bash", "-l", "-c"]

RUN curl -L https://nixos.org/nix/install | sh -s -- --no-daemon


 RUN nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && \
     nix-channel --update

 # Set environment variable
 ENV CHEZMOI_MODE=home

 # Install dotfiles and setup home-manager
 RUN curl -fsLS https://raw.githubusercontent.com/y0ug/dotfiles/refs/heads/main/install.sh | sh && \
     nix shell nixpkgs#home-manager --command home-manager switch --flake ~/.config/home-manager/
#
# # Source profile in every new shell
# # RUN echo "source ~/.profile" >> ~/.bashrc
#
# # Set entrypoint to bash
ENTRYPOINT ["/bin/bash"]
