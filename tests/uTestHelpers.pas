unit uTestHelpers;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   TestHelpers = class(TTestFromLibGit2)
      procedure Test_commit_times_with_offsets_to_TDateTime;
   end;

implementation

uses
   DateUtils;

{ TestHelpers }

procedure TestHelpers.Test_commit_times_with_offsets_to_TDateTime;
type
   testrec = record
      id: AnsiString;
      dt: TDateTime;
   end;
var
   repo:                    Pgit_repository;
   i:                       Integer;
   id:                      git_oid;
   commit:                  Pgit_commit;
   commits:                 array[0..7] of testrec;
   expected_dt, actual_dt:  TDateTime;
begin
   // commit_ids taken from other tests, interpolated into "real" git repo, reviewed with git log

   ///   Author: Scott Chacon <schacon@gmail.com>
   ///   Date:   Tue May 25 12:00:23 2010 -0700
   commits[0].id := 'a4a7dce85cf63874e984719f4fdd239f5145052f';  // "Merge branch 'master' into br2"
   commits[0].dt := EncodeDate(2010,05,25) + EncodeTime(12,00,23,0);

   commits[1].id := '9fd738e8f7967c078dceed8190330fc8648ee56a';  // "a fourth commit"
   commits[1].dt := EncodeDate(2010,05,24) + EncodeTime(10,19,19,0);

   commits[2].id := '4a202b346bb0fb0db7eff3cffeb3c70babbd2045';  // "a third commit"
   commits[2].dt := EncodeDate(2010,05,24) + EncodeTime(10,19,04,0);

   commits[3].id := 'c47800c7266a2be04c571c04d5a6614691ea99bd';  // "branch commit one"
   commits[3].dt := EncodeDate(2010,05,25) + EncodeTime(11,58,14,0);

   commits[4].id := '5b5b025afb0b4c913b4c338a42934a3863bf3644';  // "another commit"
   commits[4].dt := EncodeDate(2010,05,11) + EncodeTime(13,38,42,0);

   commits[5].id := '8496071c1b46c854b31185ea97743be6a8774479';  // "testing"
   commits[5].dt := EncodeDate(2010,05,08) + EncodeTime(16,13,06,0);

   ///   Author: Vicent Marti <tanoku@gmail.com>
   ///   Date:   Thu Aug 5 18:42:20 2010 +0200
   commits[6].id := 'e90810b8df3e80c413d903f631643c716887138d';  // "Test commit 2"
   commits[6].dt := EncodeDate(2010,08,05) + EncodeTime(18,42,20,0);

   commits[7].id := '6dcf9bf7541ee10456529833502442f385010c3d';  // "Test commit 1"
   commits[7].dt := EncodeDate(2010,08,05) + EncodeTime(18,41,33,0);

   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   for i := Low(commits) to High(commits) do
   begin
      git_oid_fromstr(@id, PAnsiChar(commits[i].id));
      must_pass(git_commit_lookup(commit, repo, @id));

      expected_dt := commits[i].dt;
      actual_dt := git_commit_DateTime(commit);

      CheckTrue(
         DateUtils.SameDateTime(expected_dt, actual_dt),
         Format('expected <%s>, but was <%s>', [DateTimeToStr(expected_dt), DateTimeToStr(actual_dt)])
      );
   end;

   git_repository_free(repo);
end;

initialization
   RegisterTest(TestHelpers.Suite);

end.
