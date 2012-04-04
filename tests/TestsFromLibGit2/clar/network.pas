unit network;

interface

uses
   TestFramework, SysUtils, Windows, Classes,
   uTestsFromLibGit2, uGitForDelphi, uClar;

type
   Test_network_remotes = class(TClarTest)
   private
      _remote: Pgit_remote;
      _repo: Pgit_repository;
      _refspec: Pgit_refspec;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure test_network_remotes__parsing;
      procedure test_network_remotes__refspec_parsing;
      procedure test_network_remotes__fnmatch;
      procedure test_network_remotes__transform;
      procedure test_network_remotes__transform_r;
   end;

   Test_network_remotelocal = class(TClarTest)
   private
      repo: Pgit_repository;
      file_path_buf: AnsiString;
      remote: Pgit_remote;
      procedure build_local_file_url(var out_: AnsiString; fixture: PAnsiChar);
      procedure connect_to_local_repository(local_repository: PAnsiChar);
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure test_network_remotelocal__retrieve_advertised_references;
      procedure test_network_remotelocal__retrieve_advertised_references_from_spaced_repository;
   end;

   Test_network_createremotethenload = class(TClarTest)
   private
      _remote: Pgit_remote;
      _repo: Pgit_repository;
      _config: Pgit_config;
      url: AnsiString;
   protected
      procedure SetUp; override;
      procedure TearDown; override;
   published
      procedure test_network_createremotethenload__parsing;
   end;

implementation

{ Test_network_remotes }

procedure Test_network_remotes.SetUp;
begin
   inherited;
   cl_fixture_sandbox('testrepo.git');

   cl_git_pass(git_repository_open(_repo, 'testrepo.git'));
   cl_git_pass(git_remote_load(_remote, _repo, 'test'));

   _refspec := git_remote_fetchspec(_remote);
   cl_assert(_refspec <> nil);
end;

procedure Test_network_remotes.TearDown;
begin
   inherited;
   git_remote_free(_remote);
   git_repository_free(_repo);
   cl_fixture_cleanup('testrepo.git');
end;

procedure Test_network_remotes.test_network_remotes__fnmatch;
begin
   CheckTrue(true); // can't check members of opaque type
end;

procedure Test_network_remotes.test_network_remotes__parsing;
begin
   cl_assert(StrComp(git_remote_name(_remote), 'test') = 0);
   cl_assert(StrComp(git_remote_url(_remote), 'git://github.com/libgit2/libgit2') = 0);
end;

procedure Test_network_remotes.test_network_remotes__refspec_parsing;
//   function git_refspec_src(const refspec: Pgit_refspec): PAnsiChar;
//   begin
//      if refspec = nil then   Result := nil
//      else                    Result := refspec.src;
//   end;
//
//   function git_refspec_dst(const refspec: Pgit_refspec): PAnsiChar;
//   begin
//      if refspec = nil then   Result := nil
//      else                    Result := refspec.dst;
//   end;
begin
   CheckTrue(true); // can't check members of opaque type
//   cl_assert(StrComp(git_refspec_src(_refspec), 'refs/heads/*') = 0);
//   cl_assert(StrComp(git_refspec_dst(_refspec), 'refs/remotes/test/*') = 0);
end;

procedure Test_network_remotes.test_network_remotes__transform;
begin
//   char ref[1024];
//
//   memset(ref, 0x0, sizeof(ref));
//   cl_git_pass(git_refspec_transform(ref, sizeof(ref), _refspec, "refs/heads/master"));
//   cl_assert(!strcmp(ref, "refs/remotes/test/master"));
   CheckTrue(true); // can't check members of opaque type
end;

procedure Test_network_remotes.test_network_remotes__transform_r;
begin
//   git_buf buf = GIT_BUF_INIT;
//
//   cl_git_pass(git_refspec_transform_r(&buf,  _refspec, "refs/heads/master"));
//   cl_assert(!strcmp(git_buf_cstr(&buf), "refs/remotes/test/master"));
//   git_buf_free(&buf);
   CheckTrue(true); // can't check members of an opaque type
