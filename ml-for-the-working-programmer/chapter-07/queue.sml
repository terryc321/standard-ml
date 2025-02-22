
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
But it is more selective than an opaque constraint: it applies to chosen types
instead of an entire signature.

A simple abstype declaration contains two elements, a datatype binding
DB and a declaration D:

abstype DB with D end

A datatype binding is a type name followed by constructor descriptions, exactly
as they would appear in a datatype declaration. The constructors are visible
within the declaration part, D, which must use them to implement all operations
associated with the abstract type. Identifiers declared in D are visible outside,
as is the type, but its constructors are hidden. Moreover, the type does not admit
equality testing.
To illustrate the abstype declaration, let us apply it to queues. The dec-
laration ought to be enclosed in a structure to prevent name clashes with the
built-in list functions null and hd . But as a structure would complicate the ex-
ample, those functions have instead been renamed. Exceptions are omitted to
save space.
Queues as lists. We begin with Representation 1. Although list is already a
datatype, the abstype declaration forces us to use a new constructor (Q1) in
all the queue operations. This constructor is traditionally called the abstraction
function, as it maps concrete representations to abstract values.

 *)

abstype 'a queue1
	= Q1 of 'a list  with
val empty = Q1 [];
fun enq(Q1 q, x ) = Q1 (q @ [x ]);
fun qnull (Q1(x ::q)) = false
  | qnull _ = true;
fun qhd (Q1(x ::q)) = x ;
fun deq(Q1(x ::q)) = Q1 q;
end;

(*

The abstype declaration has hidden the connection between queue1 and list.
Queues as a new datatype. Now turn to Representation 2. Previously we called
the constructors empty and enq, with lower case names, for use outside as val-
ues. And that was naughty. But the abstype declaration hides the construc-
tors. We may as well give them capitalised names Empty and Enq, since we
must now export their values explicitly:

*)


abstype 'a queue2 = Empty
		  | Enq of 'a queue2 * 'a
					   with
val empty = Empty
and enq = Enq
fun qnull (Enq _) = false
  | qnull Empty = true;
fun qhd (Enq(Empty,x )) = x
  | qhd (Enq(q,x )) = qhd q;
fun deq (Enq(Empty,x )) = Empty
  | deq (Enq(q,x )) = Enq(deq q, x );
end;

(*

We do not need to declare a new constructor Q2 because this representation
requires its own constructors. ML’s response is identical to its response to the
declaration of queue1 except for the name of the queue type. An external user
can operate on queues only by the exported operations.
These two examples illustrate the main features of abstype. We do not
need to see the analogous declaration of queue3.
Abstract types in ML: summary. ML’s treatment of abstract types is less straight-
forward than one might like, but it can be reduced to a few steps. If you would
like to declare a type t and allow access only by operations you have chosen to
export, here is how to proceed.
1 Consider whether to export the equality test for t. It is only appropriate
if the representation admits equality, and if this equality coincides with
equality of the abstract values. Also consider whether equality testing
would actually be useful. Equality testing is appropriate for small ob-
jects such as dates and rational numbers, but not for matrices or flexible
arrays.7.7 Inferred signatures for structures
273
2 Declare a signature SIG specifying the abstract type and its operations.
The signature must specify t as an eqtype if it is to admit equality,
and as a type otherwise.
3 Decide which sort of signature constraint to use with SIG. An opaque
constraint is suitable only if all the types in the signatures are intended
to be abstract.
4 Write the shell of a structure (or functor) declaration, attaching the con-
straint chosen in the previous step.
5 Within the brackets struct and end, declare type t and the desired
operations. If you used a transparent signature constraint, this must be
either a datatype declaration (to export equality) or an abstype
declaration (to hide equality).
A datatype declaration can yield an abstract type because the signature con-
straint hides the constructors. An abstype or datatype declaration creates
a fresh type, which ML regards as distinct from all others.
Functor Dictionary exemplifies the first approach (see page 286). The ring
buffer structure RingBuf exemplifies the second (see page 339).

*)

(*
7.7
Inferred signatures for structures
A structure declaration can appear without a signature constraint, as in
the declarations of Queue1, Queue2 and Queue3. ML then infers a signature
fully describing the structure’s internal details.274

7 Abstract Types and Functors

Signature QUEUE1 is equivalent to the signature that is inferred for structure
Queue1. It specifies α t as an eqtype — a type that admits equality — because
lists can be compared for equality. Observe that the types of values involve type
α list instead of α t, as in signature QUEUE.

*)

