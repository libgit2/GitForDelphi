unit uTestsFromLibGit2;

interface

uses
   TestFramework, Windows, SysUtils,
   uGitForDelphi;

type
   TTestFromLibGit2 = class (TTestCase)
   strict private
      function GitReturnValue(aResult: Integer): String;
   public
      class function NamedSuite(const aName: String): ITestSuite;

      procedure must_pass(aResult: Integer);
      procedure must_fail(aResult: Integer; aExpectedResult: Integer = 0);
      procedure must_be_true(b: Boolean; const msg: String = '');
      function remove_loose_object(const aRepository_folder: PAnsiChar; object_: Pgit_object): Integer;
      function gitfo_exists(const path: String): Integer;
      function gitfo_not_exists(const path: String): Integer;
      function copydir_recurs(const fromDir, toDir: AnsiString): Boolean;
      function rmdir_recurs(const dir: AnsiString): Boolean;
      function open_temp_repo(var repo: Pgit_repository; const path: PAnsiChar): Integer;
      procedure close_temp_repo(repo: Pgit_repository);
      function git__suffixcmp(str, suffix: PAnsiChar): Integer;
      function ensure_repository_init(
         working_directory: PAnsiChar;
         repository_kind: Integer;
         expected_path_index,
         expected_path_repository,
         expected_working_directory: PAnsiChar): Integer;
      function remove_placeholders(directory_path, filename: PAnsiChar): Integer;
   end;

   TTestSuiteForLibGit2 = class(TTestSuite, ITestSuite, ITest)
   public
      constructor Create(TestClass: TTestCaseClass; const aName: String);
   end;

const
   REPOSITORY_FOLDER_         = 'resources/testrepo.git';
   BAD_TAG_REPOSITORY_FOLDER_ = 'resources/bad_tag.git/';
   TEST_INDEX_PATH            = 'resources/testrepo.git/index';
   TEST_INDEX2_PATH           = 'resources/gitgit.index';
   TEST_INDEXBIG_PATH         = 'resources/big.index';
   TEST_INDEX_ENTRY_COUNT     = 109;
   TEST_INDEX2_ENTRY_COUNT    = 1437;
   TEMP_REPO_FOLDER:          PAnsiChar = '/testrepo.git/';
   TEMP_REPO_FOLDER_REL:      PAnsiChar = './testrepo.git/';
   TEMP_REPO_FOLDER_NS:       PAnsiChar = '/testrepo.git';
   TEMP_REPO_FOLDER_NS_REL:   PAnsiChar = './testrepo.git';

   tag1_id           = 'b25fa35b38051e4ae45d4222e795f9df2e43f1d1';
   tag2_id           = '7b4384978d2493e851f9cca7858815fac9b10980';
   tagged_commit     = 'e90810b8df3e80c413d903f631643c716887138d';
   tree_oid          = '1810dff58d8a660512d4832e740f692884338ccd';

type
   test_entry = record
      index:         Integer;
      path:          array [0..127] of AnsiChar;
      file_size:     size_t;
      mtime:         time_t;
   end;

const
   TEST_ENTRIES: array [0..4] of test_entry =
   (
      (index:  4; path: 'Makefile';          file_size: 5064;  mtime: $4C3F7F33),
      (index: 62; path: 'tests/Makefile';    file_size: 2631;  mtime: $4C3F7F33),
      (index: 36; path: 'src/index.c';       file_size: 10014; mtime: $4C43368D),
      (index:  6; path: 'git.git-authors';   file_size: 2709;  mtime: $4C3F7F33),
      (index: 48; path: 'src/revobject.h';   file_size: 1448;  mtime: $4C3F7FE2)
   );

function REPOSITORY_FOLDER: PAnsiChar;
function BAD_TAG_REPOSITORY_FOLDER: PAnsiChar;
function OctalToInt(const Value: string): Longint;
function cmp_files(const File1, File2: TFileName): Integer;

implementation

uses
   Classes, ShellAPI;

