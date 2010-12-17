unit uGitForDelphi;

interface

uses
   Windows;

function InitLibgit2: Boolean;

const
//   /** Size (in bytes) of a raw/binary oid */
//   #define GIT_OID_RAWSZ 20
   GIT_OID_RAWSZ = 20;
//   /** Size (in bytes) of a hex formatted oid */
//   #define GIT_OID_HEXSZ (GIT_OID_RAWSZ * 2)
   GIT_OID_HEXSZ = (GIT_OID_RAWSZ * 2);
//   #define GIT_PACK_NAME_MAX (5 + 40 + 1)
   GIT_PACK_NAME_MAX = (5 + 40 + 1);

   // git_otype, enum with integer values
   //      typedef enum {
   //      GIT_OBJ_ANY = -2,		/**< Object can be any of the following */
   //      GIT_OBJ_BAD = -1,       /**< Object is invalid. */
   //      GIT_OBJ__EXT1 = 0,      /**< Reserved for future use. */
   //      GIT_OBJ_COMMIT = 1,     /**< A commit object. */
   //      GIT_OBJ_TREE = 2,       /**< A tree (directory listing) object. */
   //      GIT_OBJ_BLOB = 3,       /**< A file revision object. */
   //      GIT_OBJ_TAG = 4,        /**< An annotated tag object. */
   //      GIT_OBJ__EXT2 = 5,      /**< Reserved for future use. */
   //      GIT_OBJ_OFS_DELTA = 6,  /**< A delta, base is given by an offset. */
   //      GIT_OBJ_REF_DELTA = 7,  /**< A delta, base is given by object id. */
   //   } git_otype;
   GIT_OBJ_ANY = -2;
   GIT_OBJ_BAD = -1;
   GIT_OBJ__EXT1 = 0;
   GIT_OBJ_COMMIT = 1;
   GIT_OBJ_TREE = 2;
   GIT_OBJ_BLOB = 3;
   GIT_OBJ_TAG = 4;
   GIT_OBJ__EXT2 = 5;
   GIT_OBJ_OFS_DELTA = 6;
   GIT_OBJ_REF_DELTA = 7;

//   /** Operation completed successfully. */
//   #define GIT_SUCCESS 0
//
//   /**
//    * Operation failed, with unspecified reason.
//    * This value also serves as the base error code; all other
//    * error codes are subtracted from it such that all errors
//    * are < 0, in typical POSIX C tradition.
//    */
//   #define GIT_ERROR -1
//
//   /** Input was not a properly formatted Git object id. */
//   #define GIT_ENOTOID (GIT_ERROR - 1)
//
//   /** Input does not exist in the scope searched. */
//   #define GIT_ENOTFOUND (GIT_ERROR - 2)
//
//   /** Not enough space available. */
//   #define GIT_ENOMEM (GIT_ERROR - 3)
//
//   /** Consult the OS error information. */
//   #define GIT_EOSERR (GIT_ERROR - 4)
//
//   /** The specified object is of invalid type */
//   #define GIT_EOBJTYPE (GIT_ERROR - 5)
//
//   /** The specified object has its data corrupted */
//   #define GIT_EOBJCORRUPTED (GIT_ERROR - 6)
//
//   /** The specified repository is invalid */
//   #define GIT_ENOTAREPO (GIT_ERROR - 7)
//
//   /** The object type is invalid or doesn't match */
//   #define GIT_EINVALIDTYPE (GIT_ERROR - 8)
//
//   /** The object cannot be written that because it's missing internal data */
//   #define GIT_EMISSINGOBJDATA (GIT_ERROR - 9)
//
//   /** The packfile for the ODB is corrupted */
//   #define GIT_EPACKCORRUPTED (GIT_ERROR - 10)
//
//   /** Failed to adquire or release a file lock */
//   #define GIT_EFLOCKFAIL (GIT_ERROR - 11)
//
//   /** The Z library failed to inflate/deflate an object's data */
//   #define GIT_EZLIB (GIT_ERROR - 12)
//
//   /** The queried object is currently busy */
//   #define GIT_EBUSY (GIT_ERROR - 13)
//
//   /** The index file is not backed up by an existing repository */
//   #define GIT_EBAREINDEX (GIT_ERROR -14)

   GIT_SUCCESS          = 0;
   GIT_ERROR            = -1;
   GIT_ENOTOID          = (GIT_ERROR - 1);
   GIT_ENOTFOUND        = (GIT_ERROR - 2);
   GIT_ENOMEM           = (GIT_ERROR - 3);
   GIT_EOSERR           = (GIT_ERROR - 4);
   GIT_EOBJTYPE         = (GIT_ERROR - 5);
   GIT_EOBJCORRUPTED    = (GIT_ERROR - 6);
   GIT_ENOTAREPO        = (GIT_ERROR - 7);
   GIT_EINVALIDTYPE     = (GIT_ERROR - 8);
   GIT_EMISSINGOBJDATA  = (GIT_ERROR - 9);
   GIT_EPACKCORRUPTED   = (GIT_ERROR - 10);
   GIT_EFLOCKFAIL       = (GIT_ERROR - 11);
   GIT_EZLIB            = (GIT_ERROR - 12);
   GIT_EBUSY            = (GIT_ERROR - 13);
   GIT_EBAREINDEX       = (GIT_ERROR - 14);