signature QUEUE1 =
sig
    eqtype 'a t
    exception E
    val empty : 'a list
    val enq : 'a list * 'a -> 'a list
    val null : 'a list -> bool
    val hd : 'a list -> 'a
    val deq : 'a list -> 'a list
end;

(*
The signature inferred for Queue2 specifies α t as a datatype with construc-
tors empty and enq; constructors are not specified again as values. The signa-
ture could be declared as follows:
*)

signature QUEUE2 =
sig
    datatype 'a t = empty | enq of 'a t * 'a
    exception E
    val null : 'a t -> bool
    val hd : 'a t -> 'a
    val deq : 'a t -> 'a t
end;

(** can we see signature definition from standard ml repl ?

 **)

(*
The signature inferred for structure Queue3 again specifies α t as a datatype
— not merely a type, as in signature QUEUE. All items in the structure are
specified, including Queue and norm.
*)


signature QUEUE3 =
sig
    datatype 'a t = Queue of 'a list * 'a list
    exception E
    val empty : 'a t
    val enq   : 'a t * 'a -> 'a t
    val null  : 'a t -> bool
    val hd    : 'a t -> 'a
    val deq   : 'a t -> 'a t
    val norm  : 'a t -> 'a t
end;

(*
These signatures are more concrete and specific than QUEUE.

No structure can be an instance of more than one of them.

Consider QUEUE1 and QUEUE3.

Function hd must have type α list → α to satisfy QUEUE1;
it must have type α t → α to satisfy QUEUE3
which also specifies that α t is a datatype clearly different from α list.

On the other hand, each signature has many different instances. A struc-
ture can satisfy the specification val x :int by declaring x to be any value
of type int.

It can satisfy the specification type t by declaring t to be any
type.

(However, it can satisfy a datatype specification only by an identical
datatype declaration.)

A structure may include items not specified in the
signature.

Thus, a signature defines a class of structures.

Interesting relationships hold among these classes.

We have already seen that QUEUE1, QUEUE2 and QUEUE3 are disjoint. The latter two are contained
in QUEUE; an instance of QUEUE2 or QUEUE3 is an instance of QUEUE. An
instance of QUEUE1 is an instance of QUEUE only if it makes type α t equivalent
to α list. These containments can be shown in a Venn diagram:



*)



(*
Functors

An ML function is an expression that takes parameters. Applying it
substitutes argument values for the parameters. The value of the resulting ex-
pression is returned. A function can only be applied to arguments of the correct
type.

We have several implementations of queues. Could we write code that uses
queues but is independent of any particular implementation? This seems to re-
quire taking a structure as a parameter.

Functions themselves can be parameters, for functions are values in ML. Rec-
ords are also values. They are a bit like structures, but they cannot represent
queue implementations because they cannot have types and exception construc-
tors as components.

An ML functor is a structure that takes other structures as parameters. Ap-
plying it substitutes argument structures for the parameters. The bindings that
arise from the resulting structure are returned. A functor can only be applied to
arguments that match the correct signature.

Functors let us write program units that can be combined in different ways. A
replacement unit can quickly be linked in, and the new system tested. Functors
can also express generic algorithms.

Let us see how they do so.

7.8 Testing the queue structures

Here is a simple test harness for queues. Given a queue structure, it
returns a testing structure containing two functions. One converts a list to a
queue; the other is the inverse operation. The test harness is declared as a functor
with argument signature QUEUE:
*)

functor TestQueue (Q: QUEUE ) =
struct
fun fromList l = foldl (fn (x ,q) => Q.enq(q,x )) Q.empty l ;
fun toList q =
    if Q.null q then []
    else Q.hd q :: toList (Q.deq q);
end;