function _TestFolder(const aSubFolder: AnsiString): PAnsiChar;
begin
   Result := PAnsiChar(AnsiString(StringReplace(ExtractFilePath(ParamStr(0)), PathDelim, '/', [rfReplaceAll]) + String(aSubFolder)));
end;

function REPOSITORY_FOLDER: PAnsiChar;
begin
   Result := _TestFolder(REPOSITORY_FOLDER_);
end;

function BAD_TAG_REPOSITORY_FOLDER: PAnsiChar;
begin
   Result := _TestFolder(BAD_TAG_REPOSITORY_FOLDER_);
end;

function OctalToInt(const Value: string): Longint;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Value) do
    Result := Result * 8 + StrToInt(Value[i]);
end;

{ TTestFromLibGit2 }

procedure TTestFromLibGit2.must_fail(aResult: Integer; aExpectedResult: Integer = 0);
begin
   if aExpectedResult <> 0 then
   begin
      if aExpectedResult <> aResult then
         CheckEquals(GitReturnValue(aExpectedResult), GitReturnValue(aResult));
   end
   else
   begin
      if aResult = GIT_SUCCESS then
         CheckEquals('not GIT_SUCCESS', GitReturnValue(aResult));
   end;
end;

procedure TTestFromLibGit2.must_pass(aResult: Integer);
begin
   CheckTrue(aResult = GIT_SUCCESS, GitReturnValue(aResult));
end;

function TTestFromLibGit2.gitfo_exists(const path: String): Integer;
begin
   if DirectoryExists(path) or FileExists(path) then
      Result := GIT_SUCCESS
   else
      Result := GIT_ERROR;
end;

function TTestFromLibGit2.gitfo_not_exists(const path: String): Integer;
begin
   if DirectoryExists(path) or FileExists(path) then
      Result := GIT_ERROR
   else
      Result := GIT_SUCCESS;
end;

function TTestFromLibGit2.GitReturnValue(aResult: Integer): String;
var
   errorName, errorMessage: AnsiString;
begin
   if aResult = GIT_SUCCESS then
   begin
      Result := '';
      Exit;
   end;

   errorName := git_strerror(aResult);
   errorMessage := git_lasterror;

   if errorMessage <> '' then
      Result := Format('%d %s: %s', [aResult, errorName, errorMessage])
   else
      Result := Format('%d %s', [aResult, errorName]);
end;

procedure TTestFromLibGit2.must_be_true(b: Boolean; const msg: String = '');
begin
   CheckTrue(b, msg);
end;

function TTestFromLibGit2.remove_loose_object(const aRepository_folder: PAnsiChar; object_: Pgit_object): Integer;
const
   objects_folder = '/objects/';
var
   ptr, full_path, top_folder: PAnsiChar;
   path_length, objects_length: Integer;
   dwAttrs: Cardinal;
begin
   CheckTrue(aRepository_folder <> nil);
   CheckTrue(object_ <> nil);

   objects_length := strlen(objects_folder);
   path_length := strlen(aRepository_folder);
   GetMem(full_path, path_length + objects_length + GIT_OID_HEXSZ + 3);
   ptr := full_path;

   StrCopy(ptr, aRepository_folder);
   StrCopy(ptr + path_length, objects_folder);

   top_folder := ptr + path_length + objects_length;
   ptr := top_folder;

   ptr^ := '/';
   Inc(ptr);
   git_oid_pathfmt(ptr, git_object_id(object_));
   Inc(ptr, GIT_OID_HEXSZ + 1);
   ptr^ := #0;

   dwAttrs := GetFileAttributesA(full_path);
   if SetFileAttributesA(full_path, dwAttrs and (not FILE_ATTRIBUTE_READONLY)) and (not DeleteFileA(full_path)) then
   begin
      raise Exception.CreateFmt('can''t delete object file "%s"', [full_path]);
      Result := -1;
      Exit;
   end;

   top_folder^ := #0;

   if (not RemoveDirectoryA(full_path)) and (GetLastError <> ERROR_DIR_NOT_EMPTY) then
   begin
      raise Exception.CreateFmt('can''t remove object directory "%s"', [full_path]);
      Result := -1;
      Exit;
   end;

   FreeMem(full_path, path_length + objects_length + GIT_OID_HEXSZ + 3);

   Result := GIT_SUCCESS;
