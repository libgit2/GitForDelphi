unit uClar;

interface

uses
   TestFramework, SysUtils, Windows, Classes,
   uTestsFromLibGit2, uGitForDelphi;

type
   TClarTest = class(TTestFromLibGit2)
   public
      function p_rename(const aFrom, aTo: AnsiString): Integer; override;

      procedure cl_fixture_sandbox(const aFixtureName: AnsiString);
      procedure cl_fixture_cleanup(const aFixtureName: AnsiString);
      procedure cl_git_pass(expr: Integer);
      procedure cl_assert_(b: Boolean; const aDescr: String); overload;
      procedure cl_assert_(b: Boolean; const aDescr: AnsiString); overload;
   end;

implementation

{ TClarTest }

procedure TClarTest.cl_fixture_sandbox(const aFixtureName: AnsiString);
var
   path: AnsiString;
begin
   path := 'resources/' + aFixtureName;
   copydir_recurs(path, aFixtureName);
end;

procedure TClarTest.cl_assert_(b: Boolean; const aDescr: String);
begin
   CheckTrue(b, aDescr);
end;

procedure TClarTest.cl_assert_(b: Boolean; const aDescr: AnsiString);
begin
   CheckTrue(b, String(aDescr));
end;

procedure TClarTest.cl_fixture_cleanup(const aFixtureName: AnsiString);
var
   path: AnsiString;
begin
   path := './' + aFixtureName;
   rmdir_recurs(path);
end;

procedure TClarTest.cl_git_pass(expr: Integer);
begin
   git_clearerror();
//   if ((expr) <> GIT_SUCCESS)
//      clar__assert(0, __FILE__, __LINE__, 'Function call failed: ' #expr, git_lasterror(), 1);
//   } while(0);

   if expr <> GIT_SUCCESS then
      Fail('Funciton failed ' + String(AnsiString(git_lasterror())),  CallerAddr);
end;

function TClarTest.p_rename(const aFrom, aTo: AnsiString): Integer;
begin
   if DirectoryExists(String(aFrom)) then
   begin
      if RenameDir(aFrom, aTo) then
         Result := GIT_SUCCESS
      else
         Result := GIT_ERROR;
   end
   else
      Result := inherited p_rename(aFrom, aTo);
end;

end.
