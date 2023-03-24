#include "third_party/ffmpeg/ffmpeg_rename_defines.h" // add by source_replacer.py 
/*
 * Copyright (c) 2009 Baptiste Coudurier <qoroliang@tencent.com>
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

#ifndef AVUTIL_PTHREAD_HELPER_H
#define AVUTIL_PTHREAD_HELPER_H

/**
 * Wait for a task
 *
 * @param poll_max_count            poll max count
 * @param poll_interval_time        poll interval time, in microsecond
 *
 * @return poll count
 *
 */

int liteav_ff_wait_thread(int poll_max_count, int poll_interval_time, int *running);

#ifdef _WIN32
unsigned long pthread_self();
#endif

#endif
