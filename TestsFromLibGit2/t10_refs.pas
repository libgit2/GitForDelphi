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
      procedure create_new_deep_symbolic_ref;
      procedure create_new_object_id_ref;
   end;

   Test10_refs_packfile = class(TTestFromLibGit2)
      procedure create_packfile_for_empty_folder;
      procedure create_packfile_from_all_loose;
   end;

   Test10_refs_rename = class(TTestFromLibGit2)
      procedure rename_loose_reference;
      procedure rename_packed_reference__should_make_it_loose;
      procedure rename_packed_reference_does_not_pack_reference_which_is_both_loose_and_packed;
      procedure cannot_rename_reference_to_existing_reference;
      procedure cannot_rename_reference_to_invalid_name;
   end;

   Test10_refs_delete = class(TTestFromLibGit2)
      procedure delete_reference_deletes_both_packed_and_loose;
   end;

   Test10_refs_list = class(TTestFromLibGit2)
      procedure list_all_the_references_in_our_test_repo;
   end;

implementation

const
   loose_tag_ref_name: PAnsiChar = 'refs/tags/test';

{ Test10_refs_readtag }

procedure Test10_refs_readtag.loose_tag_reference_looking_up;
var
   repo: Pgit_repository;
   reference: Pgit_reference;
   object_: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_reference_lookup(reference, repo, loose_tag_ref_name));
   must_be_true((reference.type_ and GIT_REF_OID) > 0);
   must_be_true((reference.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(reference.name, loose_tag_ref_name) = 0);

   must_pass(git_object_lookup(object_, repo, git_reference_oid(reference), GIT_OBJ_ANY));
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
   must_fail(git_reference_lookup(reference, repo, non_existing_tag_ref_name), GIT_ENOTFOUND);

   git_repository_free(repo);
end;

{ Test10_refs_readsymref }

const
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

   must_pass(git_reference_lookup(reference, repo, GIT_HEAD_FILE));
   must_be_true((reference.type_ and GIT_REF_SYMBOLIC) > 0);
   must_be_true((reference.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(reference.name, GIT_HEAD_FILE) = 0);

   must_pass(git_reference_resolve(resolved_ref, reference));
   must_be_true(resolved_ref.type_ = GIT_REF_OID);

   must_pass(git_object_lookup(object_, repo, git_reference_oid(resolved_ref), GIT_OBJ_ANY));
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

   must_pass(git_reference_lookup(reference, repo, head_tracker_sym_ref_name));
   must_be_true((reference.type_ and GIT_REF_SYMBOLIC) > 0);
   must_be_true((reference.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(reference.name, head_tracker_sym_ref_name) = 0);

   must_pass(git_reference_resolve(resolved_ref, reference));
   must_be_true(resolved_ref.type_ = GIT_REF_OID);

   must_pass(git_object_lookup(object_, repo, git_reference_oid(resolved_ref), GIT_OBJ_ANY));
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

   must_pass(git_reference_lookup(reference, repo, head_tracker_sym_ref_name));
   must_pass(git_reference_resolve(resolved_ref, reference));
   comp_base_ref := resolved_ref;

   must_pass(git_reference_lookup(reference, repo, GIT_HEAD_FILE));
   must_pass(git_reference_resolve(resolved_ref, reference));
   must_pass(git_oid_cmp(git_reference_oid(comp_base_ref), git_reference_oid(resolved_ref)));

   must_pass(git_reference_lookup(reference, repo, current_head_target));
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

   must_pass(git_reference_lookup(master_ref, repo, current_head_target));
   must_pass(git_reference_lookup(reference, repo, GIT_HEAD_FILE));

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

   must_pass(git_reference_lookup(reference, repo, packed_head_name));
   must_be_true((reference.type_ and GIT_REF_OID) > 0);
   must_be_true((reference.type_ and GIT_REF_PACKED) > 0);
   must_be_true(StrComp(reference.name, packed_head_name) = 0);

   must_pass(git_object_lookup(object_, repo, git_reference_oid(reference), GIT_OBJ_ANY));
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
   must_pass(git_reference_lookup(reference, repo, packed_head_name));
   must_pass(git_reference_lookup(reference, repo, packed_test_head_name));
   must_be_true((reference.type_ and GIT_REF_OID) > 0);
   must_be_true((reference.type_ and GIT_REF_PACKED) = 0);
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
   must_pass(git_reference_create_symbolic(new_reference, repo, new_head_tracker, current_head_target));
   git_reference_set_target(new_reference, current_head_target);

   //* Ensure the reference can be looked-up... */
   must_pass(git_reference_lookup(looked_up_ref, repo, new_head_tracker));
   must_be_true((looked_up_ref.type_ and GIT_REF_SYMBOLIC) > 0);
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(looked_up_ref.name, new_head_tracker) = 0);

   //* ...peeled.. */
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(resolved_ref.type_ = GIT_REF_OID);

   //* ...and that it points to the current master tip */
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   git_repository_free(repo);

   //* Similar test with a fresh new repository */
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_reference_lookup(looked_up_ref, repo, new_head_tracker));
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   git_repository_free(repo);

   SysUtils.DeleteFile(ref_path); //* TODO_: replace with git_reference_delete() when available */
end;

procedure Test10_refs_createref.create_new_deep_symbolic_ref;
var
   new_reference, looked_up_ref, resolved_ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
   repo_path, ref_path: String;
const
   new_head_tracker: PAnsiChar = 'deep/rooted/tracker';
begin
   git_oid_mkstr(@id, current_master_tip);

   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   repo_path := StringReplace(String(AnsiString(repo.path_repository)), '/', PathDelim, [rfReplaceAll]);
   ref_path := IncludeTrailingPathDelimiter(repo_path + String(AnsiString(new_head_tracker)));
   ref_path := StringReplace(ref_path, PathDelim, '/', [rfReplaceAll]);

   must_pass(git_reference_create_symbolic(new_reference, repo, new_head_tracker, current_head_target));
   must_pass(git_reference_lookup(looked_up_ref, repo, new_head_tracker));
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   git_repository_free(repo);

   rmdir_recurs(ref_path);
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
   must_pass(git_reference_create_oid(new_reference, repo, new_head, @id));

   //* Ensure the reference can be looked-up... */
   must_pass(git_reference_lookup(looked_up_ref, repo, new_head));
   must_be_true((looked_up_ref.type_ and GIT_REF_OID) > 0);
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(looked_up_ref.name, new_head) = 0);

   //* ...and that it points to the current master tip */
   must_be_true(git_oid_cmp(@id, git_reference_oid(looked_up_ref)) = 0);

   git_repository_free(repo);

   //* Similar test with a fresh new repository */
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_reference_lookup(looked_up_ref, repo, new_head));
   must_be_true(git_oid_cmp(@id, git_reference_oid(looked_up_ref)) = 0);

   git_repository_free(repo);

   SysUtils.DeleteFile(ref_path); // TODO_: replace with git_reference_delete() when available */
