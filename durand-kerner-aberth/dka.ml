(** dka.ml --- Durand-Kerner-Aberth method

    [MIT Lisence] Copyright (C) 2015 Akinori ABE
*)

open Format
open Complex

let fold_lefti f init x =
  let acc = ref init in
  for i = 0 to Array.length x - 1 do acc := f i !acc x.(i) done;
  !acc

let for_all2 f x y =
  assert(Array.length x = Array.length y);
  let rec aux i =
    if i < 0 then true
    else if f x.(i) y.(i) then aux (i - 1)
    else false
  in
  aux (Array.length x - 1)

let ( +! ) = add
let ( -! ) = sub
let ( *! ) = mul
let ( /! ) = div

let pi = 3.14159265358979

(** [roots_initvals ?r [c(n); ...; c(2); c(1); c(0)]] computes
    initial values for [roots] by Aberth's method.
    @param r a radius of a circle containing all roots on complex plane
 *)
let roots_init_vals ?(r = 1000.) cs =
  let n = Array.length cs in
  if n < 2 then invalid_arg "roots_init_vals: #coefficients < 2";
  let n = n - 1 in (* the order of a given polynominal *)
  let s = pi /. float n in
  let t = cs.(1) /! (cs.(0) *! { re = ~-. (float n); im = 0. }) in
  Array.init n
    (fun i ->
       let angle = s *. (2.0 *. float i +. 0.5) in
       t +! ({ re=r; im=0. } *! (exp { re=0.; im=angle })))

(** [roots ?epsilon ?init [c(n); ...; c(2); c(1); c(0)]] computes roots of a
    polynominal [c(n)*x**n + ... + c(2)*x**2 + c(1)*x + c(0)] by using the
    Durand-Kerner method.
 *)
let roots ?(epsilon = 1e-6) ?init cs =
  let zs = match init with (* initial values of roots *)
    | None -> roots_init_vals cs
    | Some zs0 -> zs0 in
  let calc_poly x = Array.fold_left (fun acc ci -> acc *! x +! ci) zero cs in
  let cn = cs.(0) in (* c(n) *)
  let rec update_z zs = (* update z(0), ..., z(n-1) until they converge *)
    let update_zi zs i zi = (* update z(i) *)
      let deno = fold_lefti
          (fun j acc zj -> if i = j then acc else acc *! (zi -! zj)) cn zs in
      zi -! calc_poly zi /! deno
    in
    let zs' = Array.mapi (update_zi zs) zs in (* new z(0),...,z(n-1) *)
    if for_all2 (fun zi zi' -> norm2 (zi -! zi') < epsilon) zs zs'
    then zs' (* converged! *)
    else update_z zs'
  in
  update_z zs

let main () =
  (* -300 + 320 x - 59 x^2 - 26 x^3 + 5 x^4 + 2 x^5 = 0 *)
  let cs = [|
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(320.); im=0. };
    { re=(-300.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(320.); im=0. };
    { re=(-300.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(30.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(32.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(30.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(30.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(320.); im=0. };
    { re=(-10.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-6.); im=0. };
    { re=(-5.); im=0. };
    { re=(32.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-5.); im=0. };
    { re=(320.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-2.); im=0. };
    { re=(-59.); im=0. };
    { re=(320.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(32.); im=0. };
    { re=(-300.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(32.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(320.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(30.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-26.); im=0. };
    { re=(-59.); im=0. };
    { re=(32.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
    { re=(-6.); im=0. };
    { re=(-9.); im=0. };
    { re=(30.); im=0. };
    { re=(-30.); im=0.};
    { re=2.; im=0. };
    { re=5.; im=0. };
  |] in
  roots cs

let c = Gc.get ()
let () = Gc.set
    { c with Gc.minor_heap_size = 32000000;
             Gc.space_overhead = max_int }

let gather t =
  t.Unix.tms_utime +. t.Unix.tms_stime +. t.Unix.tms_cutime +. t.Unix.tms_cstime

let () =
  let t1 = Unix.times () in
  main ();
  let t2 = Unix.times () in
  Format.printf "%f %d %d\n" (gather t2 -. gather t1) (Must.get_gen ()) (Must.get_mono ())
