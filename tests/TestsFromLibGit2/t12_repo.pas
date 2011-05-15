unit t12_repo;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test12_repo_init = class(TTestFromLibGit2)
      procedure initialize_a_standard_repo;
      procedure initialize_a_bare_repo;
      procedure initialize_and_open_a_bare_repo_with_a_relative_path_escaping_out_of_the_current_working_directory;
   end;

   Test12_repo_open = class(TTestFromLibGit2)
      procedure open_a_bare_repository_that_has_just_been_initialized_by_git;
      procedure open_a_standard_repository_that_has_just_been_initialized_by_git;
      procedure open_a_bare_repository_with_a_relative_path_escaping_out_of_the_current_working_directory;
   end;

   Test12_repo_empty = class(TTestFromLibGit2)
      procedure test_if_a_repository_is_empty_or_not;
   end;

implementation

const
   STANDARD_REPOSITORY  = 0;
   BARE_REPOSITORY      = 1;

{ Test12_repo_init }

procedure Test12_repo_init.initialize_a_standard_repo;
var
   path_index, path_repository: AnsiString;
begin
   path_repository := TEMP_REPO_FOLDER + AnsiString(GIT_DIR);
   path_index := path_repository + GIT_INDEX_FILE;

   must_pass(ensure_repository_init(TEMP_REPO_FOLDER_REL, STANDARD_REPOSITORY, PAnsiChar(path_index), PAnsiChar(path_repository), TEMP_REPO_FOLDER));
   must_pass(ensure_repository_init(TEMP_REPO_FOLDER_NS_REL, STANDARD_REPOSITORY, PAnsiChar(path_index), PAnsiChar(path_repository), TEMP_REPO_FOLDER));
end;

procedure Test12_repo_init.initialize_a_bare_repo;
var
   path_repository: AnsiString;
begin
   path_repository := TEMP_REPO_FOLDER;

   must_pass(ensure_repository_init(TEMP_REPO_FOLDER_REL, BARE_REPOSITORY, nil, PAnsiChar(path_repository), nil));
   must_pass(ensure_repository_init(TEMP_REPO_FOLDER_NS_REL, BARE_REPOSITORY, nil, PAnsiChar(path_repository), nil));
end;

procedure Test12_repo_init.initialize_and_open_a_bare_repo_with_a_relative_path_escaping_out_of_the_current_working_directory;
var
   current_workdir: String;
   path_repository: AnsiString;
//   mode: Integer;
   repo: Pgit_repository;
