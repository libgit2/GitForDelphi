unit uTestsFromLibGit2;

interface

uses
   TestFramework, SysUtils, Windows;

type
   TTestGitForDelphi = class(TTestCase)
   private
      procedure must_pass(aResult: Integer);
   published
      procedure query_details_test_0402;
      procedure simple_walk_test_0501;
      procedure index_loadempty_test_0601;
      procedure index_load_test_0601;
      procedure index2_load_test_0601;
      procedure index_find_test_0601;
      procedure index_findempty_test_0601;
   end;

implementation

uses
   uGitForDelphi;

{ TTestGitForDelphi }

const
   REPOSITORY_FOLDER = 'testrepo.git';
   TEST_INDEX_PATH   = 'testrepo.git/index';
   TEST_INDEX2_PATH  = 'gitgit.index';
   TEST_INDEX_ENTRY_COUNT = 109;
   TEST_INDEX2_ENTRY_COUNT = 1437;


type
   Ptest_entry = ^test_entry;
   test_entry = record
      index:         Integer;
      path:          array [0..127] of AnsiChar;
      file_size:     size_t;
      mtime:         UInt;
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


procedure TTestGitForDelphi.index_load_test_0601;
var
   path: String;
   index: Pgit_index;
   i: Integer;
   e: Pgit_index_entry;
