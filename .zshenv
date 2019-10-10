typeset -U path fpath manpath

path=(~/bin /sbin /local/tools/R17B01/bin $path)

fpath=(~/.zsh $fpath)
manpath=(~/usr/man $manpath)

#export LANG=C
#export LC_ALL=C
export MANWIDTH=80
export VISUAL='vim'
export EDITOR='vim'
export PAGER=less
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='41'

# export ERL_COMPILER_OPTIONS='[{warn_format,2},compressed,debug_info]'
# export ERL_COMPILER_OPTIONS="[warn_unused_vars,nowarn_shadow_vars,debug_info]"

export BIBINPUTS=".:$HOME/doc/tex:$HOME/luna/HiPE/papers/bibtex"
export TEXINPUTS="$HOME/doc/tex:"

export GZIP='-9'
export ZIPOPT='-9'
export USER=$USERNAME                          # strange zsh      [2003-12-19]

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.arj=01;31:*.bz2=01;31:*.gz=01;31:*.jar=01;31:*.lzh=01;31:*.rar=01;31:*.tar=01;31:*.taz=01;31:*.tbz2=01;31:*.tgz=01;31:*.Z=01;31:*.z=01;31:*.zip=01;31:*.bmp=01;35:*.gif=01;35:*.ico=01;35:*.jpeg=01;35:*.jpg=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.tiff=01;35:*.xbm=01;35:*.xcf=01;35:*.xpm=01;35:*.au=01;35:*.avi=01;35:*.mp3=01;35:*.mpeg=01;35:*.mpg=01;35:*.ogg=01;35:*.wav=01;35:*.xm=01;35'

export LESS='-RXQiz-2'
export LESSCHARDEF='8bcccbcc13bc4b95.33b.'
export LESSBINFMT='*s\%o'
export JLESSKEYCHARSET='latin1'

export CRACKLIB_DICTPATH=/var/cache/cracklib/cracklib_dict

export OOO_FORCE_DESKTOP=gnome
export LM_LICENSE_FILE=5555@135.86.206.75
#export ERL_LIBS=/usr/lib/erlang/lib:$HOME/libs/femto_test/deps

limit coredumpsize 0


#set PATSHOMERELOC to ${PATSHOME}
export PATSHOMERELOC=/local/tools/ats

export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export SBT_HOME=/usr/share/sbt-launcher-packaging/bin/sbt-launch.jar
export SPARK_HOME=/usr/lib/spark
export PYTHONPATH=$SPARK_HOME/python/:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH
export SPARK_LOCAL_IP=127.0.0.1
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin
export _JAVA_OPTIONS='-Dhttp.proxyHost=87.254.212.120 -Dhttp.proxyPort=8080 -Dhttps.proxyHost=87.254.212.120 -Dhttps.proxyPort=8080' 

export ARDUINO_DIR=/local/tools/arduino-1.8.2/
export ARDMK_DIR=/usr/share/arduino
export AVR_TOOLS_DIR=/usr

export PATH=$PATH:$HOME/repo/esp32/xtensa-esp32-elf/bin
export IDF_PATH=$HOME/repo/esp32/esp-idf


export GOROOT=/local/vlad/repo/golang/go
export GOPATH=/local/vlad/repo/golang
export GOBIN=/local/vlad/repo/golang/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN

#export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
#export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
#export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk
#export ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
#export GNUARMEMB_TOOLCHAIN_PATH=/local/vlad/repo/rust/cortex/gcc-arm-none-eabi-8-2018-q4-major/

export PATH=$HOME/.local/bin/:$HOME/opt/julia-1.2.0/bin:$PATH
#. "/home/axadmin/opt/anaconda3/etc/profile.d/conda.sh"
