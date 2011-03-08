unit t0902_modify;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0902_modify = class(TTestFromLibGit2)
      procedure tree_in_memory_add_test_0902;
      procedure tree_add_entry_test_0902;
   end;

implementation

{ Test0902_modify }

procedure Test0902_modify.tree_in_memory_add_test_0902;
const
   entry_count = 128;
var
   repo: Pgit_repository;
   tree: Pgit_tree;
   i: Integer;
   entry_id: git_oid;
   filename: AnsiString;
   ent: Pgit_tree_entry;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_tree_new(tree, repo));

   git_oid_mkstr(@entry_id, tree_oid);
   for i := 0 to entry_count - 1 do
   begin
      filename := AnsiString(Format('file%d.txt', [i]));
      ent := nil;
      must_pass(git_tree_add_entry(ent, tree, @entry_id, PAnsiChar(filename), OctalToInt('040000')));
      must_be_true(ent <> nil);
   end;

   must_be_true(git_tree_entrycount(tree) = entry_count);
   must_pass(git_object_write(Pgit_object(tree)));
   must_pass(remove_loose_object(REPOSITORY_FOLDER, Pgit_object(tree)));

   git_repository_free(repo);
end;

procedure Test0902_modify.tree_add_entry_test_0902;
var
   id: git_oid;
   repo: Pgit_repository;
   tree: Pgit_tree;
   entry: Pgit_tree_entry;
   i: Integer;
//   hex_oid: array [0..40] of AnsiChar;
   ent: Pgit_tree_entry;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@id, tree_oid);

   must_pass(git_tree_lookup(tree, repo, @id));

   must_be_true(git_tree_entrycount(tree) = 3);

   git_tree_add_entry(ent, tree, @id, 'zzz_test_entry.dat', 0);
   git_tree_add_entry(ent, tree, @id, '01_test_entry.txt', 0);

   must_be_true(git_tree_entrycount(tree) = 5);

   entry := git_tree_entry_byindex(tree, 0);
   must_be_true(StrComp(git_tree_entry_name(entry), '01_test_entry.txt') = 0);

   entry := git_tree_entry_byindex(tree, 4);
   must_be_true(StrComp(git_tree_entry_name(entry), 'zzz_test_entry.dat') = 0);

   must_pass(git_tree_remove_entry_byname(tree, 'README'));
   must_be_true(git_tree_entrycount(tree) = 4);

   for i := 0 to git_tree_entrycount(tree) - 1 do
   begin
      entry := git_tree_entry_byindex(tree, i);
      must_be_true(StrComp(git_tree_entry_name(entry), 'README') <> 0);
   end;

   must_pass(git_object_write(Pgit_object(tree)));

(*
   git_oid_fmt(hex_oid, git_tree_id(tree));
   hex_oid[40] := #0;
   printf('TREE New SHA1: %s\n', hex_oid);
*)

   must_pass(remove_loose_object(REPOSITORY_FOLDER, Pgit_object(tree)));

   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0902_modify.Suite);

end.
