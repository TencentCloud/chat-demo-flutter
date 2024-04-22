#include "third_party/ffmpeg/ffmpeg_rename_defines.h" // add by source_replacer.py 
/*
 * SSA/ASS spliting functions
 * Copyright (c) 2010  Aurelien Jacobs <aurel@gnuage.org>
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

#ifndef AVCODEC_ASS_SPLIT_H
#define AVCODEC_ASS_SPLIT_H

/**
 * fields extracted from the [Script Info] section
 */
typedef struct {
    char *script_type;    /**< SSA script format version (eg. v4.00) */
    char *collisions;     /**< how subtitles are moved to prevent collisions */
    int   play_res_x;     /**< video width that ASS coords are referring to */
    int   play_res_y;     /**< video height that ASS coords are referring to */
    float timer;          /**< time multiplier to apply to SSA clock (in %) */
} ASSScriptInfo;

/**
 * fields extracted from the [V4(+) Styles] section
 */
typedef struct {
    char *name;           /**< name of the tyle (case sensitive) */
    char *font_name;      /**< font face (case sensitive) */
    int   font_size;      /**< font height */
    int   primary_color;  /**< color that a subtitle will normally appear in */
    int   secondary_color;
    int   outline_color;  /**< color for outline in ASS, called tertiary in SSA */
    int   back_color;     /**< color of the subtitle outline or shadow */
    int   bold;           /**< whether text is bold (1) or not (0) */
    int   italic;         /**< whether text is italic (1) or not (0) */
    int   underline;      /**< whether text is underlined (1) or not (0) */
    int   strikeout;
    float scalex;
    float scaley;
    float spacing;
    float angle;
    int   border_style;
    float outline;
    float shadow;
    int   alignment;      /**< position of the text (left, center, top...),
                               defined after the layout of the numpad
                               (1-3 sub, 4-6 mid, 7-9 top) */
    int   margin_l;
    int   margin_r;
    int   margin_v;
    int   alpha_level;
    int   encoding;
} ASSStyle;

/**
 * fields extracted from the [Events] section
 */
typedef struct {
    int   readorder;
    int   layer;    /**< higher numbered layers are drawn over lower numbered */
    int   start;    /**< start time of the dialog in centiseconds */
    int   end;      /**< end time of the dialog in centiseconds */
    char *style;    /**< name of the ASSStyle to use with this dialog */
    char *name;
    int   margin_l;
    int   margin_r;
    int   margin_v;
    char *effect;
    char *text;     /**< actual text which will be displayed as a subtitle,
                         can include style override control codes (see
                         liteav_ff_ass_split_override_codes()) */
} ASSDialog;

/**
 * structure containing the whole split ASS data
 */
typedef struct {
    ASSScriptInfo script_info;   /**< general information about the SSA script*/
    ASSStyle     *styles;        /**< array of split out styles */
    int           styles_count;  /**< number of ASSStyle in the styles array */
    ASSDialog    *dialogs;       /**< array of split out dialogs */
    int           dialogs_count; /**< number of ASSDialog in the dialogs array*/
} ASS;

typedef enum {
    ASS_STR,
    ASS_INT,
    ASS_FLT,
    ASS_COLOR,
    ASS_TIMESTAMP,
    ASS_ALGN,
} ASSFieldType;

typedef struct {
    const char *name;
    int type;
    int offset;
} ASSFields;

typedef struct {
    const char *section;
    const char *format_header;
    const char *fields_header;
    int         size;
    int         offset;
    int         offset_count;
    ASSFields   fields[24];
} ASSSection;

