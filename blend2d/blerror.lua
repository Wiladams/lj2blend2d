local enum = require("enum")

local errors = enum {
    [0] = "BL_SUCCESS",
  
    --[0x00010000] = "START_INDEX",
  
    [0x00010000] = "OUT_OF_MEMORY",  --!< Out of memory                 [ENOMEM].
    "INVALID_VALUE",                --!< Invalid value/argument        [EINVAL].
    "INVALID_STATE",                --!< Invalid state                 [EFAULT].
    "INVALID_HANDLE",               --!< Invalid handle or file.       [EBADF].
    "VALUE_TOO_LARGE",              --!< Value too large               [EOVERFLOW].
    "NOT_INITIALIZED",              --!< Not initialize (some instance is built-in none when it shouldnt be).
    "NOT_IMPLEMENTED",              --!< Not implemented               [ENOSYS].
    "NOT_PERMITTED",                --!< Operation not permitted       [EPERM].
  
    "IO",                           --!< IO error                      [EIO].
    "BUSY",                         --!< Device or resource busy       [EBUSY].
    "INTERRUPTED",                  --!< Operation interrupted         [EINTR].
    "TRY_AGAIN",                    --!< Try again                     [EAGAIN].
    "BROKEN_PIPE",                  --!< Broken pipe                   [EPIPE].
    "INVALID_SEEK",                 --!< File is not seekable          [ESPIPE].
    "SYMLINK_LOOP",                 --!< Too many levels of symlinks   [ELOOP].
    "FILE_TOO_LARGE",               --!< File is too large             [EFBIG].
    "ALREADY_EXISTS",               --!< File/directory already exists [EEXIST].
    "ACCESS_DENIED",                --!< Access denied                 [EACCES].
    "MEDIA_CHANGED",                --!< Media changed                 [Windows::ERROR_MEDIA_CHANGED].
    "READ_ONLY_FS",                 --!< The file/FS is read-only      [EROFS].
    "NO_DEVICE",                    --!< Device doesnt exist          [ENXIO].
    "NO_ENTRY",                     --!< No such file or directory     [ENOENT].
    "NO_MEDIA",                     --!< No media in drive/device      [ENOMEDIUM].
    "NO_MORE_DATA",                 --!< No more data / end of file    [ENODATA].
    "NO_MORE_FILES",                --!< No more files                 [ENMFILE].
    "NO_SPACE_LEFT",                --!< No space left on device       [ENOSPC].
    "NOT_EMPTY",                    --!< Directory is not empty        [ENOTEMPTY].
    "NOT_FILE",                     --!< Not a file                    [EISDIR].
    "NOT_DIRECTORY",                --!< Not a directory               [ENOTDIR].
    "NOT_SAME_DEVICE",              --!< Not same device               [EXDEV].
    "NOT_BLOCK_DEVICE",             --!< Not a block device            [ENOTBLK].
  
    "INVALID_FILE_NAME",            --!< File/path name is invalid     [n/a].
    "FILE_NAME_TOO_LONG",           --!< File/path name is too long    [ENAMETOOLONG].
  
    "TOO_MANY_OPEN_FILES",          --!< Too many open files           [EMFILE].
    "TOO_MANY_OPEN_FILES_BY_OS",    --!< Too many open files by OS     [ENFILE].
    "TOO_MANY_LINKS",               --!< Too many symbolic links on FS [EMLINK].
  
    "FILE_EMPTY",                   --!< File is empty (not specific to any OS error).
    "OPEN_FAILED",                  --!< File open failed              [Windows::ERROR_OPEN_FAILED].
    "NOT_ROOT_DEVICE",              --!< Not a root device/directory   [Windows::ERROR_DIR_NOT_ROOT].
  
    "UNKNOWN_SYSTEM_ERROR",         --!< Unknown system error that failed to translate to Blend2D result code.
  
    "INVALID_SIGNATURE",            --!< Invalid data signature or header.
    "INVALID_DATA",                 --!< Invalid or corrupted data.
    "INVALID_STRING",               --!< Invalid string (invalid data of either UTF8", UTF16", or UTF32).
    "DATA_TRUNCATED",               --!< Truncated data (more data required than memory/stream provides).
    "DATA_TOO_LARGE",               --!< Input data too large to be processed.
    "DECOMPRESSION_FAILED",         --!< Decompression failed due to invalid data (RLE", Huffman", etc).
  
    "INVALID_GEOMETRY",             --!< Invalid geometry (invalid path data or shape).
    "NO_MATCHING_VERTEX",           --!< Returned when there is no matching vertex in path data.
  
    "NO_MATCHING_COOKIE",           --!< No matching cookie (BLContext).
    "NO_STATES_TO_RESTORE",         --!< No states to restore (BLContext).
  
    "IMAGE_TOO_LARGE",              --!< The size of the image is too large.
    "IMAGE_NO_MATCHING_CODEC",      --!< Image codec for a required format doesnt exist.
    "IMAGE_UNKNOWN_FILE_FORMAT",    --!< Unknown or invalid file format that cannot be read.
    "IMAGE_DECODER_NOT_PROVIDED",   --!< Image codec doesnt support reading the file format.
    "IMAGE_ENCODER_NOT_PROVIDED",   --!< Image codec doesnt support writing the file format.
  
    "PNG_MULTIPLE_IHDR",            --!< Multiple IHDR chunks are not allowed (PNG).
    "PNG_INVALID_IDAT",             --!< Invalid IDAT chunk (PNG).
    "PNG_INVALID_IEND",             --!< Invalid IEND chunk (PNG).
    "PNG_INVALID_PLTE",             --!< Invalid PLTE chunk (PNG).
    "PNG_INVALID_TRNS",             --!< Invalid tRNS chunk (PNG).
    "PNG_INVALID_FILTER",           --!< Invalid filter type (PNG).
  
    "JPEG_UNSUPPORTED_FEATURE",     --!< Unsupported feature (JPEG).
    "JPEG_INVALID_SOS",             --!< Invalid SOS marker or header (JPEG).
    "JPEG_INVALID_SOF",             --!< Invalid SOF marker (JPEG).
    "JPEG_MULTIPLE_SOF",            --!< Multiple SOF markers (JPEG).
    "JPEG_UNSUPPORTED_SOF",         --!< Unsupported SOF marker (JPEG).
  
    "FONT_NO_CHARACTER_MAPPING",    --!< Font has no character to glyph mapping data.
    "FONT_MISSING_IMPORTANT_TABLE", --!< Font has missing an important table.
    "FONT_FEATURE_NOT_AVAILABLE",   --!< Font feature is not available.
    "FONT_CFF_INVALID_DATA",        --!< Font has an invalid CFF data.
    "FONT_PROGRAM_TERMINATED",      --!< Font program terminated because the execution reached the limit.
  
    "INVALID_GLYPH"                 --!< Invalid glyph identifier.
  };


return errors