//
//   /**
//    * Sort the repository contents in no particular ordering;
//    * this sorting is arbitrary, implementation-specific
//    * and subject to change at any time.
//    * This is the default sorting for new walkers.
//    */
//   #define GIT_SORT_NONE         (0)
//
//   /**
//    * Sort the repository contents in topological order
//    * (parents before children); this sorting mode
//    * can be combined with time sorting.
//    */
//   #define GIT_SORT_TOPOLOGICAL  (1 << 0)
//
//   /**
//    * Sort the repository contents by commit time;
//    * this sorting mode can be combined with
//    * topological sorting.
//    */
//   #define GIT_SORT_TIME         (1 << 1)
//
//   /**
//    * Iterate through the repository contents in reverse
//    * order; this sorting mode can be combined with
//    * any of the above.
//    */
//   #define GIT_SORT_REVERSE      (1 << 2)
   GIT_SORT_NONE        = (0);
   GIT_SORT_TOPOLOGICAL = (1 shl 0);
   GIT_SORT_TIME        = (1 shl 1);
   GIT_SORT_REVERSE     = (1 shl 2);

type
   size_t   = LongWord;
   time_t   = Int64;
   off_t    = Int64;
   git_otype = Integer; // enum as constants above

   git_file = Integer;

//   typedef struct { int dummy; } git_lck;
   git_lck = record
      dummy:                                             Integer;
   end;

//   typedef struct {
//      /** raw binary formatted id */
//      unsigned char id[GIT_OID_RAWSZ];
//   } git_oid;
   git_oid = record
      id:                                                array[0..GIT_OID_RAWSZ-1] of Byte;
   end;

   PPByte = ^PByte;
   Pgit_repository = ^git_repository;
   PPgit_pack = ^Pgit_pack;
   Pgit_pack = ^git_pack;
   Pgit_packlist = ^git_packlist;
   Pgit_oid = ^git_oid;
   Pgit_odb = ^git_odb;
   PPgit_odb = ^Pgit_odb;
   Pgit_commit = ^git_commit;
   PPgit_commit = ^Pgit_commit;
   Pgit_index = ^git_index;
   Pgit_hashtable = ^git_hashtable;
   Pgit_hashtable_node = ^git_hashtable_node;
   PPgit_hashtable_node = ^Pgit_hashtable_node;
   Pgit_map = ^git_map;
   PPgit_index_entry = ^Pgit_index_entry;
   Pgit_index_entry = ^git_index_entry;
   Pgit_index_tree = ^git_index_tree;
   PPgit_index_tree = ^Pgit_index_tree;
   Pgit_person = ^git_person;
   Pgit_odb_source = ^git_odb_source;
   Pgit_object = ^git_object;
   Pgit_tree = ^git_tree;
   Pgit_tree_entry = ^git_tree_entry;
   PPgit_tree_entry = ^Pgit_tree_entry;
   Pgit_rawobj = ^git_rawobj;
   Pgit_revwalk = ^git_revwalk;
   PPgit_revwalk = ^Pgit_revwalk;
   Pgit_revwalk_list = ^git_revwalk_list;
   Pgit_revwalk_commit = ^git_revwalk_commit;
   Pgit_revwalk_listnode = ^git_revwalk_listnode;
   Pgit_tag = ^git_tag;
   Ppack_backend = ^pack_backend;

