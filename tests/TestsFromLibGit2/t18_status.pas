unit t18_status;

interface

uses
   TestFramework, SysUtils, Windows, Classes,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test18_test_status_file = class(TTestFromLibGit2)
      procedure test_retrieving_OID_from_a_file_apart_from_the_ODB;
   end;

   Test18_test_status_statuscb = class(TTestFromLibGit2)
      procedure test_retrieving_status_for_worktree_of_repository;
      procedure test_retrieving_status_for_a_worktree_of_an_empty_repository;
      procedure test_retrieving_status_for_a_purged_worktree_of_an_valid_repository;
      procedure test_retrieving_status_for_a_worktree_where_a_file_and_a_subdir_have_been_renamed_and_some_files_have_been_added;
   end;

   Test18_test_status_singlestatus = class(TTestFromLibGit2)
      procedure test_retrieving_status_for_single_file;
      procedure test_retrieving_status_for_nonexistent_file;
      procedure test_retrieving_status_for_a_non_existent_file_in_an_empty_repository;
      procedure test_retrieving_status_for_a_new_file_in_an_empty_repository;
      procedure can_t_determine_the_status_for_a_folder;
   end;

implementation

const
   test_blob_oid = 'd4fa8600b4f37d7516bef4816ae2c64dbf029e3a';

   STATUS_WORKDIR_FOLDER         = 'resources/status/';
   STATUS_REPOSITORY_TEMP_FOLDER = '/testrepo.git/.gitted/';
   STATUS_REPOSITORY_TEMP_FOLDER_REL = 'testrepo.git/.gitted/';
   EMPTY_REPOSITORY_FOLDER       = 'resources/empty_standard_repo/.gitted/';

function file_create(filename, content: PAnsiChar): Integer; overload;
var
   fs: TFileStream;
begin
   try
      fs := TFileStream.Create(String(filename), fmCreate or fmOpenWrite);
      try
         fs.Write(content^, Length(content));
      finally
         fs.Free;
      end;

      Result := GIT_SUCCESS;
   except
      Result := GIT_ERROR;
   end;
end;

function file_create(const filename, content: String): Integer; overload;
begin
   Result := file_create(PAnsiChar(AnsiString(filename)), PAnsiChar(AnsiString(content)));
end;

{ Test18_test_status_file }

procedure Test18_test_status_file.test_retrieving_OID_from_a_file_apart_from_the_ODB;
var
   expected_id, actual_id: git_oid;
   filename: AnsiString;
