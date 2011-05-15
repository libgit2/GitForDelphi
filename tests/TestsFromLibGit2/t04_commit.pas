unit t04_commit;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test04_commit_details = class(TTestFromLibGit2)
      procedure query_the_details_on_a_parsed_commit;
   end;

   Test04_commit_write = class(TTestFromLibGit2)
      procedure write_a_new_commit_object_from_memory_to_disk;
   end;

   Test04_commit_root = class(TTestFromLibGit2)
      procedure create_a_root_commit;
   end;

implementation

const
   commit_ids: array[0..5] of AnsiString = (
      'a4a7dce85cf63874e984719f4fdd239f5145052f', { 0 }
      '9fd738e8f7967c078dceed8190330fc8648ee56a', { 1 }
      '4a202b346bb0fb0db7eff3cffeb3c70babbd2045', { 2 }
      'c47800c7266a2be04c571c04d5a6614691ea99bd', { 3 }
      '8496071c1b46c854b31185ea97743be6a8774479', { 4 }
      '5b5b025afb0b4c913b4c338a42934a3863bf3644'  { 5 }
   );

{ Test04_commit_details }

procedure Test04_commit_details.query_the_details_on_a_parsed_commit;
var
   i:                       Integer;
   repo:                    Pgit_repository;
   id:                      git_oid;
   commit:                  Pgit_commit;
   author, committer:       Pgit_signature;
   message_, message_short: AnsiString;
   commit_time:             time_t;
   parents, p:              UInt;
   parent, old_parent:      Pgit_commit;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   for i := Low(commit_ids) to High(commit_ids) do
   begin
      parent := nil;
      old_parent := nil;
      git_oid_mkstr(@id, PAnsiChar(commit_ids[i]));

      must_pass(git_commit_lookup(commit, repo, @id));

      message_       := git_commit_message(commit);
      message_short  := git_commit_message_short(commit);
      author         := git_commit_author(commit);
      committer      := git_commit_committer(commit);
      commit_time    := git_commit_time(commit);
      parents        := git_commit_parentcount(commit);

      CheckTrue(StrComp(author.name,      'Scott Chacon') = 0);
      CheckTrue(StrComp(author.email,     'schacon@gmail.com') = 0);
      CheckTrue(StrComp(committer.name,   'Scott Chacon') = 0);
      CheckTrue(StrComp(committer.email,  'schacon@gmail.com') = 0);
      CheckTrue(Pos(#10, String(message_)) > 0);
      CheckTrue(Pos(#10, String(message_short)) = 0);
      CheckTrue(commit_time > 0);

      CheckTrue(parents <= 2, 'parents <= 2');
      p := 0;
      while p < parents do
      begin
         if Assigned(old_parent) then
            git_commit_close(old_parent);

         old_parent := parent;

         must_pass(git_commit_parent(parent, commit, p));
         CheckTrue(parent <> nil, 'parent <> nil');
         CheckTrue(git_commit_author(parent) <> nil, 'git_commit_author(parent) <> nil'); // is it really a commit?
         Inc(p);
      end;
      must_fail(git_commit_parent(parent, commit, parents));
      git_commit_close(commit);
   end;

   git_repository_free(repo);
end;

const
   COMMITTER_NAME:   PAnsiChar = 'Vicent Marti';
   COMMITTER_EMAIL:  PAnsiChar = 'vicent@github.com';
   COMMIT_MESSAGE:   PAnsiChar =
      'This commit has been created in memory'#10 +
      'This is a commit created in memory and it will be written back to disk'#10;
   tree_oid:         PAnsiChar = '1810dff58d8a660512d4832e740f692884338ccd';

{ Test04_commit_write }

procedure Test04_commit_write.write_a_new_commit_object_from_memory_to_disk;
var
   repo: Pgit_repository;
   commit: Pgit_commit;
   tree_id, parent_id, commit_id: git_oid;
   author, committer: Pgit_signature;
   //* char hex_oid[41]; */
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@tree_id, tree_oid);
   git_oid_mkstr(@parent_id, PAnsiChar(commit_ids[4]));

   //* create signatures */
   committer := git_signature_new(COMMITTER_NAME, COMMITTER_EMAIL, 123456789, 60);
   must_be_true(committer <> nil);

   author := git_signature_new(COMMITTER_NAME, COMMITTER_EMAIL, 987654321, 90);
   must_be_true(author <> nil);

   must_pass(git_commit_create_v(
      @commit_id, //* out id */
      repo,
      nil, //* do not update the HEAD */
      author,
      committer,
      COMMIT_MESSAGE,
      @tree_id,
      1, @parent_id));

   git_signature_free(Pgit_signature(committer));
   git_signature_free(Pgit_signature(author));

   must_pass(git_commit_lookup(commit, repo, @commit_id));

   //* Check attributes were set correctly */
   author := git_commit_author(commit);
   must_be_true(author <> nil);
   must_be_true(StrComp(author.name, COMMITTER_NAME) = 0);
   must_be_true(StrComp(author.email, COMMITTER_EMAIL) = 0);
   must_be_true(author.when.time = 987654321);
   must_be_true(author.when.offset = 90);

   committer := git_commit_committer(commit);
   must_be_true(committer <> nil);
   must_be_true(StrComp(committer.name, COMMITTER_NAME) = 0);
   must_be_true(StrComp(committer.email, COMMITTER_EMAIL) = 0);
   must_be_true(committer.when.time = 123456789);
   must_be_true(committer.when.offset = 60);

   must_be_true(StrComp(git_commit_message(commit), COMMIT_MESSAGE) = 0);

   must_pass(remove_loose_object(REPOSITORY_FOLDER, Pgit_object(commit)));

   git_commit_close(commit);
   git_repository_free(repo);
end;

const
   ROOT_COMMIT_MESSAGE: PAnsiChar =
      'This is a root commit'#10 +
      'This is a root commit and should be the only one in this branch'#13;

{ Test04_commit_root }

procedure Test04_commit_root.create_a_root_commit;
var
   repo: Pgit_repository;
   commit: Pgit_commit;
   tree_id, commit_id: git_oid;
   branch_oid: Pgit_oid;
   author, committer: Pgit_signature;
   head, branch: Pgit_reference;
   head_old: AnsiString;
const
   branch_name: PAnsiChar = 'refs/heads/root-commit-branch';
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@tree_id, tree_oid);

   //* create signatures */
   committer := git_signature_new(COMMITTER_NAME, COMMITTER_EMAIL, 123456789, 60);
   must_be_true(committer <> nil);

   author := git_signature_new(COMMITTER_NAME, COMMITTER_EMAIL, 987654321, 90);
   must_be_true(author <> nil);

   //* First we need to update HEAD so it points to our non-existant branch */
   must_pass(git_reference_lookup(head, repo, 'HEAD'));
   must_be_true(git_reference_type(head) = GIT_REF_SYMBOLIC);
   head_old := AnsiString(git_reference_target(head));
   must_be_true(head_old <> '');

   must_pass(git_reference_set_target(head, branch_name));

   must_pass(git_commit_create_v(
      @commit_id, //* out id */
      repo,
      'HEAD',
      author,
      committer,
      ROOT_COMMIT_MESSAGE,
      @tree_id,
      0));

   git_signature_free(Pgit_signature(committer));
   git_signature_free(Pgit_signature(author));

   {/*
    * The fact that creating a commit works has already been
    * tested. Here we just make sure it's our commit and that it was
    * written as a root commit.
    */}
   must_pass(git_commit_lookup(commit, repo, @commit_id));
   must_be_true(git_commit_parentcount(commit) = 0);
   must_pass(git_reference_lookup(branch, repo, branch_name));
   branch_oid := git_reference_oid(branch);
   must_pass(git_oid_cmp(branch_oid, @commit_id));
   must_be_true(StrComp(git_commit_message(commit), ROOT_COMMIT_MESSAGE) = 0);

   //* Remove the data we just added to the repo */
   must_pass(git_reference_lookup(head, repo, 'HEAD'));
   must_pass(git_reference_set_target(head, PAnsiChar(head_old)));
   must_pass(git_reference_delete(branch));
   must_pass(remove_loose_object(REPOSITORY_FOLDER, Pgit_object(commit)));
   head_old := '';
   git_commit_close(commit);
   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2.t04-commit', Test04_commit_details.NamedSuite('details'));
   RegisterTest('From libgit2.t04-commit', Test04_commit_write.NamedSuite('write'));
   RegisterTest('From libgit2.t04-commit', Test04_commit_root.NamedSuite('root'));

end.
