unit t10_refs;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test10_refs_readtag = class(TTestFromLibGit2)
      procedure lookup_a_loose_tag_reference;
      procedure lookup_a_loose_tag_reference_that_doesn_t_exist;
   end;

   Test10_refs_readsymref = class(TTestFromLibGit2)
      procedure lookup_a_symbolic_reference;
      procedure lookup_a_nested_symbolic_reference;
      procedure lookup_the_HEAD_and_resolve_the_master_branch;
      procedure lookup_the_master_branch_and_then_the_HEAD;
   end;

   Test10_refs_readpackedref = class(TTestFromLibGit2)
      procedure lookup_a_packed_reference;
      procedure assure_that_a_loose_reference_is_looked_up_before_a_packed_reference;
   end;

   Test10_refs_createref = class(TTestFromLibGit2)
      procedure create_a_new_symbolic_reference;
      procedure create_a_deep_symbolic_reference;
      procedure create_a_new_OID_reference;
      procedure can_not_create_a_new_OID_reference_which_targets_at_an_unknown_id;
   end;

   Test10_refs_overwriteref = class(TTestFromLibGit2)
      procedure overwrite_an_existing_symbolic_reference;
      procedure overwrite_an_existing_object_id_reference;
      procedure overwrite_an_existing_object_id_reference_with_a_symbolic_one;
      procedure overwrite_an_existing_symbolic_reference_with_an_object_id_one;
   end;

   Test10_refs_packfile = class(TTestFromLibGit2)
      procedure create_a_packfile_for_an_empty_folder;
      procedure create_a_packfile_from_all_the_loose_rn_a_repo;
   end;

   Test10_refs_rename = class(TTestFromLibGit2)
      procedure rename_a_loose_reference;
      procedure rename_packed_reference__should_make_it_loose_;
      procedure renaming_a_packed_reference_does_not_pack_another_reference_which_happens_to_be_in_both_loose_and_pack_state;
      procedure can_not_rename_a_reference_with_the_name_of_an_existing_reference;
      procedure can_not_rename_a_reference_with_an_invalid_name;
      procedure can_force__rename_a_reference_with_the_name_of_an_existing_reference;
   end;

   Test10_refs_delete = class(TTestFromLibGit2)
      procedure deleting_a_ref_which_is_both_packed_and_loose_should_remove_both_tracks_in_the_filesystem;
   end;

   Test10_refs_list = class(TTestFromLibGit2)
      procedure try_to_list_all_the_references_in_our_test_repo;
      procedure try_to_list_only_the_symbolic_references;
   end;

implementation

const
   loose_tag_ref_name: PAnsiChar = 'refs/tags/e90810b';

{ Test10_refs_readtag }

procedure Test10_refs_readtag.lookup_a_loose_tag_reference;
var
   repo: Pgit_repository;
   reference: Pgit_reference;
   object_: Pgit_object;
   ref_name_from_tag_name: AnsiString;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   must_pass(git_reference_lookup(reference, repo, loose_tag_ref_name));
   must_be_true((reference.type_ and GIT_REF_OID) > 0);
   must_be_true((reference.type_ and GIT_REF_PACKED) = 0);
   must_be_true(StrComp(reference.name, loose_tag_ref_name) = 0);

   must_pass(git_object_lookup(object_, repo, git_reference_oid(reference), GIT_OBJ_ANY));
   must_be_true(object_ <> nil);
   must_be_true(git_object_type(object_) = GIT_OBJ_TAG);

   //* Ensure the name of the tag matches the name of the reference */
   ref_name_from_tag_name := GIT_REFS_TAGS_DIR + AnsiString(git_tag_name(Pgit_tag(object_)));
   must_be_true(StrComp(PAnsiChar(ref_name_from_tag_name), loose_tag_ref_name) = 0);

   git_object_close(object_);
   git_repository_free(repo);
end;

procedure Test10_refs_readtag.lookup_a_loose_tag_reference_that_doesn_t_exist;
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

procedure Test10_refs_readsymref.lookup_a_symbolic_reference;
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

   git_object_close(object_);
   git_repository_free(repo);
