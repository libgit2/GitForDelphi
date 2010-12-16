unit uTestGitRecords;

interface

uses
   TestFramework, SysUtils, Windows;

type
   TTestGitRecords = class(TTestCase)
      procedure Test_sizes;

      procedure Test_git_pack;
      procedure Test_git_packlist;
      procedure Test_git_revwalk;
      procedure Test_git_index;
      procedure Test_git_rawobj;
      procedure Test_git_map;
      procedure Test_git_odb;
      procedure Test_git_tag;
   end;

implementation

uses
   uGitForDelphi;

{ TTestGitRecordSizes }

procedure TTestGitRecords.Test_git_index;
   function offsetof(const Value: string): Integer;
   var
     item: git_index;
   begin
     if Value = 'repository'              then Result := Integer(@item.repository) - Integer(@item)
     else if Value = 'index_file_path'    then Result := Integer(@item.index_file_path) - Integer(@item)

     else if Value = 'last_modified'      then Result := Integer(@item.last_modified) - Integer(@item)

     else if Value = 'entries'            then Result := Integer(@item.entries) - Integer(@item)
     else if Value = 'entries_size'       then Result := Integer(@item.entries_size) - Integer(@item)

     else if Value = 'entry_count'        then Result := Integer(@item.entry_count) - Integer(@item)
     else if Value = 'sortedANDon_disk'   then Result := Integer(@item.sortedANDon_disk) - Integer(@item)

     else if Value = 'tree'               then Result := Integer(@item.tree) - Integer(@item)

     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 40, sizeof(git_index),           'git_index size');

   CheckEquals(  0, offsetof('repository'),      'repository');
   CheckEquals(  4, offsetof('index_file_path'), 'index_file_path');
   CheckEquals(  8, offsetof('last_modified'),   'last_modified');
   CheckEquals( 16, offsetof('entries'),         'entries');
   CheckEquals( 20, offsetof('entries_size'),    'entries_size');
   CheckEquals( 24, offsetof('entry_count'),     'entry_count');
   CheckEquals( 32, offsetof('tree'),            'tree');
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
     if      Value = 'lock'               then Result := Integer(@item.lock) - Integer(@item)
     else if Value = 'objects_dir'        then Result := Integer(@item.objects_dir) - Integer(@item)
     else if Value = 'packlist'           then Result := Integer(@item.packlist) - Integer(@item)
     else if Value = 'alternates'         then Result := Integer(@item.alternates) - Integer(@item)
     else if Value = 'n_alternates'       then Result := Integer(@item.n_alternates) - Integer(@item)
     else if Value = 'object_zlib_level'  then Result := Integer(@item.object_zlib_level) - Integer(@item)
     else if Value = 'fsync_object_files' then Result := Integer(@item.fsync_object_files) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 28, sizeof(git_odb),                'git_odb');

   CheckEquals(  0, offsetof('lock'),               'lock');
   CheckEquals(  4, offsetof('objects_dir'),        'objects_dir');
   CheckEquals(  8, offsetof('packlist'),           'packlist');
   CheckEquals( 12, offsetof('alternates'),         'alternates');
   CheckEquals( 16, offsetof('n_alternates'),       'n_alternates');
   CheckEquals( 20, offsetof('object_zlib_level'),  'object_zlib_level');
   CheckEquals( 24, offsetof('fsync_object_files'), 'fsync_object_files');
end;

