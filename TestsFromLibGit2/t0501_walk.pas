unit t0501_walk;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0501_walk = class(TTestFromLibGit2)
      procedure simple_walk_test_0501;
   end;

implementation

{ Test0501_walk }

procedure Test0501_walk.simple_walk_test_0501;
type
   TArray6 = array[0..5] of Integer;
const
   commit_head = 'a4a7dce85cf63874e984719f4fdd239f5145052f';
   commit_ids: array[0..5] of AnsiString = (
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

   function get_commit_index(raw_oid: Pgit_oid): Integer;
   var
      i: Integer;
      oid: array[0..39] of AnsiChar;
   begin
      git_oid_fmt(oid, raw_oid);

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


   function test_walk(walk: Pgit_revwalk;
         flags: Integer; const possible_results: array of TArray6; results_count: Integer): Integer;
   var
      oid: git_oid;

      ret, i: Integer;
      result_array: array [0..commit_count-1] of Integer;
   begin
      git_revwalk_reset(walk);
      git_revwalk_sorting(walk, flags);

      for i := 0 to commit_count - 1 do
         result_array[i] := -1;

      i := 0;
      ret := git_revwalk_next(@oid, walk);
      while (ret = GIT_SUCCESS) do
      begin
         result_array[i] := get_commit_index(@oid);
         (*{
            char str[41];
            git_oid_fmt(str, &oid);
            str[40] = 0;
            printf("  %d) %s\n", i, str);
         }*)
         Inc(i);
         ret := git_revwalk_next(@oid, walk);
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
begin
   repo := nil;

   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_revwalk_new(walk, repo));

   git_oid_mkstr(@id, commit_head);
   git_revwalk_push(walk, @id);

   must_pass(test_walk(walk, GIT_SORT_TIME, commit_sorting_time, 1));

   must_pass(test_walk(walk, GIT_SORT_TOPOLOGICAL, commit_sorting_topo, 2));

   must_pass(test_walk(walk, GIT_SORT_TIME or GIT_SORT_REVERSE, commit_sorting_time_reverse, 1));

   must_pass(test_walk(walk, GIT_SORT_TOPOLOGICAL or GIT_SORT_REVERSE, commit_sorting_topo_reverse, 2));

   git_revwalk_free(walk);
   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0501_walk.Suite);

end.
