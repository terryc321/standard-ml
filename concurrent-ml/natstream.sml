


(* natstream.sml - natural numbers as a stream  *)

structure NatStream = struct

  open CML

  fun makeNatStream () = let
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
    let val ch = makeNatStream ()
    in
      printFirstN 10000000 ch;
      TextIO.print "Done\n"
    end

end

(* Run the program *)
val _ = RunCML.doit (NatStream.main, NONE);


			  

		    