procedure TTestGitRecords.Test_git_pack;
   function offsetof(const Value: string): Integer;
   var
     item: git_pack;
   begin
     if Value = 'db'                      then Result := Integer(@item.db) - Integer(@Item)
     else if Value = 'lock'               then Result := Integer(@item.lock) - Integer(@Item)
     else if Value = 'idx_search'         then Result := Integer(@item.idx_search) - Integer(@Item)
     else if Value = 'idx_search_offset'  then Result := Integer(@item.idx_search_offset) - Integer(@Item)
     else if Value = 'idx_get'            then Result := Integer(@item.idx_get) - Integer(@Item)

     else if Value = 'idx_fd'             then Result := Integer(@item.idx_fd) - Integer(@Item)
     else if Value = 'idx_map'            then Result := Integer(@item.idx_map) - Integer(@Item)
     else if Value = 'im_fanout'          then Result := Integer(@item.im_fanout) - Integer(@Item)
     else if Value = 'im_oid'             then Result := Integer(@item.im_oid) - Integer(@Item)
     else if Value = 'im_crc'             then Result := Integer(@item.im_crc) - Integer(@Item)
     else if Value = 'im_offset32'        then Result := Integer(@item.im_offset32) - Integer(@Item)
     else if Value = 'im_offset64'        then Result := Integer(@item.im_offset64) - Integer(@Item)
     else if Value = 'im_off_idx'         then Result := Integer(@item.im_off_idx) - Integer(@Item)
     else if Value = 'im_off_next'        then Result := Integer(@item.im_off_next) - Integer(@Item)
     else if Value = 'obj_cnt'            then Result := Integer(@item.obj_cnt) - Integer(@Item)
     else if Value = 'pack_fd'            then Result := Integer(@item.pack_fd) - Integer(@Item)
     else if Value = 'pack_map'           then Result := Integer(@item.pack_map) - Integer(@Item)
     else if Value = 'pack_size'          then Result := Integer(@item.pack_size) - Integer(@Item)
     else if Value = 'pack_mtime'         then Result := Integer(@item.pack_mtime) - Integer(@Item)
     else if Value = 'refcnt'             then Result := Integer(@item.refcnt) - Integer(@Item)
     else if Value = 'idxcnt'             then Result := Integer(@item.idxcnt) - Integer(@Item)
     else if Value = 'invalid'            then Result := Integer(@item.invalid) - Integer(@Item)
     else if Value = 'pack_name'          then Result := Integer(@item.pack_name) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
  CheckEquals(168, sizeof(git_pack),               'git_pack size');

  CheckEquals(  0, offsetof('db'),                 'db');
  CheckEquals(  4, offsetof('lock'),               'lock');
  CheckEquals(  8, offsetof('idx_search'),         'idx_search');
  CheckEquals( 12, offsetof('idx_search_offset'),  'idx_search_offset');
  CheckEquals( 16, offsetof('idx_get'),            'idx_get');
  CheckEquals( 20, offsetof('idx_fd'),             'idx_fd');
  CheckEquals( 24, offsetof('idx_map'),            'idx_map');
  CheckEquals( 36, offsetof('im_fanout'),          'im_fanout');
  CheckEquals( 40, offsetof('im_oid'),             'im_oid');
  CheckEquals( 44, offsetof('im_crc'),             'im_crc');
  CheckEquals( 48, offsetof('im_offset32'),        'im_offset32');
  CheckEquals( 52, offsetof('im_offset64'),        'im_offset64');
  CheckEquals( 56, offsetof('im_off_idx'),         'im_off_idx');
  CheckEquals( 60, offsetof('im_off_next'),        'im_off_next');
  CheckEquals( 64, offsetof('obj_cnt'),            'obj_cnt');
  CheckEquals( 68, offsetof('pack_fd'),            'pack_fd');
  CheckEquals( 72, offsetof('pack_map'),           'pack_map');
  CheckEquals( 88, offsetof('pack_size'),          'pack_size');
  CheckEquals( 96, offsetof('pack_mtime'),         'pack_mtime');
  CheckEquals(104, offsetof('refcnt'),             'refcnt');
  CheckEquals(108, offsetof('idxcnt'),             'idxcnt');
  CheckEquals(116, offsetof('pack_name'),          'pack_name');
end;

procedure TTestGitRecords.Test_git_packlist;
   function offsetof(const Value: string): Integer;
   var
     item: git_packlist;
   begin
     if      Value = 'n_packs'            then Result := Integer(@item.n_packs) - Integer(@item)
     else if Value = 'refcnt'             then Result := Integer(@item.refcnt) - Integer(@item)
     else if Value = 'packs'              then Result := Integer(@item.packs) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 12, sizeof(git_packlist),           'git_packlist');

   CheckEquals(  0, offsetof('n_packs'),               'n_packs');
   CheckEquals(  4, offsetof('refcnt'),                'refcnt');
   CheckEquals(  8, offsetof('packs'),                 'packs');
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

