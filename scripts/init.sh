. scripts/env.sh

echo 'Installing LLVM.' >&2
# Which LLVM are we using?
CLANG_LLVM=clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04
if [ ! -d $LLVM ]; then
    LLVM_SRC=https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/$CLANG_LLVM.tar.xz
    cd $EMBDING_HOME 
    wget $LLVM_SRC 
    tar -xvf $CLANG_LLVM.tar.xz
    rm $CLANG_LLVM.tar.xz 
    mv $CLANG_LLVM clang+llvm14 
    ln -s clang+llvm14 clang+llvm 
fi

echo 'Installing AFL++.' >&2
if [ ! -d $AFL ]; then
    git clone https://github.com/AFLplusplus/AFLplusplus.git
fi
cd $AFL; make -j; cd ..

if ! [ -x "$(command -v gradle)" ]; then
  echo 'Warning: gradle is not installed.' >&2
  echo '         `sudo apt install gradle` if you want to work on Java, otherwise you can ignore it.' >&2
  exit 1
else
    echo 'Preparing Kelinci for Java programs.' >&2
    if [ ! -d $KELINCI ]; then
        git clone https://github.com/isstac/kelinci.git
    fi
    cd $KELINCI/fuzzerside; make -j
    cd $KELINCI/instrumentor; gradle build
fi

cd $EMBDING_HOME
echo 'Installing pip dependencies.' >&2
python3 -m pip install -r ./requirements.txt

echo 'Making dynlib for C/C++ programs.' >&2
make

echo 'Done.'