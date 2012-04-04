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
      procedure cl_assert(b: Boolean; const aDescr: String); overload;
      procedure cl_assert(b: Boolean; const aDescr: AnsiString = ''); overload;
      function cl_fixture(fixture_name: PAnsiChar): PAnsiChar;
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

procedure TClarTest.cl_assert(b: Boolean; const aDescr: String);
begin
   cl_assert_(b, aDescr);
end;

procedure TClarTest.cl_assert(b: Boolean; const aDescr: AnsiString);
begin
   cl_assert_(b, aDescr);
end;

procedure TClarTest.cl_assert_(b: Boolean; const aDescr: AnsiString);
begin
   CheckTrue(b, String(aDescr));
end;

function TClarTest.cl_fixture(fixture_name: PAnsiChar): PAnsiChar;
   function fixture_path(abase, afixture_name: PAnsiChar): PAnsiChar;
   var
      path_buf: String;
   begin
      path_buf := IncludeTrailingPathDelimiter(String(AnsiString(abase)));
      if (afixture_name <> '') and (afixture_name[1] = '/') then
         path_buf := path_buf + Copy(String(AnsiString(afixture_name)), 2)
      else
         path_buf := path_buf + String(AnsiString(afixture_name));

      Result := PAnsiChar(AnsiString(StringReplace(path_buf, '\', '/', [rfReplaceAll])));
   end;
var
   CLAR_FIXTURE_PATH: String;
begin
   CLAR_FIXTURE_PATH := IncludeTrailingPathDelimiter(GetCurrentDir) + 'resources';
   Result := fixture_path(PAnsiChar(AnsiString(CLAR_FIXTURE_PATH)), fixture_name);
end;

procedure TClarTest.cl_fixture_cleanup(const aFixtureName: AnsiString);
var
   path: AnsiString;
begin
   path := './' + aFixtureName;
   rmdir_recurs(path);
end;

procedure TClarTest.cl_git_pass(expr: Integer);
var
   e: PAnsiChar;
begin
   git_clearerror();
//   if ((expr) <> GIT_SUCCESS)
//      clar__assert(0, __FILE__, __LINE__, 'Function call failed: ' #expr, git_lasterror(), 1);
//   } while(0);

   if expr <> GIT_SUCCESS then
   begin
      e := git_lasterror();
      Fail('Funciton failed ' + String(AnsiString(e)),  CallerAddr);
   end;
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
