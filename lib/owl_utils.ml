(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

(** Helper functions used in the library *)

let range a b =
  let r = Array.make (b - a + 1) 0 in
  for i = a to b do r.(i - a) <- i done; r

let filteri_array f x =
  let atype = snd (f 0 x.(0)) in
  let r = Array.make (Array.length x) atype and c = ref 0 in
  for i = 0 to Array.length x - 1 do
    let y, z = f i x.(i) in
    if y = true then (r.(!c) <- z; c := !c + 1)
  done;
  Array.sub r 0 !c

let filter_array f x = filteri_array (fun _ y -> f y) x

let mapi_array f x =
  let atype = f 0 x.(0) in
  let r = Array.make (Array.length x) atype in
  for i = 0 to Array.length x - 1 do
    r.(i) <- f i x.(i)
  done; r

let map_array f x = mapi_array (fun _ y -> f y) x

let reverse_array x =
  let d = Array.length x - 1 in
  let n = d / 2 in
  for i = 0 to n do
    let t = x.(i) in
    x.(i) <- x.(d - i);
    x.(d - i) <- t;
  done

(* get the suffix a file name *)
let get_suffix s =
  let parts = Str.(split (regexp "\\.")) s in
  List.(nth parts (length parts - 1))

(* deal with the issue: OCaml 4.02.3 does not have Array.iter2
  eventually we need to move to OCaml 4.03.0 *)
let array_iter2 f x y =
  let c = min (Array.length x) (Array.length y) in
  for i = 0 to c - 1 do
    f x.(i) y.(i)
  done

let array_iter3 f x y z =
  let c = min (Array.length x) (Array.length y) |> min (Array.length z) in
  for i = 0 to c - 1 do
    f x.(i) y.(i) z.(i)
  done

let array_map2i f x y =
  let c = min (Array.length x) (Array.length y) in
  Array.init c (fun i -> f i x.(i) y.(i))

let array_sum x = Array.fold_left (+.) 0. x

let array1_iter f x =
  let open Bigarray in
  for i = 0 to Array1.dim x - 1 do
    f (Array1.unsafe_get x i)
  done

let array1_iteri f x =
  let open Bigarray in
  for i = 0 to Array1.dim x - 1 do
    f i (Array1.unsafe_get x i)
  done

(* extend passed in array by appending n slots *)
let array1_extend x n =
  let open Bigarray in
  let m = Array1.dim x in
  let y = Array1.(create (kind x) c_layout (m + n)) in
  let z = Array1.sub y 0 m in
  Array1.blit x z;
  y

(* make a copy of the passed in array1 *)
let array1_clone x =
  let open Bigarray in
  let y = Array1.(create (kind x) c_layout (dim x)) in
  Array1.blit x y;
  y
