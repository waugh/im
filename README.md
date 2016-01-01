# im -- Programming Language "Imperatrix Mundi"

I am trying to invent a programming language with these broad characteristics:

- suitability for transparent persistence;
- concurrent-constraint logic;
- lazy evaluation;
- referential transparency;
- suitability for programming browsers as well as web servers.

The implementation for browsers might not ever handle persistency.

At this stage, I am still doing very low-level experimentation with
lazy evaluation, etc., and have
achieved nothing yet in the way of parsing source code or for that matter
even laying down its abstract syntax.

Purposes of some of the files here:

- test.coffee -- regression testing, including low-level.
- support.coffee -- low-level programming and testing support.
- scheduling.coffee -- basic scheduling of tasks (includes trampoline, events).
- lazy.coffee -- lazy evaluation.
- snippets -- lines of code that I paste into a REPL or a shell for testing etc.
- user_snippets -- reminder of how to set up a user acct. to run node.js etc.