static const ASSSection ass_sections[] = {
    { .section       = "Script Info",
      .offset        = offsetof(ASS, script_info),
      .fields = {{"ScriptType", ASS_STR, offsetof(ASSScriptInfo, script_type)},
                 {"Collisions", ASS_STR, offsetof(ASSScriptInfo, collisions) },
                 {"PlayResX",   ASS_INT, offsetof(ASSScriptInfo, play_res_x) },
                 {"PlayResY",   ASS_INT, offsetof(ASSScriptInfo, play_res_y) },
                 {"Timer",      ASS_FLT, offsetof(ASSScriptInfo, timer)      },
                 {0},
        }
    },
    { .section       = "V4+ Styles",
      .format_header = "Format",
      .fields_header = "Style",
      .size          = sizeof(ASSStyle),
      .offset        = offsetof(ASS, styles),
      .offset_count  = offsetof(ASS, styles_count),
      .fields = {{"Name",            ASS_STR,   offsetof(ASSStyle, name)           },
                 {"Fontname",        ASS_STR,   offsetof(ASSStyle, font_name)      },
                 {"Fontsize",        ASS_INT,   offsetof(ASSStyle, font_size)      },
                 {"PrimaryColour",   ASS_COLOR, offsetof(ASSStyle, primary_color)  },
                 {"SecondaryColour", ASS_COLOR, offsetof(ASSStyle, secondary_color)},
                 {"OutlineColour",   ASS_COLOR, offsetof(ASSStyle, outline_color)  },
                 {"BackColour",      ASS_COLOR, offsetof(ASSStyle, back_color)     },
                 {"Bold",            ASS_INT,   offsetof(ASSStyle, bold)           },
                 {"Italic",          ASS_INT,   offsetof(ASSStyle, italic)         },
                 {"Underline",       ASS_INT,   offsetof(ASSStyle, underline)      },
                 {"StrikeOut",       ASS_INT,   offsetof(ASSStyle, strikeout)      },
                 {"ScaleX",          ASS_FLT,   offsetof(ASSStyle, scalex)         },
                 {"ScaleY",          ASS_FLT,   offsetof(ASSStyle, scaley)         },
                 {"Spacing",         ASS_FLT,   offsetof(ASSStyle, spacing)        },
                 {"Angle",           ASS_FLT,   offsetof(ASSStyle, angle)          },
                 {"BorderStyle",     ASS_INT,   offsetof(ASSStyle, border_style)   },
                 {"Outline",         ASS_FLT,   offsetof(ASSStyle, outline)        },
                 {"Shadow",          ASS_FLT,   offsetof(ASSStyle, shadow)         },
                 {"Alignment",       ASS_INT,   offsetof(ASSStyle, alignment)      },
                 {"MarginL",         ASS_INT,   offsetof(ASSStyle, margin_l)       },
                 {"MarginR",         ASS_INT,   offsetof(ASSStyle, margin_r)       },
                 {"MarginV",         ASS_INT,   offsetof(ASSStyle, margin_v)       },
                 {"Encoding",        ASS_INT,   offsetof(ASSStyle, encoding)       },
                 {0},
        }
    },
    { .section       = "V4 Styles",
      .format_header = "Format",
      .fields_header = "Style",
      .size          = sizeof(ASSStyle),
      .offset        = offsetof(ASS, styles),
      .offset_count  = offsetof(ASS, styles_count),
      .fields = {{"Name",            ASS_STR,   offsetof(ASSStyle, name)           },
                 {"Fontname",        ASS_STR,   offsetof(ASSStyle, font_name)      },
                 {"Fontsize",        ASS_INT,   offsetof(ASSStyle, font_size)      },
                 {"PrimaryColour",   ASS_COLOR, offsetof(ASSStyle, primary_color)  },
                 {"SecondaryColour", ASS_COLOR, offsetof(ASSStyle, secondary_color)},
                 {"TertiaryColour",  ASS_COLOR, offsetof(ASSStyle, outline_color)  },
                 {"BackColour",      ASS_COLOR, offsetof(ASSStyle, back_color)     },
                 {"Bold",            ASS_INT,   offsetof(ASSStyle, bold)           },
                 {"Italic",          ASS_INT,   offsetof(ASSStyle, italic)         },
                 {"BorderStyle",     ASS_INT,   offsetof(ASSStyle, border_style)   },
                 {"Outline",         ASS_FLT,   offsetof(ASSStyle, outline)        },
                 {"Shadow",          ASS_FLT,   offsetof(ASSStyle, shadow)         },
                 {"Alignment",       ASS_ALGN,  offsetof(ASSStyle, alignment)      },
                 {"MarginL",         ASS_INT,   offsetof(ASSStyle, margin_l)       },
                 {"MarginR",         ASS_INT,   offsetof(ASSStyle, margin_r)       },
                 {"MarginV",         ASS_INT,   offsetof(ASSStyle, margin_v)       },
                 {"AlphaLevel",      ASS_INT,   offsetof(ASSStyle, alpha_level)    },
                 {"Encoding",        ASS_INT,   offsetof(ASSStyle, encoding)       },
                 {0},
        }
    },
    { .section       = "Events",
      .format_header = "Format",
      .fields_header = "Dialogue",
      .size          = sizeof(ASSDialog),
      .offset        = offsetof(ASS, dialogs),
      .offset_count  = offsetof(ASS, dialogs_count),
      .fields = {{"Layer",   ASS_INT,        offsetof(ASSDialog, layer)   },
                 {"Start",   ASS_TIMESTAMP,  offsetof(ASSDialog, start)   },
                 {"End",     ASS_TIMESTAMP,  offsetof(ASSDialog, end)     },
                 {"Style",   ASS_STR,        offsetof(ASSDialog, style)   },
                 {"Name",    ASS_STR,        offsetof(ASSDialog, name)    },
                 {"MarginL", ASS_INT,        offsetof(ASSDialog, margin_l)},
                 {"MarginR", ASS_INT,        offsetof(ASSDialog, margin_r)},
                 {"MarginV", ASS_INT,        offsetof(ASSDialog, margin_v)},
                 {"Effect",  ASS_STR,        offsetof(ASSDialog, effect)  },
                 {"Text",    ASS_STR,        offsetof(ASSDialog, text)    },
                 {0},
        }
    },
};

