# im

There might not be anything here yet, to speak of, but my intent with this repo
is to implement in Javascript (ECMAscript, JS) a virtual machine suitable for
running a programming language I am trying to design. Although I aim for a
future in which some of the code could run in browsers, I am testing primarily
on top of node.js (nodejs). For the time being at least, I use the name
Imperatrix Mundi for the new programming language. My ideas about the definition
of Imperatrix Mundi and the list of its features remain at the time of this
writing, somewhat fluid. Imperatrix Mundi (IM) will probably be fundamentally a
concurrent-constraint language with lazy evaluation. It may be possible to
design the language and its compiler to enforce sufficient static constraints
to preclude certain runtime errors. However, it is not the responsibility of the
virtual machine to do that static checking. So, as I code this VM, my attitude
says to handle errors at runtime.

# What Kind of Language Am I Designing the VM to Execute?

It is a concurrent-constraint logic language without backtracking.

There is no reassignment of different values to a variable over time.

Function definitions are not fundamental. However, the effect of such can
easily simulated.

Procedure definitions are fundamental. Arguments can carry data in or out.
Invocation of a procedure constitutes a logical determination, i. e. a
statement of believed truth. Execution of a procedure amounts to inference
of the consequences implied.

An argument may be copyable (in a certain direction) or linear.

It is possible to construct a _message_, which is pretty much the same thing
as a so-called _record_ in Oz/Mozart. I refer to the symbol at the head of a
message as
its _verb_. A message has _key words_ that label _arguments_. The arguments
represent data paths. It must be possible to compare a message to a list of
alternative message patterns to see which it matches, if any, in which case,
the arguments in the message are connected to the corresponding parameters in
the message pattern that matches.

## "Source Code"

"Source code" from the viewpoint of the VM is not the same as "source code" from
the viewpoint of a compiler for Imperatrix Mundi, the supposed high-level
programming language. "Source code" from the viewpoint of the VM is the code
that must be fed into the VM
for execution. If I mention "source code" without qualification in the rest of
this document, my
meaning will be the code for the VM, not the high-level language.

In comments, I might use sort of a pseudocode to lay out the intent of a piece
of source code that I want to test, or insert somewhere, or talk about as an
example. The form of the pseudocode may hint at
possible syntax for Imperatrix Mundi, but does not represent a final decision
on that.

## Formal Interpreters

What is the minimal API for controlling the VM from an imperative language?

A related question is using what API, within the language understood by the VM,
to express
the invocation of a sub-interpreter for reflection and/or for catching errors.

Another related question is what is the API of a server intended to serve the
virtual machine across computer networks.

Generally for an instance of the VM, there have to be one or more virtual
output devices as part of the fundamental understanding of the state shared
between the VM and its clients. The
data paths leading to the output devices constitute the roots for garbage
collection.

## Same Structures for Expressing Runtime State and Source Code?

Data structures designed for interpretation may suffice for expressing code.
With that in mind, I might not have to design separate structures for the two
purposes.

## Low-level Data Structures for the VM

The state of an execution is a graph. Until such time as practice leads to any
suggestion that simplification relative to the following assumption may be
possible, I will assume it is necessary to lay out the graph with very explicit
data structures expressing the terminals of an edge in the graph. An edge
represents a path along which an argument can flow. The direction of the
intended flow might not be indicated explicitly before the argument arrives
for transport. Transport of one argument may or may not imply the end of the
life of a path. An argument can represent a copyable datum or a linear
structure.

Some of the low-level operations that have to traverse an edge include:
- a signal of demand for a result.
- a signal that a result is available, at least with regard to the structure
  of its root node.
The above two signals run in opposite directions.

I assume that every data path should be labeled as to
whether it represents copyable data. I am hoping it is possible to derive that
label early relative to lazy evaluation. For example, literals are inherently
copyable. A message whose arguments are all provably copyable is itself
copyable. The result of adding two numbers is copyable. If we can prove that
the addends are numbers even before knowing their values, we an label the sum
as copyable before being able to compute its value.

An attempt to copy a linear argument results in a runtime error detection.
So should an attempt to copy a teller.

A given element of code or execution shall function as a node in a
graph. I will represent each node as an instance of a class in Coffeescript.
One of those instances shall own terminals of data paths leading to the
related nodes in the graph.
I will make classes of terminal
for specific rôles with respect to specific classes of node.

## Some Fundamental Programming Constructs For The VM

Given that edges have just two ends, it is necessary to include a structure
for copying an argument, and one for destroying an argument.

Although the spawning of a logical variable, resulting in _asker_ and _teller_
data paths, is conceptually fundamental to the languages, it might not be
necessary to establish any special data structure to express that in the VM.
Just plug stuff directly together, maybe.

Conversion between a message (or message pattern) and its arguments is
fundamental. That implies creation of a message from arguments, or decomposition
of a message into its arguments when it matches a pattern. It might not be
necessary to use separate data structures for the two operations. It might be
possible to tell from context which operation to execute.

Creation of a logical closure is fundamental.

A logical procedure in source code is semantically the same as a logical
closure that doesn't happen to close over anything. However, it may be easier
to get started by drafting a data structure to express a procedure without
accomodating closing over anything. Once that can be demostrated to be working,
the time will arrive to think about what structure to use in constructing a
closure at runtime.

A list of alternative patterns is fundamental. It must be possible at runtime
to apply such a list to a message.
