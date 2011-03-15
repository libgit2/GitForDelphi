unit uTestGitRecords;

interface

uses
   TestFramework, SysUtils, Windows;

type
   TTestGitRecords = class(TTestCase)
      procedure Test_sizes;

      procedure Test_git_index;
      procedure Test_git_rawobj;
      procedure Test_git_map;
      procedure Test_git_odb;
      procedure Test_git_tag;
      procedure Test_git_vector;
      procedure Test_git_odb_backend;
      procedure Test_git_commit;
      procedure Test_git_time;
      procedure Test_git_signature;
      procedure Test_git_reference;
      procedure Test_git_object;
      procedure Test_git_repository;
   end;

implementation

uses
   uGitForDelphi;

{ TTestGitRecordSizes }

procedure TTestGitRecords.Test_git_commit;
   function offsetof(const Value: string): Integer;
   var
     item: git_commit;
   begin
     if      Value = 'object_'            then Result := Integer(@item.object_) - Integer(@item)
     else if Value = 'parent_oids'        then Result := Integer(@item.parent_oids) - Integer(@item)
     else if Value = 'tree_oid'           then Result := Integer(@item.tree_oid) - Integer(@item)
     else if Value = 'author'             then Result := Integer(@item.author) - Integer(@item)
     else if Value = 'committer'          then Result := Integer(@item.committer) - Integer(@item)
     else if Value = 'message_'           then Result := Integer(@item.message_) - Integer(@item)
     else if Value = 'message_short'      then Result := Integer(@item.message_short) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals(112, sizeof(git_commit),             'git_commit');

   CheckEquals(  0, offsetof('object_'),           'object_');
   CheckEquals( 56, offsetof('parent_oids'),       'parent_oids');
   CheckEquals( 76, offsetof('tree_oid'),          'tree_oid');
   CheckEquals( 96, offsetof('author'),            'author');
   CheckEquals(100, offsetof('committer'),         'committer');
   CheckEquals(104, offsetof('message_'),          'message_');
   CheckEquals(108, offsetof('message_short'),     'message_short');
end;

procedure TTestGitRecords.Test_git_index;
   function offsetof(const Value: string): Integer;
   var
     item: git_index;
   begin
     if      Value = 'repository'         then Result := Integer(@item.repository) - Integer(@item)
     else if Value = 'index_file_path'    then Result := Integer(@item.index_file_path) - Integer(@item)
     else if Value = 'last_modified'      then Result := Integer(@item.last_modified) - Integer(@item)
     else if Value = 'entries'            then Result := Integer(@item.entries) - Integer(@item)
     else if Value = 'on_disk'            then Result := Integer(@item.on_disk) - Integer(@item)
     else if Value = 'tree'               then Result := Integer(@item.tree) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 48, sizeof(git_index),           'git_index size');

   CheckEquals(  0, offsetof('repository'),      'repository');
   CheckEquals(  4, offsetof('index_file_path'), 'index_file_path');
   CheckEquals(  8, offsetof('last_modified'),   'last_modified');
   CheckEquals( 16, offsetof('entries'),         'entries');
   CheckEquals( 40, offsetof('tree'),            'tree');
end;

procedure TTestGitRecords.Test_git_map;
   function offsetof(const Value: string): Integer;
   var
     item: git_map;
   begin
     if      Value = 'data'               then Result := Integer(@item.data) - Integer(@item)
     else if Value = 'len'                then Result := Integer(@item.len) - Integer(@item)
     else if Value = 'fmh'                then Result := Integer(@item.fmh) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 12, sizeof(git_map),       'git_map size');

   CheckEquals(  0, offsetof('data'),      'data');
   CheckEquals(  4, offsetof('len'),       'len');
   CheckEquals(  8, offsetof('fmh'),       'fmh');
end;

procedure TTestGitRecords.Test_git_object;
   function offsetof(const Value: string): Integer;
   var
      item: git_object;
   begin
      if      Value = 'id'                then Result := Integer(@item.id) - Integer(@item)
      else if Value = 'repo'              then Result := Integer(@item.repo) - Integer(@item)
      else if Value = 'source'            then Result := Integer(@item.source) - Integer(@item)
      else if Value = 'lru'               then Result := Integer(@item.lru) - Integer(@item)
      else if Value = 'in_memory'         then Result := Integer(@item.in_memory) - Integer(@item)
      else if Value = 'modified'          then Result := Integer(@item.modified) - Integer(@item)
      else if Value = 'can_free'          then Result := Integer(@item.can_free) - Integer(@item)
      else if Value = '_pad'              then Result := Integer(@item._pad) - Integer(@item)
      else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 56, sizeof(git_object),             'git_object');

   CheckEquals(  0, offsetof('id'),                 'id');
   CheckEquals( 20, offsetof('repo'),               'repo');
   CheckEquals( 24, offsetof('source'),             'source');
   CheckEquals( 48, offsetof('lru'),                'lru');
   CheckEquals( 52, offsetof('in_memory'),          'in_memory');
   CheckEquals( 53, offsetof('modified'),           'modified');
   CheckEquals( 54, offsetof('can_free'),           'can_free');
   CheckEquals( 55, offsetof('_pad'),               '_pad');