struct ASSSplitContext {
    ASS ass;
    int current_section;
    int field_number[FF_ARRAY_ELEMS(ass_sections)];
    int *field_order[FF_ARRAY_ELEMS(ass_sections)];
};

/**
 * This struct can be casted to ASS to access to the split data.
 */
typedef struct ASSSplitContext ASSSplitContext;

/**
 * Split a full ASS file or a ASS header from a string buffer and store
 * the split structure in a newly allocated context.
 *
 * @param buf String containing the ASS formatted data.
 * @return Newly allocated struct containing split data.
 */
ASSSplitContext *liteav_ff_ass_split(const char *buf);

/**
 * Split one or several ASS "Dialogue" lines from a string buffer and store
 * them in an already initialized context.
 *
 * @param ctx Context previously initialized by liteav_ff_ass_split().
 * @param buf String containing the ASS "Dialogue" lines.
 * @param cache Set to 1 to keep all the previously split ASSDialog in
 *              the context, or set to 0 to free all the previously split
 *              ASSDialog.
 * @param number If not NULL, the pointed integer will be set to the number
 *               of split ASSDialog.
 * @return Pointer to the first split ASSDialog.
 */
ASSDialog *liteav_ff_ass_split_dialog(ASSSplitContext *ctx, const char *buf,
                               int cache, int *number);

/**
 * Free a dialogue obtained from liteav_ff_ass_split_dialog2().
 */
void liteav_ff_ass_free_dialog(ASSDialog **dialogp);

/**
 * Split one ASS Dialogue line from a string buffer.
 *
 * @param ctx Context previously initialized by liteav_ff_ass_split().
 * @param buf String containing the ASS "Dialogue" line.
 * @return Pointer to the split ASSDialog. Must be freed with liteav_ff_ass_free_dialog()
 */
ASSDialog *liteav_ff_ass_split_dialog2(ASSSplitContext *ctx, const char *buf);

/**
 * Free all the memory allocated for an ASSSplitContext.
 *
 * @param ctx Context previously initialized by liteav_ff_ass_split().
 */
void liteav_ff_ass_split_free(ASSSplitContext *ctx);


/**
 * Set of callback functions corresponding to each override codes that can
 * be encountered in a "Dialogue" Text field.
 */
typedef struct {
    /**
     * @defgroup ass_styles    ASS styles
     * @{
     */
    void (*text)(void *priv, const char *text, int len);
    void (*new_line)(void *priv, int forced);
    void (*style)(void *priv, char style, int close);
    void (*color)(void *priv, unsigned int /* color */, unsigned int color_id);
    void (*alpha)(void *priv, int alpha, int alpha_id);
    void (*font_name)(void *priv, const char *name);
    void (*font_size)(void *priv, int size);
    void (*alignment)(void *priv, int alignment);
    void (*cancel_overrides)(void *priv, const char *style);
    /** @} */

    /**
     * @defgroup ass_functions    ASS functions
     * @{
     */
    void (*move)(void *priv, int x1, int y1, int x2, int y2, int t1, int t2);
    void (*origin)(void *priv, int x, int y);
    /** @} */

    /**
     * @defgroup ass_end    end of Dialogue Event
     * @{
     */
    void (*end)(void *priv);
    /** @} */
} ASSCodesCallbacks;

/**
 * Split override codes out of a ASS "Dialogue" Text field.
 *
 * @param callbacks Set of callback functions called for each override code
 *                  encountered.
 * @param priv Opaque pointer passed to the callback functions.
 * @param buf The ASS "Dialogue" Text field to split.
 * @return >= 0 on success otherwise an error code <0
 */
int liteav_ff_ass_split_override_codes(const ASSCodesCallbacks *callbacks, void *priv,
                                const char *buf);

/**
 * Find an ASSStyle structure by its name.
 *
 * @param ctx Context previously initialized by liteav_ff_ass_split().
 * @param style name of the style to search for.
 * @return the ASSStyle corresponding to style, or NULL if style can't be found
 */
ASSStyle *liteav_ff_ass_style_get(ASSSplitContext *ctx, const char *style);

#endif /* AVCODEC_ASS_SPLIT_H */