//   typedef int (*git_vector_cmp)(const void *, const void *);
   git_vector_cmp = Pointer;

//   typedef int (*git_vector_srch)(const void *, const void *);
   git_vector_srch = Pointer;

//   typedef struct git_vector {
//      unsigned int _alloc_size;
//      git_vector_cmp _cmp;
//      git_vector_srch _srch;
//
//      void **contents;
//      unsigned int length;
//   } git_vector;
   git_vector = record
      _alloc_size:                                       UInt;
      _cmp:                                              git_vector_cmp;
      _srch:                                             git_vector_srch;

      contents:                                          PPByte;
      length:                                            UInt;
   end;

//   struct git_odb_backend {
//      git_odb *odb;
//
//      int priority;
//
//      int (* read)(
//            git_rawobj *,
//            struct git_odb_backend *,
//            const git_oid *);
//
//      int (* read_header)(
//            git_rawobj *,
//            struct git_odb_backend *,
//            const git_oid *);
//
//      int (* write)(
//            git_oid *id,
//            struct git_odb_backend *,
//            git_rawobj *obj);
//
//      int (* exists)(
//            struct git_odb_backend *,
//            const git_oid *);
//
//      void (* free)(struct git_odb_backend *);
//   };
   git_odb_backend = record
      odb:                                               Pgit_odb;

      priority:                                          Integer;

      read:                                              Pointer;
      read_header:                                       Pointer;
      write:                                             Pointer;
      exists:                                            Pointer;
      free:                                              Pointer;
   end;

//   typedef struct pack_backend {
//      git_odb_backend parent;
//
//      git_lck lock;
//      char *objects_dir;
//      git_packlist *packlist;
//   } pack_backend;
   pack_backend = record
      parent:                                            git_odb_backend;

      lock:                                              git_lck;
      objects_dir:                                       PAnsiChar;
      packlist:                                          Pgit_packlist;
   end;

//   typedef struct {
//      size_t n_packs;
//      unsigned int refcnt;
//      git_pack *packs[GIT_FLEX_ARRAY];
//   } git_packlist;
   git_packlist = record
      n_packs:                                           size_t;
      refcnt:                                            UInt;
      packs:                                             PPgit_pack;
   end;

//   struct git_odb {
//      void *_internal;
//      git_vector backends;
//   };
   git_odb = record
      _internal:                                         PByte;
      backends:                                          git_vector;
   end;

//   typedef struct {  /* memory mapped buffer   */
//      void *data;  /* data bytes          */
//      size_t len;  /* data length         */
//   #ifdef GIT_WIN32
//      HANDLE fmh;  /* file mapping handle */
//   #endif
//   } git_map;
   git_map = record
      data:                                              PByte;  //* data bytes          */
      len:                                               size_t;  //* data length         */
      fmh:                                               THandle;  //* file mapping handle */
   end;

