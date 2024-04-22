#include "third_party/ffmpeg/ffmpeg_rename_defines.h" // add by source_replacer.py 
/*
 * copyright (c) 2006 Michael Niedermayer <michaelni@gmx.at>
 *
 * This file is part of FFmpeg.
 *
 * FFmpeg is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * FFmpeg is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with FFmpeg; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#ifndef AVUTIL_LOG_H
#define AVUTIL_LOG_H

#include <stdarg.h>
#include "avutil.h"
#include "attributes.h"
#include "version.h"

typedef enum {
    AV_CLASS_CATEGORY_NA = 0,
    AV_CLASS_CATEGORY_INPUT,
    AV_CLASS_CATEGORY_OUTPUT,
    AV_CLASS_CATEGORY_MUXER,
    AV_CLASS_CATEGORY_DEMUXER,
    AV_CLASS_CATEGORY_ENCODER,
    AV_CLASS_CATEGORY_DECODER,
    AV_CLASS_CATEGORY_FILTER,
    AV_CLASS_CATEGORY_BITSTREAM_FILTER,
    AV_CLASS_CATEGORY_SWSCALER,
    AV_CLASS_CATEGORY_SWRESAMPLER,
    AV_CLASS_CATEGORY_DEVICE_VIDEO_OUTPUT = 40,
    AV_CLASS_CATEGORY_DEVICE_VIDEO_INPUT,
    AV_CLASS_CATEGORY_DEVICE_AUDIO_OUTPUT,
    AV_CLASS_CATEGORY_DEVICE_AUDIO_INPUT,
    AV_CLASS_CATEGORY_DEVICE_OUTPUT,
    AV_CLASS_CATEGORY_DEVICE_INPUT,
    AV_CLASS_CATEGORY_NB  ///< not part of ABI/API
}AVClassCategory;

#define AV_IS_INPUT_DEVICE(category) \
    (((category) == AV_CLASS_CATEGORY_DEVICE_VIDEO_INPUT) || \
     ((category) == AV_CLASS_CATEGORY_DEVICE_AUDIO_INPUT) || \
     ((category) == AV_CLASS_CATEGORY_DEVICE_INPUT))

#define AV_IS_OUTPUT_DEVICE(category) \
    (((category) == AV_CLASS_CATEGORY_DEVICE_VIDEO_OUTPUT) || \
     ((category) == AV_CLASS_CATEGORY_DEVICE_AUDIO_OUTPUT) || \
     ((category) == AV_CLASS_CATEGORY_DEVICE_OUTPUT))

struct AVOptionRanges;

/**
 * Describe the class of an AVClass context structure. That is an
 * arbitrary struct of which the first field is a pointer to an
 * AVClass struct (e.g. AVCodecContext, AVFormatContext etc.).
 */
typedef struct AVClass {
    /**
     * The name of the class; usually it is the same name as the
     * context structure type to which the AVClass is associated.
     */
    const char* class_name;

    /**
     * A pointer to a function which returns the name of a context
     * instance ctx associated with the class.
     */
    const char* (*item_name)(void* ctx);

    /**
     * a pointer to the first option specified in the class if any or NULL
     *
     * @see av_set_default_options()
     */
    const struct AVOption *option;

    /**
     * LIBAVUTIL_VERSION with which this structure was created.
     * This is used to allow fields to be added without requiring major
     * version bumps everywhere.
     */

    int version;

    /**
     * Offset in the structure where log_level_offset is stored.
     * 0 means there is no such variable
     */
    int log_level_offset_offset;

    /**
     * Offset in the structure where a pointer to the parent context for
     * logging is stored. For example a decoder could pass its AVCodecContext
     * to eval as such a parent context, which an liteav_av_log() implementation
     * could then leverage to display the parent context.
     * The offset can be NULL.
     */
    int parent_log_context_offset;

    /**
     * Return next AVOptions-enabled child or NULL
     */
    void* (*child_next)(void *obj, void *prev);

    /**
     * Return an AVClass corresponding to the next potential
     * AVOptions-enabled child.
     *
     * The difference between child_next and this is that
     * child_next iterates over _already existing_ objects, while
     * child_class_next iterates over _all possible_ children.
     */
    const struct AVClass* (*child_class_next)(const struct AVClass *prev);

    /**
     * Category used for visualization (like color)
     * This is only set if the category is equal for all objects using this class.
     * available since version (51 << 16 | 56 << 8 | 100)
     */
    AVClassCategory category;

    /**
     * Callback to return the category.
     * available since version (51 << 16 | 59 << 8 | 100)
     */
    AVClassCategory (*get_category)(void* ctx);

    /**
     * Callback to return the supported/allowed ranges.
     * available since version (52.12)
     */
    int (*query_ranges)(struct AVOptionRanges **, void *obj, const char *key, int flags);
} AVClass;

