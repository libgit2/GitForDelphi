unit t0802_write;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0802_write = class(TTestFromLibGit2)
      procedure tag_writeback_test_0802;
   end;

implementation

{ Test0802_write }

procedure Test0802_write.tag_writeback_test_0802;
var
   id: git_oid;
   repo: Pgit_repository;
   tag: Pgit_tag;
//   hex_oid: array [0..40] of AnsiChar;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@id, tag1_id);

   must_pass(git_tag_lookup(tag, repo, @id));

   git_tag_set_name(tag, 'This is a different tag LOL');

   must_pass(git_object_write(Pgit_object(tag)));

(*
   git_oid_fmt(@hex_oid, git_tag_id(tag));
   hex_oid[40] := #0;
   printf('TAG New SHA1: %s\n', hex_oid);
*)

   must_pass(remove_loose_object(REPOSITORY_FOLDER, Pgit_object(tag)));

   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0802_write.Suite);

end.