//   struct git_pack {
//      struct pack_backend *backend;
//      git_lck lock;
//
//      /** Functions to access idx_map. */
//      int (*idx_search)(
//         uint32_t *,
//         struct git_pack *,
//         const git_oid *);
//      int (*idx_search_offset)(
//         uint32_t *,
//         struct git_pack *,
//         off_t);
//      int (*idx_get)(
//         index_entry *,
//         struct git_pack *,
//         uint32_t n);
//
//      /** The .idx file, mapped into memory. */
//      git_file idx_fd;
//      git_map idx_map;
//      uint32_t *im_fanout;
//      unsigned char *im_oid;
//      uint32_t *im_crc;
//      uint32_t *im_offset32;
//      uint32_t *im_offset64;
//      uint32_t *im_off_idx;
//      uint32_t *im_off_next;
//
//      /** Number of objects in this pack. */
//      uint32_t obj_cnt;
//
//      /** File descriptor for the .pack file. */
//      git_file pack_fd;
//
//      /** Memory map of the pack's contents */
//      git_map pack_map;
//
//      /** The size of the .pack file. */
//      off_t pack_size;
//
//      /** The mtime of the .pack file. */
//      time_t pack_mtime;
//
//      /** Number of git_packlist we appear in. */
//      unsigned int refcnt;
//
//      /** Number of active users of the idx_map data. */
//      unsigned int idxcnt;
//      unsigned
//         invalid:1 /* the pack is unable to be read by libgit2 */
//         ;
//
//      /** Name of the pack file(s), without extension ("pack-abc"). */
//      char pack_name[GIT_PACK_NAME_MAX];
//   } git_pack;
   git_pack = record
      backend:                                           Ppack_backend;
      lock:                                              git_lck;

      //* Functions to access idx_map. */
      idx_search:          Pointer; // function (i: PUInt; pack: Pgit_pack; const oid: Pgit_oid):  Integer cdecl;
      idx_search_offset:   Pointer; // function (i: PUint; pack: Pgit_pack; t: off_t):             Integer cdecl;
      idx_get:             Pointer; // function (entry: Pindex_entry; pack: Pgit_pack; n: UInt):   Integer cdecl;

      //* The .idx file, mapped into memory. */
      idx_fd:                                            git_file;
      idx_map:                                           git_map;
      im_fanout:                                         PUINT;
      im_oid:                                            PByte;
      im_crc:                                            PUINT;
      im_offset32:                                       PUINT;
      im_offset64:                                       PUINT;
      im_off_idx:                                        PUINT;
      im_off_next:                                       PUINT;

      //* Number of objects in this pack. */
      obj_cnt:                                           UINT;

      //* File descriptor for the .pack file. */
      pack_fd:                                           git_file;

      //* Memory map of the pack's contents */
      pack_map:                                          git_map;

      //* The size of the .pack file. */
      pack_size:                                         off_t;

      //* The mtime of the .pack file. */
      pack_mtime:                                        time_t;

      //* Number of git_packlist we appear in. */
      refcnt:                                            UInt;

      //* Number of active users of the idx_map data. */
      idxcnt:                                            UInt;
      //* the pack is unable to be read by libgit2 */
      invalid:                                           Integer;

      //* Name of the pack file(s), without extension ("pack-abc"). */
      pack_name:                                         array[0..GIT_PACK_NAME_MAX-1] of AnsiChar;
   end;

//   typedef struct {
//      time_t seconds;
//      time_t nanoseconds;
//   } git_index_time;
   git_index_time = record
      seconds:                                           time_t;
      nanoseconds:                                       time_t;
   end;

//   typedef struct git_index_entry {
//      git_index_time ctime;
//      git_index_time mtime;
//
//      unsigned int dev;
//      unsigned int ino;
//      unsigned int mode;
//      unsigned int uid;
//      unsigned int gid;
//      off_t file_size;
//
//      git_oid oid;
//
//      unsigned short flags;
//      unsigned short flags_extended;
//
//      char *path;
//   } git_index_entry;
   git_index_entry = record
      ctime:                                             git_index_time;
      mtime:                                             git_index_time;

      dev:                                               UInt;
      ino:                                               UInt;
      mode:                                              UInt;
      uid:                                               UInt;
      gid:                                               UInt;
      file_size:                                         off_t;

      oid:                                               git_oid;

      flags:                                             SHORT;
      flags_extended:                                    SHORT;

      path:                                              PAnsiChar;
   end;

//   struct git_index_tree {
//      char *name;
//
//      struct git_index_tree *parent;
//      struct git_index_tree **children;
//      size_t children_count;
//
//      size_t entries;
//      git_oid oid;
//   };
   git_index_tree = record
      name:                                              PAnsiChar;

      parent:                                            Pgit_index_tree;
      children:                                          PPgit_index_tree;
      children_count:                                    size_t;

      entries:                                           size_t;
      oid:                                               git_oid;
   end;

//   struct git_index {
//      git_repository *repository;
//      char *index_file_path;
//
//      time_t last_modified;
//      git_vector entries;
//
//      unsigned int sorted:1,
//                on_disk:1;
//
//      git_index_tree *tree;
//   };
   git_index = record
      repository:                                        Pgit_repository;
      index_file_path:                                   PAnsiChar;

      last_modified:                                     time_t;
      entries:                                           git_vector;

      sortedANDon_disk:                                  UInt;

      tree:                                              Pgit_index_tree;

      function GetSorted: Integer;
      function GetOnDisk: Integer;
      property sorted: Integer read GetSorted;
      property on_disk: Integer read GetOnDisk;
   end;

