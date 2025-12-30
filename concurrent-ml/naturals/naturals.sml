


(* natural numbers as a stream  *)

structure Naturals = struct

  open CML

  fun makeNaturals () = let
      val ch = channel ()
      fun count i = (send (ch, i); count (i+1))
  in
      spawn (fn () => count 0);
      ch
  end

  fun printFirstN n ch =
    if n <= 0 then ()
    else
      (TextIO.print (Int.toString (recv ch) ^ "\n");
       printFirstN (n-1) ch)

  fun main () =
    let val ch = makeNaturals ()
    in
      printFirstN 1000 ch;
      TextIO.print "Done\n"
    end

  (* Run the program
   * Naturals.run()
   *)
  fun run () = RunCML.doit (main, NONE);
	
end





			  

		    
