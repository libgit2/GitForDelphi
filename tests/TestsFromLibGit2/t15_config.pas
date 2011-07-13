unit t15_config;

interface

uses
   TestFramework, SysUtils, Windows,
   uTestsFromLibGit2, uGitForDelphi;

type
   Test15_test_config = class(TTestFromLibGit2)
      procedure read_a_simple_configuration;
      procedure case_sensitivity;
      procedure parse_a_multiline_value;
      procedure parse_a__section_subsection__header;
      procedure a_variable_name_on_its_own_is_valid;
      procedure test_number_suffixes;
      procedure test_blank_lines;
      procedure test_for_invalid_ext_headers;
      procedure don_t_fail_on_empty_files;
      procedure replace_a_value;
      procedure a_repo_s_config_overrides_the_global_config;
      procedure fall_back_to_the_global_config;
   end;

implementation

const
   CONFIG_BASE: PAnsiChar = 'resources/config';

procedure Test15_test_config.read_a_simple_configuration;
var
   cfg: Pgit_config;
   i: Integer;
begin
   must_pass(git_config_open_ondisk(&cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config0'))));
   must_pass(git_config_get_int(cfg, 'core.repositoryformatversion', i));
   must_be_true(i = 0);
   must_pass(git_config_get_bool(cfg, 'core.filemode', i));
   must_be_true(i = 1);
   must_pass(git_config_get_bool(cfg, 'core.bare', i));
   must_be_true(i = 0);
   must_pass(git_config_get_bool(cfg, 'core.logallrefupdates', i));
   must_be_true(i = 1);

   git_config_free(cfg);
end;

procedure Test15_test_config.case_sensitivity;
var
   cfg: Pgit_config;
   i: Integer;
   s: PAnsiChar;
begin
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config1'))));

   must_pass(git_config_get_string(cfg, 'this.that.other', s));
   must_be_true(StrComp(s, 'true') = 0);
   must_pass(git_config_get_string(cfg, 'this.That.other', s));
   must_be_true(StrComp(s, 'yes') = 0);

   must_pass(git_config_get_bool(cfg, 'this.that.other', i));
   must_be_true(i = 1);
   must_pass(git_config_get_bool(cfg, 'this.That.other', i));
   must_be_true(i = 1);

   //* This one doesn't exist */
   must_fail(git_config_get_bool(cfg, 'this.thaT.other', i));

   git_config_free(cfg);
end;

procedure Test15_test_config.parse_a_multiline_value;
var
   cfg: Pgit_config;
   s: PAnsiChar;
begin
   must_pass(git_config_open_ondisk(&cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config2'))));

   must_pass(git_config_get_string(cfg, 'this.That.and', s));
   must_be_true(StrComp(s, 'one one one two two three three') = 0);

   git_config_free(cfg);
end;

procedure Test15_test_config.parse_a__section_subsection__header;
var
   cfg: Pgit_config;
   s: PAnsiChar;
begin
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config3'))));

   must_pass(git_config_get_string(cfg, 'section.subsection.var', s));
   must_be_true(StrComp(s, 'hello') = 0);

   //* Avoid a false positive */
   s := 'nohello';
   must_pass(git_config_get_string(cfg, 'section.subSectIon.var', s));
   must_be_true(StrComp(s, 'hello') = 0);

   git_config_free(cfg);
end;

procedure Test15_test_config.a_variable_name_on_its_own_is_valid;
var
   cfg: Pgit_config;
   s: PAnsiChar;
   i: Integer;
begin
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config4'))));

   must_pass(git_config_get_string(cfg, 'some.section.variable', s));
   must_be_true(s = nil);

   must_pass(git_config_get_bool(cfg, 'some.section.variable', i));
   must_be_true(i = 1);

   git_config_free(cfg);
end;

procedure Test15_test_config.test_number_suffixes;
var
   cfg: Pgit_config;
   i: LongInt;
begin
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config5'))));

   must_pass(git_config_get_long(cfg, 'number.simple', i));
   must_be_true(i = 1);

   must_pass(git_config_get_long(cfg, 'number.k', i));
   must_be_true(i = 1 * 1024);

   must_pass(git_config_get_long(cfg, 'number.kk', i));
   must_be_true(i = 1 * 1024);

   must_pass(git_config_get_long(cfg, 'number.m', i));
   must_be_true(i = 1 * 1024 * 1024);

   must_pass(git_config_get_long(cfg, 'number.mm', i));
   must_be_true(i = 1 * 1024 * 1024);

   must_pass(git_config_get_long(cfg, 'number.g', i));
   must_be_true(i = 1 * 1024 * 1024 * 1024);

   must_pass(git_config_get_long(cfg, 'number.gg', i));
   must_be_true(i = 1 * 1024 * 1024 * 1024);

   git_config_free(cfg);
end;

procedure Test15_test_config.test_blank_lines;
var
   cfg: Pgit_config;
   i: Integer;
begin
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config6'))));

   must_pass(git_config_get_bool(cfg, 'valid.subsection.something', i));
   must_be_true(i = 1);

   must_pass(git_config_get_bool(cfg, 'something.else.something', i));
   must_be_true(i = 0);

   git_config_free(cfg);
end;

procedure Test15_test_config.test_for_invalid_ext_headers;
var
   cfg: Pgit_config;
begin
   must_fail(git_config_open_ondisk(&cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config7'))));
end;

procedure Test15_test_config.don_t_fail_on_empty_files;
var
   cfg: Pgit_config;
begin
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config8'))));

   git_config_free(cfg);
end;

procedure Test15_test_config.replace_a_value;
var
   cfg: Pgit_config;
   i: Integer;
begin
   //* By freeing the config, we make sure we flush the values  */
   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config9'))));
   must_pass(git_config_set_int(cfg, 'core.dummy', 5));
   git_config_free(cfg);

   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config9'))));
   must_pass(git_config_get_int(cfg, 'core.dummy', i));
   must_be_true(i = 5);
   git_config_free(cfg);

   must_pass(git_config_open_ondisk(cfg, PAnsiChar(CONFIG_BASE + AnsiString('/config9'))));
   must_pass(git_config_set_int(cfg, 'core.dummy', 1));
   git_config_free(cfg);
end;

procedure Test15_test_config.a_repo_s_config_overrides_the_global_config;
var
   repo: Pgit_repository;
   cfg: Pgit_config;
   version: Integer;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_repository_config(cfg, repo, 'resources/config/.gitconfig', nil));
   must_pass(git_config_get_int(cfg, 'core.repositoryformatversion', version));
   must_be_true(version = 0);
   git_config_free(cfg);
   git_repository_free(repo);
end;

procedure Test15_test_config.fall_back_to_the_global_config;
var
   repo: Pgit_repository;
   cfg: Pgit_config;
   num: Integer;
begin
   must_pass(git_repository_open(repo, REPOSITORY_FOLDER));
   must_pass(git_repository_config(cfg, repo, 'resources/config/.gitconfig', nil));
   must_pass(git_config_get_int(cfg, 'core.something', num));
   must_be_true(num = 2);
   git_config_free(cfg);
   git_repository_free(repo);
end;

initialization
   RegisterTest('From libgit2.t15-config', Test15_test_config.NamedSuite('config'));

end.