end;

function TTestFromLibGit2.remove_placeholders(directory_path, filename: PAnsiChar): Integer;
var
   path, fname: String;
   tsDirs: TStringList;
   i, r: Integer;
   SR: TSearchRec;
begin
   /// I think this is what remove_placeholders does:
   ///   Ensures that `directory_path` exists,
   ///   then deletes `filename` if it exists in `directory_path` or any subdirectory

   fname := String(AnsiString(filename));
   path := StringReplace(String(AnsiString(directory_path)), '/', PathDelim, [rfReplaceAll]);
   if (path <> '') and (path[1] = '\') then
      Insert('.', path, 1);

   Result := GIT_EINVALIDPATH;
   if DirectoryExists(path) then
   begin
      tsDirs := TStringList.Create;
      try
         tsDirs.Add(path);
         i := 0;

         while i < tsDirs.Count do
         begin
            path := tsDirs[i];

            r := FindFirst(path + '*.*', faDirectory, SR);
            while r = 0 do
            begin
               if (SR.Attr and faDirectory = faDirectory) and (SR.Name <> '.') and (SR.Name <> '..') then
                  tsDirs.Add(path + SR.Name + PathDelim);

               r := FindNext(SR);
            end;

            FindClose(SR);

            Inc(i);
         end;

         for i := 0 to tsDirs.Count - 1 do
            SysUtils.DeleteFile(tsDirs[i] + fname);

         Result := GIT_SUCCESS;
      finally
         tsDirs.Free;
      end;
   end;
end;

function cmp_files(const File1, File2: TFileName): Integer;
var
   ms1, ms2: TMemoryStream;
begin
   Result := GIT_ERROR;

   ms2 := nil;
   ms1 := TMemoryStream.Create;
   try
      ms2 := TMemoryStream.Create;

      ms1.LoadFromFile(File1);
      ms2.LoadFromFile(File2);

      if ms1.Size = ms2.Size then
      begin
         if CompareMem(ms1.Memory, ms2.Memory, ms1.Size) then
            Result := GIT_SUCCESS;
      end;
   finally
      ms1.Free;
      ms2.Free;
   end
end;

function TTestFromLibGit2.copydir_recurs(const fromDir, toDir: AnsiString): Boolean;
   function _copydir_recurs(const _fromDir, _toDir: string): Boolean;
   var
     fos: ShellAPI.TSHFileOpStruct;
   begin
     ZeroMemory(@fos, SizeOf(fos));

     fos.wFunc  := FO_COPY;
     fos.fFlags := FOF_FILESONLY or FOF_SILENT or FOF_NOCONFIRMATION or FOF_NOERRORUI or FOF_NOCONFIRMMKDIR;
     fos.pFrom  := PChar(_fromDir + #0#0);
     fos.pTo    := PChar(_toDir + #0#0);

     Result := (0 = ShellAPI.ShFileOperation(fos));
   end;
var
   from_path, to_path: String;
begin
   from_path   := StringReplace(String(AnsiString(fromDir)), '/', PathDelim, [rfReplaceAll]);
   to_path     := StringReplace(String(AnsiString(ToDir)),   '/', PathDelim, [rfReplaceAll]);

   if (from_path <> '') and (from_path[1] = '\') then
      Insert('.', from_path, 1);
   if (to_path <> '') and (to_path[1] = '\') then
      Insert('.', to_path, 1);

   Result := _copydir_recurs(from_path, to_path);
end;

function TTestFromLibGit2.git__suffixcmp(str, suffix: PAnsiChar): Integer;
var
   a, b: size_t;
begin
   a := strlen(str);
   b := strlen(suffix);
   if (a < b) then
      Result := -1
   else
      Result := StrComp(str + (a - b), suffix);
end;

function TTestFromLibGit2.ensure_repository_init(working_directory: PAnsiChar; repository_kind: Integer; expected_path_index, expected_path_repository,
  expected_working_directory: PAnsiChar): Integer;
var
   win_path: String;
   path_odb: AnsiString; //[GIT_PATH_MAX];
   repo: Pgit_repository;
label
   cleanup;
begin
   win_path := StringReplace(String(AnsiString(working_directory)), '/', PathDelim, [rfReplaceAll]);
   if (win_path <> '') and (win_path[1] = '\') then
      Insert('.', win_path, 1);

   if DirectoryExists(win_path) then
   begin
      Result := GIT_ERROR;
      Exit;
   end;

   path_odb := AnsiString(expected_path_repository) + AnsiString(GIT_OBJECTS_DIR);

   if (git_repository_init(repo, working_directory, repository_kind) < GIT_SUCCESS) then
   begin
      Result := GIT_ERROR;
      Exit;
   end;

   if ((git_repository_workdir(repo) <> nil) or (expected_working_directory <> nil)) then
   begin
      if (git__suffixcmp(git_repository_workdir(repo), expected_working_directory) <> 0) then
         goto cleanup;
   end;

//   if (git__suffixcmp(git_repository_odb(repo), PAnsiChar(path_odb)) <> 0) then
//      goto cleanup;

   if (git__suffixcmp(git_repository_path(repo), expected_path_repository) <> 0) then
      goto cleanup;

//   if ((git_repository_index(repo) <> nil) or (expected_path_index <> nil)) then
//   begin
//      if (git__suffixcmp(git_repository_path(repo, GIT_REPO_PATH_INDEX), expected_path_index) <> 0) then
//         goto cleanup;
//
//      if (git_repository_is_bare(repo) = 1) then
//         goto cleanup;
//   end
//   else if (git_repository_is_bare(repo) = 0) then
//         goto cleanup;

   if (git_repository_is_empty(repo) = 0) then
      goto cleanup;

   git_repository_free(repo);
   rmdir_recurs(working_directory);

   Result := GIT_SUCCESS;
   Exit;

cleanup:
   git_repository_free(repo);
   rmdir_recurs(working_directory);
   Result := GIT_ERROR;
end;

function TTestFromLibGit2.rmdir_recurs(const dir: AnsiString): Boolean;
   function _rmdir_recurs(const _dir: string): Boolean;
   var
     fos: ShellAPI.TSHFileOpStruct;
   begin
     ZeroMemory(@fos, SizeOf(fos));

     fos.wFunc  := FO_DELETE;
     fos.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
     fos.pFrom  := PChar(_dir + #0);

     Result := (0 = ShellAPI.ShFileOperation(fos));
   end;
var
   path: String;
begin
   path := StringReplace(String(AnsiString(dir)), '/', PathDelim, [rfReplaceAll]);
//   if (path <> '') and (path[1] = '\') then
//      Insert('.', path, 1);

   Result := _rmdir_recurs(path);
end;

function TTestFromLibGit2.open_temp_repo(var repo: Pgit_repository; const path: PAnsiChar): Integer;
begin
   if not copydir_recurs(path, TEMP_REPO_FOLDER) then
      Result := GIT_ERROR
   else
      Result := git_repository_open(repo, TEMP_REPO_FOLDER_REL);
end;

procedure TTestFromLibGit2.close_temp_repo(repo: Pgit_repository);
begin
   git_repository_free(repo);

   rmdir_recurs(TEMP_REPO_FOLDER_REL);
end;

{ TTestSuiteForLibGit2 }

class function TTestFromLibGit2.NamedSuite(const aName: String): ITestSuite;
begin
  Result := TTestSuiteForLibGit2.Create(Self, aName);
end;

constructor TTestSuiteForLibGit2.Create(TestClass: TTestCaseClass; const aName: String);
begin
  inherited Create(aName);
  AddTests(testClass);
end;

initialization
   InitLibgit2;

end.