//   struct git_hashtable_node {
//      void *object;
//      uint32_t hash;
//      struct git_hashtable_node *next;
//   };
   git_hashtable_node = record
      object_:                                           PByte;
      hash:                                              UInt;
      next:                                              Pgit_hashtable_node;
   end;

//   struct git_hashtable {
//      struct git_hashtable_node **nodes;
//
//      unsigned int size_mask;
//      unsigned int count;
//      unsigned int max_count;
//
//      git_hash_ptr hash;
//      git_hash_keyeq_ptr key_equal;
//   };
   git_hashtable = record
      nodes:                                             PPgit_hashtable_node;

      size_mask:                                         UInt;
      count:                                             UInt;
      max_count:                                         UInt;

      hash:        Pointer;
      key_equal:   Pointer;
   end;
   
//   struct git_repository {
//      git_odb *db;
//      git_index *index;
//      git_hashtable *objects;
//
//      char *path_repository;
//      char *path_index;
//      char *path_odb;
//      char *path_workdir;
//
//      unsigned is_bare:1;
//   };
   git_repository = record
      db:                                                Pgit_odb;
      index:                                             Pgit_index;
      objects:                                           Pgit_hashtable;

      path_repository:                                   PAnsiChar;
      path_index:                                        PAnsiChar;
      path_odb:                                          PAnsiChar;
      path_workdir:                                      PAnsiChar;

      is_bare:                                           UInt;
   end;

//   typedef struct {
//      void *data;          /**< Raw, decompressed object data. */
//      size_t len;          /**< Total number of bytes in data. */
//      git_otype type;      /**< Type of this object. */
//   } git_rawobj;
   git_rawobj = record
      data:                                              PByte;
      len:                                               size_t;
      type_:                                             git_otype;
   end;
   
//   typedef struct {
//      git_rawobj raw;
//      void *write_ptr;
//      size_t written_bytes;
//      int open:1;
//   } git_odb_source;
   git_odb_source = record
      raw:                                               git_rawobj;
      write_ptr:                                         PByte;
      written_bytes:                                     size_t;
      open:                                              Integer;
   end;

//   struct git_object {
//      git_oid id;
//      git_repository *repo;
//      git_odb_source source;
//      int in_memory:1, modified:1;
//   };
   git_object = record
      id:                                                git_oid;
      repo:                                              Pgit_repository;
      source:                                            git_odb_source;
      in_memoryANDmodified:                              LongWord;
   end;

//   struct git_tree_entry {
//      unsigned int attr;
//      char *filename;
//      git_oid oid;
//
//      git_tree *owner;
//   };
   git_tree_entry = record
      attr:                                              UInt;
      filename:                                          PAnsiChar;
      oid:                                               git_oid;

      owner:                                             Pgit_tree;
   end;

//   struct git_tree {
//      git_object object;
//      git_vector entries;
//   };
   git_tree = record
      object_:                                           git_object;
      entries:                                           git_vector;
   end;

//   struct git_commit {
//      git_object object;
//
//      time_t commit_time;
//      git_vector parents;
//
//      git_tree *tree;
//      git_person *author;
//      git_person *committer;
//
//      char *message;
//      char *message_short;
//
//      unsigned full_parse:1;
//   };
   git_commit = record
      object_:                                           git_object;

      commit_time:                                       time_t;
      parents:                                           git_vector;

      tree:                                              Pgit_tree;
      author:                                            Pgit_person;
      committer:                                         Pgit_person;

      message_:                                          PAnsiChar;
      message_short:                                     PAnsiChar;

      full_parse:                                        UInt;
   end;

//   struct git_person {
//      char *name; /**< Full name */
//      char *email; /**< Email address */
//      time_t time; /**< Time when this person committed the change */
//   };
   git_person = record
      name:                                              PAnsiChar;
      email:                                             PAnsiChar;
      time:                                              time_t;
   end;