procedure TTestGitRecords.Test_git_revwalk;
   function offsetof(const Value: string): Integer;
   var
     item: git_revwalk;
   begin
     if Value = 'repo'               then Result := Integer(@item.repo) - Integer(@item)

     else if Value = 'commits'            then Result := Integer(@item.commits) - Integer(@item)
     else if Value = 'iterator'           then Result := Integer(@item.iterator) - Integer(@item)

     else if Value = 'next'               then Result := Integer(@item.next) - Integer(@item)

     else if Value = 'walking'            then Result := Integer(@item.walking) - Integer(@item)
     else if Value = 'sorting'            then Result := Integer(@item.sorting) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 32, sizeof(git_revwalk),    'git_revwalk size');

   CheckEquals(  0, offsetof('repo'),       'repo');
   CheckEquals(  4, offsetof('commits'),    'commits');
   CheckEquals(  8, offsetof('iterator'),   'iterator');
   CheckEquals( 20, offsetof('next'),       'next');
   CheckEquals( 28, offsetof('sorting'),    'sorting');
end;

procedure TTestGitRecords.Test_git_tag;
   function offsetof(const Value: string): Integer;
   var
     item: git_tag;
   begin
     if Value = 'object_'                 then Result := Integer(@item.object_) - Integer(@item)
     else if Value = 'target'             then Result := Integer(@item.target) - Integer(@item)
     else if Value = 'type_'              then Result := Integer(@item.type_) - Integer(@item)
     else if Value = 'tag_name'           then Result := Integer(@item.tag_name) - Integer(@item)
     else if Value = 'tagger'             then Result := Integer(@item.tagger) - Integer(@item)
     else if Value = 'message_'           then Result := Integer(@item.message_) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 72, sizeof(git_tag),               'git_tag size');

   CheckEquals(  0, offsetof('object_'),           'object_');
   CheckEquals( 52, offsetof('target'),            'target');
   CheckEquals( 56, offsetof('type_'),             'type_');
   CheckEquals( 60, offsetof('tag_name'),          'tag_name');
   CheckEquals( 64, offsetof('tagger'),            'tagger');
   CheckEquals( 68, offsetof('message_'),          'message_');
end;

procedure TTestGitRecords.Test_sizes;
begin
   CheckEquals(  4, sizeof(size_t),                 'size_t');
   CheckEquals(  8, sizeof(time_t),                 'time_t');
   CheckEquals(  8, sizeof(off_t),                  'off_t');
   CheckEquals(  4, sizeof(git_file),               'git_file');

   CheckEquals(  4, sizeof(git_lck),                'git_lck');
   CheckEquals( 20, sizeof(git_oid),                'git_oid');

   CheckEquals( 24, sizeof(index_entry),            'index_entry');
   CheckEquals(  8, sizeof(git_index_time),         'git_index_time');
   CheckEquals( 68, sizeof(git_index_entry),        'git_index_entry');
   CheckEquals( 40, sizeof(git_index_tree),         'git_index_tree');
   CheckEquals( 40, sizeof(git_index),              'git_index');
   CheckEquals( 12, sizeof(git_hashtable_node),     'git_hashtable_node');
   CheckEquals( 24, sizeof(git_hashtable),          'git_hashtable');
   CheckEquals( 32, sizeof(git_repository),         'git_repository');
   CheckEquals( 24, sizeof(git_odb_source),         'git_odb_source');
   CheckEquals( 52, sizeof(git_object),             'git_object');
   CheckEquals( 32, sizeof(git_tree_entry),         'git_tree_entry');
   CheckEquals( 64, sizeof(git_tree),               'git_tree');
   CheckEquals(  8, sizeof(git_commit_parents),     'git_commit_parents');
   CheckEquals( 96, sizeof(git_commit),             'git_commit');
   CheckEquals( 16, sizeof(git_person),             'git_person');
   CheckEquals( 12, sizeof(git_revwalk_listnode),   'git_revwalk_listnode');
   CheckEquals( 12, sizeof(git_revwalk_list),       'git_revwalk_list');
   CheckEquals( 24, sizeof(git_revwalk_commit),     'git_revwalk_commit');
end;

initialization
   RegisterTest(TTestGitRecords.Suite);

end.