/**
 * @addtogroup lavu_log
 *
 * @{
 *
 * @defgroup lavu_log_constants Logging Constants
 *
 * @{
 */

/**
 * Print no output.
 */
#define AV_LOG_QUIET    -8

/**
 * Something went really wrong and we will crash now.
 */
#define AV_LOG_PANIC     0

/**
 * Something went wrong and recovery is not possible.
 * For example, no header was found for a format which depends
 * on headers or an illegal combination of parameters is used.
 */
#define AV_LOG_FATAL     8

/**
 * Something went wrong and cannot losslessly be recovered.
 * However, not all future data is affected.
 */
#define AV_LOG_ERROR    16

/**
 * Something somehow does not look correct. This may or may not
 * lead to problems. An example would be the use of '-vstrict -2'.
 */
#define AV_LOG_WARNING  24

/**
 * Standard information.
 */
#define AV_LOG_INFO     32

/**
 * Detailed information.
 */
#define AV_LOG_VERBOSE  40

/**
 * Stuff which is only useful for libav* developers.
 */
#define AV_LOG_DEBUG    48

/**
 * Extremely verbose debugging, useful for libav* development.
 */
#define AV_LOG_TRACE    56

#define AV_LOG_MAX_OFFSET (AV_LOG_TRACE - AV_LOG_QUIET)

/**
 * @}
 */

/**
 * Sets additional colors for extended debugging sessions.
 * @code
   liteav_av_log(ctx, AV_LOG_DEBUG|AV_LOG_C(134), "Message in purple\n");
   @endcode
 * Requires 256color terminal support. Uses outside debugging is not
 * recommended.
 */
#define AV_LOG_C(x) ((x) << 8)

/**
 * Send the specified message to the log if the level is less than or equal
 * to the current av_log_level. By default, all logging messages are sent to
 * stderr. This behavior can be altered by setting a different logging callback
 * function.
 * @see liteav_av_log_set_callback
 *
 * @param avcl A pointer to an arbitrary struct of which the first field is a
 *        pointer to an AVClass struct or NULL if general log.
 * @param level The importance level of the message expressed using a @ref
 *        lavu_log_constants "Logging Constant".
 * @param fmt The format string (printf-compatible) that specifies how
 *        subsequent arguments are converted to output.
 */
void liteav_av_log(void *avcl, int level, const char *fmt, ...) av_printf_format(3, 4);


/**
 * Send the specified message to the log if the level is less than or equal
 * to the current av_log_level. By default, all logging messages are sent to
 * stderr. This behavior can be altered by setting a different logging callback
 * function.
 * @see liteav_av_log_set_callback
 *
 * @param avcl A pointer to an arbitrary struct of which the first field is a
 *        pointer to an AVClass struct.
 * @param level The importance level of the message expressed using a @ref
 *        lavu_log_constants "Logging Constant".
 * @param fmt The format string (printf-compatible) that specifies how
 *        subsequent arguments are converted to output.
 * @param vl The arguments referenced by the format string.
 */
void liteav_av_vlog(void *avcl, int level, const char *fmt, va_list vl);

/**
 * Get the current log level
 *
 * @see lavu_log_constants
 *
 * @return Current log level
 */
int liteav_av_log_get_level(void);

/**
 * Set the log level
 *
 * @see lavu_log_constants
 *
 * @param level Logging level
 */
void liteav_av_log_set_level(int level);

/**
 * Set the logging callback
 *
 * @note The callback must be thread safe, even if the application does not use
 *       threads itself as some codecs are multithreaded.
 *
 * @see liteav_av_log_default_callback
 *
 * @param callback A logging function with a compatible signature.
 */
void liteav_av_log_set_callback(void (*callback)(void*, int, const char*, va_list));

/**
 * Default logging callback
 *
 * It prints the message to stderr, optionally colorizing it.
 *
 * @param avcl A pointer to an arbitrary struct of which the first field is a
 *        pointer to an AVClass struct.
 * @param level The importance level of the message expressed using a @ref
 *        lavu_log_constants "Logging Constant".
 * @param fmt The format string (printf-compatible) that specifies how
 *        subsequent arguments are converted to output.
 * @param vl The arguments referenced by the format string.
 */
void liteav_av_log_default_callback(void *avcl, int level, const char *fmt,
                             va_list vl);

/**
 * Return the context name
 *
 * @param  ctx The AVClass context
 *
 * @return The AVClass class_name
 */
const char* liteav_av_default_item_name(void* ctx);
AVClassCategory liteav_av_default_get_category(void *ptr);

/**
 * Format a line of log the same way as the default callback.
 * @param line          buffer to receive the formatted line
 * @param line_size     size of the buffer
 * @param print_prefix  used to store whether the prefix must be printed;
 *                      must point to a persistent integer initially set to 1
 */
void liteav_av_log_format_line(void *ptr, int level, const char *fmt, va_list vl,
                        char *line, int line_size, int *print_prefix);

