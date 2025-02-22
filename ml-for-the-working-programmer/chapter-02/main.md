
# Chapter 2 Names Functions and Types


```
1 + 2 ;
3.2 - 1.2;
Math.sqrt 2.0 ;
```


## 2.1 Value declarations

```
val seconds = 60;
  val minutes = 60;
  val hours = 24;
  val product = seconds * minutes * hours ;
  val seconds_in_hour = seconds * minutes ;
  val pi = 3.14159265;
  val r = 2.0;
  val area = pi * r * r;
```

Redundant it

Whilst the book mentions use of it , to refer to last expression evaluated at the toplevel
in the repl , cannot use it in code because it is not defined there.

## 2.2 Declaring functions

```
val area = fn r => pi * r * r;
  area( 2.0 );
  area 1.0 ;
  (* sometimes an extra semi colon is helpful *)
  val pi = 0.0 ;
  area 3.0 ;
  (* area continues to work - see static binding *)
```

## 2.3 Identifiers in standard ml

An alphabetic name must begin with a letter, which may be followed
by any number of letters, digits, underscores (_), or primes (’), usually called
single quotes. For instance:

```
x UB40 Hamlet_Prince_of_Denmark h’’3_H
```

The case of letters matters, so q differs from Q. Prime characters are allowed
because ML was designed by mathematicians, who like variables called x , x' , x'' .

When choosing names, be certain to avoid ML’s keywords:

```
abstype and andalso as case datatype do else end eqtype exception fn fun functor handle
if in include infix infixr let local nonfix of op open orelse raise rec sharing sig
signature struct structure then type val where while with withtype

Watch especially for the short ones: as, fn, if, in, of, op.
```

Perhaps emacs can warn us about this by highlighting words differently.

Symbolic names

```
! % & $ # + - * / : < = > ? @ \ ˜ ‘ ˆ |
```

Reserved special characters - these cannot form part of symbol name

```
: | = => -> # :>
```

Addendum : the vertical bar appears in both symbolic name and reserved special characters

Numbers, character strings and truth values
The simplest ML values are integer and real numbers, strings and characters, and the booleans or truth values. This section introduces these types with
their constants and principal operations.

## 2.4 Arithmetic

ML distinguishes between integers (type int) and real numbers (type real). Integer arithmetic is exact (with unlimited precision in some ML systems)
while real arithmetic is only as accurate as the computer’s floating-point hardware.

### Integers. An integer constant is a sequence of digits, possibly beginning with a minus sign (˜).
For instance:

```
0 ˜23 01234 ˜85601435654678

  ~ is minus sign , unfortunate.
```

Integer operations include addition (+), subtraction (-), multiplication (*), division (div) and remainder (mod).

These are infix operators with conventional precedences: thus in

Real numbers. A real constant contains a decimal point or E notation, or both.

For instance:

```
0.01 2.718281828 ˜1.2E12 7E˜5
```

The ending En means ‘times the nth power of 10.’ A negative exponent begins
with the unary minus sign (˜). Thus 123.4E˜2 denotes 1.234.
Negative real numbers begin with unary minus (˜).

Infix operators for reals include addition (+), subtraction (-), multiplication (*) and division (/).

### 2.4.2 Function Application Precedence

Function application binds more tightly than infix operators.

For instance, area a + b is equivalent to (area a) + b, not area (a + b).

### 2.4.3 Exponents are not signed

Neither + nor - may appear in the exponent of a real number.

E`3 or E3 , but never E-3 or E+3 as might be expected

```
fun square x = x * x ;
```

Book says the definiton of square gives an error , but defaults to assume x is an int .

Here below , we say the argument to square is a real number 

```
(* type of x is real  *)
fun square (x:real) = x * x ;
```

Here below , we say that the Or we can specify the end result of square

```
(* type of square is ? -> real *)
fun square x : real = x * x ;
```

If argument in definition is a name , just assumed no type has been declared.

Arithmetic and the standard library

Int.abs , absolute value

Int.max , maximum of two fix ints 

Int.min , minimum of two fix ints 

Int.mod , the remainder operation

Int.div , the division operation

## 2.5 Strings and Characters

Messages and other text are strings of characters. They have type string.
String constants are written in double quotes:

```
"How now! a rat? Dead, for a ducat, dead!";
> "How now! a rat? Dead, for a ducat, dead!" : string
```


The concatenation operator (ˆ) joins two strings end-to-end:

```
"Fair " ˆ "Ophelia";
> "Fair Ophelia" : string
```

The built-in function size returns the number of characters in a string. Here it

refers to "Fair Ophelia":

```
size (it);
> 12 : int
```

The space character counts, of course. The empty string contains no characters;

```
size("");
> 0
```



Here is a function that makes noble titles:

```
fun title(name) = "The Duke of " ˆ name;
> val title = fn : string -> string
title "York";
> "The Duke of York" : string
```


### Escape sequences

```
Special characters. Escape sequences, which begin with a backslash (\), insert
certain special characters into a string. Here are some of them:

- \n inserts a newline character (line break).
- \t inserts a tabulation character.
- \" inserts a double quote.
- \\ inserts a backslash.
- \ followed by a newline and other white-space characters, followed by
another \ inserts nothing, but continues a string across the line break.
Here is a string containing newline characters:

