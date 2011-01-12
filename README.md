GitForDelphi 
=================================
Delphi bindings to libgit2 <https://github.com/libgit2/libgit2>


All function exports from git2.dll have been converted, including
necessary structures. Some of the tests from libgit2 have been
converted and are all passing.

git2.dll built from Visual C++ 2010 Express is in the `binary` branch,
you can use it while in the master branch like this

    git checkout binary -- git2.dll; git reset git2.dll

The dll and code are currently based on the `e52e38d` commit of libgit2.git

