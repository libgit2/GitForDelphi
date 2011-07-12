unit uGitForDelphi;

interface

uses
   SysUtils, Windows;

function InitLibgit2: Boolean;

const
//   /** Size (in bytes) of a raw/binary oid */
//   #define GIT_OID_RAWSZ 20
   GIT_OID_RAWSZ = 20;
//   /** Size (in bytes) of a hex formatted oid */
//   #define GIT_OID_HEXSZ (GIT_OID_RAWSZ * 2)
   GIT_OID_HEXSZ = (GIT_OID_RAWSZ * 2);
//   #define GIT_OID_MINPREFIXLEN 4
   GIT_OID_MINPREFIXLEN = 4;
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

//   typedef enum {
//      GIT_SUCCESS = 0,
//      GIT_ERROR = -1,
//
//      /** Input was not a properly formatted Git object id. */
//      GIT_ENOTOID = -2,
//
//      /** Input does not exist in the scope searched. */
//      GIT_ENOTFOUND = -3,
//
//      /** Not enough space available. */
//      GIT_ENOMEM = -4,
//
//      /** Consult the OS error information. */
//      GIT_EOSERR = -5,
//
//      /** The specified object is of invalid type */
//      GIT_EOBJTYPE = -6,
//
//      /** The specified repository is invalid */
//      GIT_ENOTAREPO = -7,
//
//      /** The object type is invalid or doesn't match */
//      GIT_EINVALIDTYPE = -8,
//
//      /** The object cannot be written because it's missing internal data */
//      GIT_EMISSINGOBJDATA = -9,
//
//      /** The packfile for the ODB is corrupted */
//      GIT_EPACKCORRUPTED = -10,
//
//      /** Failed to acquire or release a file lock */
//      GIT_EFLOCKFAIL = -11,
//
//      /** The Z library failed to inflate/deflate an object's data */
//      GIT_EZLIB = -12,
//
//      /** The queried object is currently busy */
//      GIT_EBUSY = -13,
//
//      /** The index file is not backed up by an existing repository */
//      GIT_EBAREINDEX = -14,
//
//      /** The name of the reference is not valid */
//      GIT_EINVALIDREFNAME = -15,
//
//      /** The specified reference has its data corrupted */
//      GIT_EREFCORRUPTED  = -16,
//
//      /** The specified symbolic reference is too deeply nested */
//      GIT_ETOONESTEDSYMREF = -17,
//
//      /** The pack-refs file is either corrupted or its format is not currently supported */
//      GIT_EPACKEDREFSCORRUPTED = -18,
//
//      /** The path is invalid */
//      GIT_EINVALIDPATH = -19,
//
//      /** The revision walker is empty; there are no more commits left to iterate */
//      GIT_EREVWALKOVER = -20,
//
//      /** The state of the reference is not valid */
//      GIT_EINVALIDREFSTATE = -21,
//
//      /** This feature has not been implemented yet */
//      GIT_ENOTIMPLEMENTED = -22,
//
//      /** A reference with this name already exists */
//      GIT_EEXISTS = -23,
//
//      /** The given integer literal is too large to be parsed */
//      GIT_EOVERFLOW = -24,
//
//      /** The given literal is not a valid number */
//      GIT_ENOTNUM = -25,
//
//      /** Streaming error */
//      GIT_ESTREAM = -26,
//
//      /** invalid arguments to function */
//      GIT_EINVALIDARGS = -27,
//
//      /** The specified object has its data corrupted */
//      GIT_EOBJCORRUPTED = -28,
//
//      /** The given short oid is ambiguous */
//      GIT_EAMBIGUOUSOIDPREFIX = -29,
//
//      /** Skip and passthrough the given ODB backend */
//      GIT_EPASSTHROUGH = -30,
//   } git_error;
   GIT_SUCCESS                = 0;
   GIT_ERROR                  = -1;
   GIT_ENOTOID                = -2;
   GIT_ENOTFOUND              = -3;
   GIT_ENOMEM                 = -4;
   GIT_EOSERR                 = -5;
   GIT_EOBJTYPE               = -6;
   GIT_ENOTAREPO              = -7;
   GIT_EINVALIDTYPE           = -8;
   GIT_EMISSINGOBJDATA        = -9;
   GIT_EPACKCORRUPTED         = -10;
   GIT_EFLOCKFAIL             = -11;
   GIT_EZLIB                  = -12;
   GIT_EBUSY                  = -13;
   GIT_EBAREINDEX             = -14;
   GIT_EINVALIDREFNAME        = -15;
   GIT_EREFCORRUPTED          = -16;
   GIT_ETOONESTEDSYMREF       = -17;
   GIT_EPACKEDREFSCORRUPTED   = -18;
   GIT_EINVALIDPATH           = -19;
   GIT_EREVWALKOVER           = -20;
   GIT_EINVALIDREFSTATE       = -21;
   GIT_ENOTIMPLEMENTED        = -22;
   GIT_EEXISTS                = -23;
   GIT_EOVERFLOW              = -24;
   GIT_ENOTNUM                = -25;
   GIT_ESTREAM                = -26;
   GIT_EINVALIDARGS           = -27;
   GIT_EOBJCORRUPTED          = -28;
   GIT_EAMBIGUOUSOIDPREFIX    = -29;
   GIT_EPASSTHROUGH           = -30;


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

//   /** Basic type of any Git reference. */
//   typedef enum {
//      GIT_REF_INVALID = 0, /** Invalid reference */
//      GIT_REF_OID = 1, /** A reference which points at an object id */
//      GIT_REF_SYMBOLIC = 2, /** A reference which points at another reference */
//      GIT_REF_PACKED = 4,
//      GIT_REF_HAS_PEEL = 8,
//      GIT_REF_LISTALL = GIT_REF_OID|GIT_REF_SYMBOLIC|GIT_REF_PACKED,
//   } git_rtype

   GIT_REF_INVALID   = 0;
   GIT_REF_OID       = 1;
   GIT_REF_SYMBOLIC  = 2;
   GIT_REF_PACKED    = 4;
   GIT_REF_HAS_PEEL  = 8;
   GIT_REF_LISTALL   = GIT_REF_OID or GIT_REF_SYMBOLIC or GIT_REF_PACKED;

//      typedef enum {
//      GIT_STREAM_RDONLY = (1 << 1),
//      GIT_STREAM_WRONLY = (1 << 2),
//      GIT_STREAM_RW = (GIT_STREAM_RDONLY | GIT_STREAM_WRONLY),
//   } git_odb_streammode;

   GIT_STREAM_RDONLY = (1 shl 1);
   GIT_STREAM_WRONLY = (1 shl 2);
   GIT_STREAM_RW     = (GIT_STREAM_RDONLY or GIT_STREAM_WRONLY);

//   #define GIT_IDXENTRY_UPDATE            (1 << 0)
//   #define GIT_IDXENTRY_REMOVE            (1 << 1)
//   #define GIT_IDXENTRY_UPTODATE          (1 << 2)
//   #define GIT_IDXENTRY_ADDED             (1 << 3)
//
//   #define GIT_IDXENTRY_HASHED            (1 << 4)
//   #define GIT_IDXENTRY_UNHASHED          (1 << 5)
//   #define GIT_IDXENTRY_WT_REMOVE         (1 << 6) /* remove in work directory */
//   #define GIT_IDXENTRY_CONFLICTED        (1 << 7)
//
//   #define GIT_IDXENTRY_UNPACKED          (1 << 8)
//   #define GIT_IDXENTRY_NEW_SKIP_WORKTREE (1 << 9)
//
//   /*
//    * Extended on-disk flags:
//    */
//   #define GIT_IDXENTRY_INTENT_TO_ADD     (1 << 13)
//   #define GIT_IDXENTRY_SKIP_WORKTREE     (1 << 14)
//   /* GIT_IDXENTRY_EXTENDED2 is for future extension */
//   #define GIT_IDXENTRY_EXTENDED2         (1 << 15)
//
//   #define GIT_IDXENTRY_EXTENDED_FLAGS (GIT_IDXENTRY_INTENT_TO_ADD | GIT_IDXENTRY_SKIP_WORKTREE)
   GIT_IDXENTRY_UPDATE              = (1 shl 0);
   GIT_IDXENTRY_REMOVE              = (1 shl 1);
   GIT_IDXENTRY_UPTODATE            = (1 shl 2);
   GIT_IDXENTRY_ADDED               = (1 shl 3);

   GIT_IDXENTRY_HASHED              = (1 shl 4);
   GIT_IDXENTRY_UNHASHED            = (1 shl 5);
   GIT_IDXENTRY_WT_REMOVE           = (1 shl 6); //* remove in work directory */
   GIT_IDXENTRY_CONFLICTED          = (1 shl 7);

   GIT_IDXENTRY_UNPACKED            = (1 shl 8);
   GIT_IDXENTRY_NEW_SKIP_WORKTREE   = (1 shl 9);

// * Extended on-disk flags:
   GIT_IDXENTRY_INTENT_TO_ADD       = (1 shl 13);
   GIT_IDXENTRY_SKIP_WORKTREE       = (1 shl 14);
//* GIT_IDXENTRY_EXTENDED2 is for future extension */
   GIT_IDXENTRY_EXTENDED2           = (1 shl 15);

   GIT_IDXENTRY_EXTENDED_FLAGS      = (GIT_IDXENTRY_INTENT_TO_ADD or GIT_IDXENTRY_SKIP_WORKTREE);

   GIT_HEAD_FILE:       PAnsiChar = 'HEAD';
   GIT_MERGE_HEAD_FILE: PAnsiChar = 'MERGE_HEAD';
   GIT_DIR:             PAnsiChar = '.git/';
   GIT_INDEX_FILE:      PAnsiChar = 'index';
   GIT_OBJECTS_DIR:     PAnsiChar = 'objects/';
   GIT_REFS_HEADS_DIR:  PAnsiChar = 'heads/';
   GIT_PACKEDREFS_FILE: PAnsiChar = 'packed-refs';
   GIT_REFS_TAGS_DIR:   PAnsiChar = 'refs/tags/';

