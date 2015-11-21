# im

There might not be anything here yet, but my intent with this repo
is to implement in Javascript (ECMAscript, JS) a virtual machine.

I am using node.js (nodejs) as the platform for running JS as I test the code.
So the arrangement of code into files here, and the way code files refer to
other code files, is in the style that nodejs understands.

## What Kind of Language Am I Designing the VM to Execute?

It is a concurrent-constraint logic language without backtracking.

There is no reassignment of different values to a variable over time.

Procedure definitions are fundamental from the VM's viewpoint.
Arguments to procedures can carry data in or out.

## Why is the repo named "im"?

In designing the VM, I have in mind to compile to the VM's language from a
higher-level language, to be called Imperatrix Mundi.