end;

procedure Test10_refs_packfile.create_packfile_for_empty_folder;
var
   repo: Pgit_repository;
   temp_path: String;
//   mode: Integer;
begin
//   mode := 0755; //* or 0777 ? */

   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      IncludeTrailingPathDelimiter(String(AnsiString(GIT_REFS_HEADS_DIR))) +
      'empty_dir';

   ForceDirectories(temp_path);

   must_pass(git_reference_packall(repo));

   close_temp_repo(repo);
end;

procedure Test10_refs_packfile.create_packfile_from_all_loose;
const
   loose_tag_ref_name: PAnsiChar = 'refs/tags/test';
   non_existing_tag_ref_name: PAnsiChar = 'refs/tags/i-do-not-exist';
var
   repo: Pgit_repository;
   reference: Pgit_reference;
   temp_path: String;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* Ensure a known loose ref can be looked up */
   must_pass(git_reference_lookup(reference, repo, loose_tag_ref_name));
   must_be_true((reference.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(reference.name, loose_tag_ref_name) = 0);

   must_pass(git_reference_packall(repo));

   //* Ensure the packed-refs file exists */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(GIT_PACKEDREFS_FILE));
   must_pass(gitfo_exists(temp_path));

   //* Ensure the known ref can still be looked up but is now packed */
   must_pass(git_reference_lookup(reference, repo, loose_tag_ref_name));
   must_be_true((reference.type_ and GIT_REF_PACKED) <> 0);
   must_be_true(StrComp(reference.name, loose_tag_ref_name) = 0);

   //* Ensure the known ref has been removed from the loose folder structure */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(loose_tag_ref_name));
   must_pass(gitfo_not_exists(temp_path));

   close_temp_repo(repo);
end;

procedure Test10_refs_rename.rename_loose_reference;
var
   looked_up_ref, another_looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
   temp_path: String;
const
   new_name: PAnsiChar = 'refs/tags/Nemo/knows/refs.kung-fu';
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* Ensure the ref doesn't exist on the file system */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(new_name));
   must_pass(gitfo_not_exists(temp_path));

   //* Retrieval of the reference to rename */
   must_pass(git_reference_lookup(looked_up_ref, repo, loose_tag_ref_name));

   //* ... which is indeed loose */
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* Now that the reference is renamed... */
   must_pass(git_reference_rename(looked_up_ref, new_name));
   must_be_true(StrComp(looked_up_ref.name, new_name) = 0);

   //* ...It can't be looked-up with the old name... */
   must_fail(git_reference_lookup(another_looked_up_ref, repo, loose_tag_ref_name));

   //* ...but the new name works ok... */
   must_pass(git_reference_lookup(another_looked_up_ref, repo, new_name));
   must_be_true(StrComp(another_looked_up_ref.name, new_name) = 0);

   //* .. the ref is still loose... */
   must_be_true((another_looked_up_ref.type_ and GIT_REF_PACKED) = 0);
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* ...and the ref can be found in the file system */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(new_name));
   must_pass(gitfo_exists(temp_path));

   close_temp_repo(repo);
end;

procedure Test10_refs_rename.rename_packed_reference__should_make_it_loose;
var
   looked_up_ref, another_looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
   temp_path: String;
