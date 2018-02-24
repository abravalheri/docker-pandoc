from pritunl/archlinux:latest
# Use Arch Linux and AUR to get uptodate packages

# Install all the files that can be installed with pacman and create simple
# user to install the remainder
RUN pacman -S --needed --noconfirm base-devel sudo git texlive-most texlive-lang biber && \
    useradd user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

# Try to do everything in one command to minimize image
USER user
RUN cd /tmp && \
    git clone https://aur.archlinux.org/pandoc-bin.git && cd pandoc-bin && makepkg -si --noconfirm && cd .. && \
    git clone https://aur.archlinux.org/pandoc-citeproc-bin.git && cd pandoc-citeproc-bin && makepkg -si --noconfirm && cd .. && \
    git clone https://aur.archlinux.org/pandoc-crossref-bin.git && cd pandoc-crossref-bin && makepkg -si --noconfirm && cd .. && \
    rm -rf pandoc-*

# Set the locale just in case
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Expect working dir to be mounted somewhere
WORKDIR /data
VOLUME ["/data"]

# Avoid typing pandoc everytime
ENTRYPOINT ["pandoc"]

# If no option is passed call for help
CMD ["--help"]
