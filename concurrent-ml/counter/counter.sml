


(* counts up  *)

structure Counter = struct

  open CML

  fun makeCounter n = let
      val ch = channel ()
      fun count s = (send (ch, s); count (s+n))
  in
      (* initial value sent to count procedure will be n *)
      spawn (fn () => count n);
      ch
  end

  fun printFirstN n ch =
    if n <= 0 then ()
    else
      (TextIO.print (Int.toString (recv ch) ^ "\n");
       printFirstN (n-1) ch)
	  
  fun main () =
    let val ch = makeCounter(3)
    in
      printFirstN 30 ch;
      TextIO.print "Done\n"
    end

  (* Run the program
     Counter.run
   *)
  fun run () = RunCML.doit (main, NONE);
		
end

