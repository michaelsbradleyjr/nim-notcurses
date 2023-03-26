# paste into shell prompt provided by e.g. `docker run -it --rm ubuntu`
# this script should be converted into a Dockerfile

# when using emacs in the container, Docker's default binding for the detach
# keys (ctrl-p,q) is annoying, but it can be configured in
# ~/.docker/config.json on the host machine, e.g. `"detachKeys": "ctrl-z,z"`

cd "${HOME}"
echo "export TERM=xterm-256color" >> "${HOME}/.bashrc"
export TERM=xterm-256color
echo "export COLORTERM=24bit" >> "${HOME}/.bashrc"
export COLORTERM=24bit
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -yq software-properties-common
add-apt-repository -y ppa:apt-fast/stable
DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-fast
DEBIAN_FRONTEND=noninteractive apt-fast install --no-install-recommends -yq aspell aspell-en bash-completion build-essential cmake curl doctest doctest-dev emacs-nox ffmpeg git less libavcodec-dev libavformat-dev libdeflate-dev libswscale-dev libtinfo-dev libunistring-dev locales man-db nano pandoc pkg-config vim wget
echo ". /etc/profile.d/bash_completion.sh" >> "${HOME}/.bashrc"
. /etc/profile.d/bash_completion.sh
sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
echo "export LANG=en_US.UTF-8" >> "${HOME}/.bashrc"
export LANG=en_US.UTF-8
yes | unminimize
git clone https://github.com/michaelsbradleyjr/bash-it.git "${HOME}/.bash_it"
cd "${HOME}/.bash_it"
git checkout origin/custom
cd "${HOME}"
echo 'export BASH_IT="${HOME}/.bash_it"' >> "${HOME}/.bashrc"
echo 'export BASH_IT_THEME=nodez' >> "${HOME}/.bashrc"
echo '. ${BASH_IT}/bash_it.sh' >> "${HOME}/.bashrc"
export BASH_IT="${HOME}/.bash_it"
export BASH_IT_THEME=nodez
. "${BASH_IT}/bash_it.sh"
curl -L https://git.io/epre | sh
emacs -batch --eval "(progn (require 'package) (add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t) (package-refresh-contents) (package-initialize) (mapcar (lambda (package) (unless (package-installed-p package) (package-install package))) '(yasnippet nim-mode)))"
echo "(require 'prelude-ivy) (require 'prelude-company) (require 'prelude-c) (require 'prelude-emacs-lisp) (require 'prelude-lisp) (require 'prelude-lsp) (require 'prelude-shell) (provide 'prelude-modules)" > "${HOME}/.emacs.d/personal/prelude-modules.el"
echo "(setq prelude-minimalistic-ui t)" > "${HOME}/.emacs.d/personal/preload/minimalistic.el"
echo "(use-package nim-mode :ensure t :hook (nim-mode . lsp))" > "${HOME}/.emacs.d/personal/nim.el"
emacs -batch -l ~/.emacs.d/init.el
git clone https://github.com/dankamongmen/notcurses.git "${HOME}/repos/notcurses"
cd "${HOME}/repos/notcurses"
git checkout tags/v3.0.9
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j16
cd "${HOME}"
curl -sSf -O https://nim-lang.org/choosenim/init.sh
CHOOSENIM_CHOOSE_VERSION=\#version-1-6 CHOOSENIM_NO_ANALYTICS=1 sh init.sh -y
rm init.sh
echo 'export PATH="${HOME}/.nimble/bin${PATH:+:${PATH}}"' >> "${HOME}/.bashrc"
export PATH="${HOME}/.nimble/bin${PATH:+:${PATH}}"
nimble --accept install nimlangserver
git clone https://github.com/michaelsbradleyjr/nim-notcurses.git "${HOME}/repos/nim-notcurses"
cd "${HOME}/repos/nim-notcurses"
nimble --accept develop
echo 'export LD_LIBRARY_PATH="${HOME}/repos/notcurses/build${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"' >> "${HOME}/.bashrc"
export LD_LIBRARY_PATH="${HOME}/repos/notcurses/build${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
echo && echo nim c --passC:"-I${HOME}/repos/notcurses/include" --passL:"-L${HOME}/repos/notcurses/build" -r examples/cli1.nim && echo
nim c --passC:"-I${HOME}/repos/notcurses/include" --passL:"-L${HOME}/repos/notcurses/build" -r examples/cli1.nim || true
