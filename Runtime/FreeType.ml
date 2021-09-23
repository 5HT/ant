
open XNum;

type face;
type glyph_slot;

external ft_init_freetype         : unit -> unit                                = "Wrapper_FT_Init_FreeType";
external ft_new_face              : string -> face                              = "Wrapper_FT_New_Face";
external ft_attach_file           : face -> string -> int                       = "Wrapper_FT_Attach_File";
external wrapper_ft_set_char_size : face -> int -> int -> unit                  = "Wrapper_FT_Set_Char_Size";
external ft_get_char_index        : face -> int -> int                          = "Wrapper_FT_Get_Char_Index";
external ft_get_first_char        : face -> (int * int)                         = "Wrapper_FT_Get_First_Char";
external ft_get_next_char         : face -> (int * int) -> (int * int)          = "Wrapper_FT_Get_Next_Char";
external ft_load_glyph            : face -> int -> int -> unit                  = "Wrapper_FT_Load_Glyph";
external ft_get_kerning           : face -> int -> int -> int -> (int * int)    = "Wrapper_FT_Get_Kerning";
external ft_get_postscript_name   : face -> string                              = "Wrapper_FT_Get_Postscript_Name";
external face_num_glyphs          : face -> int                                 = "face_num_glyphs";
external face_glyph               : face -> glyph_slot                          = "face_glyph";
external face_metrics             : face -> (int * int * int * int * int * int) = "face_metrics";
external glyph_metrics            : glyph_slot -> (int * int * int * int * int) = "glyph_metrics";
external ft_get_glyph_name        : face -> int -> string                       = "get_glyph_name";
external ft_is_sfnt               : face -> bool                                = "is_sfnt";
external ft_is_postscript         : face -> bool                                = "is_postscript";
external ft_has_ps_glyph_names    : face -> bool                                = "has_ps_glyph_names";
external ft_glyph_to_bitmap       : glyph_slot -> (int * int * int * int * int * string)
                                                                                = "glyph_to_bitmap";

value ft_load_default       =    0;
value ft_load_no_scale      =    1;
value ft_load_no_hinting    =    2;
value ft_load_render        =    4;
value ft_load_monochrome    = 4096;
value ft_load_linear_design = 8192;

value ft_kerning_default    =    0;
value ft_kerning_unfitted   =    1;
value ft_kerning_unscaled   =    2;

value ft_set_char_size face size dpi = do
{
  wrapper_ft_set_char_size face (int_of_num (round_num (size */ num_of_int 64))) dpi
};

value ft_get_glyph face index = do
{
  ft_load_glyph face index 0;

  face_glyph face
};

value glyph_to_bitmap glyph = do
{
  let (left, top, rows, width, pitch, buffer) = ft_glyph_to_bitmap glyph;

  (left,
   top,
   {
     Bitmap.bm_width         = width;
     Bitmap.bm_height        = rows;
     Bitmap.bm_bytes_per_row = pitch;
     Bitmap.bm_data          = buffer
   })
};