end;

procedure Test10_refs_readsymref.lookup_a_nested_symbolic_reference;
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

   git_object_close(object_);
   git_repository_free(repo);
end;

procedure Test10_refs_readsymref.lookup_the_HEAD_and_resolve_the_master_branch;
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

procedure Test10_refs_readsymref.lookup_the_master_branch_and_then_the_HEAD;
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

procedure Test10_refs_readpackedref.lookup_a_packed_reference;
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

   git_object_close(object_);
   git_repository_free(repo);
end;

procedure Test10_refs_readpackedref.assure_that_a_loose_reference_is_looked_up_before_a_packed_reference;
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

procedure Test10_refs_createref.create_a_new_symbolic_reference;
var
   new_reference, looked_up_ref, resolved_ref: Pgit_reference;
   repo, repo2: Pgit_repository;
   id: git_oid;
   ref_path: String;
const
   new_head_tracker: PAnsiChar = 'another-head-tracker';
begin
   git_oid_mkstr(@id, current_master_tip);

   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

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
   must_pass(git_repository_open(repo2, TEMP_REPO_FOLDER_REL));

   must_pass(git_reference_lookup(looked_up_ref, repo2, new_head_tracker));
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   close_temp_repo(repo2);
end;

procedure Test10_refs_createref.create_a_deep_symbolic_reference;
var
   new_reference, looked_up_ref, resolved_ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
   repo_path, ref_path: String;
const
   new_head_tracker: PAnsiChar = 'deep/rooted/tracker';
begin
   git_oid_mkstr(@id, current_master_tip);

   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   repo_path := StringReplace(String(AnsiString(repo.path_repository)), '/', PathDelim, [rfReplaceAll]);
   ref_path := IncludeTrailingPathDelimiter(repo_path + String(AnsiString(new_head_tracker)));
   ref_path := StringReplace(ref_path, PathDelim, '/', [rfReplaceAll]);

   must_pass(git_reference_create_symbolic(new_reference, repo, new_head_tracker, current_head_target));
   must_pass(git_reference_lookup(looked_up_ref, repo, new_head_tracker));
   must_pass(git_reference_resolve(resolved_ref, looked_up_ref));
   must_be_true(git_oid_cmp(@id, git_reference_oid(resolved_ref)) = 0);

   close_temp_repo(repo);
end;

procedure Test10_refs_createref.create_a_new_OID_reference;
var
   new_reference, looked_up_ref: Pgit_reference;
   repo, repo2: Pgit_repository;
   id: git_oid;
   ref_path: String;
const
   new_head: PAnsiChar = 'refs/heads/new-head';
begin
   git_oid_mkstr(@id, current_master_tip);

   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

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
   must_pass(git_repository_open(repo2, TEMP_REPO_FOLDER_REL));

   must_pass(git_reference_lookup(looked_up_ref, repo2, new_head));
   must_be_true(git_oid_cmp(@id, git_reference_oid(looked_up_ref)) = 0);

   close_temp_repo(repo2);
end;

procedure Test10_refs_createref.can_not_create_a_new_OID_reference_which_targets_at_an_unknown_id;
var
   new_reference, looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
const
   new_head: PAnsiChar = 'refs/heads/new-head';
begin
   git_oid_mkstr(@id, 'deadbeef3f795b2b4353bcce3a527ad0a4f7f644');

   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   //* Create and write the new object id reference */
   must_fail(git_reference_create_oid(new_reference, repo, new_head, @id));

   //* Ensure the reference can't be looked-up... */
   must_fail(git_reference_lookup(looked_up_ref, repo, new_head));

   git_repository_free(repo);
end;

procedure Test10_refs_packfile.create_a_packfile_for_an_empty_folder;
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

procedure Test10_refs_packfile.create_a_packfile_from_all_the_loose_rn_a_repo;
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

procedure Test10_refs_rename.rename_a_loose_reference;
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

procedure Test10_refs_rename.rename_packed_reference__should_make_it_loose_;
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

