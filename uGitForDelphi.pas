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
//   define GIT_EBAREINDEX (GIT_ERROR - 14)
//
//   /** The name of the reference is not valid */
//   #define GIT_EINVALIDREFNAME (GIT_ERROR - 15)
//
//   /** The specified reference has its data corrupted */
//   #define GIT_EREFCORRUPTED  (GIT_ERROR - 16)
//
//   /** The specified symbolic reference is too deeply nested */
//   #define GIT_ETOONESTEDSYMREF (GIT_ERROR - 17)
//
//   /** The pack-refs file is either corrupted of its format is not currently supported */
//   #define GIT_EPACKEDREFSCORRUPTED (GIT_ERROR - 18)
//
//   /** The path is invalid */
//   #define GIT_EINVALIDPATH (GIT_ERROR - 19)
//
//   /** The revision walker is empty; there are no more commits left to iterate */
//   #define GIT_EREVWALKOVER (GIT_ERROR - 20)

   GIT_SUCCESS                = 0;
   GIT_ERROR                  = -1;
   GIT_ENOTOID                = (GIT_ERROR - 1);
   GIT_ENOTFOUND              = (GIT_ERROR - 2);
   GIT_ENOMEM                 = (GIT_ERROR - 3);
   GIT_EOSERR                 = (GIT_ERROR - 4);
   GIT_EOBJTYPE               = (GIT_ERROR - 5);
   GIT_EOBJCORRUPTED          = (GIT_ERROR - 6);
   GIT_ENOTAREPO              = (GIT_ERROR - 7);
   GIT_EINVALIDTYPE           = (GIT_ERROR - 8);
   GIT_EMISSINGOBJDATA        = (GIT_ERROR - 9);
   GIT_EPACKCORRUPTED         = (GIT_ERROR - 10);
   GIT_EFLOCKFAIL             = (GIT_ERROR - 11);
   GIT_EZLIB                  = (GIT_ERROR - 12);
   GIT_EBUSY                  = (GIT_ERROR - 13);
   GIT_EBAREINDEX             = (GIT_ERROR - 14);
   GIT_EINVALIDREFNAME        = (GIT_ERROR - 15);
   GIT_EREFCORRUPTED          = (GIT_ERROR - 16);
   GIT_ETOONESTEDSYMREF       = (GIT_ERROR - 17);
   GIT_EPACKEDREFSCORRUPTED   = (GIT_ERROR - 18);
   GIT_EINVALIDPATH           = (GIT_ERROR - 19);
   GIT_EREVWALKOVER           = (GIT_ERROR - 20);

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
//      GIT_REF_INVALID = -1, /** Invalid reference */
//      GIT_REF_OID = 1, /** A reference which points at an object id */
//      GIT_REF_SYMBOLIC = 2, /** A reference which points at another reference */
//   } git_rtype;
   GIT_REF_INVALID   = -1;
   GIT_REF_OID       = 1;
   GIT_REF_SYMBOLIC  = 2;

type
   size_t   = LongWord;
   time_t   = Int64;
   off_t = Int64;
   git_off_t = Int64;  //  typedef __int64 git_off_t;
   git_time_t = Int64; //  typedef __time64_t git_time_t;

   git_otype = Integer; // enum as constants above
   git_rtype = Integer;

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
   Pgit_signature = ^git_signature;
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
   Pgit_blob = ^git_blob;
   Pgit_odb_backend = ^git_odb_backend;
   Pgit_reference = ^git_reference;

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
      file_size:                                         git_off_t;

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

//   typedef struct {
//      git_hashtable *cache;
//      unsigned pack_loaded:1;
//   } git_refcache;
   git_refcache = record
      cache: Pgit_hashtable;
      pack_loaded: UInt;
   end;

//   struct git_repository {
//      git_odb *db;
//      git_index *index;
//      git_hashtable *objects;
//
//      git_refcache references;
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

      references:                                        git_refcache;

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
//      unsigned sorted:1;
//   };
   git_tree = record
      object_:                                           git_object;
      entries:                                           git_vector;
      sorted:                                            UInt;
   end;

//   struct git_commit {
//      git_object object;
//
//      git_vector parents;
//
//      git_tree *tree;
//      git_signature *author;
//      git_signature *committer;
//
//      char *message;
//      char *message_short;
//
//      unsigned full_parse:1;
//   };
   git_commit = record
      object_:                                           git_object;

      parents:                                           git_vector;

      tree:                                              Pgit_tree;
      author:                                            Pgit_signature;
      committer:                                         Pgit_signature;

      message_:                                          PAnsiChar;
      message_short:                                     PAnsiChar;

      full_parse:                                        UInt;
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
//      git_signature *tagger;
//      char *message;
//   };
   git_tag = record
      object_:                                           git_object;

      target:                                            Pgit_object;
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
//      git_rtype type;
//      char *name;
//
//      unsigned packed:1,
//             modified:1;
//
//      union {
//         char *ref;
//         git_oid oid;
//      } target;
//   };
   git_reference = record
      owner: Pgit_repository;
      type_: git_rtype;
      name: PAnsiChar;

      packedAndModified: UInt;

      // Doesn't seem to do as "Delphi in a nutshell" suggests (that the size is the sum of the largest members),
      // instead seems that sizeof is the size of all possible members.
