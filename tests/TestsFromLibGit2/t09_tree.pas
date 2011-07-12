unit t09_tree;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test09_tree_read = class(TTestFromLibGit2)
      procedure access_randomly_the_entries_on_a_loaded_tree;
      procedure read_a_tree_from_the_repository;
   end;

   Test09_tree_write = class(TTestFromLibGit2)
      // still not run? : procedure write_a_tree_from_an_index;
      procedure write_a_tree_from_a_memory;
      procedure write_a_hierarchical_tree_from_a_memory;
   end;

implementation

{ Test09_tree_read }

procedure Test09_tree_read.access_randomly_the_entries_on_a_loaded_tree;
var
   id: git_oid ;
   repo: Pgit_repository;
   tree: Pgit_tree;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_fromstr(@id, tree_oid);

   must_pass(git_tree_lookup(tree, repo, @id));

   must_be_true(git_tree_entry_byname(tree, 'README') <> nil);
   must_be_true(git_tree_entry_byname(tree, 'NOTEXISTS') = nil);
   must_be_true(git_tree_entry_byname(tree, '') = nil);
   must_be_true(git_tree_entry_byindex(tree, 0) <> nil);
   must_be_true(git_tree_entry_byindex(tree, 2) <> nil);
   must_be_true(git_tree_entry_byindex(tree, 3) = nil);
   must_be_true(git_tree_entry_byindex(tree, Uint(-1)) = nil);

   git_tree_close(tree);
   git_repository_free(repo);
end;

procedure Test09_tree_read.read_a_tree_from_the_repository;
var
   id: git_oid;
   repo: Pgit_repository;
   tree: Pgit_tree;
   entry: Pgit_tree_entry;
   obj: Pgit_object;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));

   git_oid_fromstr(@id, tree_oid);

   must_pass(git_tree_lookup(tree, repo, @id));

   must_be_true(git_tree_entrycount(tree) = 3);

   must_be_true(git_object_lookup(obj, repo, @id, GIT_OBJ_TREE) = 0);
   git_object_close(obj);
   must_be_true(git_object_lookup(obj, repo, @id, GIT_OBJ_BLOB) = GIT_EINVALIDTYPE);
   git_object_close(obj);

   entry := git_tree_entry_byname(tree, 'README');
   must_be_true(entry <> nil);

   must_be_true(StrComp(git_tree_entry_name(entry), 'README') = 0);

   must_pass(git_tree_entry_2object(obj, repo, entry));

   git_object_close(obj);
   git_tree_close(tree);
   git_repository_free(repo);
end;

{ Test09_tree_write }

const
   blob_oid:      PAnsiChar = 'fa49b077972391ad58037050f2a75f74e3671e92';
   first_tree:    PAnsiChar = '181037049a54a1eb5fab404658a3a250b44335d7';
   second_tree:   PAnsiChar = 'f60079018b664e4e79329a7ef9559c8d9e0378d1';
   third_tree:    PAnsiChar = 'eb86d8b81d6adbd5290a935d6c9976882de98488';

procedure Test09_tree_write.write_a_tree_from_a_memory;
var
   repo: Pgit_repository;
   builder: Pgit_treebuilder;
   tree: Pgit_tree;
   id, bid, rid, id2: git_oid;
   unused: Pgit_tree_entry;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));
   try
      git_oid_fromstr(@id, first_tree);
      git_oid_fromstr(@id2, second_tree);
      git_oid_fromstr(@bid, blob_oid);

      //create a second tree from first tree using `git_treebuilder_insert` on REPOSITORY_FOLDER.
      must_pass(git_tree_lookup(tree, repo, @id));
      must_pass(git_treebuilder_create(builder, tree));
      unused := nil;
      must_pass(git_treebuilder_insert(unused, builder, 'new.txt', @bid, OctalToInt('0100644')));
      must_pass(git_treebuilder_write(@rid, repo, builder));

      must_be_true(git_oid_cmp(@rid, @id2) = 0);

      git_treebuilder_free(builder);
      git_tree_close(tree);
   finally
      close_temp_repo(repo);
   end;
end;

procedure Test09_tree_write.write_a_hierarchical_tree_from_a_memory;
var
   repo: Pgit_repository;
   builder: Pgit_treebuilder;
   tree: Pgit_tree;
   id, bid, subtree_id, id2, id3: git_oid;
   id_hiearar: git_oid;
   unused: Pgit_tree_entry;
begin
   must_pass(open_temp_repo(repo, REPOSITORY_FOLDER));
   try
      git_oid_fromstr(@id, first_tree);
      git_oid_fromstr(@id2, second_tree);
      git_oid_fromstr(@id3, third_tree);
      git_oid_fromstr(@bid, blob_oid);

      //create subtree
      must_pass(git_treebuilder_create(builder, nil));
      unused := nil;
      must_pass(git_treebuilder_insert(unused, builder, 'new.txt', @bid, OctalToInt('0100644')));
      must_pass(git_treebuilder_write(@subtree_id, repo, builder));
      git_treebuilder_free(builder);

      // create parent tree
      must_pass(git_tree_lookup(tree, repo, @id));
      must_pass(git_treebuilder_create(builder, tree));
      unused := nil;
      must_pass(git_treebuilder_insert(unused, builder, 'new', @subtree_id, OctalToInt('040000')));
      must_pass(git_treebuilder_write(@id_hiearar, repo, builder));
      git_treebuilder_free(builder);
      git_tree_close(tree);

      must_be_true(git_oid_cmp(@id_hiearar, @id3) = 0);

      // check data is correct
      must_pass(git_tree_lookup(tree, repo, @id_hiearar));
      must_be_true(2 = git_tree_entrycount(tree));
      git_tree_close(tree);
   finally
      close_temp_repo(repo);
   end;
end;

initialization
   RegisterTest('From libgit2.t09-tree', Test09_tree_read.NamedSuite('read'));
   RegisterTest('From libgit2.t09-tree', Test09_tree_write.NamedSuite('write'));

end.