type
   size_t   = LongWord;
   time_t   = Int64;
   off_t = Int64;
   git_off_t = Int64;  //  typedef __int64 git_off_t;
   git_time_t = Int64; //  typedef __time64_t git_time_t;

   git_otype            = Integer; // enum as constants above
   git_rtype            = Integer;
   git_odb_streammode   = Integer;

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
   Pgit_oid = ^git_oid;
   PPgit_oid = ^Pgit_oid;
   Pgit_odb = ^git_odb;
   PPgit_odb = ^Pgit_odb;
   Pgit_commit = ^git_commit;
   PPgit_commit = ^Pgit_commit;
   Pgit_index = ^git_index;
   Pgit_hashtable = ^git_hashtable;
   Pgit_hashtable_node = ^git_hashtable_node;
   Pgit_map = ^git_map;
   PPgit_index_entry = ^Pgit_index_entry;
   Pgit_index_entry = ^git_index_entry;
   Pgit_index_tree = ^git_index_tree;
   PPgit_index_tree = ^Pgit_index_tree;
   Pgit_signature = ^git_signature;
   Pgit_object = ^git_object;
   Pgit_tree = ^git_tree;
   PPgit_tree_entry = ^Pgit_tree_entry;
   Pgit_tag = ^git_tag;
   Pgit_blob = ^git_blob;
   Pgit_odb_backend = ^git_odb_backend;
   Pgit_reference = ^git_reference;
   Pgit_strarray = ^git_strarray;
   Pgit_index_entry_unmerged = ^git_index_entry_unmerged;

   // structs not translated because they should be internal details,
   // and not necessary from GitForDelphi
   Pgit_repository   = Pointer;
   Pgit_tree_entry   = Pointer;
   Pgit_rawobj       = Pointer;
   Pgit_odb_object   = Pointer;
   Pgit_odb_stream   = Pointer;
   Pgit_revwalk      = Pointer;
   Pgit_treebuilder  = Pointer;
   Pgit_config       = Pointer;
   Pgit_config_file  = Pointer;

//   typedef int (*git_vector_cmp)(const void *, const void *);
   git_vector_cmp = Pointer;

   // int (*callback)(const char *, void *)
   git_reference_foreach_callback = function (const name: PAnsiChar; payload: PByte): Integer; cdecl;
   Pgit_reference_foreach_callback = ^git_reference_foreach_callback;

//   typedef struct git_vector {
//      unsigned int _alloc_size;
//      git_vector_cmp _cmp;
//      void **contents;
//      unsigned int length;
//      int sorted
//   } git_vector;
   git_vector = record
      _alloc_size:                                       UInt;
      _cmp:                                              git_vector_cmp;
      contents:                                          PPByte;
      length:                                            UInt;
      sorted:                                            Integer;
   end;

//   struct git_odb_backend {
//      git_odb *odb;
//
//      int (* read)(
//            void **, size_t *, git_otype *,
//            struct git_odb_backend *,
//            const git_oid *);
//
//      /* To find a unique object given a prefix
//       * of its oid.
//       * The oid given must be so that the
//       * remaining (GIT_OID_HEXSZ - len)*4 bits
//       * are 0s.
//       */
//      int (* read_prefix)(
//            git_oid *,
//            void **, size_t *, git_otype *,
//            struct git_odb_backend *,
//            const git_oid *,
//            unsigned int);
//
//      int (* read_header)(
//            size_t *, git_otype *,
//            struct git_odb_backend *,
//            const git_oid *);
//
//      int (* write)(
//            git_oid *,
//            struct git_odb_backend *,
//            const void *,
//            size_t,
//            git_otype);
//
//      int (* writestream)(
//            struct git_odb_stream **,
//            struct git_odb_backend *,
//            size_t,
//            git_otype);
//
//      int (* readstream)(
//            struct git_odb_stream **,
//            struct git_odb_backend *,
//            const git_oid *);
//
//      int (* exists)(
//            struct git_odb_backend *,
//            const git_oid *);
//
//      void (* free)(struct git_odb_backend *);
//   };
   git_odb_backend_read          = function (var buffer_p: PByte; var len_p: size_t; var type_p: git_otype; backend: Pgit_odb_backend; const oid: Pgit_oid ): Integer; cdecl;
   git_odb_backend_read_prefix   = function (id: Pgit_oid; var buffer_p: PByte; var len_p: size_t; var type_p: git_otype; backend: Pgit_odb_backend; const short_oid: Pgit_oid; len: UInt): Integer; cdecl;
   git_odb_backend_read_header   = function (var len_p: size_t; var type_p: git_otype; backend: Pgit_odb_backend; const oid: Pgit_oid ): Integer; cdecl;
   git_odb_backend_write         = function (id: Pgit_oid; backend: Pgit_odb_backend; const data: PByte; len: size_t; type_: git_otype): Integer; cdecl;
   git_odb_backend_writestream   = function (var stream_out: Pgit_odb_stream; backend: Pgit_odb_backend; length: size_t; type_: git_otype): Integer; cdecl;
   git_odb_backend_readstream    = function (var stream_out: Pgit_odb_stream; backend: Pgit_odb_backend; const oid: Pgit_oid): Integer; cdecl;
   git_odb_backend_exists        = function (backend: Pgit_odb_backend; const oid: Pgit_oid): Integer; cdecl;
   git_odb_backend_free          = procedure (backend: Pgit_odb_backend); cdecl;

   git_odb_backend = record
      odb:                                               Pgit_odb;

      read:                                              ^git_odb_backend_read;
      read_prefix:                                       ^git_odb_backend_read_prefix;
      read_header:                                       ^git_odb_backend_read_header;
      write:                                             ^git_odb_backend_write;
      writestream:                                       ^git_odb_backend_writestream;
      readstream:                                        ^git_odb_backend_readstream;
      exists:                                            ^git_odb_backend_exists;
      free:                                              ^git_odb_backend_free;
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

//   typedef struct {
//      git_time_t seconds;
//      /* nsec should not be stored as time_t compatible */
//      unsigned int nanoseconds;
//   } git_index_time;
   git_index_time = record
      seconds:                                           git_time_t;
      nanoseconds:                                       UInt;
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
//      git_off_t file_size;
//
//      git_oid oid;
//
//      unsigned short flags;
//      unsigned short flags_extended;
//
//      const char *path;
//   } git_index_entry;
   git_index_entry = record
      ctime:                                             git_index_time;
      mtime:                                             git_index_time;

      dev:                                               UInt;
      ino:                                               UInt;
      mode:                                              UInt;
      uid:                                               UInt;
      gid:                                               UInt;
      file_size:                                         git_off_t;

      oid:                                               git_oid;

      flags:                                             SHORT;
      flags_extended:                                    SHORT;

      path:                                              PAnsiChar;
   end;

//   typedef struct git_index_entry_unmerged {
//      unsigned int mode[3];
//      git_oid oid[3];
//      const char *path;
//   } git_index_entry_unmerged;
   git_index_entry_unmerged = record
      mode:                                              array [0..2] of UInt;
      oid:                                               array [0..2] of git_oid;
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
//      unsigned int on_disk:1;
//      git_index_tree *tree;
//
//      git_vector unmerged;
//   };
   git_index = record
      repository:                                        Pgit_repository;
      index_file_path:                                   PAnsiChar;

      last_modified:                                     time_t;
      entries:                                           git_vector;

      on_disk:                                           UInt;
      tree:                                              Pgit_index_tree;

      unmerged:                                          git_vector;
   end;

//   struct git_hashtable_node {
//      const void *key;
//      void *value;
//   };
   git_hashtable_node = record
      key:                                               PByte;
      value:                                             PByte;
   end;

//   struct git_hashtable {
//      struct git_hashtable_node *nodes;
//
//      size_t size_mask;
//      size_t size;
//      size_t key_count;
//
//      int is_resizing;
//
//      git_hash_ptr hash;
//      git_hash_keyeq_ptr key_equal;
//   };
   git_hashtable = record
      nodes:                                             Pgit_hashtable_node;

      size_mask:                                         size_t;
      count:                                             size_t;
      max_count:                                         size_t;

      is_resizing:                                       Integer;

      hash:        Pointer;
      key_equal:   Pointer;
   end;

//   typedef struct {
//      git_hashtable *cache;
//      git_hashtable *loose_cache;
//   } git_refcache;
   git_refcache = record
      cache:                                             Pgit_hashtable;
      loose_cache:                                       Pgit_hashtable;
   end;

//   typedef struct {
//      volatile int val;
//   } git_atomic;
   git_atomic = record
      val:                                               Integer;
   end;

//   typedef struct {
//      git_oid oid;
//      git_atomic refcount;
//   } git_cached_obj;
   git_cached_obj = record
      oid:                                               git_oid;
      refcount:                                          git_atomic;
   end;

//   struct git_object {
//      git_cached_obj cached;
//      git_repository *repo;
//      git_otype type;
//   };
   git_object = record
      cached:                                            git_cached_obj;
      repo:                                              Pgit_repository;
      type_:                                             git_otype;
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
//      git_vector parent_oids;
//      git_oid tree_oid;
//
//      git_signature *author;
//      git_signature *committer;
//
//      char *message;
//      char *message_short;
//   };
   git_commit = record
      object_:                                           git_object;

      parent_oids:                                       git_vector;
      tree_oid:                                          git_oid;

      author:                                            Pgit_signature;
      committer:                                         Pgit_signature;

      message_:                                          PAnsiChar;
      message_short:                                     PAnsiChar;
   end;

//   /** Time in a signature */
//   typedef struct git_time {
//      time_t time; /** time in seconds from epoch */
//      int offset; /** timezone offset, in minutes */
//   } git_time;
   git_time = record
      time:                                              time_t;
      offset:                                            Integer;
   end;