"This above all:\nto thine own self be true\n";
```

## Characters 

The type char. Just as the number 3 differs from the set {3}, a character differs
from a one-character string. Characters have type char . The constants have the
form #s, where s is a string constant consisting of a single character. Here is a
letter, a space and a special character:
#"a" #" " #"\n"

The functions ord and chr convert between characters and character codes.
Most implementations use the ASCII character set; if k is in the
range 0 ≤ k ≤ 255 then chr (k) returns the character with code k. Conversely, ord(c)
is the integer code of the character c. We can use these to convert a number
between 0 and 9 to a character between #"0" and #"9":

```
fun digit i = chr(i + ord #"0");
> val digit = fn : int -> char
```



The functions str and String.sub convert between characters and strings. If c
is a character then str (c) is the corresponding string. Conversely, if s is a string
then String.sub(s, n) returns the nth character in s, counting from zero. Let
us try these, first expressing the function digit differently:

```
fun digit i = String.sub("0123456789", i);
> val digit = fn : int -> char
```

```
str (digit 5);
> "5" : string
```

The second definition of digit is preferable to the first, as it does not rely on
character codes.

Strings, characters and the standard library. Structure String contains numerous operations on strings. Structure Char provides functions such as isDigit,
isAlpha, etc., to recognize certain classes of character. A substring is a contiguous
subsequence of characters from a string; structure Substring provides operations for
extracting and manipulating them.

The ML Definition only has type string (Milner et al., 1990). The standard library
introduces the type char . It also modifies the types of built-in functions such as ord
and chr , which previously operated on single-character strings.

===============================================================================================================================================================

## 2.6 Truth values and conditional expressions

To define a function by cases — where the result depends on the outcome of a test — we employ a conditional expression.1 The test is an expression E of type bool, whose values are true and false. The outcome of the test
chooses one of two expressions E1 or E2. The value of the conditional expression
if E then E1 else E2
1 Because a Standard ML expression can update the state, conditional expressions can also act like the if commands of procedural languages.
is that of E1 if E equals true, and that of E2 if E equals false. The else part
is mandatory.
The simplest tests are the relations:
• less than (<)
• greater than (>)
• less than or equals (<=)
• greater than or equals (>=)
These are defined on integers and reals; they also test alphabetical ordering on
strings and characters. Thus the relations are overloaded and may require type
constraints. Equality (=) and its negation (<>) can be tested for most types.
For example, the function sign computes the sign (1, 0, or −1) of an integer.
It has two conditional expressions and a comment.
fun sign(n) =
if n>0 then 1
else if n=0 then 0
else (*n<0*) ˜1;
> val sign = fn : int ->int
Tests are combined by ML’s boolean operations:
• logical or (called orelse)
• logical and (called andalso)
• logical negation (the function not)
Functions that return a boolean value are known as predicates. Here is a predicate to test whether its argument, a character, is a lower-case letter:
fun isLower c = #"a" <= c andalso c <= #"z";
> val isLower = fn : char -> bool
When a conditional expression is evaluated, either the then or the else expression is evaluated, never both. The boolean operators andalso and orelse
behave differently from ordinary functions: the second operand is evaluated only
if necessary. Their names reflect this sequential behaviour.
==============================================================================================================================================================

## Pairs, tuples and records

(a,b);

```
val zerovec = (0,0);
val a = (1.5,6.8);
val b = (3.6, 0.9);
fun lengthvec (x ,y) = Math.sqrt ( x * x + y * y );
lengthvec a ;
lengthvec b ;
fun negvec (x : real ,y : real) = (~x , ~y) ;
negvec (1.0,1.0);
val bn = negvec b;
type vec = real * real ;
```

==============================================================================================================================================================

## 2.8 Functions with multiple arguments and results

```
fun average (x,y) = (x + y) / 2.0;
average(3.1,3.3);
((2.0,3.5),zerovec);

(* needed to add type constraint on addvec - smlnj assume int *)
fun addvec ((x1,y1),(x2,y2)) : real * real  = (x1+x2,y1+y2);
addvec((8.9,4.4),b);
addvec(it,(0.1,0.2));
fun subvec(v1,v2) = addvec(v1,negvec v2);
subvec(a,b);
fun distance(v1,v2) = lengthvec(subvec(v1,v2));
distance(a,b);
fun scalevec(r,(x,y)) : vec = (r*x , r *y);
scalevec(2.0,a);
scalevec(2.0,it);
```


# Page 32 Selecting components of a tuple

```
val (xc,yc) = scalevec(4.0, a);
val ((x1,y1), (x2,y2)) = (addvec(a,b), subvec(a,b));
```
## The 0 Tuple - unit ()

```
see the type of procedure use to read in files
- use;
val it = fn : string -> unit
```

The 0-tuple and the type unit. Previously we have considered n-tuples for n ≥
2. There is also a 0-tuple, written () and pronounced ‘unity,’ which has no
components. It serves as a placeholder in situations where no data needs to be
conveyed. The 0-tuple is the sole value of type unit.
Type unit is often used with procedural programming in ML. A procedure is
typically a ‘function’ whose result type is unit. The procedure is called for its
effect — not for its value, which is always (). For instance, some ML systems
provide a function use of type string → unit. Calling use "myfile" has the
effect of reading the definitions on the file "myfile" into ML.
A function whose argument type is unit passes no information to its body
when called. Calling the function simply causes its body to be evaluated. In
Chapter 5, such functions are used to delay evaluation for programming with
infinite lists.

==============================================================================================================================================================
==============================================================================================================================================================
==============================================================================================================================================================



99 Problems 
==============================================================================================================================================================
==============================================================================================================================================================
==============================================================================================================================================================

```
Problem 1
?- my_last(X,[a,b,c,d]).
X = d

val X = List.last(["a","b","c","d"]);
```
   
==============================================================================================================================================================






==============================================================================================================================================================

```
  Improvmenets

1 - org mode standard ml fix , the mode is currently balked with stdIn string appearing
   from nowhere

2 - emacs oode editor assistance

3 - 
         
```



#+CAPTION: This is a queue , first in first out 
#+NAME:   fig:queue-img
[[./images/queueImg.jpg]]

