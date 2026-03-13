# Cuis-Smalltalk-StdIO

Stdin, stdout, stderror, and a simple REPL (Read Eval Print Loop)

Refactored for Cuis 7.6

````Smalltalk
  Feature require: #'StdIO'.
  [(StdIOReadEvalPrint newWithDefaults) readEvalPrint] fork. "Blocks image unless running on supported VM on Unix like process"
````
## REPL Features
Inputs are valid Smalltalk, except for the character marking end of input. No other special characters or keywords are parsed. Access instance with messages to ''self''.

````Smalltalk
  self help "Shows detailed help message"
  self commands "Shows a list of commands"
  self reuse. self reuse: aNumber "Retrieve an answer that can be interacted with as a Smalltalk object"
  self rerun. self rerun: aNumber "Rerun a previous input"
````
### REPL Session Manager
The session manager can be accessed with "self sn". Use session manager to access inputs and outputs. Declare and reuse shared variables. And save the REPL session to a text file.

````Smalltalk
  self sn help
  self sn commands
````

### Variables
Temporary variables can be declared using the usual method. These are scoped only to that input. 

Shared variables can be declared using messages to the Object Manager. See "self obj help".

### Object Reuse
Outputs are saved and retrieved within the REPL session as Smalltalk objects.

Block Closures can be created and saved as either output or shared variable and reused within the REPL session.

Objects can be saved to and restored from file.

````
1 >  [:a :b | a * b]! "Save a block closure to the output"
...
2 >  "Alias of self sn previousOutput"
     (self reuse) value: 3 value: 5! 
...
3 >  self obj set: #aBlock value: [:a :b | a * b]! "Save a block closure to a shared variable"
...
4 >  (self use: #aBlock) value: 3 value: 5!
...
5 >  self obj save: self reuse to: 'myObject'! "Save an object to file"
...
6 >  self obj restoreFromFile: 'myObject'! "Restore an object from file"
````

### Creating Classes and Instances
All the usual Smalltalk class and instance creation messages are available. However missing a GUI the usability is poor. Instead, "minimal class" and instance objects are available. These have sufficient features for quick prototyping. See "self cls help".
