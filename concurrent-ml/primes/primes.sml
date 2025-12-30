

(* primes.sml - prime numbers as a stream  *)
(* this version tries to store up the primes found into a list  *)
(* we can enable timings on all toplevel evaluations by starting sml with compiler.timings flag true *)
(* sml -Ccompiler.timings=true *)
			   
structure Primes = struct

  open CML

  (* val counter : int -> (int chan) ; *)
  fun counter n m = let
      val ch = channel()
      fun count n = (send(ch, n); count(n+m))
  in
      spawn (fn () => count n);
      ch
  end	   
			     
  (* p is a prime number , inCh channel of int ,
   * returns a channel with multiples of p removed
   *) 
  fun filter (p, inCh) = let
      val outCh = channel()
      (* for some int i if not divisible by p - ie mod non zero then keep that int i
         otherwise loop *)
      fun loop () = let val i = recv inCh
		    in
			if ((i mod p)<> 0) then send (outCh, i) else ();
			loop ()
		    end
  in
      spawn loop;
      outCh
  end

  fun sieve () = let
      val primes = channel ()
      fun head ch = let val p = recv ch
		    in
			send (primes, p);
			head (filter (p, ch))
		    end
  in
      spawn (fn () => head (counter 2 1));
      primes
  end
			     
  fun primes n = let
      val ch = sieve ()
      fun loop (0, l) = rev l
	| loop (i, l) = loop (i-1, (recv ch)::l)
  in
      loop (n, [])
  end

  fun printList [] = ()
    | printList (x::xs) = 
      (TextIO.print (Int.toString x ^ " ");
       printList xs);

		     
  fun main (n) = let val p = primes(n)
		in ( printList p ; () )
		end

  fun timeIt f x =
  let
    val timer = Timer.startCPUTimer ()
    val result = f x
    val {usr, sys} = Timer.checkCPUTimer timer
  in
    TextIO.print ("Elapsed CPU time: " ^ Time.toString (Time.+ (usr, sys)) ^ " s\n");
    result
  end

(* (* Usage *) *)
(* val result = timeIt (fn () => someExpensiveComputation ()) (); *)
		     
  (* Run the program - think main has to be thunk *)
  fun run n = RunCML.doit (fn () => main(n), NONE);
  fun runWithTimeout n lim = RunCML.doit (fn () => main(n), SOME(Time.fromSeconds lim));
end





			  

		    