//   /** An action signature (e.g. for committers, taggers, etc) */
//   typedef struct git_signature {
//      char *name; /** full name of the author */
//      char *email; /** email of the author */
//      git_time when; /** time when the action happened */
//   } git_signature;
   git_signature = record
      name:                                              PAnsiChar;
      email:                                             PAnsiChar;
      when:                                              git_time;
   end;

//   struct git_tag {
//      git_object object;
//
//      git_oid target;
//      git_otype type;
//
//      char *tag_name;
//      git_signature *tagger;
//      char *message;
//   };
   git_tag = record
      object_:                                           git_object;

      target:                                            git_oid;
      type_:                                             git_otype;

      tag_name:                                          PAnsiChar;
      tagger:                                            Pgit_signature;
      message_:                                          PAnsiChar;
   end;

//   typedef struct {  /* file io buffer  */
//      void *data;  /* data bytes   */
//      size_t len;  /* data length  */
//   } gitfo_buf;
   gitfo_buf = record
      data:                                              PByte;
      len:                                               size_t;
   end;

//   struct git_blob {
//      git_object object;
//      gitfo_buf content;
//   };
   git_blob = record
      object_:                                           git_object;
      content:                                           gitfo_buf;
   end;

//   struct git_reference {
//      git_repository *owner;
//      char *name;
//      unsigned int type;
//   };
   git_reference = record
      owner:                                             Pgit_repository;
      name:                                              PAnsiChar;
      type_:                                             UInt;
   end;

//   typedef struct {
//      char **strings;
//      size_t count;
//   } git_strarray;
   git_strarray = record
      strings:                                           PPAnsiChar;
      count:                                             size_t;
   end;

   Pgit_treebuilder_filter_filter = ^git_treebuilder_filter_filter;
   git_treebuilder_filter_filter = function (const entry: Pgit_tree_entry; payload: PByte): Integer; cdecl;

   Pgit_config_file_foreach_callback = ^git_config_file_foreach_callback;
   git_config_file_foreach_callback = function (const key: PAnsiChar; data: PByte): Integer; cdecl;

   Pgit_config_file_open = ^git_config_file_open;
   Pgit_config_file_get = ^git_config_file_get;
   Pgit_config_file_set = ^git_config_file_set;
   Pgit_config_file_foreach = ^git_config_file_foreach;
   Pgit_config_file_free = ^git_config_file_free;

   git_config_file_open    = function (f: Pgit_config_file): Integer; cdecl;
   git_config_file_get     = function (f: Pgit_config_file; const key: PAnsiChar; out value: PAnsiChar): Integer; cdecl;
   git_config_file_set     = function (f: Pgit_config_file; const key, value: PAnsiChar): Integer; cdecl;
   git_config_file_foreach = function (f: Pgit_config_file; fn: Pgit_config_file_foreach_callback; data: PByte): Integer; cdecl;
   git_config_file_free    = function (f: Pgit_config_file): Integer; cdecl;

//   struct git_config_file {
//      struct git_config *cfg;
//
//      /* Open means open the file/database and parse if necessary */
//      int (*open)(struct git_config_file *);
//      int (*get)(struct git_config_file *, const char *key, const char **value);
//      int (*set)(struct git_config_file *, const char *key, const char *value);
//      int (*foreach)(struct git_config_file *, int (*fn)(const char *, void *), void *data);
//      void (*free)(struct git_config_file *);
//   };
   git_config_file = record
      cfg:                                               Pgit_config;

      open:                                              Pgit_config_file_open;
      get:                                               Pgit_config_file_get;
      set_:                                              Pgit_config_file_set;
      foreach:                                           Pgit_config_file_foreach;
      free:                                              Pgit_config_file_free;
   end;

   Pgit_config_foreach_callback = ^git_config_foreach_callback;
   git_config_foreach_callback = function (const key: PAnsiChar; data: PByte): Integer; cdecl;

//   typedef enum {
//      GIT_REPO_PATH,
//      GIT_REPO_PATH_INDEX,
//      GIT_REPO_PATH_ODB,
//      GIT_REPO_PATH_WORKDIR
//   } git_repository_pathid;
const
   GIT_REPO_PATH           = 0;
   GIT_REPO_PATH_INDEX     = 1;
   GIT_REPO_PATH_ODB       = 2;
   GIT_REPO_PATH_WORKDIR   = 3;
type
   git_repository_pathid = Integer;


