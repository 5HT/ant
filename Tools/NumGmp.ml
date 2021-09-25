
(* stub to replace Num by Gmp *)

open Gmp;

type num = Q.t;

value num_of_int  x   = Q.make_int x 1;
value num_of_ints x y = Q.make_int x y;
value float_of_num    = Q.to_float;
value string_of_num   = Q.to_string;

value num_zero      = Q.zero;
value num_one       = num_of_int 1;
value num_minus_one = num_of_int (-1);
value num_two       = num_of_int 2;
value num_three     = num_of_int 3;
value num_ten       = num_of_int 10;

value sgn x = Q.compare x Q.zero;
value equal_int x y = Z.compare_int x y = 0;

value add_num     = Q.add;
value minus_num   = Q.neg;
value sub_num     = Q.sub;
value mult_num    = Q.mul;
value div_num     = Q.div;
value sign_num    = sgn;
value compare_num = Q.compare;

value square_num x = mult_num x x;

value is_integer_num x = equal_int (Q.den x) 1;

value power_num_int x exp = do
{
  if exp = 0 then
    num_one
  else if exp > 0 then
    Q.make_z (Z.pow_int (Q.num x) exp)
              (Z.pow_int (Q.den x) exp)
  else
    Q.make_z (Z.pow_int (Q.den x) (~-exp))
              (Z.pow_int (Q.num x) (~-exp))
};

value power_num x y = do
{
  if is_integer_num y then
    power_num_int x (Z.to_int (Q.num y))
  else
    invalid_arg "power_num"
};

value abs_num x = do
{
  match sgn x with
  [ (-1) -> Q.neg x
  | _    -> x
  ]
};

value succ_num x = Q.add x num_one;
value pred_num x = Q.sub x num_one;

value incr_num x = !x := succ_num !x;
value decr_num x = !x := pred_num !x;

value fdiv_q x y = fst (Gmp.Z.fdiv x y);
value cdiv_q x y = fst (Gmp.Z.cdiv x y);

value floor_num   x = Q.of_z (fdiv_q (Q.num x) (Q.den x));
value ceiling_num x = Q.of_z (cdiv_q (Q.num x) (Q.den x));

value integer_num x = do
{
  let n = Q.num x;
  let d = Q.den x;

  let (q,r) = Z.tdiv n d;

  if Z.compare_int n 0 < 0 then
    if Z.add d r < r then
      Q.of_z (Z.sub_int q 1)
    else
      Q.of_z q
  else
    if Z.sub d r < r then
      Q.of_z (Z.add_int q 1)
    else
      Q.of_z q
};
value round_num x = do
{
  let n = Q.num x;
  let d = Q.den x;

  let (q,r) = Z.tdiv n d;

  if Z.compare_int n 0 < 0 then
    if Z.add d r <= r then
      Q.of_z (Z.sub_int q 1)
    else
      Q.of_z q
  else
    if Z.sub d r <= r then
      Q.of_z (Z.add_int q 1)
    else
      Q.of_z q
};

value quo_num x y = floor_num (div_num x y);
value mod_num x y = sub_num x (mult_num y (quo_num x y));

value eq_num x y = (Q.compare x y) =  0;
value lt_num x y = (Q.compare x y) <  0;
value le_num x y = (Q.compare x y) <= 0;
value gt_num x y = (Q.compare x y) >  0;
value ge_num x y = (Q.compare x y) >= 0;

value max_num x y = do
{
  if lt_num x y then y else x
};
value min_num x y = do
{
  if gt_num x y then y else x
};

value land_num x y = do
{
  if is_integer_num x && is_integer_num y then
    Q.of_z (Z.logand (Q.num x) (Q.num y))
  else
    invalid_arg "land_num"
};

value lor_num x y = do
{
  if is_integer_num x && is_integer_num y then
    Q.of_z (Z.logor (Q.num x) (Q.num y))
  else
    invalid_arg "lor_num"
};

