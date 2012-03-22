program GitForDelphi;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options 
  to use the console test runner.  Otherwise the GUI test runner will be used by 
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  uTestsFromLibGit2 in 'TestsFromLibGit2\uTestsFromLibGit2.pas',
  uTestGitRecords in 'uTestGitRecords.pas',
  t04_commit in 'TestsFromLibGit2\t04_commit.pas',
  t05_revwalk in 'TestsFromLibGit2\t05_revwalk.pas',
  t06_index in 'TestsFromLibGit2\t06_index.pas',
  t08_tag in 'TestsFromLibGit2\t08_tag.pas',
  t09_tree in 'TestsFromLibGit2\t09_tree.pas',
  uTestHelpers in 'uTestHelpers.pas',
  t10_refs in 'TestsFromLibGit2\t10_refs.pas',
  uGitForDelphi in '..\uGitForDelphi.pas',
  t15_config in 'TestsFromLibGit2\t15_config.pas',
  t18_status in 'TestsFromLibGit2\t18_status.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

