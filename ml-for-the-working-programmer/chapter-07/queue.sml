
(*
a queue is somewhat like you see at supermarket .

en-queue enq people join the back of the queue .

people served from the front of the queue.
people this is a first in , first out system

*)

structure Queue1 =
struct
type 'a t = 'a list;
exception E ;
val empty = [];
(* en-queue : put someone at the end of the queue *)
fun enq(q,x) = q @ [x ];  (* @ is append*)
fun null (x :: q) = false  (* :: is cons operator *)
  | null _ = true;
fun hd (x ::q) = x
  | hd [] = raise E ;    (* [] is empty list  *)
fun deq(x ::q) = q   (* de-queue : take someone from the front of the shopping queue  *)
  | deq [] = raise E ;  (* raises an exception E  *)
end;


Queue1.deq ["We","happy","few"];


structure Queue2 =
struct
datatype 'a t = empty
	       | enq of 'a t * 'a;
exception E ;
fun null (enq _) = false
  | null empty   = true;
fun hd (enq(empty,x )) = x
  | hd (enq(q,x ))     = hd q
  | hd empty           = raise E ;
fun deq (enq(empty,x )) = empty
  | deq (enq(q,x ))     = enq(deq q, x )
  | deq empty           = raise E ;
end;



fun last (Queue2.enq(q,x )) = x ;

(* datatype should start with upper case letter Empty rather than empty
 - section 4.4 ml-for-the-working-programmer
 from : page 265 2nd edition chapter 7 section 7.3 representing queues as pairs of lists              
 *)

val tmp = Queue2.empty;


structure Queue3 =
struct
datatype 'a t = Queue of ('a list * 'a list);
exception E ;
val empty = Queue([],[]);
fun norm (Queue([],tails)) = Queue(rev tails, [])
  | norm q = q;
fun enq(Queue(heads,tails), x ) = norm(Queue(heads, x ::tails));
fun null (Queue([],[])) = true
  | null _ = false;
fun hd (Queue(x ::_,_)) = x
  | hd (Queue([],_)) = raise E ;
fun deq(Queue(x ::heads,tails)) = norm(Queue(heads,tails))
  | deq(Queue([],_)) = raise E ;
end;


(* observation - none of the internals are hidden
   users can tamper with constructor Queue3 
   calling Queue3.norm serves no purpose from outside perspective
*)


(*
7.4 all three queue implementations share the same common
    interface 
*)

signature QUEUE =
sig
    type 'a t (*type of queues*)
    exception E (*for errors in hd, deq*)
    val empty: 'a t (*the empty queue*)
    val enq : 'a t * 'a -> 'a t (*add to end*)
    val null : 'a t -> bool (*test for empty queue*)
    val hd : 'a t -> 'a (*return front element*)
    val deq : 'a t -> 'a t  (*remove from front*)
end;


structure S1: QUEUE = Queue1;
structure S2: QUEUE = Queue2;
structure S3: QUEUE = Queue3;


S1.deq ["We","band","of","brothers"];

val Queue3.Queue(heads,tails) =
    S3.enq(S3.enq(S3.empty,"Saint"), "Crispin");

(*
7.5 signature constraints 
    data abstraction is compromised
    user can test queue equality by comparing lists
    which may not be correct

  using symbol :> instead of colon : makes the constraint opaque
The constraint hides all informationa about the new
structure except its signature

Constrain the concrete structures by creating abstract queues
*)
structure AbsQueue1 :> QUEUE = Queue1;
structure AbsQueue2 :> QUEUE = Queue2;
structure AbsQueue3 :> QUEUE = Queue3;

(*
structure AbsQueue1 represents queues by lists , but we
cannot see this

if we try this we get an error 

> AbsQueue1.deq ["We","band","of","brothers"];

> AbsQueue3.empty = AbsQueue3.empty;
/tmp/emacs-regionbNHxGU:1.2-1.35 Error: operator and operand do not agree [equality type required]
  operator domain: ''Z * ''Z
  operand:         'Y AbsQueue3.t * 'X AbsQueue3.t
  in expression:
    AbsQueue3.empty = AbsQueue3.empty
val it = () : unit


we can simply constrain the original declaration 
structure Queue :> QUEUE = struct ... end;

7.5 Limitations.

An opaque signature constraint is perfect for declaring an abstract
type of queues. The abstract structure can be made from an existing concrete
structure, as in the AbsQueue declarations above, or we can simply constrain
the original structure declaration:

structure Queue :> QUEUE = struct . . . end;

But the two kinds of signature constraints give us an all-or-nothing choice,
which is awkward for complex abstract types. Signature DICTIONARY spec-
ifies two types: key is the type of search keys; α t is the type of dictionaries
(see Section 4.14). Type α t should be abstract, but key should be something
concrete, like string. Otherwise, we should have no way to refer to keys; we
should be unable to call lookup and update! The next section describes a more
flexible approach to declaring abstract types

But the two kinds of signature constraints give us an all-or-nothing choice,
which is awkward for complex abstract types.

7.6 The abstype declaration

Standard ML has a declaration form specifically intended for declaring
abstract types. It hides the representation fully, including the equality test. The
abstype declaration originates from the first ML dialect and reflects the early
thinking of the structured programming school. Now it looks distinctly dated.

 *)




