GitForDelphi 
=================================
Delphi bindings to libgit2 <https://github.com/libgit2/libgit2>


Header conversion started, some minimal tests are passing.

git2.dll built from Visual C++ 2010 Express is in the `binary` branch,
you can use it while in the master branch like this

    git checkout binary -- git2.dll; git reset git2.dll

The dll and code are currently based on the `1f080e2` commit of libgit2.git
