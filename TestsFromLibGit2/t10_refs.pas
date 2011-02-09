unit t10_refs;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test10_refs_readtag = class(TTestFromLibGit2)
      procedure loose_tag_reference_looking_up;
      procedure non_existing_tag_reference_looking_up;
   end;

   Test10_refs_readsymref = class(TTestFromLibGit2)
      procedure symbolic_reference_looking_up;
      procedure nested_symbolic_reference_looking_up;
      procedure looking_up_head_then_master;
      procedure looking_up_master_then_head;
   end;

   Test10_refs_readpackedref = class(TTestFromLibGit2)
      procedure packed_reference_looking_up;
      procedure packed_exists_but_more_recent_loose_reference_is_retrieved;
   end;

   Test10_refs_createref = class(TTestFromLibGit2)
      procedure create_new_symbolic_ref;
      procedure create_new_object_id_ref;
   end;

implementation

{ Test10_refs_readtag }

procedure Test10_refs_readtag.loose_tag_reference_looking_up;
const
   loose_tag_ref_name: PAnsiChar = 'refs/tags/test';
var
   repo: Pgit_repository;
   reference: Pgit_reference;
   object_: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(reference, repo, loose_tag_ref_name));
   must_be_true(reference.type_ = GIT_REF_OID);
   must_be_true(reference.packed_ = 0);
   must_be_true(StrComp(reference.name, loose_tag_ref_name) = 0);

   must_pass(git_repository_lookup(object_, repo, git_reference_oid(reference), GIT_OBJ_ANY));
   must_be_true(object_ <> nil);
   must_be_true(git_object_type(object_) = GIT_OBJ_TAG);

   git_repository_free(repo);
end;

procedure Test10_refs_readtag.non_existing_tag_reference_looking_up;
const
   non_existing_tag_ref_name: PAnsiChar = 'refs/tags/i-do-not-exist';
var
   repo: Pgit_repository;
   reference: Pgit_reference;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_fail(git_repository_lookup_ref(reference, repo, non_existing_tag_ref_name), GIT_ENOTFOUND);

   git_repository_free(repo);
end;

{ Test10_refs_readsymref }

const
   head_ref_name:             PAnsiChar = 'HEAD';
   head_tracker_sym_ref_name: PAnsiChar = 'head-tracker';
   current_head_target:       PAnsiChar = 'refs/heads/master';
   current_master_tip:        PAnsiChar = 'be3563ae3f795b2b4353bcce3a527ad0a4f7f644';

procedure Test10_refs_readsymref.symbolic_reference_looking_up;
var
   repo: Pgit_repository;
   reference, resolved_ref: Pgit_reference;
   object_: Pgit_object;
   id: git_oid;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(reference, repo, head_ref_name));
   must_be_true(reference.type_ = GIT_REF_SYMBOLIC);
   must_be_true(reference.packed_ = 0);
   must_be_true(StrComp(reference.name, head_ref_name) = 0);

   must_pass(git_reference_resolve(resolved_ref, reference));
   must_be_true(resolved_ref.type_ = GIT_REF_OID);

   must_pass(git_repository_lookup(object_, repo, git_reference_oid(resolved_ref), GIT_OBJ_ANY));
   must_be_true(object_ <> nil);
   must_be_true(git_object_type(object_) = GIT_OBJ_COMMIT);

   git_oid_mkstr(@id, current_master_tip);
   must_be_true(git_oid_cmp(@id, git_object_id(object_)) = 0);

   git_repository_free(repo);
end;

procedure Test10_refs_readsymref.nested_symbolic_reference_looking_up;
var
   repo: Pgit_repository;
   reference, resolved_ref: Pgit_reference;
   object_: Pgit_object;
   id: git_oid;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(reference, repo, head_tracker_sym_ref_name));
   must_be_true(reference.type_ = GIT_REF_SYMBOLIC);
   must_be_true(reference.packed_ = 0);
   must_be_true(StrComp(reference.name, head_tracker_sym_ref_name) = 0);

   must_pass(git_reference_resolve(resolved_ref, reference));
   must_be_true(resolved_ref.type_ = GIT_REF_OID);

   must_pass(git_repository_lookup(object_, repo, git_reference_oid(resolved_ref), GIT_OBJ_ANY));
   must_be_true(object_ <> nil);
   must_be_true(git_object_type(object_) = GIT_OBJ_COMMIT);

   git_oid_mkstr(@id, current_master_tip);
   must_be_true(git_oid_cmp(@id, git_object_id(object_)) = 0);

   git_repository_free(repo);
end;

procedure Test10_refs_readsymref.looking_up_head_then_master;
var
   repo: Pgit_repository;
   reference, resolved_ref, comp_base_ref: Pgit_reference;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(reference, repo, head_tracker_sym_ref_name));
   must_pass(git_reference_resolve(resolved_ref, reference));
   comp_base_ref := resolved_ref;

   must_pass(git_repository_lookup_ref(reference, repo, head_ref_name));
   must_pass(git_reference_resolve(resolved_ref, reference));
   must_pass(git_oid_cmp(git_reference_oid(comp_base_ref), git_reference_oid(resolved_ref)));

   must_pass(git_repository_lookup_ref(reference, repo, current_head_target));
   must_pass(git_reference_resolve(resolved_ref, reference));
   must_pass(git_oid_cmp(git_reference_oid(comp_base_ref), git_reference_oid(resolved_ref)));

   git_repository_free(repo);
