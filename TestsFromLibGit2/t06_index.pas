unit t06_index;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test06_index_read = class(TTestFromLibGit2)
      procedure index_loadempty_test_0601;
      procedure index_load_test_0601;
      procedure index2_load_test_0601;
      procedure index_find_test_0601;
      procedure index_findempty_test_0601;
   end;

   Test06_index_write = class(TTestFromLibGit2)
      procedure index_write_test;
   end;

implementation

{ Test0601_read }

procedure Test06_index_read.index_loadempty_test_0601;
var
   index: Pgit_index;
begin
   must_pass(git_index_open_bare(index, PAnsiChar('in-memory-index')));
   CheckTrue(index.on_disk = 0);

   must_pass(git_index_read(index));

   CheckTrue(index.on_disk = 0);
   CheckTrue(git_index_entrycount(index) = 0);
   CheckTrue(index.entries.sorted = 1);

   git_index_free(index);
end;

procedure Test06_index_read.index_load_test_0601;
var
   path: AnsiString;
   index: Pgit_index;
   i, offset: Integer;
   entries: PPgit_index_entry;
   e: Pgit_index_entry;
begin
   path := AnsiString(StringReplace(ExtractFilePath(ParamStr(0)) + TEST_INDEX_PATH, '/', '\', [rfReplaceAll]));

   must_pass(git_index_open_bare(index, PAnsiChar(path)));

   CheckTrue(index.on_disk = 1);

   must_pass(git_index_read(index));

   CheckTrue(index.on_disk = 1);
   CheckTrue(git_index_entrycount(index) = TEST_INDEX_ENTRY_COUNT);
   CheckTrue(index.entries.sorted = 1);

   entries := PPgit_index_entry(index.entries.contents);

   for i := Low(TEST_ENTRIES) to High(TEST_ENTRIES) do
   begin
      offset := TEST_ENTRIES[i].index * sizeof(Pgit_index_entry);
      e := PPgit_index_entry(Integer(entries) + offset)^;

      CheckTrue(StrComp(e.path, TEST_ENTRIES[i].path) = 0);
      CheckTrue(e.mtime.seconds = TEST_ENTRIES[i].mtime);
      CheckTrue(e.file_size = TEST_ENTRIES[i].file_size);
   end;

   git_index_free(index);
end;

procedure Test06_index_read.index2_load_test_0601;
var
   index: Pgit_index;
begin
   must_pass(git_index_open_bare(index, TEST_INDEX2_PATH));
   CheckTrue(index.on_disk = 1);

   must_pass(git_index_read(index));

   CheckTrue(index.on_disk = 1);
   CheckTrue(git_index_entrycount(index) = TEST_INDEX2_ENTRY_COUNT);
   CheckTrue(index.entries.sorted = 1);
   CheckTrue(index.tree <> nil);

   git_index_free(index);
end;

procedure Test06_index_read.index_find_test_0601;
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

procedure Test06_index_read.index_findempty_test_0601;
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

procedure Test06_index_write.index_write_test;
var
   index: Pgit_index;
begin
   CopyFile(TEST_INDEXBIG_PATH, 'index_rewrite', true);

   must_pass(git_index_open_bare(index, 'index_rewrite'));
   must_pass(git_index_read(index));
   must_be_true(index.on_disk > 0);

   must_pass(git_index_write(index));
   must_pass(cmp_files(TEST_INDEXBIG_PATH, 'index_rewrite'));

   git_index_free(index);

   SysUtils.DeleteFile('index_rewrite');
end;

initialization
   RegisterTest('From libgit2.t06-index', Test06_index_read.Suite);
   RegisterTest('From libgit2.t06-index', Test06_index_write.Suite);

end.