value lxor_num x y = do
{
  if is_integer_num x && is_integer_num y then
    Q.of_z (Z.logxor (Q.num x) (Q.num y))
  else
    invalid_arg "lxor_num"
};

value lneg_num x = do
{
  if is_integer_num x then
    Q.of_z (Z.lognot (Q.num x))
  else
    invalid_arg "lneg_num"
};

value num_of_string s = do
{
  try
    let n = String.index s '/';

    Q.make_z (Z.of_string (String.sub s 0 n))
             (Z.of_string (String.sub s (n+1) (String.length s - n - 1)))
  with
  [ Not_found -> Q.of_z (Z.of_string s) ]
};

value int_of_num x = do
{
  if is_integer_num x then
    Z.to_int (Q.num x)
  else
    failwith "integer argument required"
};

value num_of_float x = do
{
  let (f, n) = frexp x;
  let factor = power_num_int num_two n;
  let str    = string_of_float f;
  let len    = String.length str;

  if str.[0] = '-' then do
  {
    let factor2 = power_num_int num_ten (len - 3);
    let z       = if str.[1] = '1' then         (* check whether str = "-1." *)
                    num_one
                  else
                    num_of_string (String.sub str 3 (len - 3));

    minus_num (z */ factor // factor2)
  }
  else do
  {
    let factor2 = power_num_int num_ten (len - 2);
    let z       = if str.[0] = '1' then         (* check whether str = "1." *)
                    num_one
                  else
                    num_of_string (String.sub str 2 (len - 2));

    z */ factor // factor2
  }
};

value serialise_num os x = do
{
  let n = Q.num x;
  let d = Q.den x;

  let s1 = Z.of_based_string 16 (Z.to_string n);
  let s2 = Z.of_based_string 16 (Z.to_string d);

  let l1 = String.length (Z.to_string s1);
  let l2 = String.length (Z.to_string s2);

  let b10 = l1          land 0xff;
  let b11 = (l1 lsr  8) land 0xff;
  let b12 = (l1 lsr 16) land 0xff;
  let b13 = (l1 lsr 24) land 0xff;
  let b20 = l2          land 0xff;
  let b21 = (l2 lsr  8) land 0xff;
  let b22 = (l2 lsr 16) land 0xff;
  let b23 = (l2 lsr 24) land 0xff;

  IO_Base.io_write_char os (char_of_int b13);
  IO_Base.io_write_char os (char_of_int b12);
  IO_Base.io_write_char os (char_of_int b11);
  IO_Base.io_write_char os (char_of_int b10);
  IO_Base.io_write_char os (char_of_int b23);
  IO_Base.io_write_char os (char_of_int b22);
  IO_Base.io_write_char os (char_of_int b21);
  IO_Base.io_write_char os (char_of_int b20);
  IO_Base.io_write_string os (Z.to_string s1);
  IO_Base.io_write_string os (Z.to_string s2);
};

value unserialise_num is = do
{
  let b13 = int_of_char (IO_Base.io_read_char is);
  let b12 = int_of_char (IO_Base.io_read_char is);
  let b11 = int_of_char (IO_Base.io_read_char is);
  let b10 = int_of_char (IO_Base.io_read_char is);
  let b23 = int_of_char (IO_Base.io_read_char is);
  let b22 = int_of_char (IO_Base.io_read_char is);
  let b21 = int_of_char (IO_Base.io_read_char is);
  let b20 = int_of_char (IO_Base.io_read_char is);

  let len1 = b10 lor (b11 lsl 8) lor (b12 lsl 16) lor (b13 lsr 24);
  let len2 = b20 lor (b21 lsl 8) lor (b22 lsl 16) lor (b23 lsr 24);

  let s1 = IO_Base.io_read_string is len1;
  let s2 = IO_Base.io_read_string is len2;

  let d = Z.of_based_string 16 s1;
  let n = Z.of_based_string 16 s2;

  Q.make_z d n
};

