#include "internal/c/parts/video/font/ttf/src/freetypeamalgam.h"
//The following license applies to utf8decode() and associated data only
// Copyright (c) 2008-2010 Bjoern Hoehrmann <bjoern@hoehrmann.de>
// See http://bjoern.hoehrmann.de/utf-8/decoder/dfa/ for details.
/* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#define UTF8_ACCEPT 0
#define UTF8_REJECT 1
static const uint8_t utf8d[] = {
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, // 00..1f
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, // 20..3f
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, // 40..5f
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, // 60..7f
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9, // 80..9f
  7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7, // a0..bf
  8,8,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, // c0..df
  0xa,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x4,0x3,0x3, // e0..ef
  0xb,0x6,0x6,0x6,0x5,0x8,0x8,0x8,0x8,0x8,0x8,0x8,0x8,0x8,0x8,0x8, // f0..ff
  0x0,0x1,0x2,0x3,0x5,0x8,0x7,0x1,0x1,0x1,0x4,0x6,0x1,0x1,0x1,0x1, // s0..s0
  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,1, // s1..s2
  1,2,1,1,1,1,1,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1, // s3..s4
  1,2,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,1,1,1,1,1,1, // s5..s6
  1,3,1,1,1,1,1,3,1,3,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1, // s7..s8
};

uint32_t inline
utf8decode(uint32_t* state, uint32_t* codep, uint32_t byte) {
  uint32_t type = utf8d[byte];

  *codep = (*state != UTF8_ACCEPT) ?
    (byte & 0x3fu) | (*codep << 6) :
    (0xff >> type) & (byte);

  *state = utf8d[256 + *state*16 + type];
  return *state;
}
/**************************************************************/

struct fonts_struct { //copied from parts/video/font/ttf/src.c
  uint8 in_use;
  uint8 *ttf_data;
  int32 default_pixel_height;
  uint8 bold;
  uint8 italic;
  uint8 underline;
  uint8 monospace;
  int32 monospace_width;
  uint8 unicode;
  //---------------------------------
  FT_Face handle;
  int32 baseline;
  float default_pixel_height_scale;
};
extern img_struct *write_page;
extern int32 *font;
extern fonts_struct *fonts;

FT_Face get_fhandle() {
  return fonts[font[write_page->font]].handle;
}

int get_defheight() {
  return fonts[font[write_page->font]].default_pixel_height;
}

int gp2px(int gp) {
  return (float)gp / get_fhandle()->units_per_EM * get_defheight();
}

int uheight() {
  switch (write_page->font) {
    case 8: return 9;
    case 14: return 15;
    case 16: return 17;
  }
  return gp2px(get_fhandle()->ascender - get_fhandle()->descender);
}

int uascension() {
  switch (write_page->font) {
    case 8: return 9;
    case 14: return 13;
    case 16: return 14;
  }
  return gp2px(get_fhandle()->ascender);
}

int uspacing() {
  if (write_page->font < 32) return write_page->font;
  return gp2px(get_fhandle()->height) + 2;
}

extern uint8 charset8x8[256][8][8];
extern uint8 charset8x16[256][16][8];