procedure Test10_refs_rename.renaming_a_packed_reference_does_not_pack_another_reference_which_happens_to_be_in_both_loose_and_pack_state;
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
   must_pass(git_reference_lookup(another_looked_up_ref, repo, packed_test_head_name));

   //* Ensure it's loose */
   must_be_true((another_looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* Lookup the reference to rename */
   must_pass(git_reference_lookup(looked_up_ref, repo, packed_head_name));

   //* Ensure it's packed */
   must_be_true((looked_up_ref.type_ and GIT_REF_PACKED) <> 0);

   //* Now that the reference is renamed... */
   must_pass(git_reference_rename(looked_up_ref, brand_new_name));

   //* Lookup the other reference */
   must_pass(git_reference_lookup(another_looked_up_ref, repo, packed_test_head_name));

   //* Ensure it's loose */
   must_be_true((another_looked_up_ref.type_ and GIT_REF_PACKED) = 0);

   //* Ensure the other ref still exists on the file system */
   must_pass(gitfo_exists(temp_path));

   close_temp_repo(repo);
end;

procedure Test10_refs_rename.can_not_rename_a_reference_with_the_name_of_an_existing_reference;
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

procedure Test10_refs_rename.can_not_rename_a_reference_with_an_invalid_name;
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

procedure Test10_refs_rename.can_force__rename_a_reference_with_the_name_of_an_existing_reference;
var
   looked_up_ref: Pgit_reference;
   repo: Pgit_repository;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));
   try
      //* An existing reference... */
      must_pass(git_reference_lookup(looked_up_ref, repo, packed_head_name));

      //* Can not be renamed to the name of another existing reference. */
      must_pass(git_reference_rename_f(looked_up_ref, packed_test_head_name));

      //* Check we actually renamed it */
      must_pass(git_reference_lookup(looked_up_ref, repo, packed_test_head_name));
      must_be_true(StrComp(looked_up_ref.name, packed_test_head_name) = 0);
   finally
      close_temp_repo(repo);
   end;
end;

{ Test10_refs_delete }

procedure Test10_refs_delete.deleting_a_ref_which_is_both_packed_and_loose_should_remove_both_tracks_in_the_filesystem;
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

procedure Test10_refs_list.try_to_list_all_the_references_in_our_test_repo;
var
   repo: Pgit_repository;
   ref_list: git_strarray;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_reference_listall(@ref_list, repo, GIT_REF_LISTALL));

   (* We have exactly 8 refs in total if we include the packed ones:
    * there is a reference that exists both in the packfile and as
    * loose, but we only list it once *)
   must_be_true(ref_list.count = 8);

   git_strarray_free(@ref_list);
   git_repository_free(repo);
end;

procedure Test10_refs_list.try_to_list_only_the_symbolic_references;
var
   repo: Pgit_repository;
   ref_list: git_strarray;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_reference_listall(@ref_list, repo, GIT_REF_SYMBOLIC));
   must_be_true(ref_list.count = 0); //* no symrefs in the test repo */

   git_strarray_free(@ref_list);
   git_repository_free(repo);
end;

const
   ref_name = 'refs/heads/other';
   ref_master_name = 'refs/heads/master';
   ref_branch_name = 'refs/heads/branch';
   ref_test_name = 'refs/heads/test';

{ Test10_refs_overwriteref }

procedure Test10_refs_overwriteref.overwrite_an_existing_symbolic_reference;
var
   ref, branch_ref: Pgit_reference;
   repo: Pgit_repository;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));

   //* The target needds to exist and we need to check the name has changed */
   must_pass(git_reference_create_symbolic(branch_ref, repo, ref_branch_name, ref_master_name));
   must_pass(git_reference_create_symbolic(ref, repo, ref_name, ref_branch_name));
   //* Ensure it points to the right place*/
   must_pass(git_reference_lookup(ref, repo, ref_name));
   must_be_true(git_reference_type(ref) and GIT_REF_SYMBOLIC <> 0);
   must_be_true(StrComp(git_reference_target(ref), ref_branch_name) = 0);

   //* Ensure we can't create it unless we force it to */
   must_fail(git_reference_create_symbolic(ref, repo, ref_name, ref_master_name));
   must_pass(git_reference_create_symbolic_f(ref, repo, ref_name, ref_master_name));

   //* Ensure it points to the right place */
   must_pass(git_reference_lookup(ref, repo, ref_name));
   must_be_true(git_reference_type(ref) and GIT_REF_SYMBOLIC <> 0);
   must_be_true(StrComp(git_reference_target(ref), ref_master_name) = 0);

   close_temp_repo(repo);