end;

procedure TTestGitRecords.Test_git_odb;
   function offsetof(const Value: string): Integer;
   var
     item: git_odb;
   begin
     if      Value = '_internal'          then Result := Integer(@item._internal) - Integer(@item)
     else if Value = 'backends'           then Result := Integer(@item.backends) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 24, sizeof(git_odb),                'git_odb');

   CheckEquals(  0, offsetof('_internal'),          '_internal');
   CheckEquals(  4, offsetof('backends'),           'backends');
end;

procedure TTestGitRecords.Test_git_odb_backend;
   function offsetof(const Value: string): Integer;
   var
     item: git_odb_backend;
   begin
     if      Value = 'odb'                then Result := Integer(@item.odb) - Integer(@item)
     else if Value = 'read'               then Result := Integer(@item.read) - Integer(@item)
     else if Value = 'read_header'        then Result := Integer(@item.read_header) - Integer(@item)
     else if Value = 'write'              then Result := Integer(@item.write) - Integer(@item)
     else if Value = 'exists'             then Result := Integer(@item.exists) - Integer(@item)
     else if Value = 'free'               then Result := Integer(@item.free) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 24, sizeof(git_odb_backend),       'git_odb_backend size');

   CheckEquals(  0, offsetof('odb'),               'odb');
   CheckEquals(  4, offsetof('read'),              'read');
   CheckEquals(  8, offsetof('read_header'),       'read_header');
   CheckEquals( 12, offsetof('write'),             'write');
   CheckEquals( 16, offsetof('exists'),            'exists');
   CheckEquals( 20, offsetof('free'),              'free');
end;

procedure TTestGitRecords.Test_git_rawobj;
   function offsetof(const Value: string): Integer;
   var
     item: git_rawobj;
   begin
     if      Value = 'data'               then Result := Integer(@item.data) - Integer(@item)
     else if Value = 'len'                then Result := Integer(@item.len) - Integer(@item)
     else if Value = 'type_'              then Result := Integer(@item.type_) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 12, sizeof(git_rawobj),    'git_rawobj size');

   CheckEquals(  0, offsetof('data'),      'data');
   CheckEquals(  4, offsetof('len'),       'len');
   CheckEquals(  8, offsetof('type_'),     'type_');
end;

procedure TTestGitRecords.Test_git_reference;
   function offsetof(const Value: string): Integer;
   var
      item: git_reference;
   begin
      if Value = 'owner'                  then  Result := Integer(@item.owner) - Integer(@item)
      else if Value = 'name'              then  Result := Integer(@item.name) - Integer(@item)
      else if Value = 'type_'             then  Result := Integer(@item.type_) - Integer(@item)
      else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   // Variant record doesn't seem to be equivalent to C union in a struct (the sizeof was 40 in Delphi),
   // so ignoring the "char *ref;" member for now.
   CheckEquals( 12, sizeof(git_reference),  'git_reference size');

   CheckEquals(  0, offsetof('owner'),      'owner');
   CheckEquals(  4, offsetof('name'),       'name');
   CheckEquals(  8, offsetof('type_'),      'type_');
end;

procedure TTestGitRecords.Test_git_repository;
   function offsetof(const Value: string): Integer;
   var
     item: git_repository;
   begin
     if      Value = 'db'                 then Result := Integer(@item.db) - Integer(@item)
     else if Value = 'index'              then Result := Integer(@item.index) - Integer(@item)
     else if Value = 'objects'            then Result := Integer(@item.objects) - Integer(@item)
     else if Value = 'memory_objects'     then Result := Integer(@item.memory_objects) - Integer(@item)
     else if Value = 'references'         then Result := Integer(@item.references) - Integer(@item)
     else if Value = 'path_repository'    then Result := Integer(@item.path_repository) - Integer(@item)
     else if Value = 'path_index'         then Result := Integer(@item.path_index) - Integer(@item)
     else if Value = 'path_odb'           then Result := Integer(@item.path_odb) - Integer(@item)
     else if Value = 'path_workdir'       then Result := Integer(@item.path_workdir) - Integer(@item)
     else if Value = 'lru_counter'        then Result := Integer(@item.lru_counter) - Integer(@item)

     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 64, sizeof(git_repository), 'git_repository size');

   CheckEquals(  0, offsetof('db'),                'db');
   CheckEquals(  4, offsetof('index'),             'index');
   CheckEquals(  8, offsetof('objects'),           'objects');
   CheckEquals( 12, offsetof('memory_objects'),    'memory_objects');
   CheckEquals( 32, offsetof('references'),        'references');
   CheckEquals( 40, offsetof('path_repository'),   'path_repository');
   CheckEquals( 44, offsetof('path_index'),        'path_index');
   CheckEquals( 48, offsetof('path_odb'),          'path_odb');
   CheckEquals( 52, offsetof('path_workdir'),      'path_workdir');
   CheckEquals( 60, offsetof('lru_counter'),       'lru_counter');
