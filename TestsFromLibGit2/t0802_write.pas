unit t0802_write;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test0802_write = class(TTestFromLibGit2)
      procedure tag_writeback_test_0802;
   end;

implementation

{ Test0802_write }

procedure Test0802_write.tag_writeback_test_0802;
const
   TAGGER_NAME:      PAnsiChar = 'Vicent Marti';
   TAGGER_EMAIL:     PAnsiChar = 'vicent@github.com';
   TAGGER_MESSAGE:   PAnsiChar = 'This is my tag.'#10#10'There are many tags, but this one is mine'#10;
var
   repo: Pgit_repository;
   tag: Pgit_tag;
   target_id, tag_id: git_oid;
   tagger: Pgit_signature;
   ref_tag: Pgit_reference;
//   hex_oid: array [0..40] of AnsiChar;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_mkstr(@target_id, tagged_commit);

   //* create signatures */
   tagger := git_signature_new(TAGGER_NAME, TAGGER_EMAIL, 123456789, 60);
   must_be_true(tagger <> nil);

   must_pass(git_tag_create(
      @tag_id, //* out id */
      repo,
      'the-tag', //* do not update the HEAD */
      @target_id,
      GIT_OBJ_COMMIT,
      tagger,
      TAGGER_MESSAGE));



   git_signature_free(Pgit_signature(tagger));


   must_pass(git_tag_lookup(tag, repo, @tag_id));

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

   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2', Test0802_write.Suite);

end.