begin
//   mode := 0755; //* or 0777 ? */
   current_workdir := GetCurrentDir;

   path_repository := TEMP_REPO_FOLDER + AnsiString('a/b/c/');
   path_repository := AnsiString(StringReplace(String(AnsiString(TEMP_REPO_FOLDER) + AnsiString('a/b/c/')), '/', PathDelim, [rfReplaceAll]));
   if (path_repository <> '') and (path_repository[1] = '\') then
      Insert('.', path_repository, 1);
   ForceDirectories(String(path_repository));
   try
      ChDir(String(path_repository));
      try
         must_pass(git_repository_init(repo, '../d/e.git', 1));
         must_pass(git__suffixcmp(repo.path_repository, '/a/b/d/e.git/'));

         git_repository_free(repo);

         must_pass(git_repository_open(repo, '../d/e.git'));

         git_repository_free(repo);
      finally
         ChDir(current_workdir);
      end;
   finally
      rmdir_recurs(TEMP_REPO_FOLDER);
   end;
end;

const
   EMPTY_BARE_REPOSITORY_NAME = 'empty_bare.git';
   EMPTY_BARE_REPOSITORY_FOLDER: PAnsiChar =  'resources/' + EMPTY_BARE_REPOSITORY_NAME + '/';

{ Test12_repo_open }

procedure Test12_repo_open.open_a_bare_repository_that_has_just_been_initialized_by_git;
var
   repo: Pgit_repository;
begin
   if not copydir_recurs(EMPTY_BARE_REPOSITORY_FOLDER, TEMP_REPO_FOLDER) then
      must_pass(GIT_ERROR);
   try
      must_pass(remove_placeholders(TEMP_REPO_FOLDER, 'dummy-marker.txt'));

      must_pass(git_repository_open(repo, TEMP_REPO_FOLDER_REL));
      must_be_true(git_repository_path(repo) <> nil);
      must_be_true(git_repository_workdir(repo) = nil);

      git_repository_free(repo);
   finally
      if not rmdir_recurs(TEMP_REPO_FOLDER) then
         must_pass(GIT_ERROR);
   end;
end;

const
   SOURCE_EMPTY_REPOSITORY_NAME = 'empty_standard_repo/.gitted';
   EMPTY_REPOSITORY_NAME:        PAnsiChar = 'empty_standard_repo/.git';
   EMPTY_REPOSITORY_FOLDER:      PAnsiChar = 'resources/' + SOURCE_EMPTY_REPOSITORY_NAME + '/';
   DEST_REPOSITORY_FOLDER:       PAnsiChar = '/testrepo.git/.git/';
   DEST_REPOSITORY_FOLDER_REL:   PAnsiChar = './testrepo.git/.git/';

procedure Test12_repo_open.open_a_standard_repository_that_has_just_been_initialized_by_git;
var
   repo: Pgit_repository;
begin
   if not copydir_recurs(EMPTY_REPOSITORY_FOLDER, DEST_REPOSITORY_FOLDER) then
      must_pass(GIT_ERROR);
   try
      must_pass(remove_placeholders(DEST_REPOSITORY_FOLDER, 'dummy-marker.txt'));

      must_pass(git_repository_open(repo, DEST_REPOSITORY_FOLDER_REL));
      must_be_true(git_repository_path(repo) <> nil);
      must_be_true(git_repository_workdir(repo) <> nil);

      git_repository_free(repo);
   finally
      if not rmdir_recurs(TEMP_REPO_FOLDER) then
         must_pass(GIT_ERROR);
   end;
end;

procedure Test12_repo_open.open_a_bare_repository_with_a_relative_path_escaping_out_of_the_current_working_directory;
var
   new_current_workdir, current_workdir, path_repository: String;
   repo: Pgit_repository;
//const
//   mode = 0755; //* or 0777 ? */
begin
   //* Setup the repository to open */
   current_workdir := GetCurrentDir;

   path_repository := current_workdir + StringReplace(String(AnsiString(TEMP_REPO_FOLDER) + AnsiString('a/d/e.git')), '/', PathDelim, [rfReplaceAll]);

   if not copydir_recurs(REPOSITORY_FOLDER, AnsiString(path_repository)) then
      must_pass(GIT_ERROR);
   try
      //* Change the current working directory */
      new_current_workdir := current_workdir + StringReplace(String(AnsiString(TEMP_REPO_FOLDER) + AnsiString('a/b/c/')), '/', PathDelim, [rfReplaceAll]);
      ForceDirectories(new_current_workdir);
      try
         ChDir(new_current_workdir);

         must_pass(git_repository_open(repo, '../../d/e.git'));

         git_repository_free(repo);
      finally
         ChDir(current_workdir);
      end;
   finally
      rmdir_recurs(TEMP_REPO_FOLDER);
   end;
end;

{ Test12_repo_empty }

procedure Test12_repo_empty.test_if_a_repository_is_empty_or_not;
var
   repo_empty, repo_normal: Pgit_repository;
begin
   must_pass(git_repository_open(repo_normal, REPOSITORY_FOLDER));
   must_be_true(git_repository_is_empty(repo_normal) = 0);
   git_repository_free(repo_normal);

   must_pass(git_repository_open(repo_empty, EMPTY_BARE_REPOSITORY_FOLDER));
   must_be_true(git_repository_is_empty(repo_empty) = 1);
   git_repository_free(repo_empty);
end;

initialization
   RegisterTest('From libgit2.t12-repo', Test12_repo_init.NamedSuite('init'));
   RegisterTest('From libgit2.t12-repo', Test12_repo_open.NamedSuite('open'));
   RegisterTest('From libgit2.t12-repo', Test12_repo_empty.NamedSuite('empty'));

end.