begin
   path := StringReplace(ExtractFilePath(ParamStr(0)) + TEST_INDEX_PATH, '/', '\', [rfReplaceAll]);

   must_pass(git_index_open_bare(index, PAnsiChar(path)));

   CheckEquals(1, index.on_disk);

   must_pass(git_index_read(index));

   CheckTrue(index.on_disk = 1);
   CheckTrue(index.entry_count = TEST_INDEX_ENTRY_COUNT);
   CheckTrue(index.sorted = 1);

   for i := 0 to 4 do
   begin
      e := Ptr(Integer(index.entries) + (TEST_ENTRIES[i].index * sizeof(git_index_entry)));

      CheckTrue(StrComp(e.path, TEST_ENTRIES[i].path) = 0);
      CheckTrue(e.mtime.seconds = TEST_ENTRIES[i].mtime);
      CheckTrue(e.file_size = TEST_ENTRIES[i].file_size);
   end;

   git_index_free(index);
end;

procedure TTestGitForDelphi.must_pass(aResult: Integer);
   function GitReturnValue: String;
   begin
      case aResult of
         GIT_ERROR            : Result := 'GIT_ERROR';
         GIT_ENOTOID          : Result := 'GIT_ENOTOID';
         GIT_ENOTFOUND        : Result := 'GIT_ENOTFOUND';
         GIT_ENOMEM           : Result := 'GIT_ENOMEM';
         GIT_EOSERR           : Result := 'GIT_EOSERR';
         GIT_EOBJTYPE         : Result := 'GIT_EOBJTYPE';
         GIT_EOBJCORRUPTED    : Result := 'GIT_EOBJCORRUPTED';
         GIT_ENOTAREPO        : Result := 'GIT_ENOTAREPO';
         GIT_EINVALIDTYPE     : Result := 'GIT_EINVALIDTYPE';
         GIT_EMISSINGOBJDATA  : Result := 'GIT_EMISSINGOBJDATA';
         GIT_EPACKCORRUPTED   : Result := 'GIT_EPACKCORRUPTED';
         GIT_EFLOCKFAIL       : Result := 'GIT_EFLOCKFAIL';
         GIT_EZLIB            : Result := 'GIT_EZLIB';
         GIT_EBUSY            : Result := 'GIT_EBUSY';
         GIT_EBAREINDEX       : Result := 'GIT_EBAREINDEX';
         else
            Result := 'Unknown';
      end;
   end;
begin
   if not aResult = GIT_SUCCESS then
   begin
      CheckEquals('GIT_SUCCESS', GitReturnValue);
   end;
end;

procedure TTestGitForDelphi.index2_load_test_0601;
var
   index: Pgit_index;
begin
   must_pass(git_index_open_bare(index, TEST_INDEX2_PATH));
   CheckTrue(index.on_disk = 1);

   must_pass(git_index_read(index));

   CheckTrue(index.on_disk = 1);
   CheckTrue(index.entry_count = TEST_INDEX2_ENTRY_COUNT);
   CheckTrue(index.sorted = 1);
   CheckTrue(index.tree <> nil);

   git_index_free(index);
end;

procedure TTestGitForDelphi.index_findempty_test_0601;
var
   index: Pgit_index;
   i, idx: Integer;
begin
   must_pass(git_index_open_bare(index, 'fake-index'));

   for i := 0 to 4 do
   begin
      idx := git_index_find(index, TEST_ENTRIES[i].path);
      CheckTrue(idx = GIT_ENOTFOUND);
   end;

   git_index_free(index);
end;

procedure TTestGitForDelphi.index_find_test_0601;
var
   index: Pgit_index;
   i, idx: Integer;
begin
   must_pass(git_index_open_bare(index, TEST_INDEX_PATH));
   must_pass(git_index_read(index));

   for i := 0 to 4 do
   begin
      idx := git_index_find(index, TEST_ENTRIES[i].path);
      CheckTrue(idx = TEST_ENTRIES[i].index);
   end;

   git_index_free(index);
end;

procedure TTestGitForDelphi.index_loadempty_test_0601;
var
   index: Pgit_index;
begin
   must_pass(git_index_open_bare(index, PAnsiChar('in-memory-index')));
   CheckTrue(index.on_disk = 0);

   CheckEquals(GIT_SUCCESS, git_index_read(index));

   CheckTrue(index.on_disk = 0);
   CheckTrue(index.entry_count = 0);
   CheckTrue(index.sorted = 1);

   git_index_free(index);
end;

procedure TTestGitForDelphi.query_details_test_0402;
const
   commit_ids: array[0..5] of string = (
      'a4a7dce85cf63874e984719f4fdd239f5145052f', { 0 }
      '9fd738e8f7967c078dceed8190330fc8648ee56a', { 1 }
      '4a202b346bb0fb0db7eff3cffeb3c70babbd2045', { 2 }
      'c47800c7266a2be04c571c04d5a6614691ea99bd', { 3 }
      '8496071c1b46c854b31185ea97743be6a8774479', { 4 }
      '5b5b025afb0b4c913b4c338a42934a3863bf3644'  { 5 }
   );
var
   commit_count, i:         Integer;
   repo:                    Pgit_repository;
   id:                      git_oid;
   commit:                  Pgit_commit;
   author, committer:       Pgit_person;
   message_, message_short: String;
   commit_time:             time_t;
begin
   commit_count := High(commit_ids) - Low(commit_ids);

   git_repository_open(repo, PAnsiChar(ExtractFilePath(ParamStr(0)) + REPOSITORY_FOLDER));

   for i := 0 to commit_count - 1 do
   begin
      git_oid_mkstr(@id, PAnsiChar(commit_ids[i]));

      git_commit_lookup(commit, repo, @id);

      message_       := git_commit_message(commit);
      message_short  := git_commit_message_short(commit);
      author         := git_commit_author(commit);
      committer      := git_commit_committer(commit);
      commit_time    := git_commit_time(commit);


      CheckTrue(CompareStr(author.name,      'Scott Chacon') = 0);
      CheckTrue(CompareStr(author.email,     'schacon@gmail.com') = 0);
      CheckTrue(CompareStr(committer.name,   'Scott Chacon') = 0);
      CheckTrue(CompareStr(committer.email,  'schacon@gmail.com') = 0);
      CheckTrue(Pos(#10, message_) > 0);
      CheckTrue(Pos(#10, message_short) = 0);
      CheckTrue(commit_time > 0);
   end;

   git_repository_free(repo);
end;

procedure TTestGitForDelphi.simple_walk_test_0501;
type
   TArray6 = array[0..5] of Integer;
const
   commit_head = 'a4a7dce85cf63874e984719f4fdd239f5145052f';
   commit_ids: array[0..5] of string = (
      'a4a7dce85cf63874e984719f4fdd239f5145052f', { 0 }
      '9fd738e8f7967c078dceed8190330fc8648ee56a', { 1 }
      '4a202b346bb0fb0db7eff3cffeb3c70babbd2045', { 2 }
      'c47800c7266a2be04c571c04d5a6614691ea99bd', { 3 }
      '8496071c1b46c854b31185ea97743be6a8774479', { 4 }
      '5b5b025afb0b4c913b4c338a42934a3863bf3644'  { 5 }
   );

   //* Careful: there are two possible topological sorts */
   commit_sorting_topo: array [0..1] of TArray6 =
   (
      (0, 1, 2, 3, 5, 4), (0, 3, 1, 2, 5, 4)
   );

   commit_sorting_time: array [0..0] of TArray6 =
   (
      (0, 3, 1, 2, 5, 4)
   );

   commit_sorting_topo_reverse: array [0..1] of TArray6 = (
      (4, 5, 3, 2, 1, 0), (4, 5, 2, 1, 3, 0)
   );

   commit_sorting_time_reverse: array [0..0] of TArray6 = (
      (4, 5, 2, 1, 3, 0)
   );

   commit_count = 6;
   result_bytes = 24;

   function get_commit_index(commit: Pgit_commit): Integer;
   var
      i: Integer;
      oid: array[0..39] of AnsiChar;
   begin
      git_oid_fmt(oid, @commit.object_.id);

      for i := 0 to commit_count - 1 do
      begin
         if CompareMem(@oid, PAnsiChar(commit_ids[i]), 40) then
         begin
            Result := i;
            Exit;
         end;
      end;

      Result := -1;
   end;


   function test_walk(walk: Pgit_revwalk; start_from: Pgit_commit;
         flags: Integer; const possible_results: array of TArray6; results_count: Integer): Integer;
   var
      commit: Pgit_commit;

      i: Integer;
      result_array: array [0..commit_count-1] of Integer;
   begin
      git_revwalk_sorting(walk, flags);
      git_revwalk_push(walk, start_from);

      for i := 0 to commit_count - 1 do
         result_array[i] := -1;

      i := 0;
      commit := git_revwalk_next(walk);
      while (commit <> nil) do
      begin
         result_array[i] := get_commit_index(commit);
         commit := git_revwalk_next(walk);
         Inc(i);
      end;

      for i := 0 to results_count - 1 do
      begin
         if CompareMem(@possible_results[i], @result_array, result_bytes) then
         begin
            Result := GIT_SUCCESS;
            Exit;
         end;
      end;

      Result := GIT_ERROR;
   end;

var
   id: git_oid;
   repo: Pgit_repository;
   walk: Pgit_revwalk;
   head: Pgit_commit;
begin
   repo := nil;
   head := nil;

   git_repository_open(repo, PAnsiChar(ExtractFilePath(ParamStr(0)) + REPOSITORY_FOLDER));

   git_revwalk_new(walk, repo);

   git_oid_mkstr(@id, commit_head);

   git_commit_lookup(head, repo, @id);

   CheckEquals(GIT_SUCCESS,
      test_walk(walk, head,
            GIT_SORT_TIME,
            commit_sorting_time, 1)
   );

   CheckEquals(GIT_SUCCESS,
      test_walk(walk, head,
            GIT_SORT_TOPOLOGICAL,
            commit_sorting_topo, 2)
   );

   CheckEquals(GIT_SUCCESS,
      test_walk(walk, head,
            GIT_SORT_TIME or GIT_SORT_REVERSE,
            commit_sorting_time_reverse, 1)
   );

   CheckEquals(GIT_SUCCESS,
      test_walk(walk, head,
            GIT_SORT_TOPOLOGICAL or GIT_SORT_REVERSE,
            commit_sorting_topo_reverse, 2)
   );

   git_revwalk_free(walk);
   git_repository_free(repo);
end;

initialization
   InitLibgit2;
   RegisterTest(TTestGitForDelphi.Suite);

end.