end;

procedure TTestGitRecords.Test_git_signature;
   function offsetof(const Value: string): Integer;
   var
     item: git_signature;
   begin
     if      Value = 'name'               then Result := Integer(@item.name) - Integer(@item)
     else if Value = 'email'              then Result := Integer(@item.email) - Integer(@item)
     else if Value = 'when'               then Result := Integer(@item.when) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 24, sizeof(git_signature),         'git_signature size');

   CheckEquals(  0, offsetof('name'),              'name');
   CheckEquals(  4, offsetof('email'),             'email');
   CheckEquals(  8, offsetof('when'),              'when');
end;

procedure TTestGitRecords.Test_git_tag;
   function offsetof(const Value: string): Integer;
   var
     item: git_tag;
   begin
     if      Value = 'object_'            then Result := Integer(@item.object_) - Integer(@item)
     else if Value = 'target'             then Result := Integer(@item.target) - Integer(@item)
     else if Value = 'type_'              then Result := Integer(@item.type_) - Integer(@item)
     else if Value = 'tag_name'           then Result := Integer(@item.tag_name) - Integer(@item)
     else if Value = 'tagger'             then Result := Integer(@item.tagger) - Integer(@item)
     else if Value = 'message_'           then Result := Integer(@item.message_) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 92, sizeof(git_tag),               'git_tag size');

   CheckEquals(  0, offsetof('object_'),           'object_');
   CheckEquals( 56, offsetof('target'),            'target');
   CheckEquals( 76, offsetof('type_'),             'type_');
   CheckEquals( 80, offsetof('tag_name'),          'tag_name');
   CheckEquals( 84, offsetof('tagger'),            'tagger');
   CheckEquals( 88, offsetof('message_'),          'message_');
end;

procedure TTestGitRecords.Test_git_time;
   function offsetof(const Value: string): Integer;
   var
     item: git_time;
   begin
     if      Value = 'time'               then Result := Integer(@item.time) - Integer(@item)
     else if Value = 'offset'             then Result := Integer(@item.offset) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 16, sizeof(git_time),              'git_time size');

   CheckEquals(  0, offsetof('time'),              'time');
   CheckEquals(  8, offsetof('offset'),            'offset');
end;

procedure TTestGitRecords.Test_git_vector;
   function offsetof(const Value: string): Integer;
   var
     item: git_vector;
   begin
     if      Value = '_alloc_size'        then Result := Integer(@item._alloc_size) - Integer(@item)
     else if Value = '_cmp'               then Result := Integer(@item._cmp) - Integer(@item)
     else if Value = 'contents'           then Result := Integer(@item.contents) - Integer(@item)
     else if Value = 'length'             then Result := Integer(@item.length) - Integer(@item)
     else if Value = 'sorted'             then Result := Integer(@item.sorted) - Integer(@item)

     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 20, sizeof(git_vector),            'git_vector size');

   CheckEquals(  0, offsetof('_alloc_size'),       '_alloc_size');
   CheckEquals(  4, offsetof('_cmp'),              '_cmp');
   CheckEquals(  8, offsetof('contents'),          'contents');
   CheckEquals( 12, offsetof('length'),            'length');
   CheckEquals( 16, offsetof('sorted'),            'sorted');
end;

procedure TTestGitRecords.Test_sizes;
begin
   CheckEquals(  4, sizeof(size_t),                 'size_t');
   CheckEquals(  8, sizeof(time_t),                 'time_t');
   CheckEquals(  8, sizeof(git_time_t),             'git_time_t');
   CheckEquals(  8, sizeof(git_off_t),              'git_off_t');
   CheckEquals(  4, sizeof(git_file),               'git_file');
   CheckEquals(  4, sizeof(git_lck),                'git_lck');
   CheckEquals( 20, sizeof(git_oid),                'git_oid');
   CheckEquals( 16, sizeof(git_index_time),         'git_index_time');
   CheckEquals( 96, sizeof(git_index_entry),        'git_index_entry');
   CheckEquals( 40, sizeof(git_index_tree),         'git_index_tree');
   CheckEquals( 48, sizeof(git_index),              'git_index');
   CheckEquals(  8, sizeof(git_hashtable_node),     'git_hashtable_node');
   CheckEquals( 28, sizeof(git_hashtable),          'git_hashtable');
   CheckEquals( 24, sizeof(git_odb_source),         'git_odb_source');
   CheckEquals( 32, sizeof(git_tree_entry),         'git_tree_entry');
   CheckEquals( 76, sizeof(git_tree),               'git_tree');
   CheckEquals(  8, sizeof(git_refcache),           'git_refcache');
end;

initialization
   RegisterTest(TTestGitRecords.Suite);

end.