//      case target: Integer of
//         0: (ref: PAnsiChar);
//         1: (oid: git_oid);
      oid: git_oid;
   end;

var
   // GIT_EXTERN(int) git_blob_set_rawcontent_fromfile(git_blob *blob, const char *filename);
   git_blob_set_rawcontent_fromfile:   function (blob: Pgit_blob; const filename: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_blob_set_rawcontent(git_blob *blob, const void *buffer, size_t len);
   git_blob_set_rawcontent:            function (blob: Pgit_blob; const buffer: PByte; len: size_t): Integer cdecl;
   // GIT_EXTERN(const char *) git_blob_rawcontent(git_blob *blob);
   git_blob_rawcontent:                function (blob: Pgit_blob): PAnsiChar cdecl;
   // GIT_EXTERN(int) git_blob_rawsize(git_blob *blob);
   git_blob_rawsize:                   function (blob: Pgit_blob): Integer cdecl;
   // GIT_EXTERN(int) git_blob_writefile(git_oid *written_id, git_repository *repo, const char *path);
   git_blob_writefile:                 function (written_id: Pgit_oid; repo: Pgit_repository; const path: PAnsiChar): Integer cdecl;

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
   // GIT_EXTERN(time_t) git_commit_time(git_commit *commit);
   git_commit_time:                    function (commit: Pgit_commit): time_t cdecl;
   // GIT_EXTERN(unsigned int) git_commit_parentcount(git_commit *commit);
   git_commit_parentcount:             function (commit: Pgit_commit): UInt cdecl;
   // GIT_EXTERN(git_commit *) git_commit_parent(git_commit *commit, unsigned int n);
   git_commit_parent:                  function (commit: Pgit_commit; n: UInt): Pgit_commit cdecl;
   // GIT_EXTERN(int) git_commit_time_offset(git_commit *commit);
   git_commit_time_offset:         function (commit: Pgit_commit): Integer cdecl;
   // GIT_EXTERN(const git_tree *) git_commit_tree(git_commit *commit);
   git_commit_tree:                    function (commit: Pgit_commit): Pgit_tree cdecl;
   // GIT_EXTERN(int) git_commit_add_parent(git_commit *commit, git_commit *new_parent);
   git_commit_add_parent:              function (commit: Pgit_commit; new_parent: Pgit_commit): Integer cdecl;
   // GIT_EXTERN(void) git_commit_set_message(git_commit *commit, const char *message);
   git_commit_set_message:             procedure (commit: Pgit_commit; const message_: PAnsiChar) cdecl;
   // GIT_EXTERN(void) git_commit_set_committer(git_commit *commit, const git_signature *committer_sig);
   git_commit_set_committer:           procedure (commit: Pgit_commit; const committer_sig: Pgit_signature) cdecl;
   // GIT_EXTERN(void) git_commit_set_author(git_commit *commit, const git_signature *author_sig);
   git_commit_set_author:              procedure (commit: Pgit_commit; const author_sig: Pgit_signature) cdecl;
   // GIT_EXTERN(void) git_commit_set_tree(git_commit *commit, git_tree *tree);
   git_commit_set_tree:                procedure (commit: Pgit_commit; tree: Pgit_tree) cdecl;

   // GIT_EXTERN(int) git_index_open_bare(git_index **index, const char *index_path);
   git_index_open_bare:                function (var index: Pgit_index; const index_path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_index_read(git_index *index);
   git_index_read:                     function (index: Pgit_index): Integer cdecl;
   // GIT_EXTERN(void) git_index_free(git_index *index);
   git_index_free:                     procedure (index: Pgit_index) cdecl;
   // GIT_EXTERN(int) git_index_find(git_index *index, const char *path);
   git_index_find:                     function (index: Pgit_index; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(unsigned int) git_index_entrycount(git_index *index);
   git_index_entrycount:               function (index: Pgit_index): UInt cdecl;
   // GIT_EXTERN(int) git_index_open_inrepo(git_index **index, git_repository *repo);
   git_index_open_inrepo:              function (var index: Pgit_index; repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(void) git_index_clear(git_index *index);
   git_index_clear:                    procedure (index: Pgit_index) cdecl;
   // GIT_EXTERN(int) git_index_write(git_index *index);
   git_index_write:                    function (index: Pgit_index): Integer cdecl;
   // GIT_EXTERN(int) git_index_add(git_index *index, const char *path, int stage);
   git_index_add:                      function (index: Pgit_index; const path: PAnsiChar; stage: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_index_remove(git_index *index, int position);
   git_index_remove:                   function (index: Pgit_index; position: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_index_insert(git_index *index, const git_index_entry *source_entry);
   git_index_insert:                   function (index: Pgit_index; const source_entry: Pgit_index_entry): Integer cdecl;
   // GIT_EXTERN(git_index_entry *) git_index_get(git_index *index, int n);
   git_index_get:                      function (index: Pgit_index; n: Integer): Pgit_index_entry cdecl;

   // GIT_EXTERN(const git_oid *) git_object_id(git_object *obj);
   git_object_id:                      function (obj: Pgit_object): Pgit_oid cdecl;
   // GIT_EXTERN(int) git_object_write(git_object *object);
   git_object_write:                   function (object_: Pgit_object): Integer cdecl;
   // GIT_EXTERN(void) git_object_free(git_object *object);
   git_object_free:                    procedure (object_: Pgit_object) cdecl;
   // GIT_EXTERN(git_otype) git_object_type(git_object *obj);
   git_object_type:                    function(obj: Pgit_object): git_otype cdecl;
   // GIT_EXTERN(git_repository *) git_object_owner(git_object *obj);
   git_object_owner:                   function (obj: Pgit_object): Pgit_repository cdecl;
   // GIT_EXTERN(const char *) git_object_type2string(git_otype type);
   git_object_type2string:             function (type_: git_otype): PAnsiChar cdecl;
   // GIT_EXTERN(git_otype) git_object_string2type(const char *str);
   git_object_string2type:             function (const str: PAnsiChar): git_otype cdecl;
   // GIT_EXTERN(int) git_object_typeisloose(git_otype type);
   git_object_typeisloose:             function (type_: git_otype): Integer cdecl;

   // GIT_EXTERN(int) git_odb_new(git_odb **out);
   git_odb_new:                        function (var out_: Pgit_odb): Integer cdecl;
   // GIT_EXTERN(int) git_odb_open(git_odb **out, const char *objects_dir);
   git_odb_open:                       function (var out_: Pgit_odb; const objects_dir: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_odb_add_backend(git_odb *odb, git_odb_backend *backend);
   git_odb_add_backend:                function (odb: Pgit_odb; backend: Pgit_odb_backend): Integer cdecl;
   // GIT_EXTERN(void) git_odb_close(git_odb *db);
   git_odb_close:                      procedure (db: Pgit_odb) cdecl;
   // GIT_EXTERN(int) git_odb_read(git_rawobj *out, git_odb *db, const git_oid *id);
   git_odb_read:                       function (out_: Pgit_rawobj; db: Pgit_odb; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_odb_read_header(git_rawobj *out, git_odb *db, const git_oid *id);
   git_odb_read_header:                function (out_: Pgit_rawobj; db: Pgit_odb; const id: Pgit_oid): Integer cdecl;
   // GIT_EXTERN(int) git_odb_write(git_oid *id, git_odb *db, git_rawobj *obj);
   git_odb_write:                      function (id: Pgit_oid; db: Pgit_odb; obj: Pgit_rawobj): Integer cdecl;
   // GIT_EXTERN(int) git_odb_exists(git_odb *db, const git_oid *id);
   git_odb_exists:                     function (db: Pgit_odb; const id: Pgit_oid): Integer cdecl;

   // GIT_EXTERN(int) git_odb_backend_pack(git_odb_backend **backend_out, const char *objects_dir);
   git_odb_backend_pack:               function (var backend_out: Pgit_odb_backend; const objects_dir: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_odb_backend_loose(git_odb_backend **backend_out, const char *objects_dir);
   git_odb_backend_loose:              function (var backend_out: Pgit_odb_backend; const objects_dir: PAnsiChar): Integer cdecl;

   // #ifdef GIT2_SQLITE_BACKEND
   // GIT_EXTERN(int) git_odb_backend_sqlite(git_odb_backend **backend_out, const char *sqlite_db);
   // #endif
   _git_odb_backend_sqlite:            function (var backend_out: Pgit_odb_backend; const sqlite_db: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(int) git_rawobj_hash(git_oid *id, git_rawobj *obj);
   git_rawobj_hash:                    function (id: Pgit_oid; obj: Pgit_rawobj): Integer cdecl;
   // GIT_EXTERN(void) git_rawobj_close(git_rawobj *obj);
   git_rawobj_close:                   procedure (obj: Pgit_rawobj) cdecl;

   // GIT_EXTERN(int) git_oid_mkstr(git_oid *out, const char *str);
   git_oid_mkstr:                      function (aOut: Pgit_oid; aStr: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(void) git_oid_fmt(char *str, const git_oid *oid);
   git_oid_fmt:                        procedure (aStr: PAnsiChar; const oid: Pgit_oid) cdecl;
   // GIT_EXTERN(void) git_oid_pathfmt(char *str, const git_oid *oid);
   git_oid_pathfmt:                    procedure (aStr: PAnsiChar; const oid: Pgit_oid) cdecl;
   // GIT_EXTERN(void) git_oid_mkraw(git_oid *out, const unsigned char *raw);
   git_oid_mkraw:                      procedure (out_: Pgit_oid; const raw: PByte) cdecl;
   // GIT_EXTERN(char *) git_oid_allocfmt(const git_oid *oid);
   git_oid_allocfmt:                   function (const oid: Pgit_oid): PAnsiChar cdecl;
   // GIT_EXTERN(char *) git_oid_to_string(char *out, size_t n, const git_oid *oid);
   git_oid_to_string:                  function (out_: PAnsiChar; n: size_t; const oid: Pgit_oid): PAnsiChar cdecl;
   // GIT_EXTERN(void) git_oid_cpy(git_oid *out, const git_oid *src);
   git_oid_cpy:                        procedure (out_: Pgit_oid; const src: Pgit_oid) cdecl;
   // GIT_EXTERN(int) git_oid_cmp(const git_oid *a, const git_oid *b);
   git_oid_cmp:                        function (const a, b: Pgit_oid): Integer cdecl;

   // GIT_EXTERN(int) git_repository_open(git_repository **repository, const char *path);
   git_repository_open:                function (var repo_out: Pgit_repository; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(void) git_repository_free(git_repository *repo);
   git_repository_free:                procedure (repo: Pgit_repository) cdecl;
   // GIT_EXTERN(int) git_repository_open2(git_repository **repository, const char *git_dir, const char *git_object_directory, const char *git_index_file, const char *git_work_tree);
   git_repository_open2:               function (var repository: Pgit_repository; const git_dir, git_object_directory, git_index_file, git_work_tree: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) git_repository_open3(git_repository **repository, const char *git_dir, git_odb *object_database, const char *git_index_file, const char *git_work_tree);
   git_repository_open3:               function (var repository: Pgit_repository; const git_dir: PAnsiChar; object_database: Pgit_odb; const git_index_file, git_work_tree: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(int) git_repository_lookup(git_object **object, git_repository *repo, const git_oid *id, git_otype type);
   git_repository_lookup:              function (var object_: Pgit_object; repo: Pgit_repository; const id: Pgit_oid; type_: git_otype): Integer cdecl;
   // GIT_EXTERN(int) git_repository_lookup_ref(git_reference **reference_out, git_repository *repo, const char *name);
   git_repository_lookup_ref:          function (var reference_out: Pgit_reference; repo: Pgit_repository; const name: PAnsiChar): Integer cdecl;

   // GIT_EXTERN(git_odb *) git_repository_database(git_repository *repo);
   git_repository_database:            function (repo: Pgit_repository): Pgit_odb cdecl;
   // GIT_EXTERN(int) git_repository_index(git_index **index, git_repository *repo);
   git_repository_index:               function (var index: Pgit_index; repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(int) git_repository_newobject(git_object **object, git_repository *repo, git_otype type);
   git_repository_newobject:           function (var object_: Pgit_object; repo: Pgit_repository; type_: git_otype): Integer cdecl;
   // GIT_EXTERN(int) git_repository_init(git_repository **repo_out, const char *path, unsigned is_bare);
   git_repository_init:                function (var repo_out: Pgit_repository; const path: PAnsiChar; is_bare: UInt): Integer cdecl;

   // GIT_EXTERN(int) git_revwalk_new(git_revwalk **walker, git_repository *repo);
   git_revwalk_new:                    function (var walker: Pgit_revwalk; repo: Pgit_repository): Integer cdecl;
   // GIT_EXTERN(void) git_revwalk_free(git_revwalk *walk);
   git_revwalk_free:                   procedure (walk: Pgit_revwalk) cdecl;
   // GIT_EXTERN(int) git_revwalk_sorting(git_revwalk *walk, unsigned int sort_mode);
   git_revwalk_sorting:                function (walk: Pgit_revwalk; sort_mode: UInt): Integer cdecl;
   // GIT_EXTERN(int) git_revwalk_push(git_revwalk *walk, git_commit *commit);
   git_revwalk_push:                   function (walk: Pgit_revwalk; commit: Pgit_commit): Integer cdecl;
   // GIT_EXTERN(int) git_revwalk_next(git_commit **commit, git_revwalk *walk);
   git_revwalk_next:                   function (var commit: Pgit_commit; walk: Pgit_revwalk): Integer cdecl;
   // GIT_EXTERN(void) git_revwalk_reset(git_revwalk *walker);
   git_revwalk_reset:                  procedure (walker: Pgit_revwalk) cdecl;
   // GIT_EXTERN(int) git_revwalk_hide(git_revwalk *walk, git_commit *commit);
   git_revwalk_hide:                   function (walk: Pgit_revwalk; commit: Pgit_commit): Integer cdecl;
   // GIT_EXTERN(git_repository *) git_revwalk_repository(git_revwalk *walk);
   git_revwalk_repository:             function (walk: Pgit_revwalk): Pgit_repository cdecl;

   // GIT_EXTERN(git_signature *) git_signature_new(const char *name, const char *email, time_t time, int offset);
   git_signature_new:                  function (const name, email: PAnsiChar; time: time_t; offset: Integer): Pgit_signature cdecl;
   // GIT_EXTERN(git_signature *) git_signature_dup(const git_signature *sig);
   git_signature_dup:                  function (const sig: Pgit_signature): Pgit_signature cdecl;
   // GIT_EXTERN(void) git_signature_free(git_signature *sig);
   git_signature_free:                 procedure (sig: Pgit_signature)cdecl;

   // GIT_EXTERN(const char *) git_tag_name(git_tag *t);
   git_tag_name:                       function (t: Pgit_tag): PAnsiChar cdecl;
   // GIT_EXTERN(git_otype) git_tag_type(git_tag *t);
   git_tag_type:                       function (t: Pgit_tag): git_otype cdecl;
   // GIT_EXTERN(const git_object *) git_tag_target(git_tag *t);
   git_tag_target:                     function (t: Pgit_tag): Pgit_object cdecl;
   // GIT_EXTERN(const git_oid *) git_tag_id(git_tag *tag);
   git_tag_id:                         function (tag: Pgit_tag): Pgit_oid cdecl;
   // GIT_EXTERN(void) git_tag_set_name(git_tag *tag, const char *name);
   git_tag_set_name:                   procedure (tag: Pgit_tag; const name: PAnsiChar) cdecl;
   // GIT_EXTERN(const git_signature *) git_tag_tagger(git_tag *t);
   git_tag_tagger:                     function (t: Pgit_tag): Pgit_signature cdecl;
   // GIT_EXTERN(const char *) git_tag_message(git_tag *t);
   git_tag_message:                    function (t: Pgit_tag): PAnsiChar cdecl;
   // GIT_EXTERN(void) git_tag_set_target(git_tag *tag, git_object *target);
   git_tag_set_target:                 procedure (tag: Pgit_tag; target: Pgit_object) cdecl;
   // GIT_EXTERN(void) git_tag_set_tagger(git_tag *tag, const git_signature *tagger_sig);
   git_tag_set_tagger:                 procedure (tag: Pgit_tag; const tagger_sig: Pgit_signature) cdecl;
   // GIT_EXTERN(void) git_tag_set_message(git_tag *tag, const char *message);
   git_tag_set_message:                procedure (tag: Pgit_tag; const message_: PAnsiChar) cdecl;

   // GIT_EXTERN(git_tree_entry *) git_tree_entry_byname(git_tree *tree, const char *filename);
   git_tree_entry_byname:              function (tree: Pgit_tree; const filename: PAnsiChar): Pgit_tree_entry cdecl;
   // GIT_EXTERN(git_tree_entry *) git_tree_entry_byindex(git_tree *tree, int idx);
   git_tree_entry_byindex:             function (tree: Pgit_tree; idx: Integer): Pgit_tree_entry cdecl;
   // GIT_EXTERN(size_t) git_tree_entrycount(git_tree *tree);
   git_tree_entrycount:                function (tree: Pgit_tree): size_t cdecl;
   // GIT_EXTERN(const char *) git_tree_entry_name(git_tree_entry *entry);
   git_tree_entry_name:                function (entry: Pgit_tree_entry): PAnsiChar cdecl;
   // GIT_EXTERN(int) git_tree_entry_2object(git_object **object, git_tree_entry *entry);
   git_tree_entry_2object:             function (var object_: Pgit_object; entry: Pgit_tree_entry): Integer cdecl;
   // GIT_EXTERN(int) git_tree_add_entry(git_tree_entry **entry_out, git_tree *tree, const git_oid *id, const char *filename, int attributes);
   git_tree_add_entry:                 function (var entry_out: Pgit_tree_entry; tree: Pgit_tree; const id: Pgit_oid; const filename: PAnsiChar; attributes: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_tree_remove_entry_byindex(git_tree *tree, int idx);
   git_tree_remove_entry_byindex:      function (tree: Pgit_tree; idx: Integer): Integer cdecl;
   // GIT_EXTERN(int) git_tree_remove_entry_byname(git_tree *tree, const char *filename);
   git_tree_remove_entry_byname:       function (tree: Pgit_tree; const filename: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(const git_oid *) git_tree_id(git_tree *tree);
   git_tree_id:                        function (tree: Pgit_tree): Pgit_oid cdecl;
   // GIT_EXTERN(unsigned int) git_tree_entry_attributes(git_tree_entry *entry);
   git_tree_entry_attributes:          function (entry: Pgit_tree_entry): UInt cdecl;
   // GIT_EXTERN(const git_oid *) git_tree_entry_id(git_tree_entry *entry);
   git_tree_entry_id:                  function (entry: Pgit_tree_entry): Pgit_oid cdecl;
   // GIT_EXTERN(void) git_tree_entry_set_id(git_tree_entry *entry, const git_oid *oid);
   git_tree_entry_set_id:              procedure (entry: Pgit_tree_entry; const oid: Pgit_oid) cdecl;
   // GIT_EXTERN(void) git_tree_entry_set_name(git_tree_entry *entry, const char *name);
   git_tree_entry_set_name:            procedure (entry: Pgit_tree_entry; const name: PAnsiChar) cdecl;
   // GIT_EXTERN(void) git_tree_entry_set_attributes(git_tree_entry *entry, int attr);
   git_tree_entry_set_attributes:      procedure (entry: Pgit_tree_entry; attr: Integer) cdecl;
   // GIT_EXTERN(void) git_tree_clear_entries(git_tree *tree);
   git_tree_clear_entries:             procedure (tree: Pgit_tree) cdecl;

   // GIT_EXTERN(int) git_reference_new(git_reference **ref_out, git_repository *repo);
   git_reference_new:                  function (var ref_out: Pgit_reference; repo: Pgit_repository): Integer cdecl;
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
   // GIT_EXTERN(int) git_reference_write(git_reference *ref);
   git_reference_write:                function (ref: Pgit_reference): Integer cdecl;
   // GIT_EXTERN(git_repository *) git_reference_owner(git_reference *ref);
   git_reference_owner:                function (ref: Pgit_reference): Pgit_repository cdecl;
   // GIT_EXTERN(void) git_reference_set_name(git_reference *ref, const char *name);
   git_reference_set_name:             procedure (ref: Pgit_reference; const name: PAnsiChar) cdecl;
   // GIT_EXTERN(void) git_reference_set_target(git_reference *ref, const char *target);
   git_reference_set_target:           procedure (ref: Pgit_reference; const target: PAnsiChar) cdecl;
   // GIT_EXTERN(void) git_reference_set_oid(git_reference *ref, const git_oid *id);
   git_reference_set_oid:              procedure (ref: Pgit_reference; const id: Pgit_oid) cdecl;

   // GIT_EXTERN(size_t) git_object__size(git_otype type);
   git_object__size:                   function (type_: git_otype): size_t cdecl;

   // GIT_EXTERN(int) gitfo_prettify_dir_path(char *buffer_out, const char *path);
   gitfo_prettify_dir_path:            function (buffer_out: PAnsiChar; const path: PAnsiChar): Integer cdecl;
   // GIT_EXTERN(int) gitfo_prettify_file_path(char *buffer_out, const char *path);
   gitfo_prettify_file_path:           function (buffer_out: PAnsiChar; const path: PAnsiChar): Integer cdecl;

// GIT_EXTERNs later inlined
function git_blob_lookup(var blob: Pgit_blob; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_blob_new(var blob: Pgit_blob; repo: Pgit_repository): Integer cdecl;
function git_commit_lookup(var commit: Pgit_commit; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_commit_new(var commit: Pgit_commit; repo: Pgit_repository): Integer cdecl;
function git_tag_lookup(var tag: Pgit_tag; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_tag_new(var tag: Pgit_tag; repo: Pgit_repository): Integer cdecl;
function git_tree_lookup(var tree: Pgit_tree; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
function git_tree_new(var tree: Pgit_tree; repo: Pgit_repository): Integer cdecl;

// Optionally compiled-in functions
function git_odb_backend_sqlite(var backend_out: Pgit_odb_backend; const sqlite_db: PAnsiChar): Integer cdecl;

// Helpers
function time_t__to__TDateTime(t: time_t; const aAdjustMinutes: Integer = 0): TDateTime;
function git_commit_DateTime(commit: Pgit_commit): TDateTime;

implementation

var
  libgit2: THandle;

function git_blob_lookup(var blob: Pgit_blob; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_repository_lookup((git_object **)blob, repo, id, GIT_OBJ_BLOB);
   Result := git_repository_lookup(Pgit_object(blob), repo, id, GIT_OBJ_BLOB);
end;

function git_blob_new(var blob: Pgit_blob; repo: Pgit_repository): Integer cdecl;
begin
   // return git_repository_newobject((git_object **)blob, repo, GIT_OBJ_BLOB);
   Result := git_repository_newobject(Pgit_object(blob), repo, GIT_OBJ_BLOB);
end;

function git_commit_lookup(var commit: Pgit_commit; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_repository_lookup((git_object **)commit, repo, id, GIT_OBJ_COMMIT);
   Result := git_repository_lookup(Pgit_object(commit), repo, id, GIT_OBJ_COMMIT);
end;

function git_commit_new(var commit: Pgit_commit; repo: Pgit_repository): Integer cdecl;
begin
   // return git_repository_newobject((git_object **)commit, repo, GIT_OBJ_COMMIT);
   Result := git_repository_newobject(Pgit_object(commit), repo, GIT_OBJ_COMMIT);
end;

function git_tag_lookup(var tag: Pgit_tag; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_repository_lookup((git_object **)tag, repo, id, GIT_OBJ_TAG);
   Result := git_repository_lookup(Pgit_object(tag), repo, id, GIT_OBJ_TAG);
end;

function git_tag_new(var tag: Pgit_tag; repo: Pgit_repository): Integer cdecl;
begin
   // return git_repository_newobject((git_object **)tag, repo, GIT_OBJ_TAG);
   Result := git_repository_newobject(Pgit_object(tag), repo, GIT_OBJ_TAG);
end;

function git_tree_lookup(var tree: Pgit_tree; repo: Pgit_repository; const id: Pgit_oid): Integer cdecl;
begin
   // return git_repository_lookup((git_object **)tree, repo, id, GIT_OBJ_TREE);
   Result := git_repository_lookup(Pgit_object(tree), repo, id, GIT_OBJ_TREE);
end;

function git_tree_new(var tree: Pgit_tree; repo: Pgit_repository): Integer cdecl;
begin
   // return git_repository_newobject((git_object **)tree, repo, GIT_OBJ_TREE);
   Result := git_repository_newobject(Pgit_object(tree), repo, GIT_OBJ_TREE);
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
      git_object__size                          := Bind('git_object__size');
      gitfo_prettify_dir_path                   := Bind('gitfo_prettify_dir_path');
      gitfo_prettify_file_path                  := Bind('gitfo_prettify_file_path');

      git_blob_set_rawcontent_fromfile          := Bind('git_blob_set_rawcontent_fromfile');
      git_blob_set_rawcontent                   := Bind('git_blob_set_rawcontent');
      git_blob_rawcontent                       := Bind('git_blob_rawcontent');
      git_blob_rawsize                          := Bind('git_blob_rawsize');
      git_blob_writefile                        := Bind('git_blob_writefile');

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
      git_commit_add_parent                     := Bind('git_commit_add_parent');
      git_commit_set_message                    := Bind('git_commit_set_message');
      git_commit_set_committer                  := Bind('git_commit_set_committer');
      git_commit_set_author                     := Bind('git_commit_set_author');
      git_commit_set_tree                       := Bind('git_commit_set_tree');

      git_index_open_bare                       := Bind('git_index_open_bare');
      git_index_read                            := Bind('git_index_read');
      git_index_free                            := Bind('git_index_free');
      git_index_find                            := Bind('git_index_find');
      git_index_entrycount                      := Bind('git_index_entrycount');

      git_index_open_inrepo                     := Bind('git_index_open_inrepo');
      git_index_clear                           := Bind('git_index_clear');
      git_index_write                           := Bind('git_index_write');
      git_index_add                             := Bind('git_index_add');
      git_index_remove                          := Bind('git_index_remove');
      git_index_insert                          := Bind('git_index_insert');
      git_index_get                             := Bind('git_index_get');

      git_object_id                             := Bind('git_object_id');
      git_object_write                          := Bind('git_object_write');
      git_object_free                           := Bind('git_object_free');
      git_object_type                           := Bind('git_object_type');
      git_object_owner                          := Bind('git_object_owner');
      git_object_type2string                    := Bind('git_object_type2string');
      git_object_string2type                    := Bind('git_object_string2type');
      git_object_typeisloose                    := Bind('git_object_typeisloose');

      git_odb_new                               := Bind('git_odb_new');
      git_odb_open                              := Bind('git_odb_open');
      git_odb_add_backend                       := Bind('git_odb_add_backend');
      git_odb_close                             := Bind('git_odb_close');
      git_odb_read                              := Bind('git_odb_read');
      git_odb_read_header                       := Bind('git_odb_read_header');
      git_odb_write                             := Bind('git_odb_write');
      git_odb_exists                            := Bind('git_odb_exists');

      git_odb_backend_pack                      := Bind('git_odb_backend_pack');
      git_odb_backend_loose                     := Bind('git_odb_backend_loose');

      git_rawobj_hash                           := Bind('git_rawobj_hash');
      git_rawobj_close                          := Bind('git_rawobj_close');

      git_oid_mkstr                             := Bind('git_oid_mkstr');
      git_oid_fmt                               := Bind('git_oid_fmt');
      git_oid_pathfmt                           := Bind('git_oid_pathfmt');
      git_oid_mkraw                             := Bind('git_oid_mkraw');
      git_oid_allocfmt                          := Bind('git_oid_allocfmt');
      git_oid_to_string                         := Bind('git_oid_to_string');
      git_oid_cpy                               := Bind('git_oid_cpy');
      git_oid_cmp                               := Bind('git_oid_cmp');

      git_reference_new                         := Bind('git_reference_new');
      git_reference_oid                         := Bind('git_reference_oid');
      git_reference_target                      := Bind('git_reference_target');
      git_reference_type                        := Bind('git_reference_type');
      git_reference_name                        := Bind('git_reference_name');
      git_reference_resolve                     := Bind('git_reference_resolve');
      git_reference_write                       := Bind('git_reference_write');
      git_reference_owner                       := Bind('git_reference_owner');
      git_reference_set_name                    := Bind('git_reference_set_name');
      git_reference_set_target                  := Bind('git_reference_set_target');
      git_reference_set_oid                     := Bind('git_reference_set_oid');

      git_repository_open                       := Bind('git_repository_open');
      git_repository_free                       := Bind('git_repository_free');
      git_repository_open2                      := Bind('git_repository_open2');
      git_repository_open3                      := Bind('git_repository_open3');
      git_repository_lookup                     := Bind('git_repository_lookup');
      git_repository_lookup_ref                 := Bind('git_repository_lookup_ref');
      git_repository_database                   := Bind('git_repository_database');
      git_repository_index                      := Bind('git_repository_index');
      git_repository_newobject                  := Bind('git_repository_newobject');
      git_repository_init                       := Bind('git_repository_init');

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

      git_tag_name                              := Bind('git_tag_name');
      git_tag_type                              := Bind('git_tag_type');
      git_tag_target                            := Bind('git_tag_target');
      git_tag_id                                := Bind('git_tag_id');
      git_tag_set_name                          := Bind('git_tag_set_name');
      git_tag_tagger                            := Bind('git_tag_tagger');
      git_tag_message                           := Bind('git_tag_message');
      git_tag_set_target                        := Bind('git_tag_set_target');
      git_tag_set_tagger                        := Bind('git_tag_set_tagger');
      git_tag_set_message                       := Bind('git_tag_set_message');

      git_tree_entry_byname                     := Bind('git_tree_entry_byname');
      git_tree_entry_byindex                    := Bind('git_tree_entry_byindex');
      git_tree_entrycount                       := Bind('git_tree_entrycount');
      git_tree_entry_name                       := Bind('git_tree_entry_name');
      git_tree_entry_2object                    := Bind('git_tree_entry_2object');
      git_tree_add_entry                        := Bind('git_tree_add_entry');
      git_tree_remove_entry_byindex             := Bind('git_tree_remove_entry_byindex');
      git_tree_remove_entry_byname              := Bind('git_tree_remove_entry_byname');
      git_tree_id                               := Bind('git_tree_id');

      git_tree_entry_attributes                 := Bind('git_tree_entry_attributes');
      git_tree_entry_id                         := Bind('git_tree_entry_id');
      git_tree_entry_set_id                     := Bind('git_tree_entry_set_id');
      git_tree_entry_set_name                   := Bind('git_tree_entry_set_name');
      git_tree_entry_set_attributes             := Bind('git_tree_entry_set_attributes');
      git_tree_clear_entries                    := Bind('git_tree_clear_entries');

      _git_odb_backend_sqlite                   := Bind('git_odb_backend_sqlite', OPTIONAL);
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

    git_object__size                          := nil;
    gitfo_prettify_dir_path                   := nil;
    gitfo_prettify_file_path                  := nil;

    git_blob_set_rawcontent_fromfile          := nil;
    git_blob_set_rawcontent                   := nil;
    git_blob_rawcontent                       := nil;
    git_blob_rawsize                          := nil;
    git_blob_writefile                        := nil;

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
    git_commit_add_parent                     := nil;
    git_commit_set_message                    := nil;
    git_commit_set_committer                  := nil;
    git_commit_set_author                     := nil;
    git_commit_set_tree                       := nil;

    git_index_open_bare                       := nil;
    git_index_read                            := nil;
    git_index_free                            := nil;
    git_index_find                            := nil;
    git_index_entrycount                      := nil;

    git_index_open_inrepo                     := nil;
    git_index_clear                           := nil;
    git_index_write                           := nil;
    git_index_add                             := nil;
    git_index_remove                          := nil;
    git_index_insert                          := nil;
    git_index_get                             := nil;

    git_object_id                             := nil;
    git_object_write                          := nil;
    git_object_free                           := nil;
    git_object_type                           := nil;
    git_object_owner                          := nil;
    git_object_type2string                    := nil;
    git_object_string2type                    := nil;
    git_object_typeisloose                    := nil;

    git_odb_new                               := nil;
    git_odb_open                              := nil;
    git_odb_add_backend                       := nil;
    git_odb_close                             := nil;
    git_odb_read                              := nil;
    git_odb_read_header                       := nil;
    git_odb_write                             := nil;
    git_odb_exists                            := nil;

    git_odb_backend_pack                      := nil;
    git_odb_backend_loose                     := nil;

    git_rawobj_hash                           := nil;
    git_rawobj_close                          := nil;

    git_oid_mkstr                             := nil;
    git_oid_fmt                               := nil;
    git_oid_pathfmt                           := nil;
    git_oid_mkraw                             := nil;
    git_oid_allocfmt                          := nil;
    git_oid_to_string                         := nil;
    git_oid_cpy                               := nil;
    git_oid_cmp                               := nil;

    git_reference_new                         := nil;
    git_reference_oid                         := nil;
    git_reference_target                      := nil;
    git_reference_type                        := nil;
    git_reference_name                        := nil;
    git_reference_resolve                     := nil;
    git_reference_write                       := nil;
    git_reference_owner                       := nil;
    git_reference_set_name                    := nil;
    git_reference_set_target                  := nil;
    git_reference_set_oid                     := nil;

    git_repository_open                       := nil;
    git_repository_free                       := nil;
    git_repository_open2                      := nil;
    git_repository_open3                      := nil;
    git_repository_lookup                     := nil;
    git_repository_lookup_ref                 := nil;
    git_repository_database                   := nil;
    git_repository_index                      := nil;
    git_repository_newobject                  := nil;
    git_repository_init                       := nil;

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

    git_tag_name                              := nil;
    git_tag_type                              := nil;
    git_tag_target                            := nil;
    git_tag_id                                := nil;
    git_tag_set_name                          := nil;
    git_tag_tagger                            := nil;
    git_tag_message                           := nil;
    git_tag_set_target                        := nil;
    git_tag_set_tagger                        := nil;
    git_tag_set_message                       := nil;

    git_tree_entry_byname                     := nil;
    git_tree_entry_byindex                    := nil;
    git_tree_entrycount                       := nil;
    git_tree_entry_name                       := nil;
    git_tree_entry_2object                    := nil;
    git_tree_add_entry                        := nil;
    git_tree_remove_entry_byindex             := nil;
    git_tree_remove_entry_byname              := nil;
    git_tree_id                               := nil;

    git_tree_entry_attributes                 := nil;
    git_tree_entry_id                         := nil;
    git_tree_entry_set_id                     := nil;
    git_tree_entry_set_name                   := nil;
    git_tree_entry_set_attributes             := nil;
    git_tree_clear_entries                    := nil;

    _git_odb_backend_sqlite                   := nil;
  end;
end;

{ Optional functions, may not be in DLL }

function git_odb_backend_sqlite(var backend_out: Pgit_odb_backend; const sqlite_db: PAnsiChar): Integer cdecl;
begin
   if Assigned(_git_odb_backend_sqlite) then
      Result := _git_odb_backend_sqlite(backend_out, sqlite_db)
   else
      raise Exception.Create('git_odb_backend_sqlite not compiled in');
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
