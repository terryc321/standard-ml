
(* fibonacci - version 1 *)
(* uses pure luck to avoid deadlock  *)

(* conventional fibonacci counter which we will check our synchronous concurrent network against *)


(* be cautious of sml reserved keywords of in let val fn *)
(* orthodox version of fibonacci with side effects  *)
structure Ortho = struct
open IntInf;
open CML;

  (* simple object when given NEXT it computes next fib , VALUE it returns value *)
  datatype t = NEXT | VALUE ;

  (* val foo : t -> int ; *)
  fun foo () =
      let val a = ref (1 : IntInf.int)
	  val b = ref (1 : IntInf.int)
          val c = ref 0		      
      in 
     	  let fun frob opp =
		  if !c = 0 then (c := 1; 1)
		  else if !c = 1 then ( c := 2; 1)
		  else 
		      case opp of
			  NEXT => let val s = !a + !b
				  in
				      (b := !a;
				       a := s;
				       s)
				  end
			| VALUE => !a
	  in
	      frob
	  end
      end
  (* collect say some large number of items *)

  fun fibby n = let  	  
      fun collect 0 f acc = acc
	| collect n f acc = collect (n-1) f (f(NEXT)  :: acc)
  in
      collect n (foo ()) [] 
  end

  				
				
end


structure Fib = struct
open IntInf;
open CML;
  
  fun forever init f = let
      fun loop s = loop (f s)
  in
      ignore (spawn (fn () => loop init))
  end
	   
  fun add (inCh1, inCh2, outCh) =
      forever () (fn () =>
		     send (outCh, (recv inCh1) + (recv inCh2)))

  fun delay init (inCh, outCh) =
      forever init (
	  fn NONE => SOME(recv inCh)
	| (SOME x) => (send(outCh, x); NONE)
      (* end fn *))

  fun copy (inCh, outCh1, outCh2) =
      forever () (fn () => let
		      val x = recv inCh
		  in
		      send(outCh1, x); send(outCh2, x)
		  end)

  (* page 50 section 3.3 Implementing fibonacci network *)
  (* russian roulette whether we get deadlock - depending on placement of delay copy add and sends *)
  (* in this instance - it has been carefully worked out for us to avoid deadlock	       *)
  fun mkFibNetwork () = let
      val outCh = channel()
      val c1 = channel() and c2 = channel() and c3 = channel()
      val c4 = channel() and c5 = channel()
  in
      delay (SOME (0 : IntInf.int)) (c4, c5);
      copy (c2, c3, c4);
      add (c3, c5, c1);
      copy (c1, c2, outCh);
      send (c1, 1 : IntInf.int );
      outCh
  end

  fun fibs n = let
      val ch = mkFibNetwork ()
      val gen = Ortho.foo ()

      (* Skip first two 1's from network and advance orthodox twice *)
      val _ = recv ch
      val _ = recv ch
      val _ = gen Ortho.NEXT
      val _ = gen Ortho.NEXT

      fun loop 0 = ()
	| loop i = let
            val v = recv ch
            val _ = TextIO.print ("out -> " ^ IntInf.toString v ^ "\n")
            val v2 = gen Ortho.NEXT
	in
            if v = v2 then loop (i-1)
            else raise Fail "Fibonacci mismatch!"
	end
  in
      loop n
  end
		   
			    
  (* pull one value from channel and print it and go get next one *)
  fun fibs n = let
      val ch = mkFibNetwork ()
      val gen = Ortho.foo ()
      val (ct : IntInf.int ref) = ref 0
      fun loop 0 = 0
	| loop i = let val v = recv ch
	               val v2 = gen Ortho.NEXT				    
		   in
		       (ct := !ct + 1 ; 
		        TextIO.print ("out -> " ^ (IntInf.toString (!ct)) ^ "\n");
		       	if v = v2 then loop (i + 1)
			else raise Fail ("Fibonacci mismatch ! "))
		   end
  in
      loop n
  end

 (* smlnj - caution  *)		   
  (* if running CML and output hangs ie prints nothing when expecting something
     and using compatible CML version of TextIO.print
    - do the logical thing - restart smlnj
    - may also be a bug in emacs + sml-mode comint for extremely large text output
      generated on fibonacci run
   *)		   
		   
  fun main () = (fibs 1; ())

  (* OS.Process.status of 1 indicates success *)
  (*  			 0 means failed  *)
  (* val it = 1 : OS.Process.status *)
  fun run () = RunCML.doit (main, NONE);

end





			  

		    
