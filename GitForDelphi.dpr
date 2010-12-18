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
  uGitForDelphi in 'uGitForDelphi.pas',
  uTestGitRecords in 'uTestGitRecords.pas',
  t0402_details in 'TestsFromLibGit2\t0402_details.pas',
  t0501_walk in 'TestsFromLibGit2\t0501_walk.pas',
  t0601_read in 'TestsFromLibGit2\t0601_read.pas',
  t0801_readtag in 'TestsFromLibGit2\t0801_readtag.pas',
  t0802_write in 'TestsFromLibGit2\t0802_write.pas',
  t0901_readtree in 'TestsFromLibGit2\t0901_readtree.pas',
  t0902_modify in 'TestsFromLibGit2\t0902_modify.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

