unit t0402_details;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0402_details = class(TTestFromLibGit2)
      procedure query_details_test_0402;
   end;

implementation

{ Test0402_details }

procedure Test0402_details.query_details_test_0402;
const
   commit_ids: array[0..5] of AnsiString = (
      'a4a7dce85cf63874e984719f4fdd239f5145052f', { 0 }
      '9fd738e8f7967c078dceed8190330fc8648ee56a', { 1 }
      '4a202b346bb0fb0db7eff3cffeb3c70babbd2045', { 2 }
      'c47800c7266a2be04c571c04d5a6614691ea99bd', { 3 }
      '8496071c1b46c854b31185ea97743be6a8774479', { 4 }
      '5b5b025afb0b4c913b4c338a42934a3863bf3644'  { 5 }
   );
var
   i:                       Integer;
   repo:                    Pgit_repository;
   id:                      git_oid;
   commit:                  Pgit_commit;
   author, committer:       Pgit_signature;
   message_, message_short: AnsiString;
   commit_time:             time_t;
   parents, p:              UInt;
   parent:                  Pgit_commit;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   for i := Low(commit_ids) to High(commit_ids) do
   begin
      git_oid_mkstr(@id, PAnsiChar(commit_ids[i]));

      must_pass(git_commit_lookup(commit, repo, @id));

      message_       := git_commit_message(commit);
      message_short  := git_commit_message_short(commit);
      author         := git_commit_author(commit);
      committer      := git_commit_committer(commit);
      commit_time    := git_commit_time(commit);
      parents        := git_commit_parentcount(commit);

      CheckTrue(StrComp(author.name,      'Scott Chacon') = 0);
      CheckTrue(StrComp(author.email,     'schacon@gmail.com') = 0);
      CheckTrue(StrComp(committer.name,   'Scott Chacon') = 0);
      CheckTrue(StrComp(committer.email,  'schacon@gmail.com') = 0);
      CheckTrue(Pos(#10, String(message_)) > 0);
      CheckTrue(Pos(#10, String(message_short)) = 0);
      CheckTrue(commit_time > 0);

      CheckTrue(parents <= 2, 'parents <= 2');
      p := 0;
      while p < parents do
      begin
         must_pass(git_commit_parent(parent, commit, p));
         CheckTrue(parent <> nil, 'parent <> nil');
         CheckTrue(git_commit_author(parent) <> nil, 'git_commit_author(parent) <> nil'); // is it really a commit?
         Inc(p);
      end;
      must_fail(git_commit_parent(parent, commit, parents));
   end;

   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0402_details.Suite);

end.