//   typedef struct git_revwalk_listnode {
//      struct git_revwalk_commit *walk_commit;
//      struct git_revwalk_listnode *next;
//      struct git_revwalk_listnode *prev;
//   } git_revwalk_listnode;
   git_revwalk_listnode = record
      walk_commit:                                       Pgit_revwalk_commit;
      next:                                              Pgit_revwalk_listnode;
      prev:                                              Pgit_revwalk_listnode;
   end;

//   typedef struct git_revwalk_list {
//      struct git_revwalk_listnode *head;
//      struct git_revwalk_listnode *tail;
//      size_t size;
//   } git_revwalk_list;
   git_revwalk_list = record
      head:                                              Pgit_revwalk_listnode;
      tail:                                              Pgit_revwalk_listnode;
      size:                                              size_t;
   end;

//   struct git_revwalk_commit {
//
//      git_commit *commit_object;
//      git_revwalk_list parents;
//
//      unsigned short in_degree;
//      unsigned seen:1,
//             uninteresting:1,
//             topo_delay:1,
//             flags:25;
//   };
   git_revwalk_commit = record
      commit_object:                                     Pgit_commit;
      parents:                                           git_revwalk_list;

      in_degree:                                         SHORT;
      seenANDuninterestingANDtopo_delayANDflags:         UInt;
   end;

//   struct git_revwalk {
//      git_repository *repo;
//
//      git_hashtable *commits;
//      git_revwalk_list iterator;
//
//      git_revwalk_commit *(*next)(git_revwalk_list *);
//
//      unsigned walking:1;
//      unsigned int sorting;
//   };
   git_revwalk = record
      repo:                                              Pgit_repository;

      commits:                                           Pgit_hashtable;
      iterator:                                          git_revwalk_list;

      next:                  Pointer; // function (list: Pgit_revwalk_list): git_revwalk_commit cdecl;

      walking:                                           UInt;
      sorting:                                           UInt;
   end;

//   struct git_tag {
//      git_object object;
//
//      git_object *target;
//      git_otype type;
//      char *tag_name;
//      git_person *tagger;
//      char *message;
//   };
   git_tag = record
      object_:                                           git_object;

      target:                                            Pgit_object;
      type_:                                             git_otype;
      tag_name:                                          PAnsiChar;
      tagger:                                            Pgit_person;
      message_:                                          PAnsiChar;
   end;
   