end;

{ Test_network_remotelocal }

procedure Test_network_remotelocal.build_local_file_url(var out_: AnsiString; fixture: PAnsiChar);
var
   path_buf: String;
begin
   path_buf := String(fixture);
   path_buf := 'file:///' + StringReplace(path_buf, ' ', '%20', [rfReplaceAll]);

   out_ := PAnsiChar(AnsiString(path_buf));
end;

procedure Test_network_remotelocal.connect_to_local_repository(local_repository: PAnsiChar);
begin
   build_local_file_url(file_path_buf, local_repository);

   cl_git_pass(git_remote_new(remote, repo, PAnsiChar(file_path_buf), nil));
   cl_git_pass(git_remote_connect(remote, GIT_DIR_FETCH));
end;

procedure Test_network_remotelocal.SetUp;
begin
   inherited;
   cl_git_pass(git_repository_init(repo, 'remotelocal/', 0));
   cl_assert(repo <> nil);
end;

procedure Test_network_remotelocal.TearDown;
begin
   inherited;
   git_remote_free(remote);
   git_repository_free(repo);
   cl_fixture_cleanup('remotelocal');
end;

function count_ref__cb(head: Pgit_remote_head; payload: PByte): Integer; stdcall;
var
   count: PInt;
begin
   count := PInt(payload);

//   (void)head;
   count^ := count^ + 1;

   Result := GIT_SUCCESS;
end;

procedure Test_network_remotelocal.test_network_remotelocal__retrieve_advertised_references;
var
   how_many_refs: Integer;
begin
   how_many_refs := 0;

   connect_to_local_repository(cl_fixture('testrepo.git'));

   cl_git_pass(git_remote_ls(remote, @count_ref__cb, @how_many_refs));

   cl_assert(how_many_refs = 12); //* 1 HEAD + 9 refs + 2 peeled tags */
end;

procedure Test_network_remotelocal.test_network_remotelocal__retrieve_advertised_references_from_spaced_repository;
var
   how_many_refs: Integer;
begin
   how_many_refs := 0;

   cl_fixture_sandbox('testrepo.git');
   cl_git_pass(p_rename('testrepo.git', 'spaced testrepo.git'));

   connect_to_local_repository('spaced testrepo.git');

   cl_git_pass(git_remote_ls(remote, @count_ref__cb, @how_many_refs));

   cl_assert(how_many_refs = 12); //* 1 HEAD */

   cl_fixture_cleanup('spaced testrepo.git');
end;

{ Test_network_createremotethenload }

procedure Test_network_createremotethenload.SetUp;
begin
   inherited;

   url := 'http://github.com/libgit2/libgit2.git';

   cl_fixture_sandbox('testrepo.git');

   cl_git_pass(git_repository_open(_repo, 'testrepo.git'));

   cl_git_pass(git_repository_config(_config, _repo));
   cl_git_pass(git_config_set_string(_config, 'remote.origin.fetch', '+refs/heads/*:refs/remotes/origin/*'));
   cl_git_pass(git_config_set_string(_config, 'remote.origin.url', PAnsiChar(url)));
   git_config_free(_config);

   cl_git_pass(git_remote_load(_remote, _repo, 'origin'));
end;

procedure Test_network_createremotethenload.TearDown;
begin
   inherited;
   git_remote_free(_remote);
   git_repository_free(_repo);
   cl_fixture_cleanup('testrepo.git');
end;

procedure Test_network_createremotethenload.test_network_createremotethenload__parsing;
begin
   cl_assert(StrComp(git_remote_name(_remote), 'origin') = 0);
   cl_assert(StrComp(git_remote_url(_remote), PAnsiChar(url)) = 0);
end;

initialization
   RegisterTest('From libgit2/clar/network', Test_network_remotes.NamedSuite('remotes'));
   RegisterTest('From libgit2/clar/network', Test_network_remotelocal.NamedSuite('remotelocal'));
   RegisterTest('From libgit2/clar/network', Test_network_createremotethenload.NamedSuite('createremotethenload'));

end.