begin
   filename := 'new_file';

   must_pass(file_create(PAnsiChar(filename), PAnsiChar('new_file'#10)));

   must_pass(git_odb_hashfile(@actual_id, PAnsiChar(filename), GIT_OBJ_BLOB));

   must_pass(git_oid_fromstr(@expected_id, test_blob_oid));
   must_be_true(git_oid_cmp(@expected_id, @actual_id) = 0);

   SysUtils.DeleteFile(String(filename));
end;

const
   entry_paths0: array[0..14] of AnsiString = (
      'file_deleted',
      'ignored_file',
      'modified_file',
      'new_file',
      'staged_changes',
      'staged_changes_file_deleted',
      'staged_changes_modified_file',
      'staged_delete_file_deleted',
      'staged_delete_modified_file',
      'staged_new_file',
      'staged_new_file_deleted_file',
      'staged_new_file_modified_file',

      'subdir/deleted_file',
      'subdir/modified_file',
      'subdir/new_file'
   );

   entry_statuses0: array[0..14] of UInt = (
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_IGNORED,
      GIT_STATUS_WT_MODIFIED,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_INDEX_MODIFIED or GIT_STATUS_WT_DELETED,
      GIT_STATUS_INDEX_MODIFIED or GIT_STATUS_WT_MODIFIED,
      GIT_STATUS_INDEX_DELETED,
      GIT_STATUS_INDEX_DELETED or GIT_STATUS_WT_NEW,
      GIT_STATUS_INDEX_NEW,
      GIT_STATUS_INDEX_NEW or GIT_STATUS_WT_DELETED,
      GIT_STATUS_INDEX_NEW or GIT_STATUS_WT_MODIFIED,

      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_MODIFIED,
      GIT_STATUS_WT_NEW
   );

   ENTRY_COUNT0 = 15;

type
   status_entry_counts = record
      wrong_status_flags_count: Integer;
      wrong_sorted_path: Integer;
      entry_count: Integer;
      expected_statuses: array of UInt;
      expected_paths: array of AnsiString;
      expected_entry_count: Integer;
   end;
   Pstatus_entry_counts = ^status_entry_counts;

function status_cb(path: PAnsiChar; status_flags: UInt; payload: PByte): Integer; stdcall;
var
   counts: Pstatus_entry_counts;
begin
   Result := GIT_SUCCESS;

   counts := Pstatus_entry_counts(payload);
   try
      if (counts.entry_count >= counts.expected_entry_count) then
      begin
         Inc(counts.wrong_status_flags_count);
         exit;
      end;

      if (StrComp(path, PAnsiChar(counts.expected_paths[counts.entry_count])) <> 0) then
      begin
         Inc(counts.wrong_sorted_path);
         exit;
      end;

      if (status_flags <> counts.expected_statuses[counts.entry_count]) then
         Inc(counts.wrong_status_flags_count);
   finally
      Inc(counts.entry_count);
   end;
end;

{ Test18_test_status_statuscb }

procedure Test18_test_status_statuscb.test_retrieving_status_for_worktree_of_repository;
var
   repo: Pgit_repository;
   counts: status_entry_counts;
   i: Integer;
begin
   try
      must_be_true(copydir_recurs(STATUS_WORKDIR_FOLDER, TEMP_REPO_FOLDER));
      must_be_true(RenameDir(STATUS_REPOSITORY_TEMP_FOLDER_REL, TEST_STD_REPO_FOLDER_REL));
      must_pass(git_repository_open(repo, TEMP_REPO_FOLDER_REL));

      ZeroMemory(@counts, SizeOf(status_entry_counts));
      counts.expected_entry_count := ENTRY_COUNT0;
      // counts.expected_paths := entry_paths0;
      SetLength(counts.expected_paths, Length(entry_paths0));
      for i := Low(entry_paths0) to High(entry_paths0) do
         counts.expected_paths[i] := entry_paths0[i];
      // counts.expected_statuses := entry_statuses0;
      SetLength(counts.expected_statuses, Length(entry_statuses0));
      for i := Low(entry_statuses0) to High(entry_statuses0) do
         counts.expected_statuses[i] := entry_statuses0[i];

      must_pass(git_status_foreach(repo, @status_cb, @counts));
      must_be_true(counts.entry_count = counts.expected_entry_count);
      must_be_true(counts.wrong_status_flags_count = 0);
      must_be_true(counts.wrong_sorted_path = 0);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

function status_cb1(path: PAnsiChar; status_flags: UInt; payload: PByte): Integer; stdcall;
var
   count: PInt;
begin
   count := PInt(payload);

   count^ := count^ + 1;

   Result := GIT_SUCCESS;
end;

procedure Test18_test_status_statuscb.test_retrieving_status_for_a_worktree_of_an_empty_repository;
var
   repo: Pgit_repository;
   count: Integer;
begin
   count := 0;

   try
      must_be_true(copydir_recurs(EMPTY_REPOSITORY_FOLDER, TEST_STD_REPO_FOLDER));
      must_pass(remove_placeholders(TEST_STD_REPO_FOLDER_REL, 'dummy-marker.txt'));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      must_pass(git_status_foreach(repo, @status_cb1, @count));
      must_be_true(count = 0);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

const
   entry_paths2: array[0..14] of AnsiString = (
      'current_file',
      'file_deleted',
      'ignored_file',
      'modified_file',
      'staged_changes',
      'staged_changes_file_deleted',
      'staged_changes_modified_file',
      'staged_delete_file_deleted',
      'staged_delete_modified_file',
      'staged_new_file',
      'staged_new_file_deleted_file',
      'staged_new_file_modified_file',
      'subdir/current_file',
      'subdir/deleted_file',
      'subdir/modified_file'
   );

   entry_statuses2: array[0..14] of UInt = (
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_IGNORED,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_INDEX_DELETED,
      GIT_STATUS_INDEX_DELETED,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_NEW,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_NEW,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_NEW,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_DELETED
   );

   ENTRY_COUNT2 = 15;

procedure Test18_test_status_statuscb.test_retrieving_status_for_a_purged_worktree_of_an_valid_repository;
var
   repo: Pgit_repository;
   counts: status_entry_counts;
   i: Integer;
begin
   must_be_true(copydir_recurs(STATUS_WORKDIR_FOLDER, TEMP_REPO_FOLDER_REL));
   try
      must_be_true(RenameDir(STATUS_REPOSITORY_TEMP_FOLDER_REL, TEST_STD_REPO_FOLDER_REL));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      //* Purging the working */
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'current_file'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'modified_file'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'new_file'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'staged_changes'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'staged_changes_modified_file'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'staged_delete_modified_file'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'staged_new_file'));
      must_pass(p_unlink(TEMP_REPO_FOLDER_REL + 'staged_new_file_modified_file'));
      must_be_true(rmdir_recurs(AnsiString(TEMP_REPO_FOLDER_REL + 'subdir')));

      ZeroMemory(@counts, SizeOf(status_entry_counts));
      counts.expected_entry_count := ENTRY_COUNT2;
      SetLength(counts.expected_paths, Length(entry_paths2));
      for i := Low(entry_paths2) to High(entry_paths2) do
         counts.expected_paths[i] := entry_paths2[i];
      SetLength(counts.expected_statuses, Length(entry_statuses2));
      for i := Low(entry_statuses2) to High(entry_statuses2) do
         counts.expected_statuses[i] := entry_statuses2[i];

      must_pass(git_status_foreach(repo, @status_cb, @counts));
      must_be_true(counts.entry_count = counts.expected_entry_count);
      must_be_true(counts.wrong_status_flags_count = 0);
      must_be_true(counts.wrong_sorted_path = 0);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

const 
   entry_paths3: array [0..22] of AnsiString = (
      '.HEADER',
      '42-is-not-prime.sigh',
      'README.md',
      'current_file',
      'current_file/current_file',
      'current_file/modified_file',
      'current_file/new_file',
      'file_deleted',
      'ignored_file',
      'modified_file',
      'new_file',
      'staged_changes',
      'staged_changes_file_deleted',
      'staged_changes_modified_file',
      'staged_delete_file_deleted',
      'staged_delete_modified_file',
      'staged_new_file',
      'staged_new_file_deleted_file',
      'staged_new_file_modified_file',
      'subdir',
      'subdir/current_file',
      'subdir/deleted_file',
      'subdir/modified_file'
   );

   entry_statuses3: array [0..22] of UInt = (
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_IGNORED,
      GIT_STATUS_WT_MODIFIED,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_WT_MODIFIED or GIT_STATUS_INDEX_MODIFIED,
      GIT_STATUS_INDEX_DELETED,
      GIT_STATUS_WT_NEW or GIT_STATUS_INDEX_DELETED,
      GIT_STATUS_INDEX_NEW,
      GIT_STATUS_WT_DELETED or GIT_STATUS_INDEX_NEW,
      GIT_STATUS_WT_MODIFIED or GIT_STATUS_INDEX_NEW,
      GIT_STATUS_WT_NEW,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_DELETED,
      GIT_STATUS_WT_DELETED
   );

   ENTRY_COUNT3 = 23;

procedure Test18_test_status_statuscb.test_retrieving_status_for_a_worktree_where_a_file_and_a_subdir_have_been_renamed_and_some_files_have_been_added;
var
   repo: Pgit_repository;
   counts: status_entry_counts;
   i: Integer;
begin
   must_be_true(copydir_recurs(STATUS_WORKDIR_FOLDER, TEMP_REPO_FOLDER_REL));
   try
      must_be_true(RenameDir(STATUS_REPOSITORY_TEMP_FOLDER_REL, TEST_STD_REPO_FOLDER_REL));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      must_pass(p_rename(AnsiString(TEMP_REPO_FOLDER_REL + 'current_file'), AnsiString(TEMP_REPO_FOLDER_REL + 'swap')));
      must_be_true(RenameDir(AnsiString(TEMP_REPO_FOLDER_REL + 'subdir'), AnsiString(TEMP_REPO_FOLDER_REL + 'current_file')));
      must_pass(p_rename(AnsiString(TEMP_REPO_FOLDER_REL + 'swap'), AnsiString(TEMP_REPO_FOLDER_REL + 'subdir')));

      must_pass(file_create(TEMP_REPO_FOLDER_REL + '.HEADER', 'dummy'));
      must_pass(file_create(TEMP_REPO_FOLDER_REL + '42-is-not-prime.sigh', 'dummy'));
      must_pass(file_create(TEMP_REPO_FOLDER_REL + 'README.md', 'dummy'));

      ZeroMemory(@counts, SizeOf(status_entry_counts));
      counts.expected_entry_count := ENTRY_COUNT3;
      SetLength(counts.expected_paths, Length(entry_paths3));
      for i := Low(entry_paths3) to High(entry_paths3) do
         counts.expected_paths[i] := entry_paths3[i];
      SetLength(counts.expected_statuses, Length(entry_statuses3));
      for i := Low(entry_statuses3) to High(entry_statuses3) do
         counts.expected_statuses[i] := entry_statuses3[i];
      
      must_pass(git_status_foreach(repo, @status_cb, @counts));
      must_be_true(counts.entry_count = counts.expected_entry_count);
      must_be_true(counts.wrong_status_flags_count = 0);
      must_be_true(counts.wrong_sorted_path = 0);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

{ Test18_test_status_singlestatus }

procedure Test18_test_status_singlestatus.test_retrieving_status_for_single_file;
var
   repo: Pgit_repository;
   status_flags: UInt;
   i: Integer;
begin
   must_be_true(copydir_recurs(STATUS_WORKDIR_FOLDER, TEMP_REPO_FOLDER_REL));
   try
      must_be_true(RenameDir(STATUS_REPOSITORY_TEMP_FOLDER_REL, TEST_STD_REPO_FOLDER_REL));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      for i := 0 to ENTRY_COUNT0 - 1 do
      begin
         must_pass(git_status_file(@status_flags, repo, PAnsiChar(entry_paths0[i])));
         must_be_true(status_flags = entry_statuses0[i]);
      end;

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

procedure Test18_test_status_singlestatus.test_retrieving_status_for_nonexistent_file;
var
   repo: Pgit_repository;
   status_flags: UInt;
   error: Integer;
begin
   must_be_true(copydir_recurs(STATUS_WORKDIR_FOLDER, TEMP_REPO_FOLDER_REL));
   try
      must_be_true(RenameDir(STATUS_REPOSITORY_TEMP_FOLDER_REL, TEST_STD_REPO_FOLDER_REL));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      // "nonexistent" does not exist in HEAD, Index or the worktree
      error := git_status_file(@status_flags, repo, 'nonexistent');
      must_be_true(error = GIT_ENOTFOUND);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

procedure Test18_test_status_singlestatus.test_retrieving_status_for_a_non_existent_file_in_an_empty_repository;
var
   repo: Pgit_repository;
   status_flags: UInt;
   error: Integer;
begin
   must_be_true(copydir_recurs(EMPTY_REPOSITORY_FOLDER, TEST_STD_REPO_FOLDER_REL));
   try
      must_pass(remove_placeholders(TEST_STD_REPO_FOLDER_REL, 'dummy-marker.txt'));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      error := git_status_file(@status_flags, repo, 'nonexistent');
      must_be_true(error = GIT_ENOTFOUND);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

procedure Test18_test_status_singlestatus.test_retrieving_status_for_a_new_file_in_an_empty_repository;
var
   repo: Pgit_repository;
   status_flags: UInt;
   filename: String;
begin
   filename := 'new_file';

   must_be_true(copydir_recurs(EMPTY_REPOSITORY_FOLDER, TEST_STD_REPO_FOLDER_REL));
   try
      must_pass(remove_placeholders(TEST_STD_REPO_FOLDER_REL, 'dummy-marker.txt'));

      file_create(String(TEMP_REPO_FOLDER_REL) + filename, 'new_file'#10);

      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      must_pass(git_status_file(@status_flags, repo, PAnsiChar(AnsiString(filename))));
      must_be_true(status_flags = GIT_STATUS_WT_NEW);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

procedure Test18_test_status_singlestatus.can_t_determine_the_status_for_a_folder;
var
   repo: Pgit_repository;
   status_flags: UInt;
   error: Integer;
begin
   must_be_true(copydir_recurs(STATUS_WORKDIR_FOLDER, TEMP_REPO_FOLDER_REL));
   try
      must_be_true(RenameDir(STATUS_REPOSITORY_TEMP_FOLDER_REL, TEST_STD_REPO_FOLDER_REL));
      must_pass(git_repository_open(repo, TEST_STD_REPO_FOLDER_REL));

      // "nonexistent" does not exist in HEAD, Index or the worktree
      error := git_status_file(@status_flags, repo, 'subdir');
      must_be_true(error = GIT_EINVALIDPATH);

      git_repository_free(repo);
   finally
      rmdir_recurs(TEMP_REPO_FOLDER_REL);
   end;
end;

initialization
   RegisterTest('From libgit2.t18-status', Test18_test_status_file.NamedSuite('file'));
   RegisterTest('From libgit2.t18-status', Test18_test_status_statuscb.NamedSuite('statuscb'));
   RegisterTest('From libgit2.t18-status', Test18_test_status_singlestatus.NamedSuite('singlestatus'));

end.