(*

functor TestQueue(Q: sig
  type 'a t
  exception E
  val empty : 'a t
  val enq : 'a t * 'a -> 'a t
  val null : 'a t -> bool
  val hd : 'a t -> 'a
  val deq : 'a t -> 'a t
end) :
sig
  val fromList : 'a list -> 'a Q.t
  val toList : 'a Q.t -> 'a list
end

The functor body refers not to existing queue structures but to the argument Q.
The two functions exercise the queue operations uniformly. Any queue structure
can be tested and its efficiency measured. Let us start with Queue3. Applying
the functor to this argument yields a new structure, which we name TestQ3.
The components of TestQ3 are functions to test Queue3, as can be seen from
their types:
structure TestQ3 = TestQueue (Queue3);
> structure TestQ3 :
>
sig
>
val fromList : ’a list -> ’a Queue3.t
>
val toList
: ’a Queue3.t -> ’a list
>
end
The test data is just the list of integers from 1 to 10,000:7.8 Testing the queue structures
277
val ns = upto(1,10000);
> val ns = [1, 2, 3, 4, ...] : int list
val q3 = TestQ3.fromList ns;
> val q3 = Queue ([1], [10000, 9999, 9998, 9997, ...])
> : int Queue3.t
val l 3 = TestQ3.toList q3;
> val l3 = [1, 2, 3, 4, ...] : int list
l 3 = ns;
> true : bool
Queue3 passes its first test: we get back the original list. It is also efficient,
taking 10 msec to build q3 and 50 msec to convert it back to a list.
ML ’s response to the declaration of q3 reveals its representation as a pair of
lists: Queue3 does not define an abstract type. We ought to try structure Abs-
Queue3. Again we apply the functor and give the resulting structure a name:
structure TestAQ3 = TestQueue (AbsQueue3);
> structure TestAQ3 :
>
sig
>
val fromList : ’a list -> ’a AbsQueue3.t
>
val toList
: ’a AbsQueue3.t -> ’a list
>
end
val q = TestAQ3.fromList ns;
> val q = - : int AbsQueue3.t
Now ML reveals nothing about the representation. In terms of efficiency, Queue3
and AbsQueue3 are indistinguishable. Similar measurements reveal that Abs-
Queue3 is orders of magnitude faster than Queue1 and Queue2 and much
faster than the balanced tree representation suggested in Exercise 7.4. Because
Queue1 represents queues by lists, it could implement fromList and toList ef-
ficiently, but only operations specified in signature QUEUE are allowed in the
functor body.
A more realistic test would involve an application of queues, such as breadth-
first search. Function breadthFirst (Section 5.17) used lists instead of queues,
for simplicity. A functor can express the search strategy independently from the
implementation of queues.
functor BreadthFirst (Q: QUEUE ) =
struct
fun enqlist q xs = foldl (fn (x ,q) => Q.enq(q,x )) q xs;
fun search next x =
let fun bfs q =
if Q.null q then Nil else
let val y = Q.hd q
in Cons(y, fn()=> bfs (enqlist (Q.deq q) (next y)))
end278
7 Abstract Types and Functors
in bfs (Q.enq(Q.empty, x ))
end;
> functor BreadthFirst : <sig>
end;
The function enqlist appends a list of elements to a queue. Let us apply the
functor to an efficient queue structure:
structure Breadth = BreadthFirst (Queue3);
> structure Breadth :
>
sig
>
val enqlist : ’a Queue3.t -> ’a list -> ’a Queue3.t
>
val search : (’a -> ’a list) -> ’a -> ’a seq
>
end
The function Breadth.search is equivalent to breadthFirst, but runs a lot faster.
Most languages have nothing comparable to functors. The C programmer
obtains a similar effect using header and include files. Primitive methods such
as these go a long way, but they do not forgive errors. Including the wrong file
means the wrong code is compiled: we get a cascade of error messages. What
happens if a functor is applied to the wrong sort of structure? Try applying
BreadthFirst to the standard library structure List:
structure Wrong = BreadthFirst (List);
> Error: unmatched type spec: t
> Error: unmatched exception spec: E
> Error: unmatched val spec: empty
> Error: unmatched val spec: enq
> Error: unmatched val spec: deq
We get specific error messages describing what is missing from the argument.
There is no complaint about the absence of hd and null because List has com-
ponents with those names.
Taking the queue structure as a parameter may be a needless complication.
AbsQueue3 is the best queue structure; we may as well rename it Queue and
use it directly, just as we use standard library structures such as List. But often
we have a choice. There are several possible representations for dictionaries
and priority queues. Even the standard library admits competing structures for
real arithmetic. And when we consider generic operations, the case for functors
becomes unassailable.
*)