#ifdef QB64_64
void uprint_extra(int32 startx, int32 starty, int64 str_in, int64 bytelen, int32 kern_wanted, int32 do_render, int32 *txtwidth, int64 charpos, int32 *chars, uint32 colour, int32 max_width) {
#else
void uprint_extra(int32 startx, int32 starty, int32 str_in, int64 bytelen, int32 kern_wanted, int32 do_render, int32 *txtwidth, int64 charpos, int32 *chars, uint32 colour, int32 max_width) {
#endif
  int builtin = 0;
  if (write_page->font < 32) {
    builtin = 1;
  }
 
  uint8 *str = (uint8 *)str_in;
  uint32 cpindex, prev_state = 0, cur_state = 0, cp;
  uint8 *builtin_start;
  int cur_cpindex = 0;
  FT_Face fhandle;
  int prev_glyph = 0, glyph_index, error, kern;
  FT_Vector kern_delta;
  int pen_x, pen_y, draw_x, draw_y, pixmap_x, pixmap_y;
  float alpha;
  unsigned int rgb;

  pen_x = startx;
  pen_y = starty;
  if (builtin) {
    pen_y += 2;
  }
  else {   
    fhandle = get_fhandle();
    pen_y += uascension();
    if (FT_HAS_KERNING(fhandle) && kern_wanted) kern = 1; else kern = 0;
  }
 
  alpha = (colour >> 24) / 255.0;
  rgb = colour & 0xffffff;

  for (cpindex = 0; cpindex < bytelen; prev_state = cur_state, cpindex++) {
    //if (pen_x > im->width || pen_y > im->height) break;
    if (max_width && (pen_x > startx + max_width)) break;
    if (charpos) ((int32*)charpos)[cur_cpindex] = pen_x - startx;
   
    switch (utf8decode(&cur_state, &cp, str[cpindex])) {
    case UTF8_ACCEPT:
      //good codepoint
      cur_cpindex++;
      break;
    case UTF8_REJECT:
      //codepoint would be U+FFFD (replacement character)
      cp = 0xfffd;
      cur_state = UTF8_ACCEPT;
      if (prev_state != UTF8_ACCEPT) cpindex--;
      cur_cpindex++;
      break;
    default:
      //need to read continuation bytes
      continue;
      break;
    }
   
    if (builtin) {
      if (max_width && (pen_x + 8 > startx + max_width)) break;
      if (cp > 255) continue;
      switch (write_page->font) {
	case 8: builtin_start = &charset8x8[cp][0][0]; break;
	case 14: builtin_start = &charset8x16[cp][1][0]; break;
	case 16: builtin_start = &charset8x16[cp][0][0]; break;
      }
      if (do_render) {
	for (draw_y = pen_y, pixmap_y = 0; pixmap_y < write_page->font; draw_y++, pixmap_y++) {
	  for (draw_x = pen_x, pixmap_x = 0; pixmap_x < 8; draw_x++, pixmap_x++) {
	    if (*builtin_start++) pset_and_clip(draw_x, draw_y, colour);
	  }
	}
      }
      pen_x += 8;
    }
    else {
      glyph_index = FT_Get_Char_Index(fhandle, cp);

      if (kern && prev_glyph && glyph_index) {
        FT_Get_Kerning(fhandle, prev_glyph, glyph_index, FT_KERNING_DEFAULT, &kern_delta);
        pen_x += gp2px(kern_delta.x);
      }
 
      error = FT_Load_Glyph(fhandle, glyph_index, FT_LOAD_DEFAULT);
      if (error) continue;
      error = FT_Render_Glyph(fhandle->glyph, FT_RENDER_MODE_NORMAL);
      if (error) continue;

      if (max_width && (pen_x + fhandle->glyph->bitmap.width > startx + max_width)) break;
      if (do_render) {
	for (draw_y = pen_y - fhandle->glyph->bitmap_top, pixmap_y = 0; pixmap_y < fhandle->glyph->bitmap.rows; draw_y++, pixmap_y++) {
	  for (draw_x = pen_x + fhandle->glyph->bitmap_left, pixmap_x = 0; pixmap_x < fhandle->glyph->bitmap.width; draw_x++, pixmap_x++) {
	    pset_and_clip(draw_x, draw_y, ((int)(fhandle->glyph->bitmap.buffer[pixmap_y * fhandle->glyph->bitmap.width + pixmap_x] * alpha) << 24) | rgb);
	  }
	}
      }
      pen_x += fhandle->glyph->advance.x / 64;
      prev_glyph = glyph_index;
    }
   
    if (txtwidth) *txtwidth = pen_x - startx;
    if (chars) *chars = cur_cpindex;
  }
  if (charpos) ((int32*)charpos)[cur_cpindex] = pen_x - startx;
}

int32 uprint(int32 startx, int32 starty, char *str_in, int64 bytelen, uint32 colour, int32 max_width) {
  int32 txtwidth;
#ifdef QB64_64
  uprint_extra(startx, starty, (int64)str_in, bytelen, -1, 1, &txtwidth, 0, 0, colour, max_width);
#else
  uprint_extra(startx, starty, (int32)str_in, bytelen, -1, 1, &txtwidth, 0, 0, colour, max_width);
#endif
  return txtwidth;
}

int32 uprintwidth(char *str_in, int64 bytelen, int32 max_width) {
  int32 txtwidth;
#ifdef QB64_64
  uprint_extra(0, 0, (int64)str_in, bytelen, -1, 0, &txtwidth, 0, 0, 0, max_width);
#else
  uprint_extra(0, 0, (int32)str_in, bytelen, -1, 0, &txtwidth, 0, 0, 0, max_width);
#endif
  return txtwidth;
}
