unit uTestGitRecords;

interface

uses
   TestFramework, SysUtils, Windows;

type
   TTestGitRecords = class(TTestCase)
      procedure Test_sizes;

      procedure Test_git_odb_backend;
      procedure Test_git_time;
      procedure Test_git_signature;
      procedure Test_git_index_entry_unmerged;
      procedure Test_git_config_file;
   end;

implementation

uses
   uGitForDelphi;

{ TTestGitRecordSizes }

procedure TTestGitRecords.Test_git_config_file;
   function offsetof(const Value: string): Integer;
   var
      item: git_config_file;
   begin
      if      Value = 'cfg'               then Result := Integer(@item.cfg) - Integer(@item)
      else if Value = 'open'              then Result := Integer(@item.open) - Integer(@item)
      else if Value = 'get'               then Result := Integer(@item.get) - Integer(@item)
      else if Value = 'set'               then Result := Integer(@item.set_) - Integer(@item)
      else if Value = 'del'               then Result := Integer(@item.del) - Integer(@item)
      else if Value = 'foreach'           then Result := Integer(@item.foreach) - Integer(@item)
      else if Value = 'free'              then Result := Integer(@item.free) - Integer(@item)
      else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 28, sizeof(git_config_file), 'git_config_file size');

   CheckEquals(  0, offsetof('cfg'),               'cfg');
   CheckEquals(  4, offsetof('open'),              'open');
   CheckEquals(  8, offsetof('get'),               'get');
   CheckEquals( 12, offsetof('set'),               'set');
   CheckEquals( 16, offsetof('del'),               'del');
   CheckEquals( 20, offsetof('foreach'),           'foreach');
   CheckEquals( 24, offsetof('free'),              'free');
end;

procedure TTestGitRecords.Test_git_index_entry_unmerged;
   function offsetof(const Value: string): Integer;
   var
      item: git_index_entry_unmerged;
   begin
      if      Value = 'mode'              then Result := Integer(@item.mode) - Integer(@item)
      else if Value = 'oid'               then Result := Integer(@item.oid) - Integer(@item)
      else if Value = 'path'              then Result := Integer(@item.path) - Integer(@item)
      else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 76, sizeof(git_index_entry_unmerged), 'git_index_entry_unmerged size');

   CheckEquals(  0, offsetof('mode'),      'mode');
   CheckEquals( 12, offsetof('oid'),       'oid');
   CheckEquals( 72, offsetof('path'),      'path');
end;

procedure TTestGitRecords.Test_git_odb_backend;
   function offsetof(const Value: string): Integer;
   var
     item: git_odb_backend;
   begin
     if      Value = 'odb'                then Result := Integer(@item.odb) - Integer(@item)
     else if Value = 'read'               then Result := Integer(@item.read) - Integer(@item)
     else if Value = 'read_prefix'        then Result := Integer(@item.read_prefix) - Integer(@item)
     else if Value = 'read_header'        then Result := Integer(@item.read_header) - Integer(@item)
     else if Value = 'write'              then Result := Integer(@item.write) - Integer(@item)
     else if Value = 'writestream'        then Result := Integer(@item.writestream) - Integer(@item)
     else if Value = 'readstream'         then Result := Integer(@item.readstream) - Integer(@item)
     else if Value = 'exists'             then Result := Integer(@item.exists) - Integer(@item)
     else if Value = 'free'               then Result := Integer(@item.free) - Integer(@item)
     else raise Exception.CreateFmt('Unhandled condition (%0:s)', [Value]);
   end;
begin
   CheckEquals( 36, sizeof(git_odb_backend),       'git_odb_backend size');

   CheckEquals(  0, offsetof('odb'),               'odb');
   CheckEquals(  4, offsetof('read'),              'read');
   CheckEquals(  8, offsetof('read_prefix'),       'read_prefix');
   CheckEquals( 12, offsetof('read_header'),       'read_header');
   CheckEquals( 16, offsetof('write'),             'write');
   CheckEquals( 20, offsetof('writestream'),       'writestream');
   CheckEquals( 24, offsetof('readstream'),        'readstream');
   CheckEquals( 28, offsetof('exists'),            'exists');
   CheckEquals( 32, offsetof('free'),              'free');
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

procedure TTestGitRecords.Test_sizes;
begin
   CheckEquals(  4, sizeof(size_t),                 'size_t');
   CheckEquals(  8, sizeof(time_t),                 'time_t');
   CheckEquals(  8, sizeof(git_time_t),             'git_time_t');
   CheckEquals(  8, sizeof(git_off_t),              'git_off_t');
   CheckEquals(  4, sizeof(git_file),               'git_file');
   CheckEquals( 20, sizeof(git_oid),                'git_oid');
   CheckEquals( 16, sizeof(git_index_time),         'git_index_time');
   CheckEquals( 96, sizeof(git_index_entry),        'git_index_entry');
end;

initialization
   RegisterTest(TTestGitRecords.Suite);

end.
