unit t09_tree;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test09_tree_read = class(TTestFromLibGit2)
      procedure access_randomly_the_entries_on_a_loaded_tree;
      procedure read_a_tree_from_the_repository;
   end;

   Test09_tree_write = class(TTestFromLibGit2)
   end;

implementation

{ Test09_tree_read }

procedure Test09_tree_read.access_randomly_the_entries_on_a_loaded_tree;
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

procedure Test09_tree_read.read_a_tree_from_the_repository;
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
   RegisterTest('From libgit2.t09-tree', Test09_tree_read.NamedSuite('read'));
//   RegisterTest('From libgit2.t09-tree', Test09_tree_write.Suite('write')); // TODO THREADSAFE

end.