/**
 * Format a line of log the same way as the default callback.
 * @param line          buffer to receive the formatted line;
 *                      may be NULL if line_size is 0
 * @param line_size     size of the buffer; at most line_size-1 characters will
 *                      be written to the buffer, plus one null terminator
 * @param print_prefix  used to store whether the prefix must be printed;
 *                      must point to a persistent integer initially set to 1
 * @return Returns a negative value if an error occurred, otherwise returns
 *         the number of characters that would have been written for a
 *         sufficiently large buffer, not including the terminating null
 *         character. If the return value is not less than line_size, it means
 *         that the log message was truncated to fit the buffer.
 */
int liteav_av_log_format_line2(void *ptr, int level, const char *fmt, va_list vl,
                        char *line, int line_size, int *print_prefix);

/**
 * Skip repeated messages, this requires the user app to use liteav_av_log() instead of
 * (f)printf as the 2 would otherwise interfere and lead to
 * "Last message repeated x times" messages below (f)printf messages with some
 * bad luck.
 * Also to receive the last, "last repeated" line if any, the user app must
 * call liteav_av_log(NULL, AV_LOG_QUIET, "%s", ""); at the end
 */
#define AV_LOG_SKIP_REPEATED 1

/**
 * Include the log severity in messages originating from codecs.
 *
 * Results in messages such as:
 * [rawvideo @ 0xDEADBEEF] [error] encode did not produce valid pts
 */
#define AV_LOG_PRINT_LEVEL 2

void liteav_av_log_set_flags(int arg);
int liteav_av_log_get_flags(void);

enum FFmpegMsgType {
    FFMPEG_MSG_TYPE_DATAREPORT,
};

enum FFmpegDataReportType {
    FFMPEG_DATAREPORT_TYPE_NETERROR = 0,    //Some Net Error happened, will send last error in tcp.c to app
    FFMPEG_DATAREPORT_TYPE_BYTES,           //Size that we got from net this time
    FFMPEG_DATAREPORT_TYPE_REDIRECTIP,      //The redirected ip
    FFMPEG_DATAREPORT_TYPE_SVRCONNECTED,    //The time when svr is connected
    FFMPEG_DATAREPORT_TYPE_DURERROR,        //This ts's duration is different from m3u8's defination
    FFMPEG_DATAREPORT_TYPE_M3U8ERROR,       //This ts's m3u8 is wrong, so we cannot trust its seq_no, and sometimes it may skip 1 Ts_file.
    FFMPEG_DATAREPORT_TYPE_TCPCONNECTTIME,  //Time(in micro seconds) taken for a TCP connection. It's reported for every successful TCP connection.
    FFMPEG_DATAREPORT_TYPE_M3U8DATETIME,     //The value of the #EXT-X-PROGRAM-DATE-TIME tag for the current segment
    FFMPEG_DATAREPORT_TYPE_M3U8ADTIME,      //The value of the #EXT-QQHLS-AD tag for the current segment

    FFMPEG_DATAREPORT_TYPE_GETSTREAMDATATIME, //get stream data at the probe data
    FFMPEG_DATAREPORT_TYPE_TCPRECVERROR, //tcp recv error
    FFMPEG_DATAREPORT_TYPE_REGISTER_ALL_FAIL // av_reigister_all fail
    
};

enum FFmpegNetErrorType {
   NETERROR_TYPE_GETADDR      = 0x00010000,
   NETERROR_TYPE_OPENSOCKET   = 0x00020000,
   NETERROR_TYPE_BINDFAIL     = 0x00030000,
   NETERROR_TYPE_LISTENFAIL   = 0x00040000,
   NETERROR_TYPE_POLLFAIL     = 0x00050000,
   NETERROR_TYPE_ACCEPTFAIL   = 0x00060000,
   NETERROR_TYPE_RECV         = 0x00070000,
   NETERROR_TYPE_READTIMEOUT  = 0x00080000,
   NETERROR_TYPE_SEND         = 0x00090000,
   NETERROR_TYPE_WRITETIMEOUT = 0x000A0000,
   NETERROR_TYPE_OPENTIMEOUT  = 0x000B0000,
   NETERROR_TYPE_OTHER        = 0x40000000,
};

typedef void (*av_msg_callback_t)(int, int, const char*, int, void*);

// This function is a little tricky.
// There's no simple way to send a customized message to the caller with a specific context,
// so we take the AVIOInterruptCB->opaque as the context. But AVIOInterruptCB is defined in
// avformat module, to avoid compiling errors, we define a macro here to access the opaque field.
//
#define INTERRUPT_CB_OPAQUE(pCb)    (pCb ? pCb->opaque : NULL)
void liteav_av_msg(int nMsgType, int nSubType, const char* pucMsgBuf, int nBufSize, void* pContext);

void liteav_av_msg_set_callback(av_msg_callback_t cb);

/**
 * @}
 */

#endif /* AVUTIL_LOG_H */
