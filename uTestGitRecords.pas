unit uTestGitRecords;

interface

uses
   TestFramework, SysUtils, Windows;

type
   TTestGitRecords = class(TTestCase)
      procedure Test_sizes;

      procedure Test_git_index;
      procedure Test_git_map;
      procedure Test_git_odb;
      procedure Test_git_tag;
      procedure Test_git_vector;
      procedure Test_git_odb_backend;
      procedure Test_git_commit;
      procedure Test_git_time;
      procedure Test_git_signature;
      procedure Test_git_reference;
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
   CheckEquals( 88, sizeof(git_commit),             'git_commit');

   CheckEquals(  0, offsetof('object_'),           'object_');
   CheckEquals( 32, offsetof('parent_oids'),       'parent_oids');
   CheckEquals( 52, offsetof('tree_oid'),          'tree_oid');
   CheckEquals( 72, offsetof('author'),            'author');
   CheckEquals( 76, offsetof('committer'),         'committer');
   CheckEquals( 80, offsetof('message_'),          'message_');
   CheckEquals( 84, offsetof('message_short'),     'message_short');
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
     else if Value = 'writestream'        then Result := Integer(@item.writestream) - Integer(@item)
     else if Value = 'readstream'         then Result := Integer(@item.readstream) - Integer(@item)
     else if Value = 'exists'             then Result := Integer(@item.exists) - Integer(@item)
     else if Value = 'free'               then Result := Integer(@item.free) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 32, sizeof(git_odb_backend),       'git_odb_backend size');

   CheckEquals(  0, offsetof('odb'),               'odb');
   CheckEquals(  4, offsetof('read'),              'read');
   CheckEquals(  8, offsetof('read_header'),       'read_header');
   CheckEquals( 12, offsetof('write'),             'write');
   CheckEquals( 16, offsetof('writestream'),       'writestream');
   CheckEquals( 20, offsetof('readstream'),        'readstream');
   CheckEquals( 24, offsetof('exists'),            'exists');
   CheckEquals( 28, offsetof('free'),              'free');
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
   CheckEquals( 68, sizeof(git_tag),               'git_tag size');

   CheckEquals(  0, offsetof('object_'),           'object_');
   CheckEquals( 32, offsetof('target'),            'target');
   CheckEquals( 52, offsetof('type_'),             'type_');
   CheckEquals( 56, offsetof('tag_name'),          'tag_name');
   CheckEquals( 60, offsetof('tagger'),            'tagger');
   CheckEquals( 64, offsetof('message_'),          'message_');
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
   CheckEquals( 64, sizeof(git_repository),         'git_repository');
   CheckEquals( 32, sizeof(git_tree_entry),         'git_tree_entry');
   CheckEquals( 52, sizeof(git_tree),               'git_tree');
   CheckEquals(  8, sizeof(git_refcache),           'git_refcache');
end;

initialization
   RegisterTest(TTestGitRecords.Suite);

end.