var
   // GIT_EXTERN(void) git_libgit2_version(int *major, int *minor, int *rev);
   git_libgit2_version:                procedure (out major, minor, rev: Integer) cdecl;

   // GIT_EXTERN(const void *) git_blob_rawcontent(git_blob *blob);
   git_blob_rawcontent:                function (blob: Pgit_blob): PByte cdecl;
   // GIT_EXTERN(int) git_blob_rawsize(git_blob *blob);
   git_blob_rawsize:                   function (blob: Pgit_blob): Integer cdecl;
   // GIT_EXTERN(int) git_blob_create_fromfile(git_oid *oid, git_repository *repo, const char *path);
   git_blob_create_fromfile:           function (oid: Pgit_oid; repo: Pgit_repository; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_blob_create_frombuffer(git_oid *oid, git_repository *repo, const void *buffer, size_t len);
   git_blob_create_frombuffer:         function (oid: Pgit_oid; repo: Pgit_repository; const buffer: PByte; len: size_t): Integer cdecl;

   // GIT_EXTERN(const git_oid *) git_commit_id(git_commit *commit);
   git_commit_id:                      function (commit: Pgit_commit): Pgit_oid cdecl;
   // GIT_EXTERN(const char *) git_commit_message_short(git_commit *commit);
   git_commit_message_short:           function (commit: Pgit_commit): PAnsiChar cdecl;
   // GIT_EXTERN(const char *) git_commit_message(git_commit *commit);
   git_commit_message:                 function (commit: Pgit_commit): PAnsiChar cdecl;
   // GIT_EXTERN(const git_signature *) git_commit_author(git_commit *commit);
   git_commit_author:                  function (commit: Pgit_commit): Pgit_signature cdecl;
   // GIT_EXTERN(const git_signature *) git_commit_committer(git_commit *commit);
   git_commit_committer:               function (commit: Pgit_commit): Pgit_signature cdecl;
   // GIT_EXTERN(git_time_t) git_commit_time(git_commit *commit);
   git_commit_time:                    function (commit: Pgit_commit): git_time_t cdecl;
   // GIT_EXTERN(unsigned int) git_commit_parentcount(git_commit *commit);
   git_commit_parentcount:             function (commit: Pgit_commit): UInt cdecl;
   // GIT_EXTERN(int) git_commit_parent(git_commit **parent, git_commit *commit, unsigned int n);
   git_commit_parent:                  function (var parent: Pgit_commit; commit: Pgit_commit; n: UInt): Integer cdecl;
   // GIT_EXTERN(const git_oid *) git_commit_parent_oid(git_commit *commit, unsigned int n);
   git_commit_parent_oid:              function (commit: Pgit_commit; n: UInt): Pgit_oid cdecl;
   // GIT_EXTERN(int) git_commit_time_offset(git_commit *commit);
   git_commit_time_offset:             function (commit: Pgit_commit): Integer cdecl;
   // GIT_EXTERN(int) git_commit_tree(git_tree **tree_out, git_commit *commit);
   git_commit_tree:                    function (var tree_out: Pgit_tree; commit: Pgit_commit): Integer cdecl;
   // GIT_EXTERN(const git_oid *) git_commit_tree_oid(git_commit *commit);
   git_commit_tree_oid:                function (commit: Pgit_commit): Pgit_oid cdecl;
   // GIT_EXTERN(int) git_commit_create(git_oid *oid, git_repository *repo, const char *update_ref, const git_signature *author, const git_signature *committer, const char *message, const git_oid *tree_oid, int parent_count, const git_oid *parent_oids[]);
   git_commit_create:                  function (oid: Pgit_oid; repo: Pgit_repository; const update_ref: PAnsiChar; const author, committer: Pgit_signature; const message_: PAnsiChar; const tree_oid: Pgit_oid; parent_count: Integer; const parent_oids: PPgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_commit_create_o(git_oid *oid, git_repository *repo, const char *update_ref, const git_signature *author, const git_signature *committer, const char *message, const git_tree *tree, int parent_count, const git_commit *parents[]);
   git_commit_create_o:                function (oid: Pgit_oid; repo: Pgit_repository; const update_ref: PAnsiChar; const author, committer: Pgit_signature; const message_: PAnsiChar; const tree: Pgit_tree; parent_count: Integer; const parents: PPgit_commit): Integer cdecl;

   // GIT_EXTERN(int) git_commit_create_v(git_oid *oid, git_repository *repo, const char *update_ref, const git_signature *author, const git_signature *committer, const char *message, const git_oid *tree_oid, int parent_count, ...);
   git_commit_create_v:                function (oid: Pgit_oid; repo: Pgit_repository; const update_ref: PAnsiChar; const author, committer: Pgit_signature; const message_: PAnsiChar; const tree_oid: Pgit_oid; parent_count: Integer): Integer cdecl varargs;
   // GIT_EXTERN(int) git_commit_create_ov(git_oid *oid, git_repository *repo, const char *update_ref, const git_signature *author, const git_signature *committer, const char *message, const git_tree *tree, int parent_count, ...);
   git_commit_create_ov:               function (oid: Pgit_oid; repo: Pgit_repository; const update_ref: PAnsiChar; const author, committer: Pgit_signature; const message_: PAnsiChar; const tree: Pgit_tree; parent_count: Integer): Integer cdecl varargs;

   // GIT_EXTERN(int) git_config_find_global(char *global_config_path);
   git_config_find_global:             function (global_config_path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_config_open_global(git_config **out);
   git_config_open_global:             function (var out_: Pgit_config): Integer cdecl;
   // GIT_EXTERN(int) git_config_file__ondisk(struct git_config_file **out, const char *path);
   git_config_file__ondisk:            function (var out_: Pgit_config_file; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_config_new(git_config **out);
   git_config_new:                     function (var out_: Pgit_config): Integer cdecl;
   // GIT_EXTERN(int) git_config_add_file(git_config *cfg, git_config_file *file, int priority);
   git_config_add_file:                function (cfg: Pgit_config; file_: Pgit_config_file; priority: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_config_add_file_ondisk(git_config *cfg, const char *path, int priority);
   git_config_add_file_ondisk:         function (cfg: Pgit_config; const path: PAnsiChar; priority: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_config_open_ondisk(git_config **cfg, const char *path);
   git_config_open_ondisk:             function (out cfg: Pgit_config; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(void) git_config_free(git_config *cfg);
   git_config_free:                    procedure (cfg: Pgit_config) cdecl;
   // GIT_EXTERN(int) git_config_get_int(git_config *cfg, const char *name, int *out);
   git_config_get_int:                 function (cfg: Pgit_config; const name: PAnsiChar; var out_: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_config_get_long(git_config *cfg, const char *name, long int *out);
   git_config_get_long:                function (cfg: Pgit_config; const name: PAnsiChar; var out_: LongInt): Integer cdecl;
   // GIT_EXTERN(int) git_config_get_bool(git_config *cfg, const char *name, int *out);
   git_config_get_bool:                function (cfg: Pgit_config; const name: PAnsiChar; var out_: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_config_get_string(git_config *cfg, const char *name, const char **out);
   git_config_get_string:              function (cfg: Pgit_config; const name: PAnsiChar; var out_: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_config_set_int(git_config *cfg, const char *name, int value);
   git_config_set_int:                 function (cfg: Pgit_config; const name: PAnsiChar; value: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_config_set_long(git_config *cfg, const char *name, long int value);
   git_config_set_long:                function (cfg: Pgit_config; const name: PAnsiChar; value: LongInt): Integer cdecl;
   // GIT_EXTERN(int) git_config_set_bool(git_config *cfg, const char *name, int value);
   git_config_set_bool:                function (cfg: Pgit_config; const name: PAnsiChar; value: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_config_set_string(git_config *cfg, const char *name, const char *value);
   git_config_set_string:              function (cfg: Pgit_config; const name: PAnsiChar; const value: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_config_foreach(git_config *cfg, int (*callback)(const char *, void *data), void *data);
   git_config_foreach:                 function (cfg: Pgit_config; callback: Pgit_config_foreach_callback; data: PByte): Integer cdecl;

   // GIT_EXTERN(int) git_index_open(git_index **index, const char *index_path);
   git_index_open:                     function (var index: Pgit_index; const index_path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_index_read(git_index *index);
   git_index_read:                     function (index: Pgit_index): Integer cdecl;
   // GIT_EXTERN(void) git_index_free(git_index *index);
   git_index_free:                     procedure (index: Pgit_index) cdecl;
   // GIT_EXTERN(int) git_index_find(git_index *index, const char *path);
   git_index_find:                     function (index: Pgit_index; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(unsigned int) git_index_entrycount(git_index *index);
   git_index_entrycount:               function (index: Pgit_index): UInt cdecl;
   // GIT_EXTERN(void) git_index_clear(git_index *index);
   git_index_clear:                    procedure (index: Pgit_index) cdecl;
   // GIT_EXTERN(int) git_index_write(git_index *index);
   git_index_write:                    function (index: Pgit_index): Integer cdecl;
   // GIT_EXTERN(int) git_index_add(git_index *index, const char *path, int stage);
   git_index_add:                      function (index: Pgit_index; const path: PAnsiChar; stage: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_index_add2(git_index *index, const git_index_entry *source_entry);
   git_index_add2:                     function (index: Pgit_index; const source_entry: Pgit_index_entry): Integer cdecl;
   // GIT_EXTERN(int) git_index_append(git_index *index, const char *path, int stage);
   git_index_append:                   function (index: Pgit_index; const path: PAnsiChar; stage: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_index_append2(git_index *index, const git_index_entry *source_entry);
   git_index_append2:                  function (index: Pgit_index; const source_entry: Pgit_index_entry): Integer cdecl;
   // GIT_EXTERN(int) git_index_remove(git_index *index, int position);
   git_index_remove:                   function (index: Pgit_index; position: Integer): Integer cdecl;
   // GIT_EXTERN(git_index_entry *) git_index_get(git_index *index, unsigned int n);
   git_index_get:                      function (index: Pgit_index; n: UInt): Pgit_index_entry cdecl;
   // GIT_EXTERN(unsigned int) git_index_entrycount_unmerged(git_index *index);
   git_index_entrycount_unmerged:      function (index: Pgit_index): UInt cdecl;
   // GIT_EXTERN(const git_index_entry_unmerged *) git_index_get_unmerged_bypath(git_index *index, const char *path);
   git_index_get_unmerged_bypath:      function (index: Pgit_index; const path: PAnsiChar): Pgit_index_entry_unmerged cdecl;
   // GIT_EXTERN(const git_index_entry_unmerged *) git_index_get_unmerged_byindex(git_index *index, unsigned int n);
   git_index_get_unmerged_byindex:     function (index: Pgit_index; n: UInt): Pgit_index_entry_unmerged cdecl;
   // GIT_EXTERN(int) git_index_entry_stage(const git_index_entry *entry);
   git_index_entry_stage:              function (const entry: Pgit_index_entry): Integer cdecl;

   // GIT_EXTERN(const git_oid *) git_object_id(const git_object *obj);
   git_object_id:                      function (obj: Pgit_object): Pgit_oid cdecl;
   // GIT_EXTERN(void) git_object_close(git_object *object);
   git_object_close:                   procedure (object_: Pgit_object) cdecl;
   // GIT_EXTERN(git_otype) git_object_type(const git_object *obj);
   git_object_type:                    function(obj: Pgit_object): git_otype cdecl;
   // GIT_EXTERN(git_repository *) git_object_owner(const git_object *obj);
   git_object_owner:                   function (obj: Pgit_object): Pgit_repository cdecl;
   // GIT_EXTERN(const char *) git_object_type2string(git_otype type);
   git_object_type2string:             function (type_: git_otype): PAnsiChar cdecl;
   // GIT_EXTERN(git_otype) git_object_string2type(const char *str);
   git_object_string2type:             function (const str: PAnsiChar): git_otype cdecl;
   // GIT_EXTERN(int) git_object_typeisloose(git_otype type);
   git_object_typeisloose:             function (type_: git_otype): Integer cdecl;
   // GIT_EXTERN(int) git_object_lookup(git_object **object, git_repository *repo, const git_oid *id, git_otype type);
   git_object_lookup:                  function (var object_: Pgit_object; repo: Pgit_repository; const id: Pgit_oid; type_: git_otype): Integer cdecl;
   // GIT_EXTERN(int) git_object_lookup_prefix(git_object **object_out, git_repository *repo, const git_oid *id, unsigned int len, git_otype type);
   git_object_lookup_prefix:           function (var object_out: Pgit_object; repo: Pgit_repository; const id: Pgit_oid; len: UInt; type_: git_otype): Integer cdecl;

   // GIT_EXTERN(int) git_odb_new(git_odb **out);
   git_odb_new:                        function (var out_: Pgit_odb): Integer cdecl;
   // GIT_EXTERN(int) git_odb_open(git_odb **out, const char *objects_dir);
   git_odb_open:                       function (var out_: Pgit_odb; const objects_dir: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_odb_add_backend(git_odb *odb, git_odb_backend *backend, int priority);
   git_odb_add_backend:                function (odb: Pgit_odb; backend: Pgit_odb_backend; priority: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_odb_add_alternate(git_odb *odb, git_odb_backend *backend, int priority);
   git_odb_add_alternate:              function (odb: Pgit_odb; backend: Pgit_odb_backend; priority: Integer): Integer cdecl;
   // GIT_EXTERN(void) git_odb_close(git_odb *db);
   git_odb_close:                      procedure (db: Pgit_odb) cdecl;
   // GIT_EXTERN(int) git_odb_read(git_odb_object **out, git_odb *db, const git_oid *id);
   git_odb_read:                       function (var out_: Pgit_odb_object; db: Pgit_odb; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_odb_read_prefix(git_odb_object **out, git_odb *db, const git_oid *short_id, unsigned int len);
   git_odb_read_prefix:                function (var out_: Pgit_odb_object; db: Pgit_odb; const short_id: Pgit_oid; len: UInt): Integer cdecl;
   // GIT_EXTERN(int) git_odb_read_header(size_t *len_p, git_otype *type_p, git_odb *db, const git_oid *id);
   git_odb_read_header:                function (var len_p: size_t; var type_p: git_otype; db: Pgit_odb; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_odb_exists(git_odb *db, const git_oid *id);
   git_odb_exists:                     function (db: Pgit_odb; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_odb_open_wstream(git_odb_stream **stream, git_odb *db, size_t size, git_otype type);
   git_odb_open_wstream:               function (var stream: Pgit_odb_stream; db: Pgit_odb; size: size_t; type_: git_otype): Integer cdecl;
   // GIT_EXTERN(int) git_odb_open_rstream(git_odb_stream **stream, git_odb *db, const git_oid *oid);
   git_odb_open_rstream:               function (var stream: Pgit_odb_stream; db: Pgit_odb; const oid: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_odb_write(git_oid *oid, git_odb *odb, const void *data, size_t len, git_otype type);
   git_odb_write:                      function (oid: Pgit_oid; odb: Pgit_odb; const data: PByte; len: size_t; type_: git_otype): Integer cdecl;
   // GIT_EXTERN(int) git_odb_hash(git_oid *id, const void *data, size_t len, git_otype type);
   git_odb_hash:                       function (id: Pgit_oid; const data: PByte; len: size_t; type_: git_otype): Integer cdecl;

   // GIT_EXTERN(int) git_odb_backend_pack(git_odb_backend **backend_out, const char *objects_dir);
   git_odb_backend_pack:               function (var backend_out: Pgit_odb_backend; const objects_dir: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_odb_backend_loose(git_odb_backend **backend_out, const char *objects_dir);
   git_odb_backend_loose:              function (var backend_out: Pgit_odb_backend; const objects_dir: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(void) git_odb_object_close(git_odb_object *object);
   git_odb_object_close:               procedure (object_: Pgit_odb_object) cdecl;
   // GIT_EXTERN(const void *) git_odb_object_data(git_odb_object *object);
   git_odb_object_data:                function (object_: Pgit_odb_object): PByte cdecl;
   // GIT_EXTERN(const git_oid *) git_odb_object_id(git_odb_object *object);
   git_odb_object_id:                  function (object_: Pgit_odb_object): Pgit_oid cdecl;
   // GIT_EXTERN(size_t) git_odb_object_size(git_odb_object *object);
   git_odb_object_size:                function (object_: Pgit_odb_object): size_t cdecl;
   // GIT_EXTERN(git_otype) git_odb_object_type(git_odb_object *object);
   git_odb_object_type:                function (object_: Pgit_odb_object): git_otype cdecl;

   // GIT_EXTERN(int) git_oid_fromstr(git_oid *out, const char *str);
   git_oid_fromstr:                    function (aOut: Pgit_oid; aStr: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(void) git_oid_fmt(char *str, const git_oid *oid);
   git_oid_fmt:                        procedure (aStr: PAnsiChar; const oid: Pgit_oid) cdecl;
   // GIT_EXTERN(void) git_oid_pathfmt(char *str, const git_oid *oid);
   git_oid_pathfmt:                    procedure (aStr: PAnsiChar; const oid: Pgit_oid) cdecl;
   // GIT_EXTERN(void) git_oid_fromraw(git_oid *out, const unsigned char *raw);
   git_oid_fromraw:                    procedure (out_: Pgit_oid; const raw: PByte) cdecl;
   // GIT_EXTERN(char *) git_oid_allocfmt(const git_oid *oid);
   git_oid_allocfmt:                   function (const oid: Pgit_oid): PAnsiChar cdecl;
   // GIT_EXTERN(char *) git_oid_to_string(char *out, size_t n, const git_oid *oid);
   git_oid_to_string:                  function (out_: PAnsiChar; n: size_t; const oid: Pgit_oid): PAnsiChar cdecl;
   // GIT_EXTERN(void) git_oid_cpy(git_oid *out, const git_oid *src);
   git_oid_cpy:                        procedure (out_: Pgit_oid; const src: Pgit_oid) cdecl;
   // GIT_EXTERN(int) git_oid_cmp(const git_oid *a, const git_oid *b);
   git_oid_cmp:                        function (const a, b: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_oid_ncmp(const git_oid *a, const git_oid *b, unsigned int len);
   git_oid_ncmp:                       function (const a, b: Pgit_oid; len: UInt): Integer cdecl;

   // GIT_EXTERN(int) git_repository_open(git_repository **repository, const char *path);
   git_repository_open:                function (var repo_out: Pgit_repository; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(void) git_repository_free(git_repository *repo);
   git_repository_free:                procedure (repo: Pgit_repository) cdecl;
   // GIT_EXTERN(int) git_repository_open2(git_repository **repository, const char *git_dir, const char *git_object_directory, const char *git_index_file, const char *git_work_tree);
   git_repository_open2:               function (var repository: Pgit_repository; const git_dir, git_object_directory, git_index_file, git_work_tree: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_repository_open3(git_repository **repository, const char *git_dir, git_odb *object_database, const char *git_index_file, const char *git_work_tree);
   git_repository_open3:               function (var repository: Pgit_repository; const git_dir: PAnsiChar; object_database: Pgit_odb; const git_index_file, git_work_tree: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_repository_is_empty(git_repository *repo);
   git_repository_is_empty:            function (repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(const char *) git_repository_path(git_repository *repo, git_repository_pathid id);
   git_repository_path:                function (repo: Pgit_repository; id: git_repository_pathid): PAnsiChar cdecl;
   // GIT_EXTERN(int) git_repository_discover(char *repository_path, size_t size, const char *start_path, int across_fs, const char *ceiling_dirs);
   git_repository_discover:            function (repository_path: PAnsiChar; size: size_t; const start_path: PAnsiChar; across_fs: Integer; const ceiling_dirs: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_repository_is_bare(git_repository *repo);
   git_repository_is_bare:             function (repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(int) git_repository_config(git_config **out, git_repository *repo, const char *user_config_path, const char *system_config_path);
   git_repository_config:              function (var out_: Pgit_config; repo: Pgit_repository; const user_config_path, system_config_path: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(git_odb *) git_repository_database(git_repository *repo);
   git_repository_database:            function (repo: Pgit_repository): Pgit_odb cdecl;
   // GIT_EXTERN(int) git_repository_index(git_index **index, git_repository *repo);
   git_repository_index:               function (var index: Pgit_index; repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(int) git_repository_init(git_repository **repo_out, const char *path, unsigned is_bare);
   git_repository_init:                function (var repo_out: Pgit_repository; const path: PAnsiChar; is_bare: UInt): Integer cdecl;

   // GIT_EXTERN(int) git_revwalk_new(git_revwalk **walker, git_repository *repo);
   git_revwalk_new:                    function (var walker: Pgit_revwalk; repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(void) git_revwalk_free(git_revwalk *walk);
   git_revwalk_free:                   procedure (walk: Pgit_revwalk) cdecl;
   // GIT_EXTERN(void) git_revwalk_sorting(git_revwalk *walk, unsigned int sort_mode);
   git_revwalk_sorting:                procedure (walk: Pgit_revwalk; sort_mode: UInt) cdecl;
   // GIT_EXTERN(int) git_revwalk_push(git_revwalk *walk, const git_oid *oid);
   git_revwalk_push:                   function (walk: Pgit_revwalk; const oid: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_revwalk_next(git_oid *oid, git_revwalk *walk);
   git_revwalk_next:                   function (oid: Pgit_oid; walk: Pgit_revwalk): Integer cdecl;
   // GIT_EXTERN(void) git_revwalk_reset(git_revwalk *walker);
   git_revwalk_reset:                  procedure (walker: Pgit_revwalk) cdecl;
   // GIT_EXTERN(int) git_revwalk_hide(git_revwalk *walk, const git_oid *oid);
   git_revwalk_hide:                   function (walk: Pgit_revwalk; const oid: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(git_repository *) git_revwalk_repository(git_revwalk *walk);
   git_revwalk_repository:             function (walk: Pgit_revwalk): Pgit_repository cdecl;

   // GIT_EXTERN(git_signature *) git_signature_new(const char *name, const char *email, git_time_t time, int offset);
   git_signature_new:                  function (const name, email: PAnsiChar; time: git_time_t; offset: Integer): Pgit_signature cdecl;
   // GIT_EXTERN(git_signature *) git_signature_now(const char *name, const char *email);
   git_signature_now:                  function (const name, email: PAnsiChar): Pgit_signature cdecl;
   // GIT_EXTERN(git_signature *) git_signature_dup(const git_signature *sig);
   git_signature_dup:                  function (const sig: Pgit_signature): Pgit_signature cdecl;
   // GIT_EXTERN(void) git_signature_free(git_signature *sig);
   git_signature_free:                 procedure (sig: Pgit_signature)cdecl;

   // GIT_EXTERN(int) git_tag_list(git_strarray *tag_names, git_repository *repo);
   git_tag_list:                       function (tag_names: Pgit_strarray; repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(const char *) git_tag_name(git_tag *tag);
   git_tag_name:                       function (tag: Pgit_tag): PAnsiChar cdecl;
   // GIT_EXTERN(git_otype) git_tag_type(git_tag *tag);
   git_tag_type:                       function (tag: Pgit_tag): git_otype cdecl;
   // GIT_EXTERN(int) git_tag_target(git_object **target, git_tag *tag);
   git_tag_target:                     function (var target: Pgit_object; tag: Pgit_tag): Integer cdecl;
   // GIT_EXTERN(const git_oid *) git_tag_target_oid(git_tag *tag);
   git_tag_target_oid:                 function (tag: Pgit_tag): Pgit_oid cdecl;
   // GIT_EXTERN(const git_oid *) git_tag_id(git_tag *tag);
   git_tag_id:                         function (tag: Pgit_tag): Pgit_oid cdecl;
   // GIT_EXTERN(const git_signature *) git_tag_tagger(git_tag *tag);
   git_tag_tagger:                     function (tag: Pgit_tag): Pgit_signature cdecl;
   // GIT_EXTERN(const char *) git_tag_message(git_tag *tag);
   git_tag_message:                    function (tag: Pgit_tag): PAnsiChar cdecl;
   // GIT_EXTERN(int) git_tag_create(git_oid *oid, git_repository *repo, const char *tag_name, const git_oid *target, git_otype target_type, const git_signature *tagger, const char *message);
   git_tag_create:                     function (oid: Pgit_oid; repo: Pgit_repository; const tag_name: PAnsiChar; const target: Pgit_oid; target_type: git_otype; const tagger: Pgit_signature; const message_: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_tag_create_o(git_oid *oid, git_repository *repo, const char *tag_name, const git_object *target, const git_signature *tagger, const char *message);
   git_tag_create_o:                   function (oid: Pgit_oid; repo: Pgit_repository; const tag_name: PAnsiChar; const target: Pgit_object; const tagger: Pgit_signature; const message_: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_tag_create_f(git_oid *oid, git_repository *repo, const char *tag_name, const git_oid *target, git_otype target_type, const git_signature *tagger, const char *message);
   git_tag_create_f:                   function (oid: Pgit_oid; repo: Pgit_repository; const tag_name: PAnsiChar; const target: Pgit_oid; target_type: git_otype; const tagger: Pgit_signature; const message_: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_tag_create_fo(git_oid *oid, git_repository *repo, const char *tag_name, const git_object *target, const git_signature *tagger, const char *message);
   git_tag_create_fo:                  function (oid: Pgit_oid; repo: Pgit_repository; const tag_name: PAnsiChar; const target: Pgit_object; const tagger: Pgit_signature; const message_: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_tag_create_frombuffer(git_oid *oid, git_repository *repo, const char *buffer);
   git_tag_create_frombuffer:          function (oid: Pgit_oid; repo: Pgit_repository; const buffer: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_tag_delete(git_repository *repo, const char *tag_name);
   git_tag_delete:                     function (repo: Pgit_repository; const tag_name: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(const git_tree_entry *) git_tree_entry_byname(git_tree *tree, const char *filename);
   git_tree_entry_byname:              function (tree: Pgit_tree; const filename: PAnsiChar): Pgit_tree_entry cdecl;
   // GIT_EXTERN(const git_tree_entry *) git_tree_entry_byindex(git_tree *tree, unsigned int idx);
   git_tree_entry_byindex:             function (tree: Pgit_tree; idx: UInt): Pgit_tree_entry cdecl;
   // GIT_EXTERN(unsigned int) git_tree_entrycount(git_tree *tree);
   git_tree_entrycount:                function (tree: Pgit_tree): UInt cdecl;
   // GIT_EXTERN(const char *) git_tree_entry_name(const git_tree_entry *entry);
   git_tree_entry_name:                function (const entry: Pgit_tree_entry): PAnsiChar cdecl;
   // GIT_EXTERN(int) git_tree_entry_2object(git_object **object_out, git_repository *repo, const git_tree_entry *entry);
   git_tree_entry_2object:             function (var object_out: Pgit_object; repo: Pgit_repository; const entry: Pgit_tree_entry): Integer cdecl;
   // GIT_EXTERN(const git_oid *) git_tree_id(git_tree *tree);
   git_tree_id:                        function (tree: Pgit_tree): Pgit_oid cdecl;
   // GIT_EXTERN(unsigned int) git_tree_entry_attributes(const git_tree_entry *entry);
   git_tree_entry_attributes:          function (const entry: Pgit_tree_entry): UInt cdecl;
   // GIT_EXTERN(const git_oid *) git_tree_entry_id(const git_tree_entry *entry);
   git_tree_entry_id:                  function (const entry: Pgit_tree_entry): Pgit_oid cdecl;
   // GIT_EXTERN(int) git_tree_create_fromindex(git_oid *oid, git_index *index);
   git_tree_create_fromindex:          function (oid: Pgit_oid; index: Pgit_index): Integer cdecl;
   // GIT_EXTERN(int) git_treebuilder_create(git_treebuilder **builder_p, const git_tree *source);
   git_treebuilder_create:             function (var builder_p: Pgit_treebuilder; const source: Pgit_tree): Integer cdecl;
   // GIT_EXTERN(void) git_treebuilder_clear(git_treebuilder *bld);
   git_treebuilder_clear:              procedure (bld: Pgit_treebuilder) cdecl;
   // GIT_EXTERN(void) git_treebuilder_free(git_treebuilder *bld);
   git_treebuilder_free:               procedure (bld: Pgit_treebuilder) cdecl;
   // GIT_EXTERN(const git_tree_entry *) git_treebuilder_get(git_treebuilder *bld, const char *filename);
   git_treebuilder_get:                function (bld: Pgit_treebuilder; const filename: PAnsiChar): Pgit_tree_entry cdecl;
   // GIT_EXTERN(int) git_treebuilder_insert(git_tree_entry **entry_out, git_treebuilder *bld, const char *filename, const git_oid *id, unsigned int attributes);
   git_treebuilder_insert:             function (var entry_out: Pgit_tree_entry; bld: Pgit_treebuilder; const filename: PAnsiChar; const id: Pgit_oid; attributes: UInt): Integer cdecl;
   // GIT_EXTERN(int) git_treebuilder_remove(git_treebuilder *bld, const char *filename);
   git_treebuilder_remove:             function (bld: Pgit_treebuilder; const filename: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(void) git_treebuilder_filter(git_treebuilder *bld, int (*filter)(const git_tree_entry *, void *), void *payload);
   git_treebuilder_filter:             procedure (bld: Pgit_treebuilder; filter: Pgit_treebuilder_filter_filter; payload: PByte) cdecl;
   // GIT_EXTERN(int) git_treebuilder_write(git_oid *oid, git_repository *repo, git_treebuilder *bld);
   git_treebuilder_write:              function (oid:Pgit_oid; repo: Pgit_repository; bld: Pgit_treebuilder): Integer cdecl;
   // GIT_EXTERN(git_otype) git_tree_entry_type(const git_tree_entry *entry);
   git_tree_entry_type:                function (const entry: Pgit_tree_entry): git_otype cdecl;

   // GIT_EXTERN(int) git_reference_create_oid(git_reference **ref_out, git_repository *repo, const char *name, const git_oid *id);
   git_reference_create_oid:           function (var ref_out: Pgit_reference; repo: Pgit_repository; const name: PAnsiChar; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_reference_create_oid_f(git_reference **ref_out, git_repository *repo, const char *name, const git_oid *id);
   git_reference_create_oid_f:         function (var ref_out: Pgit_reference; repo: Pgit_repository; const name: PAnsiChar; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(const git_oid *) git_reference_oid(git_reference *ref);
   git_reference_oid:                  function (ref: Pgit_reference): Pgit_oid cdecl;
   // GIT_EXTERN(const char *) git_reference_target(git_reference *ref);
   git_reference_target:               function (ref: Pgit_reference): PAnsiChar cdecl;
   // GIT_EXTERN(git_rtype) git_reference_type(git_reference *ref);
   git_reference_type:                 function (ref: Pgit_reference): git_rtype cdecl;
   // GIT_EXTERN(const char *) git_reference_name(git_reference *ref);
   git_reference_name:                 function (ref: Pgit_reference): PAnsiChar cdecl;
   // GIT_EXTERN(int) git_reference_resolve(git_reference **resolved_ref, git_reference *ref);
   git_reference_resolve:              function (var resolved_ref: Pgit_reference; ref: Pgit_reference): Integer cdecl;
   // GIT_EXTERN(git_repository *) git_reference_owner(git_reference *ref);
   git_reference_owner:                function (ref: Pgit_reference): Pgit_repository cdecl;
   // GIT_EXTERN(int) git_reference_rename(git_reference *ref, const char *new_name);
   git_reference_rename:               function (ref: Pgit_reference; const new_name: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_reference_rename_f(git_reference *ref, const char *new_name);
   git_reference_rename_f:             function (ref: Pgit_reference; const new_name: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_reference_set_target(git_reference *ref, const char *target);
   git_reference_set_target:           function (ref: Pgit_reference; const target: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_reference_set_oid(git_reference *ref, const git_oid *id);
   git_reference_set_oid:              function (ref: Pgit_reference; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_reference_listall(git_strarray *array, git_repository *repo, unsigned int list_flags);
   git_reference_listall:              function (array_: Pgit_strarray; repo: Pgit_repository; list_flags: UInt): Integer cdecl;
   // GIT_EXTERN(int) git_reference_foreach(git_repository *repo, unsigned int list_flags, int (*callback)(const char *, void *), void *payload);
   git_reference_foreach:              function (repo: Pgit_repository; list_flags: UInt; callback: Pgit_reference_foreach_callback; payload: PByte): Integer cdecl;
   // GIT_EXTERN(void) git_strarray_free(git_strarray *array);
   git_strarray_free:                  procedure (array_: Pgit_strarray) cdecl;

   // GIT_EXTERN(int) git_reference_lookup(git_reference **reference_out, git_repository *repo, const char *name);
   git_reference_lookup:               function (var reference_out: Pgit_reference; repo: Pgit_repository; const name: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_reference_create_symbolic(git_reference **ref_out, git_repository *repo, const char *name, const char *target);
   git_reference_create_symbolic:      function (var ref_out: Pgit_reference; repo: Pgit_repository; const name: PAnsiChar; const target: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_reference_create_symbolic_f(git_reference **ref_out, git_repository *repo, const char *name, const char *target);
   git_reference_create_symbolic_f:    function (var ref_out: Pgit_reference; repo: Pgit_repository; const name, target: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_reference_delete(git_reference *ref);
   git_reference_delete:               function (ref: Pgit_reference): Integer cdecl;
   // GIT_EXTERN(int) git_reference_packall(git_repository *repo);
   git_reference_packall:              function (repo: Pgit_repository): Integer cdecl;

   // GIT_EXTERN(size_t) git_object__size(git_otype type);
   git_object__size:                   function (type_: git_otype): size_t cdecl;

   // GIT_EXTERN(const char *) git_strerror(int num);
   git_strerror:                       function (num: Integer): PAnsiChar cdecl;
   // GIT_EXTERN(const char *) git_lasterror(void);
   git_lasterror:                      function: PAnsiChar cdecl;

// GIT_EXTERNs later inlined
function git_blob_lookup(var blob: Pgit_blob; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_commit_lookup(var commit: Pgit_commit; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_tag_lookup(var tag: Pgit_tag; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_tree_lookup(var tree: Pgit_tree; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;

// GIT_INLINEs
procedure git_commit_close(commit: Pgit_commit);
procedure git_tag_close(tag: Pgit_tag);
procedure git_tree_close(tree: Pgit_tree);

// Helpers
function time_t__to__TDateTime(t: time_t; const aAdjustMinutes: Integer = 0): TDateTime;
function git_commit_DateTime(commit: Pgit_commit): TDateTime;

implementation

var
  libgit2: THandle;

function git_blob_lookup(var blob: Pgit_blob; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_object_lookup((git_object **)blob, repo, id, GIT_OBJ_BLOB);
   Result := git_object_lookup(Pgit_object(blob), repo, id, GIT_OBJ_BLOB);
end;

function git_commit_lookup(var commit: Pgit_commit; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_object_lookup((git_object **)commit, repo, id, GIT_OBJ_COMMIT);
   Result := git_object_lookup(Pgit_object(commit), repo, id, GIT_OBJ_COMMIT);
end;

function git_tag_lookup(var tag: Pgit_tag; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_object_lookup((git_object **)tag, repo, id, GIT_OBJ_TAG);
   Result := git_object_lookup(Pgit_object(tag), repo, id, GIT_OBJ_TAG);
end;

function git_tree_lookup(var tree: Pgit_tree; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_object_lookup((git_object **)tree, repo, id, GIT_OBJ_TREE);
   Result := git_object_lookup(Pgit_object(tree), repo, id, GIT_OBJ_TREE);
end;

procedure git_commit_close(commit: Pgit_commit);
begin
   git_object_close(Pgit_object(commit));
end;

procedure git_tag_close(tag: Pgit_tag);
begin
   git_object_close(Pgit_object(tag));
end;

procedure git_tree_close(tree: Pgit_tree);
begin
   git_object_close(Pgit_object(tree));
end;

function time_t__to__TDateTime(t: time_t; const aAdjustMinutes: Integer = 0): TDateTime;
const
   UnixStartDate: TDateTime = 25569.0; // 01/01/1970
begin
   Result := (t / SecsPerDay) + UnixStartDate;                          //   Result := DateUtils.IncSecond(EncodeDate(1970,1,1), t);
   if aAdjustMinutes <> 0 then
      Result := ((Result * MinsPerDay) + aAdjustMinutes) / MinsPerDay;  //      Result := DateUtils.IncMinute(Result, aAdjustMinutes);
end;

function git_commit_DateTime(commit: Pgit_commit): TDateTime;
var
   t: time_t;
   time_offset: Integer;
begin
   t := git_commit_time(commit);
   time_offset := git_commit_time_offset(commit);

   Result := time_t__to__TDateTime(t, time_offset);
end;

function InitLibgit2: Boolean;
   function Bind(const aName: AnsiString; aAllowNotFound: Boolean = false): Pointer;
   begin
      Result := GetProcAddress(libgit2, PAnsiChar(aName));
      {$IFDEF DEBUG}
      if (Result = nil) and (not aAllowNotFound) then
         raise Exception.CreateFmt('Export [%s] not found', [aName]);
      {$ENDIF}
   end;
const
   OPTIONAL = true;
begin
  if libgit2 = 0 then
  begin
    if FileExists('git2-0.dll') then
       libgit2 := LoadLibrary('git2-0.dll')
    else
       libgit2 := LoadLibrary('git2.dll');
    if libgit2 > 0 then
    begin
      git_libgit2_version                       := Bind('git_libgit2_version');
      git_object__size                          := Bind('git_object__size');
      git_strerror                              := Bind('git_strerror');
      git_lasterror                             := Bind('git_lasterror');

      git_blob_rawcontent                       := Bind('git_blob_rawcontent');
      git_blob_rawsize                          := Bind('git_blob_rawsize');
      git_blob_create_fromfile                  := Bind('git_blob_create_fromfile');
      git_blob_create_frombuffer                := Bind('git_blob_create_frombuffer');

      git_commit_message_short                  := Bind('git_commit_message_short');
      git_commit_message                        := Bind('git_commit_message');
      git_commit_author                         := Bind('git_commit_author');
      git_commit_committer                      := Bind('git_commit_committer');
      git_commit_time                           := Bind('git_commit_time');
      git_commit_parentcount                    := Bind('git_commit_parentcount');
      git_commit_parent                         := Bind('git_commit_parent');
      git_commit_id                             := Bind('git_commit_id');
      git_commit_time_offset                    := Bind('git_commit_time_offset');
      git_commit_tree                           := Bind('git_commit_tree');
      git_commit_create                         := Bind('git_commit_create');
      git_commit_create_o                       := Bind('git_commit_create_o');
      git_commit_create_v                       := Bind('git_commit_create_ov');
      git_commit_create_ov                      := Bind('git_commit_create_ov');
      git_commit_parent_oid                     := Bind('git_commit_parent_oid');
      git_commit_tree_oid                       := Bind('git_commit_tree_oid');

      git_config_find_global                    := Bind('git_config_find_global');
      git_config_open_global                    := Bind('git_config_open_global');
      git_config_file__ondisk                   := Bind('git_config_file__ondisk');
      git_config_new                            := Bind('git_config_new');
      git_config_add_file                       := Bind('git_config_add_file');
      git_config_add_file_ondisk                := Bind('git_config_add_file_ondisk');
      git_config_open_ondisk                    := Bind('git_config_open_ondisk');
      git_config_free                           := Bind('git_config_free');
      git_config_get_int                        := Bind('git_config_get_int');
      git_config_get_long                       := Bind('git_config_get_long');
      git_config_get_bool                       := Bind('git_config_get_bool');
      git_config_get_string                     := Bind('git_config_get_string');
      git_config_set_int                        := Bind('git_config_set_int');
      git_config_set_long                       := Bind('git_config_set_long');
      git_config_set_bool                       := Bind('git_config_set_bool');
      git_config_set_string                     := Bind('git_config_set_string');
      git_config_foreach                        := Bind('git_config_foreach');

      git_index_open                            := Bind('git_index_open');
      git_index_read                            := Bind('git_index_read');
      git_index_free                            := Bind('git_index_free');
      git_index_find                            := Bind('git_index_find');
      git_index_entrycount                      := Bind('git_index_entrycount');
      git_index_add2                            := Bind('git_index_add2');
      git_index_append                          := Bind('git_index_append');
      git_index_append2                         := Bind('git_index_append2');
      git_index_clear                           := Bind('git_index_clear');
      git_index_write                           := Bind('git_index_write');
      git_index_add                             := Bind('git_index_add');
      git_index_remove                          := Bind('git_index_remove');
      git_index_get                             := Bind('git_index_get');
      git_index_entrycount_unmerged             := Bind('git_index_entrycount_unmerged');
      git_index_get_unmerged_bypath             := Bind('git_index_get_unmerged_bypath');
      git_index_get_unmerged_byindex            := Bind('git_index_get_unmerged_byindex');
      git_index_entry_stage                     := Bind('git_index_entry_stage');

      git_object_id                             := Bind('git_object_id');
      git_object_close                          := Bind('git_object_close');
      git_object_type                           := Bind('git_object_type');
      git_object_owner                          := Bind('git_object_owner');
      git_object_type2string                    := Bind('git_object_type2string');
      git_object_string2type                    := Bind('git_object_string2type');
      git_object_typeisloose                    := Bind('git_object_typeisloose');
      git_object_lookup                         := Bind('git_object_lookup');
      git_object_lookup_prefix                  := Bind('git_object_lookup_prefix');

      git_odb_new                               := Bind('git_odb_new');
      git_odb_open                              := Bind('git_odb_open');
      git_odb_open_wstream                      := Bind('git_odb_open_wstream');
      git_odb_open_rstream                      := Bind('git_odb_open_rstream');
      git_odb_write                             := Bind('git_odb_write');
      git_odb_add_backend                       := Bind('git_odb_add_backend');
      git_odb_add_alternate                     := Bind('git_odb_add_alternate');
      git_odb_close                             := Bind('git_odb_close');
      git_odb_read                              := Bind('git_odb_read');
      git_odb_read_prefix                       := Bind('git_odb_read_prefix');
      git_odb_read_header                       := Bind('git_odb_read_header');
      git_odb_exists                            := Bind('git_odb_exists');
      git_odb_hash                              := Bind('git_odb_hash');

      git_odb_backend_pack                      := Bind('git_odb_backend_pack');
      git_odb_backend_loose                     := Bind('git_odb_backend_loose');

      git_odb_object_close                      := Bind('git_odb_object_close');
      git_odb_object_data                       := Bind('git_odb_object_data');
      git_odb_object_id                         := Bind('git_odb_object_id');
      git_odb_object_size                       := Bind('git_odb_object_size');
      git_odb_object_type                       := Bind('git_odb_object_type');

      git_oid_fromstr                           := Bind('git_oid_fromstr');
      git_oid_fmt                               := Bind('git_oid_fmt');
      git_oid_pathfmt                           := Bind('git_oid_pathfmt');
      git_oid_fromraw                           := Bind('git_oid_fromraw');
      git_oid_allocfmt                          := Bind('git_oid_allocfmt');
      git_oid_to_string                         := Bind('git_oid_to_string');
      git_oid_cpy                               := Bind('git_oid_cpy');
      git_oid_cmp                               := Bind('git_oid_cmp');
      git_oid_ncmp                              := Bind('git_oid_ncmp');

      git_reference_create_oid                  := Bind('git_reference_create_oid');
      git_reference_oid                         := Bind('git_reference_oid');
      git_reference_target                      := Bind('git_reference_target');
      git_reference_type                        := Bind('git_reference_type');
      git_reference_name                        := Bind('git_reference_name');
      git_reference_resolve                     := Bind('git_reference_resolve');
      git_reference_owner                       := Bind('git_reference_owner');
      git_reference_rename                      := Bind('git_reference_rename');
      git_reference_set_target                  := Bind('git_reference_set_target');
      git_reference_set_oid                     := Bind('git_reference_set_oid');
      git_reference_lookup                      := Bind('git_reference_lookup');
      git_reference_create_symbolic             := Bind('git_reference_create_symbolic');
      git_reference_delete                      := Bind('git_reference_delete');
      git_reference_packall                     := Bind('git_reference_packall');
      git_reference_listall                     := Bind('git_reference_listall');
      git_reference_foreach                     := Bind('git_reference_foreach');
      git_strarray_free                         := Bind('git_strarray_free');
      git_reference_create_oid_f                := Bind('git_reference_create_oid_f');
      git_reference_rename_f                    := Bind('git_reference_rename_f');
      git_reference_create_symbolic_f           := Bind('git_reference_create_symbolic_f');

      git_repository_open                       := Bind('git_repository_open');
      git_repository_free                       := Bind('git_repository_free');
      git_repository_open2                      := Bind('git_repository_open2');
      git_repository_open3                      := Bind('git_repository_open3');
      git_repository_database                   := Bind('git_repository_database');
      git_repository_index                      := Bind('git_repository_index');
      git_repository_init                       := Bind('git_repository_init');
      git_repository_is_empty                   := Bind('git_repository_is_empty');
      git_repository_path                       := Bind('git_repository_path');
      git_repository_is_bare                    := Bind('git_repository_is_bare');
      git_repository_discover                   := Bind('git_repository_discover');
      git_repository_config                     := Bind('git_repository_config');

      git_revwalk_new                           := Bind('git_revwalk_new');
      git_revwalk_free                          := Bind('git_revwalk_free');
      git_revwalk_sorting                       := Bind('git_revwalk_sorting');
      git_revwalk_push                          := Bind('git_revwalk_push');
      git_revwalk_next                          := Bind('git_revwalk_next');
      git_revwalk_reset                         := Bind('git_revwalk_reset');
      git_revwalk_hide                          := Bind('git_revwalk_hide');
      git_revwalk_repository                    := Bind('git_revwalk_repository');

      git_signature_new                         := Bind('git_signature_new');
      git_signature_dup                         := Bind('git_signature_dup');
      git_signature_free                        := Bind('git_signature_free');
      git_signature_now                         := Bind('git_signature_now');

      git_tag_name                              := Bind('git_tag_name');
      git_tag_type                              := Bind('git_tag_type');
      git_tag_target                            := Bind('git_tag_target');
      git_tag_target_oid                        := Bind('git_tag_target_oid');
      git_tag_id                                := Bind('git_tag_id');
      git_tag_tagger                            := Bind('git_tag_tagger');
      git_tag_message                           := Bind('git_tag_message');
      git_tag_create                            := Bind('git_tag_create');
      git_tag_create_o                          := Bind('git_tag_create_o');
      git_tag_list                              := Bind('git_tag_list');
      git_tag_create_f                          := Bind('git_tag_create_f');
      git_tag_create_fo                         := Bind('git_tag_create_fo');
      git_tag_create_frombuffer                 := Bind('git_tag_create_frombuffer');
      git_tag_delete                            := Bind('git_tag_delete');

      git_tree_entry_byname                     := Bind('git_tree_entry_byname');
      git_tree_entry_byindex                    := Bind('git_tree_entry_byindex');
      git_tree_entrycount                       := Bind('git_tree_entrycount');
      git_tree_entry_name                       := Bind('git_tree_entry_name');
      git_tree_entry_2object                    := Bind('git_tree_entry_2object');
      git_tree_id                               := Bind('git_tree_id');
      git_tree_create_fromindex                 := Bind('git_tree_create_fromindex');

      git_tree_entry_attributes                 := Bind('git_tree_entry_attributes');
      git_tree_entry_id                         := Bind('git_tree_entry_id');
      git_tree_entry_type                       := Bind('git_tree_entry_type');

      git_treebuilder_create                    := Bind('git_treebuilder_create');
      git_treebuilder_clear                     := Bind('git_treebuilder_clear');
      git_treebuilder_free                      := Bind('git_treebuilder_free');
      git_treebuilder_get                       := Bind('git_treebuilder_get');
      git_treebuilder_insert                    := Bind('git_treebuilder_insert');
      git_treebuilder_remove                    := Bind('git_treebuilder_remove');
      git_treebuilder_filter                    := Bind('git_treebuilder_filter');
      git_treebuilder_write                     := Bind('git_treebuilder_write');
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

    git_libgit2_version                       := nil;

    git_object__size                          := nil;
    git_strerror                              := nil;
    git_lasterror                             := nil;

    git_blob_rawcontent                       := nil;
    git_blob_rawsize                          := nil;
    git_blob_create_fromfile                  := nil;
    git_blob_create_frombuffer                := nil;

    git_commit_message_short                  := nil;
    git_commit_message                        := nil;
    git_commit_author                         := nil;
    git_commit_committer                      := nil;
    git_commit_time                           := nil;
    git_commit_parentcount                    := nil;
    git_commit_parent                         := nil;
    git_commit_id                             := nil;
    git_commit_time_offset                    := nil;
    git_commit_tree                           := nil;
    git_commit_create                         := nil;
    git_commit_create_o                       := nil;
    git_commit_create_v                       := nil;
    git_commit_create_ov                      := nil;
    git_commit_parent_oid                     := nil;
    git_commit_tree_oid                       := nil;

    git_config_find_global                    := nil;
    git_config_open_global                    := nil;
    git_config_file__ondisk                   := nil;
    git_config_new                            := nil;
    git_config_add_file                       := nil;
    git_config_add_file_ondisk                := nil;
    git_config_open_ondisk                    := nil;
    git_config_free                           := nil;
    git_config_get_int                        := nil;
    git_config_get_long                       := nil;
    git_config_get_bool                       := nil;
    git_config_get_string                     := nil;
    git_config_set_int                        := nil;
    git_config_set_long                       := nil;
    git_config_set_bool                       := nil;
    git_config_set_string                     := nil;
    git_config_foreach                        := nil;

    git_index_open                            := nil;
    git_index_read                            := nil;
    git_index_free                            := nil;
    git_index_find                            := nil;
    git_index_entrycount                      := nil;
    git_index_add2                            := nil;
    git_index_append                          := nil;
    git_index_append2                         := nil;
    git_index_clear                           := nil;
    git_index_write                           := nil;
    git_index_add                             := nil;
    git_index_remove                          := nil;
    git_index_get                             := nil;
    git_index_entrycount_unmerged             := nil;
    git_index_get_unmerged_bypath             := nil;
    git_index_get_unmerged_byindex            := nil;
    git_index_entry_stage                     := nil;

    git_object_id                             := nil;
    git_object_close                          := nil;
    git_object_type                           := nil;
    git_object_owner                          := nil;
    git_object_type2string                    := nil;
    git_object_string2type                    := nil;
    git_object_typeisloose                    := nil;
    git_object_lookup                         := nil;
    git_object_lookup_prefix                  := nil;

    git_odb_new                               := nil;
    git_odb_open                              := nil;
    git_odb_open_wstream                      := nil;
    git_odb_open_rstream                      := nil;
    git_odb_write                             := nil;
    git_odb_add_backend                       := nil;
    git_odb_add_alternate                     := nil;
    git_odb_close                             := nil;
    git_odb_read                              := nil;
    git_odb_read_prefix                       := nil;
    git_odb_read_header                       := nil;
    git_odb_exists                            := nil;
    git_odb_hash                              := nil;

    git_odb_backend_pack                      := nil;
    git_odb_backend_loose                     := nil;

    git_odb_object_close                      := nil;
    git_odb_object_data                       := nil;
    git_odb_object_id                         := nil;
    git_odb_object_size                       := nil;
    git_odb_object_type                       := nil;

    git_oid_fromstr                           := nil;
    git_oid_fmt                               := nil;
    git_oid_pathfmt                           := nil;
    git_oid_fromraw                           := nil;
    git_oid_allocfmt                          := nil;
    git_oid_to_string                         := nil;
    git_oid_cpy                               := nil;
    git_oid_cmp                               := nil;
    git_oid_ncmp                              := nil;

    git_reference_create_oid                  := nil;
    git_reference_oid                         := nil;
    git_reference_target                      := nil;
    git_reference_type                        := nil;
    git_reference_name                        := nil;
    git_reference_resolve                     := nil;
    git_reference_owner                       := nil;
    git_reference_rename                      := nil;
    git_reference_set_target                  := nil;
    git_reference_set_oid                     := nil;
    git_reference_lookup                      := nil;
    git_reference_create_symbolic             := nil;
    git_reference_delete                      := nil;
    git_reference_packall                     := nil;
    git_reference_listall                     := nil;
    git_reference_foreach                     := nil;
    git_strarray_free                         := nil;
    git_reference_create_oid_f                := nil;
    git_reference_rename_f                    := nil;
    git_reference_create_symbolic_f           := nil;

    git_repository_open                       := nil;
    git_repository_free                       := nil;
    git_repository_open2                      := nil;
    git_repository_open3                      := nil;
    git_repository_database                   := nil;
    git_repository_index                      := nil;
    git_repository_init                       := nil;
    git_repository_is_empty                   := nil;
    git_repository_path                       := nil;
    git_repository_is_bare                    := nil;
    git_repository_discover                   := nil;
    git_repository_config                     := nil;

    git_revwalk_new                           := nil;
    git_revwalk_free                          := nil;
    git_revwalk_sorting                       := nil;
    git_revwalk_push                          := nil;
    git_revwalk_next                          := nil;
    git_revwalk_reset                         := nil;
    git_revwalk_hide                          := nil;
    git_revwalk_repository                    := nil;

    git_signature_new                         := nil;
    git_signature_dup                         := nil;
    git_signature_free                        := nil;
    git_signature_now                         := nil;

    git_tag_name                              := nil;
    git_tag_type                              := nil;
    git_tag_target                            := nil;
    git_tag_target_oid                        := nil;
    git_tag_id                                := nil;
    git_tag_tagger                            := nil;
    git_tag_message                           := nil;
    git_tag_create                            := nil;
    git_tag_create_o                          := nil;
    git_tag_list                              := nil;
    git_tag_create_f                          := nil;
    git_tag_create_fo                         := nil;
    git_tag_create_frombuffer                 := nil;
    git_tag_delete                            := nil;

    git_tree_entry_byname                     := nil;
    git_tree_entry_byindex                    := nil;
    git_tree_entrycount                       := nil;
    git_tree_entry_name                       := nil;
    git_tree_entry_2object                    := nil;
    git_tree_id                               := nil;
    git_tree_create_fromindex                 := nil;

    git_tree_entry_attributes                 := nil;
    git_tree_entry_id                         := nil;
    git_tree_entry_type                       := nil;

    git_treebuilder_create                    := nil;
    git_treebuilder_clear                     := nil;
    git_treebuilder_free                      := nil;
    git_treebuilder_get                       := nil;
    git_treebuilder_insert                    := nil;
    git_treebuilder_remove                    := nil;
    git_treebuilder_filter                    := nil;
    git_treebuilder_write                     := nil;
  end;
end;

initialization
  libgit2 := 0;
finalization
  FreeLibgit2;

end.
