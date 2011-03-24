unit t0901_readtree;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0901_readtree = class(TTestFromLibGit2)
      procedure tree_entry_access_test_0901;
      procedure tree_read_test_0901;
   end;

implementation

{ Test0901_readtree }

procedure Test0901_readtree.tree_entry_access_test_0901;
var
   id: git_oid ;
   repo: Pgit_repository;
   tree: Pgit_tree;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@id, tree_oid);

   must_pass(git_tree_lookup(tree, repo, @id));

   must_be_true(git_tree_entry_byname(tree, 'README') <> nil);
   must_be_true(git_tree_entry_byname(tree, 'NOTEXISTS') = nil);
   must_be_true(git_tree_entry_byname(tree, '') = nil);
   must_be_true(git_tree_entry_byindex(tree, 0) <> nil);
   must_be_true(git_tree_entry_byindex(tree, 2) <> nil);
   must_be_true(git_tree_entry_byindex(tree, 3) = nil);
   must_be_true(git_tree_entry_byindex(tree, -1) = nil);

   git_repository_free(repo);
end;

procedure Test0901_readtree.tree_read_test_0901;
var
   id: git_oid;
   repo: Pgit_repository;
   tree: Pgit_tree;
   entry: Pgit_tree_entry;
   obj: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@id, tree_oid);

   must_pass(git_tree_lookup(tree, repo, @id));

   must_be_true(git_tree_entrycount(tree) = 3);

   entry := git_tree_entry_byname(tree, 'README');
   must_be_true(entry <> nil);

   must_be_true(StrComp(git_tree_entry_name(entry), 'README') = 0);

   must_pass(git_tree_entry_2object(obj, repo, entry));

   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0901_readtree.Suite);

end.
