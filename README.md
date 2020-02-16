# antlrinstaller
Just a shell script for installing quickly antlr4.8 and its C++ runtime.

#DISCLAIMER

I only tested this script on my machine, running debian10. I think it will work on yours, but I'm not sure at all ! **Be careful, and do not trust me !**

# How to install

Before installing the script, you need the following programs on your computer :

* cmake
* g++
* java (I don't know if openjdk works )
* git
* wget

Get the repo :
```
git clone https://github.com/Popiette/antlrinstaller
```

Once you are inside the repo, run the script `install.sh`
```
sudo ./install.sh [-d location/for/antlr/jar]
```
> The `-d` parameter is not mandatory.

You need to run the script as superuser, because it will copy scripts into your `/usr/bin` folder.

# How do I use that... thing ?

When you want to run antlr, just run it by calling `antlr4.sh` command. Here is an example :
```
antlr4.sh -Dlanguage=Cpp -visitor -no-listener Expr.g4
```

When you want to compile a program that use antlr library, you can use `cantlr4.sh` command. It is not very convenient, because it will simply compile every .cpp file in your current directory into a `exe` target executable using the antlr library. However, it get the job done (I think).
```
cantlr4.sh
```

> Because `antlr4.sh` and `cantlr4.sh` have been put in you `/usr/bin` directory, they should be accessible through the $PATH. So you should not have to worry about where they are located.
