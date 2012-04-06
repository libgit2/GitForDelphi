unit t08_tag;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test08_tag_read = class(TTestFromLibGit2)
      procedure read_and_parse_a_tag_from_the_repository;
      procedure list_all_tag_names_from_the_repository;
   end;

   Test08_tag_write = class(TTestFromLibGit2)
      procedure write_a_tag_to_the_repository_and_read_it_again;
      procedure attempt_to_write_a_tag_bearing_the_same_name_than_an_already_existing_tag;
      procedure replace_an_already_existing_tag;
      procedure delete_an_already_existing_tag;
   end;

implementation

{ Test08_tag_read }

procedure Test08_tag_read.read_and_parse_a_tag_from_the_repository;
var
   repo: Pgit_repository;
   tag1, tag2: Pgit_tag;
   commit: Pgit_commit;
   id1, id2, id_commit: git_oid;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_fromstr(@id1, tag1_id);
   git_oid_fromstr(@id2, tag2_id);
   git_oid_fromstr(@id_commit, tagged_commit);

   must_pass(git_tag_lookup(tag1, repo, @id1));

   CheckTrue(StrComp(git_tag_name(tag1), 'test') = 0);
   CheckTrue(git_tag_type(tag1) = GIT_OBJ_TAG);

   must_pass(git_tag_target(Pgit_object(tag2), tag1));
   CheckTrue(tag2 <> nil);

   CheckTrue(git_oid_cmp(@id2, git_tag_id(tag2)) = 0);

   must_pass(git_tag_target(Pgit_object(commit), tag2));
   CheckTrue(commit <> nil);

   CheckTrue(git_oid_cmp(@id_commit, git_commit_id(commit)) = 0);

   git_tag_free(tag1);
   git_tag_free(tag2);
   git_commit_free(commit);
   git_repository_free(repo);
end;

procedure Test08_tag_read.list_all_tag_names_from_the_repository;
var
   repo: Pgit_repository;
   tag_list: git_strarray;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_tag_list(@tag_list, repo));

   must_be_true(tag_list.count = 3);

   git_strarray_free(@tag_list);
   git_repository_free(repo);
end;

const
   TAGGER_NAME:      PAnsiChar = 'Vicent Marti';
   TAGGER_EMAIL:     PAnsiChar = 'vicent@github.com';
   TAGGER_MESSAGE:   PAnsiChar = 'This is my tag.'#10#10'There are many tags, but this one is mine'#10;

{ Test08_tag_write }

procedure Test08_tag_write.write_a_tag_to_the_repository_and_read_it_again;
var
   repo: Pgit_repository;
   tag: Pgit_tag;
   target_id, tag_id: git_oid;
   tagger: Pgit_signature;
   ref_tag: Pgit_reference;
   target: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_fromstr(@target_id, tagged_commit);
   must_pass(git_object_lookup(target, repo, @target_id, GIT_OBJ_COMMIT));

   //* create signature */
   must_pass(git_signature_new(tagger, TAGGER_NAME, TAGGER_EMAIL, 123456789, 60));

   must_pass(git_tag_create(
      @tag_id, //* out id */
      repo,
      'the-tag',
      target,
      tagger,
      TAGGER_MESSAGE,
      0));

   git_object_free(target);
   git_signature_free(tagger);

   must_pass(git_tag_lookup(tag, repo, @tag_id));
   must_be_true(git_oid_cmp(git_tag_target_oid(tag), @target_id) = 0);

   //* Check attributes were set correctly */
   tagger := git_tag_tagger(tag);
   must_be_true(tagger <> nil);
   must_be_true(StrComp(tagger.name, TAGGER_NAME) = 0);
   must_be_true(StrComp(tagger.email, TAGGER_EMAIL) = 0);
   must_be_true(tagger.when.time = 123456789);
   must_be_true(tagger.when.offset = 60);

   must_be_true(StrComp(git_tag_message(tag), TAGGER_MESSAGE) = 0);

   must_pass(git_reference_lookup(ref_tag, repo, 'refs/tags/the-tag'));
   must_be_true(git_oid_cmp(git_reference_oid(ref_tag), @tag_id) = 0);
   must_pass(git_reference_delete(ref_tag));

   must_pass(remove_loose_object(REPOSITORY_FOLDER, Pgit_object(tag)));

   git_tag_free(tag);
   git_repository_free(repo);
end;

procedure Test08_tag_write.attempt_to_write_a_tag_bearing_the_same_name_than_an_already_existing_tag;
var
   repo: Pgit_repository;
   target_id, tag_id: git_oid;
   tagger: Pgit_signature;
   target: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_fromstr(@target_id, tagged_commit);
   must_pass(git_object_lookup(target, repo, @target_id, GIT_OBJ_COMMIT));

   //* create signature */
   must_pass(git_signature_new(tagger, TAGGER_NAME, TAGGER_EMAIL, 123456789, 60));

   must_fail(git_tag_create(
      @tag_id, //* out id */
      repo,
      'e90810b',
      target,
      tagger,
      TAGGER_MESSAGE,
      0));

   git_object_free(target);
   git_signature_free(Pgit_signature(tagger));

   git_repository_free(repo);
end;

procedure Test08_tag_write.replace_an_already_existing_tag;
var
   repo: Pgit_repository;
   target_id, tag_id, old_tag_id: git_oid;
   tagger: Pgit_signature;
   ref_tag: Pgit_reference;
   target: Pgit_object;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   git_oid_fromstr(@target_id, tagged_commit);
   must_pass(git_object_lookup(target, repo, @target_id, GIT_OBJ_COMMIT));

   must_pass(git_reference_lookup(ref_tag, repo, 'refs/tags/e90810b'));
   git_oid_cpy(@old_tag_id, git_reference_oid(ref_tag));
   git_reference_free(ref_tag);

   //* create signature */
   must_pass(git_signature_new(tagger, TAGGER_NAME, TAGGER_EMAIL, 123456789, 60));

   must_pass(git_tag_create(
      @tag_id, //* out id */
      repo,
      'e90810b',
      target,
      tagger,
      TAGGER_MESSAGE,
      1));

   git_object_free(target);
   git_signature_free(Pgit_signature(tagger));

   must_pass(git_reference_lookup(ref_tag, repo, 'refs/tags/e90810b'));
   must_be_true(git_oid_cmp(git_reference_oid(ref_tag), @tag_id) = 0);
   must_be_true(git_oid_cmp(git_reference_oid(ref_tag), @old_tag_id) <> 0);

   close_temp_repo(repo);

   git_reference_free(ref_tag);
end;

procedure Test08_tag_write.delete_an_already_existing_tag;
var
   repo: Pgit_repository;
   ref_tag: Pgit_reference;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   must_pass(git_tag_delete(repo,'e90810b'));

   must_fail(git_reference_lookup(ref_tag, repo, 'refs/tags/e90810b'));

   close_temp_repo(repo);
end;

initialization
   RegisterTest('From libgit2.t08-tag', Test08_tag_read.NamedSuite('read'));
   RegisterTest('From libgit2.t08-tag', Test08_tag_write.NamedSuite('write'));

end.