end;

procedure Test10_refs_readsymref.looking_up_master_then_head;
var
   repo: Pgit_repository;
   reference, master_ref, resolved_ref: Pgit_reference;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(master_ref, repo, current_head_target));
   must_pass(git_repository_lookup_ref(reference, repo, head_ref_name));

   must_pass(git_reference_resolve(resolved_ref, reference));
   must_pass(git_oid_cmp(git_reference_oid(master_ref), git_reference_oid(resolved_ref)));

   git_repository_free(repo);
end;

{ Test10_refs_readpackedref }

const
   packed_head_name:       PAnsiChar = 'refs/heads/packed';
   packed_test_head_name:  PAnsiChar = 'refs/heads/packed-test';

procedure Test10_refs_readpackedref.packed_reference_looking_up;
var
   repo: Pgit_repository;
   reference: Pgit_reference;
   object_: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(reference, repo, packed_head_name));
   must_be_true(reference.type_ = GIT_REF_OID);
   must_be_true(reference.packed_ = 1);
   must_be_true(StrComp(reference.name, packed_head_name) = 0);

   must_pass(git_repository_lookup(object_, repo, git_reference_oid(reference), GIT_OBJ_ANY));
   must_be_true(object_ <> nil);
   must_be_true(git_object_type(object_) = GIT_OBJ_COMMIT);

   git_repository_free(repo);
end;

procedure Test10_refs_readpackedref.packed_exists_but_more_recent_loose_reference_is_retrieved;
var
   repo: Pgit_repository;
   reference: Pgit_reference;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_repository_lookup_ref(reference, repo, packed_head_name));
   must_pass(git_repository_lookup_ref(reference, repo, packed_test_head_name));
   must_be_true(reference.type_ = GIT_REF_OID);
   must_be_true(reference.packed_ = 0);
   must_be_true(StrComp(reference.name, packed_test_head_name) = 0);

   git_repository_free(repo);
end;

{ Test10_refs_createref }

procedure Test10_refs_createref.create_new_symbolic_ref;
var
   new_reference, looked_up_ref, resolved_ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
   ref_path: String;
const
   new_head_tracker: PAnsiChar = 'another-head-tracker';
begin
   git_oid_mkstr(@id, current_master_tip);

   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   //* Retrieve the physical path to the symbolic ref for further cleaning */
   ref_path := IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) + String(AnsiString(new_head_tracker));

   //* Create and write the new symbolic reference */
   must_pass(git_reference_new(new_reference, repo));
   git_reference_set_target(new_reference, current_head_target);
   git_reference_set_name(new_reference, new_head_tracker);
   must_pass(git_reference_write(new_reference));

   //* Ensure the reference can be looked-up... */
   must_pass(git_repository_lookup_ref(looked_up_ref, repo, new_head_tracker));
   must_be_true(looked_up_ref.type_ = GIT_REF_SYMBOLIC);
   must_be_true(looked_up_ref.packed_ = 0);
   must_be_true(StrComp(looked_up_ref.name, new_head_tracker) = 0);

   //* ...peeled.. */
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(resolved_ref.type_ = GIT_REF_OID);

   //* ...and that it points to the current master tip */
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   git_repository_free(repo);

   //* Similar test with a fresh new repository */
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(looked_up_ref, repo, new_head_tracker));
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   git_repository_free(repo);

   SysUtils.DeleteFile(ref_path); //* TODO_: replace with git_reference_delete() when available */
end;

procedure Test10_refs_createref.create_new_object_id_ref;
var
   new_reference, looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
   ref_path: String;
const
   new_head: PAnsiChar = 'refs/heads/new-head';
begin
   git_oid_mkstr(@id, current_master_tip);

   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   //* Retrieve the physical path to the symbolic ref for further cleaning */
   ref_path := IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) + String(AnsiString(new_head));

   //* Create and write the new object id reference */
   must_pass(git_reference_new(new_reference, repo));
   git_reference_set_oid(new_reference, @id);
   git_reference_set_name(new_reference, new_head);
   must_pass(git_reference_write(new_reference));

   //* Ensure the reference can be looked-up... */
   must_pass(git_repository_lookup_ref(looked_up_ref, repo, new_head));
   must_be_true(looked_up_ref.type_ = GIT_REF_OID);
   must_be_true(looked_up_ref.packed_ = 0);
   must_be_true(StrComp(looked_up_ref.name, new_head) = 0);

   //* ...and that it points to the current master tip */
   must_be_true(git_oid_cmp(@id, git_reference_oid(looked_up_ref)) = 0);

   git_repository_free(repo);

   //* Similar test with a fresh new repository */
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_repository_lookup_ref(looked_up_ref, repo, new_head));
   must_be_true(git_oid_cmp(@id, git_reference_oid(looked_up_ref)) = 0);

   git_repository_free(repo);

   SysUtils.DeleteFile(ref_path); // TODO_: replace with git_reference_delete() when available */
end;

initialization
   RegisterTest('From libgit2.t10-refs', Test10_refs_readtag.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_readsymref.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_readpackedref.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_createref.Suite);

end.

