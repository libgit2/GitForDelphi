GitForDelphi - Delphi bindings to [libgit2](https://github.com/libgit2/libgit2)
=================================

GitForDelphi allows you to work with git repositories from within your Delphi code, with the only dependencies being the uGitForDelphi.pas source file and the libgit2 DLL.

To use, just add `uGitForDelphi` to the uses section, and call `InitLibgit2;` and the libgit2 DLL will be loaded, and its API will be ready to use to read from, create and edit git repositories.

Current status
--------------

Currently, GitForDelphi is exposing the libgit2 C API exactly, all function exports from git2-0.dll have been converted, including necessary structures. Some of the tests from libgit2 have been converted and are all passing.

I intend to make a wrapper class, `TGitRepository` to give a nicer Delphi-like interface to working with repositories.



### pre-built libgit2 DLL:

git2-0.dll built from Visual C++ 2010 Express is in the `binary` branch,
you can use it while in the master branch like this

    git checkout origin/binary -- git2-0.dll; git reset git2-0.dll

See `LIBGIT2_sha` file for the libgit2 commit that the dll and code are currently based on.