end;

procedure Test10_refs_overwriteref.overwrite_an_existing_object_id_reference;
var
   ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));
   try
      must_pass(git_reference_lookup(ref, repo, ref_master_name));
      must_be_true(ref.type_ and GIT_REF_OID <> 0);
      git_oid_cpy(@id, git_reference_oid(ref));

      //* Create it */
      must_pass(git_reference_create_oid(ref, repo, ref_name, @id));

      must_pass(git_reference_lookup(ref, repo, ref_test_name));
      must_be_true(ref.type_ and GIT_REF_OID <> 0);
      git_oid_cpy(@id, git_reference_oid(ref));

      //* Ensure we can't overwrite unless we force it */
      must_fail(git_reference_create_oid(ref, repo, ref_name, @id));
      must_pass(git_reference_create_oid_f(ref, repo, ref_name, @id));

      //* Ensure it has been overwritten */
      must_pass(git_reference_lookup(ref, repo, ref_name));
      must_be_true(git_oid_cmp(@id, git_reference_oid(ref)) = 0);
   finally
      close_temp_repo(repo);
   end;
end;

procedure Test10_refs_overwriteref.overwrite_an_existing_object_id_reference_with_a_symbolic_one;
var
   ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));
   try
      must_pass(git_reference_lookup(ref, repo, ref_master_name));
      must_be_true(ref.type_ and GIT_REF_OID <> 0);
      git_oid_cpy(@id, git_reference_oid(ref));

      must_pass(git_reference_create_oid(ref, repo, ref_name, @id));
      must_fail(git_reference_create_symbolic(ref, repo, ref_name, ref_master_name));
      must_pass(git_reference_create_symbolic_f(ref, repo, ref_name, ref_master_name));

      //* Ensure it points to the right place */
      must_pass(git_reference_lookup(ref, repo, ref_name));
      must_be_true(git_reference_type(ref) and GIT_REF_SYMBOLIC <> 0);
      must_be_true(StrComp(git_reference_target(ref), ref_master_name) = 0);
   finally
      close_temp_repo(repo);
   end;
end;

procedure Test10_refs_overwriteref.overwrite_an_existing_symbolic_reference_with_an_object_id_one;
var
   ref: Pgit_reference;
   repo: Pgit_repository;
   id: git_oid;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));
   try
      must_pass(git_reference_lookup(ref, repo, ref_master_name));
      must_be_true(ref.type_ and GIT_REF_OID <> 0);
      git_oid_cpy(@id, git_reference_oid(ref));

      //* Create the symbolic ref */
      must_pass(git_reference_create_symbolic(ref, repo, ref_name, ref_master_name));
      //* It shouldn't overwrite unless we tell it to */
      must_fail(git_reference_create_oid(ref, repo, ref_name, @id));
      must_pass(git_reference_create_oid_f(ref, repo, ref_name, @id));

      //* Ensure it points to the right place */
      must_pass(git_reference_lookup(ref, repo, ref_name));
      must_be_true(git_reference_type(ref) and GIT_REF_OID <> 0);
      must_be_true(git_oid_cmp(git_reference_oid(ref), @id) = 0);
   finally
      close_temp_repo(repo);
   end;
end;

initialization
   RegisterTest('From libgit2.t10-refs', Test10_refs_readtag.NamedSuite('readtag'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_readsymref.NamedSuite('readsym'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_readpackedref.NamedSuite('readpacked'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_createref.NamedSuite('create'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_overwriteref.NamedSuite('overwrite'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_packfile.NamedSuite('pack'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_rename.NamedSuite('rename'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_delete.NamedSuite('delete'));
   RegisterTest('From libgit2.t10-refs', Test10_refs_list.NamedSuite('list'));

end.

