unit status;

interface

uses
   TestFramework, SysUtils, Windows, Classes,
   uTestsFromLibGit2, uGitForDelphi, uClar;

type
   Test_status_ignore = class(TClarTest)
   private
      g_repo: Pgit_repository;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure TestIgnores;
   end;

implementation

{ Test_status_ignore }

procedure Test_status_ignore.SetUp;
begin
   inherited;
   cl_fixture_sandbox('attr');
   cl_git_pass(p_rename('attr/.gitted', 'attr/.git'));
   cl_git_pass(p_rename('attr/gitignore', 'attr/.gitignore'));
   cl_git_pass(git_repository_open(g_repo, 'attr/.git'));
end;

procedure Test_status_ignore.TearDown;
begin
   inherited;
   git_repository_free(g_repo);
   g_repo := nil;
   cl_fixture_cleanup('attr');
end;

type
   ignore_test_cases = record
      path:       AnsiString;
      expected:   Integer;
   end;
procedure Test_status_ignore.TestIgnores;
const
   test_cases: array [0..13] of ignore_test_cases = (
      (path: 'file'; expected: 0),
      (path: 'ign'; expected:1 ),
      (path: 'sub'; expected:1 ),
      (path: 'sub/file'; expected:0 ),
      (path: 'sub/ign'; expected:1 ),
      (path: 'sub/sub'; expected:1 ),
      (path: 'sub/sub/file'; expected:0 ),
      (path: 'sub/sub/ign'; expected:1 ),
      (path: 'sub/sub/sub'; expected:1 ),
      //* pattern 'dir/' from .gitignore */
      (path: 'dir'; expected:1 ),
      (path: 'dir/'; expected:1 ),
      (path: 'sub/dir'; expected:1 ),
      (path: 'sub/dir/'; expected:1 ),
      (path: 'sub/sub/dir'; expected:0 ) //* dir is not actually a dir, but a file */
   );
var
   i, ignored: Integer;
begin
   for i := Low(test_cases) to High(test_cases) do
   begin
      cl_git_pass(git_status_should_ignore(g_repo, PAnsiChar(test_cases[i].path), @ignored));
      cl_assert_(ignored = test_cases[i].expected, test_cases[i].path);
   end;
end;

initialization
   RegisterTest('From libgit2/clar/status', Test_status_ignore.NamedSuite('ignore'));

end.