const
   brand_new_name: PAnsiChar = 'refs/heads/brand_new_name';
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* Ensure the ref doesn't exist on the file system */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(packed_head_name));
   must_pass(gitfo_not_exists(temp_path));

   //* The reference can however be looked-up... */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_head_name));

   //* .. and it's packed */
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) <> 0);

   //* Now that the reference is renamed... */
   must_pass(git_reference_rename(looked_up_ref, brand_new_name));
   must_be_true(StrComp(looked_up_ref.name, brand_new_name) = 0);

   //* ...It can't be looked-up with the old name... */
   must_fail(git_reference_lookup(another_looked_up_ref, repo, packed_head_name));

   //* ...but the new name works ok... */
   must_pass(git_reference_lookup(another_looked_up_ref, repo, brand_new_name));
   must_be_true(StrComp(another_looked_up_ref.name, brand_new_name) = 0);

   //* .. the ref is no longer packed... */
   must_be_true((another_looked_up_ref.type_ and GIT_REF_PACKED) = 0);
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* ...and the ref now happily lives in the file system */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(brand_new_name));
   must_pass(gitfo_exists(temp_path));

   close_temp_repo(repo);
end;

procedure Test10_refs_rename.rename_packed_reference_does_not_pack_reference_which_is_both_loose_and_packed;
var
   looked_up_ref, another_looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
   temp_path: String;
const
   brand_new_name: PAnsiChar = 'refs/heads/brand_new_name';
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* Ensure the other reference exists on the file system */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(packed_test_head_name));
   must_pass(gitfo_exists(temp_path));

   //* Lookup the other reference */
   must_pass(git_reference_lookup(&another_looked_up_ref, repo, packed_test_head_name));

   //* Ensure it's loose */
   must_be_true((another_looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* Lookup the reference to rename */
   must_pass(git_reference_lookup(&looked_up_ref, repo, packed_head_name));

   //* Ensure it's packed */
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) <> 0);

   //* Now that the reference is renamed... */
   must_pass(git_reference_rename(looked_up_ref, brand_new_name));

   //* Lookup the other reference */
   must_pass(git_reference_lookup(&another_looked_up_ref, repo, packed_test_head_name));

   //* Ensure it's loose */
   must_be_true((another_looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* Ensure the other ref still exists on the file system */
   must_pass(gitfo_exists(temp_path));

   close_temp_repo(repo);
end;

procedure Test10_refs_rename.cannot_rename_reference_to_existing_reference;
var
   looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* An existing reference... */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_head_name));

   //* Can not be renamed to the name of another existing reference. */
   must_fail(git_reference_rename(looked_up_ref, packed_test_head_name));

   //* Failure to rename it hasn't corrupted its state */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_head_name));
   must_be_true(StrComp(looked_up_ref.name, packed_head_name) = 0);

   close_temp_repo(repo);
end;

procedure Test10_refs_rename.cannot_rename_reference_to_invalid_name;
var
   looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* An existing oid reference... */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_test_head_name));

   //* Can not be renamed with an invalid name. */
   must_fail(git_reference_rename(looked_up_ref, 'Hello! I''m a very invalid name.'));

   //* Can not be renamed outside of the refs hierarchy. */
   must_fail(git_reference_rename(looked_up_ref, 'i-will-sudo-you'));

   //* Failure to rename it hasn't corrupted its state */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_test_head_name));
   must_be_true(StrComp(looked_up_ref.name, packed_test_head_name) = 0);

   close_temp_repo(repo);
end;

{ Test10_refs_delete }

procedure Test10_refs_delete.delete_reference_deletes_both_packed_and_loose;
var
   looked_up_ref, another_looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
   temp_path: String;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* Ensure the loose reference exists on the file system */
   temp_path :=
      IncludeTrailingPathDelimiter(String(AnsiString(repo.path_repository))) +
      String(AnsiString(packed_test_head_name));
   must_pass(gitfo_exists(temp_path));

   //* Lookup the reference */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_test_head_name));

   //* Ensure it's the loose version that has been found */
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* Now that the reference is deleted... */
   must_pass(git_reference_delete(looked_up_ref));

   //* Looking up the reference once again should not retrieve it */
   must_fail(git_reference_lookup(another_looked_up_ref, repo, packed_test_head_name));

   //* Ensure the loose reference doesn't exist any longer on the file system */
   must_pass(gitfo_not_exists(temp_path));

   close_temp_repo(repo);
end;

{ Test10_refs_list }

procedure Test10_refs_list.list_all_the_references_in_our_test_repo;
var
   repo: Pgit_repository;
   ref_list: git_strarray;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_reference_listall(@ref_list, repo, GIT_REF_LISTALL));
   must_be_true(ref_list.count = 8); //* 8 refs in total if we include the packed ones */

   // TODO : git_strarray_free not exposed, no way to free memory
//   git_strarray_free(ref_list);
   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2.t10-refs', Test10_refs_readtag.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_readsymref.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_readpackedref.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_createref.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_packfile.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_rename.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_delete.Suite);
   RegisterTest('From libgit2.t10-refs', Test10_refs_list.Suite);

end.