var
   // GIT_EXTERN(int) git_repository_open(git_repository **repository, const char *path);
   git_repository_open:          function (var repo_out: Pgit_repository; const path: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(void) git_repository_free(git_repository *repo);
   git_repository_free:          procedure (repo: Pgit_repository) cdecl;

   // GIT_EXTERN(int) git_oid_mkstr(git_oid *out, const char *str);
   git_oid_mkstr:                function (aOut: Pgit_oid; aStr: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(void) git_oid_fmt(char *str, const git_oid *oid);
   git_oid_fmt:                  procedure (aStr: PAnsiChar; const oid: Pgit_oid) cdecl;

   // GIT_EXTERN(void) git_oid_pathfmt(char *str, const git_oid *oid);
   git_oid_pathfmt:              procedure (aStr: PAnsiChar; const oid: Pgit_oid) cdecl;

   // GIT_EXTERN(int) git_commit_lookup(git_commit **commit, git_repository *repo, const git_oid *id);
   git_commit_lookup:            function (var commit: Pgit_commit; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;

   // GIT_EXTERN(const char *) git_commit_message_short(git_commit *commit);
   git_commit_message_short:     function (commit: Pgit_commit): PAnsiChar cdecl;

   // GIT_EXTERN(const char *) git_commit_message(git_commit *commit);
   git_commit_message:           function (commit: Pgit_commit): PAnsiChar cdecl;

   // GIT_EXTERN(const git_person *) git_commit_author(git_commit *commit);
   git_commit_author:            function (commit: Pgit_commit): Pgit_person cdecl;

   // GIT_EXTERN(const git_person *) git_commit_committer(git_commit *commit);
   git_commit_committer:         function (commit: Pgit_commit): Pgit_person cdecl;

   // GIT_EXTERN(time_t) git_commit_time(git_commit *commit);
   git_commit_time:              function (commit: Pgit_commit): time_t cdecl;

   // GIT_EXTERN(unsigned int) git_commit_parentcount(git_commit *commit);
   git_commit_parentcount:       function (commit: Pgit_commit): UInt cdecl;

   // GIT_EXTERN(git_commit *) git_commit_parent(git_commit *commit, unsigned int n);
   git_commit_parent:            function (commit: Pgit_commit; n: UInt): Pgit_commit cdecl;

   // GIT_EXTERN(int) git_revwalk_new(git_revwalk **walker, git_repository *repo);
   git_revwalk_new:              function (var walker: Pgit_revwalk; repo: Pgit_repository): Integer cdecl;

   // GIT_EXTERN(void) git_revwalk_free(git_revwalk *walk);
   git_revwalk_free:             procedure (walk: Pgit_revwalk) cdecl;

   // GIT_EXTERN(int) git_revwalk_sorting(git_revwalk *walk, unsigned int sort_mode);
   git_revwalk_sorting:          function (walk: Pgit_revwalk; sort_mode: UInt): Integer cdecl;

   // GIT_EXTERN(int) git_revwalk_push(git_revwalk *walk, git_commit *commit);
   git_revwalk_push:             function (walk: Pgit_revwalk; commit: Pgit_commit): Integer cdecl;

   // GIT_EXTERN(git_commit *) git_revwalk_next(git_revwalk *walk);
   git_revwalk_next:             function (walk: Pgit_revwalk): Pgit_commit cdecl;

   // GIT_EXTERN(int) git_index_open_bare(git_index **index, const char *index_path);
   git_index_open_bare:          function (var index: Pgit_index; const index_path: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(int) git_index_read(git_index *index);
   git_index_read:               function (index: Pgit_index): Integer cdecl;

   // GIT_EXTERN(void) git_index_free(git_index *index);
   git_index_free:               procedure (index: Pgit_index) cdecl;

   // GIT_EXTERN(int) git_index_find(git_index *index, const char *path);
   git_index_find:               function (index: Pgit_index; const path: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(unsigned int) git_index_entrycount(git_index *index);
   git_index_entrycount:         function (index: Pgit_index): UInt cdecl;

   // GIT_EXTERN(int) git_tag_lookup(git_tag **tag, git_repository *repo, const git_oid *id);
   git_tag_lookup:               function (var tag: Pgit_tag; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;

   // GIT_EXTERN(const char *) git_tag_name(git_tag *t);
   git_tag_name:                 function (t: Pgit_tag): PAnsiChar cdecl;

   // GIT_EXTERN(git_otype) git_tag_type(git_tag *t);
   git_tag_type:                 function (t: Pgit_tag): git_otype cdecl;

   // GIT_EXTERN(const git_object *) git_tag_target(git_tag *t);
   git_tag_target:               function (t: Pgit_tag): Pgit_object cdecl;

   // GIT_EXTERN(const git_oid *) git_tag_id(git_tag *tag);
   git_tag_id:                   function (tag: Pgit_tag): Pgit_oid cdecl;

   // GIT_EXTERN(void) git_tag_set_name(git_tag *tag, const char *name);
   git_tag_set_name:             procedure (tag: Pgit_tag; const name: PAnsiChar) cdecl;

   // GIT_EXTERN(const git_oid *) git_commit_id(git_commit *commit);
   git_commit_id:                function (commit: Pgit_commit): Pgit_oid cdecl;

   // GIT_EXTERN(const git_oid *) git_object_id(git_object *obj);
   git_object_id:                function (obj: Pgit_object): Pgit_oid cdecl;

   // GIT_EXTERN(int) git_object_write(git_object *object);
   git_object_write:             function (object_: Pgit_object): Integer cdecl;

implementation

var
  libgit2: THandle;

function InitLibgit2: Boolean;
begin
  if libgit2 = 0 then
  begin
    libgit2 := LoadLibrary('git2.dll');
    if libgit2 > 0 then
    begin
      git_repository_open        := GetProcAddress(libgit2, 'git_repository_open');
      git_repository_free        := GetProcAddress(libgit2, 'git_repository_free');
      git_oid_mkstr              := GetProcAddress(libgit2, 'git_oid_mkstr');
      git_oid_fmt                := GetProcAddress(libgit2, 'git_oid_fmt');
      git_oid_pathfmt            := GetProcAddress(libgit2, 'git_oid_pathfmt');
      git_commit_lookup          := GetProcAddress(libgit2, 'git_commit_lookup');
      git_commit_message_short   := GetProcAddress(libgit2, 'git_commit_message_short');
      git_commit_message         := GetProcAddress(libgit2, 'git_commit_message');
      git_commit_author          := GetProcAddress(libgit2, 'git_commit_author');
      git_commit_committer       := GetProcAddress(libgit2, 'git_commit_committer');
      git_commit_time            := GetProcAddress(libgit2, 'git_commit_time');
      git_commit_parentcount     := GetProcAddress(libgit2, 'git_commit_parentcount');
      git_commit_parent          := GetProcAddress(libgit2, 'git_commit_parent');
      git_revwalk_new            := GetProcAddress(libgit2, 'git_revwalk_new');
      git_revwalk_free           := GetProcAddress(libgit2, 'git_revwalk_free');
      git_revwalk_sorting        := GetProcAddress(libgit2, 'git_revwalk_sorting');
      git_revwalk_push           := GetProcAddress(libgit2, 'git_revwalk_push');
      git_revwalk_next           := GetProcAddress(libgit2, 'git_revwalk_next');
      git_index_open_bare        := GetProcAddress(libgit2, 'git_index_open_bare');
      git_index_read             := GetProcAddress(libgit2, 'git_index_read');
      git_index_free             := GetProcAddress(libgit2, 'git_index_free');
      git_index_find             := GetProcAddress(libgit2, 'git_index_find');
      git_index_entrycount       := GetProcAddress(libgit2, 'git_index_entrycount');
      git_tag_lookup             := GetProcAddress(libgit2, 'git_tag_lookup');
      git_tag_name               := GetProcAddress(libgit2, 'git_tag_name');
      git_tag_type               := GetProcAddress(libgit2, 'git_tag_type');
      git_tag_target             := GetProcAddress(libgit2, 'git_tag_target');
      git_tag_id                 := GetProcAddress(libgit2, 'git_tag_id');
      git_tag_set_name           := GetProcAddress(libgit2, 'git_tag_set_name');
      git_commit_id              := GetProcAddress(libgit2, 'git_commit_id');
      git_object_id              := GetProcAddress(libgit2, 'git_object_id');
      git_object_write           := GetProcAddress(libgit2, 'git_object_write');
    end;
  end;

  Result := libgit2 > 0;
end;

procedure FreeLibgit2;
begin
  if libgit2 <> 0 then
  begin
    FreeLibrary(libgit2);
    libgit2 := 0;

    git_repository_open          := nil;
    git_repository_free          := nil;
    git_oid_mkstr                := nil;
    git_oid_fmt                  := nil;
    git_oid_pathfmt              := nil;
    git_commit_lookup            := nil;
    git_commit_message_short     := nil;
    git_commit_message           := nil;
    git_commit_author            := nil;
    git_commit_committer         := nil;
    git_commit_time              := nil;
    git_commit_parentcount       := nil;
    git_commit_parent            := nil;
    git_revwalk_new              := nil;
    git_revwalk_free             := nil;
    git_revwalk_sorting          := nil;
    git_revwalk_push             := nil;
    git_revwalk_next             := nil;
    git_index_open_bare          := nil;
    git_index_read               := nil;
    git_index_free               := nil;
    git_index_find               := nil;
    git_index_entrycount         := nil;
    git_tag_lookup               := nil;
    git_tag_name                 := nil;
    git_tag_type                 := nil;
    git_tag_target               := nil;
    git_tag_id                   := nil;
    git_tag_set_name             := nil;
    git_commit_id                := nil;
    git_object_id                := nil;
    git_object_write             := nil;
  end;
end;

{ git_index }

function git_index.GetOnDisk: Integer;
begin
   Result := (sortedANDon_disk shr 1) and 1;
end;

function git_index.GetSorted: Integer;
begin
   Result := (sortedANDon_disk) and 1;
end;

initialization
  libgit2 := 0;
finalization
  FreeLibgit2;

end.
