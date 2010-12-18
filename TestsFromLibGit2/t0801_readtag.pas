unit t0801_readtag;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0801_readtag = class(TTestFromLibGit2)
      procedure readtag_0801;
   end;

implementation

{ Test0801_readtag }

procedure Test0801_readtag.readtag_0801;
var
   repo: Pgit_repository;
   tag1, tag2: Pgit_tag;
   commit: Pgit_commit;
   id1, id2, id_commit: git_oid;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@id1, tag1_id);
   git_oid_mkstr(@id2, tag2_id);
   git_oid_mkstr(@id_commit, tagged_commit);

   must_pass(git_tag_lookup(tag1, repo, @id1));

   CheckTrue(StrComp(git_tag_name(tag1), 'test') = 0);
   CheckTrue(git_tag_type(tag1) = GIT_OBJ_TAG);

   tag2 := Pgit_tag(git_tag_target(tag1));
   CheckTrue(tag2 <> nil);

   CheckTrue(git_oid_cmp(@id2, git_tag_id(tag2)) = 0);

   commit := Pgit_commit(git_tag_target(tag2));
   CheckTrue(commit <> nil);

   CheckTrue(git_oid_cmp(@id_commit, git_commit_id(commit)) = 0);

   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0801_readtag.Suite);

end.
