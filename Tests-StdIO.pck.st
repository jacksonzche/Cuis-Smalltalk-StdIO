'From Cuis7.6 [latest update: #7777] on 13 March 2026 at 11:05:46 am'!
'Description '!
!provides: 'Tests-StdIO' 1 8!
!requires: 'StdIO' 1 9 nil!
SystemOrganization addCategory: #'Tests-StdIO'!


!classDefinition: #MinInstanceTest category: #'Tests-StdIO'!
TestCase subclass: #MinInstanceTest
	instanceVariableNames: 'class instance1 instance2'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests-StdIO'!
!classDefinition: 'MinInstanceTest class' category: #'Tests-StdIO'!
MinInstanceTest class
	instanceVariableNames: ''!

!classDefinition: #StdIOReadEvalPrintTest category: #'Tests-StdIO'!
TestCase subclass: #StdIOReadEvalPrintTest
	instanceVariableNames: 'input output repl'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests-StdIO'!
!classDefinition: 'StdIOReadEvalPrintTest class' category: #'Tests-StdIO'!
StdIOReadEvalPrintTest class
	instanceVariableNames: ''!


!MinInstanceTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 09:24:14'!
testInstancesHaveDifferentVariables
	self deny: (instance1 variables == instance2 variables)! !

!MinInstanceTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 09:26:34'!
testInstancesHaveDifferentVariablesFromClass
	self deny: (instance1 variables == class variables)! !

!MinInstanceTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 08:54:41'!
testInstancesShareMethods
	self assert: (instance1 methods == instance2 methods)! !

!MinInstanceTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 08:54:21'!
testInstancesShareMethodsWithClass
	self assert: (instance1 methods == class methods)! !

!MinInstanceTest methodsFor: 'setUp/tearDown' stamp: 'JZCH 13/Mar/2026 08:52:45'!
setUp
	class := MinClass new.
	instance1 := class new.
	instance2 := class new.! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 11:00:10'!
testAlternateTerminator
"Should terminate repl"
	input nextPutAll:
	'self terminator: $? !!
	??
	'.
	
	input reset.
	[repl running] whileTrue: [(Delay forMilliseconds: 5) wait.].
	
	self deny: [repl running].! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 11:00:23'!
testDoubleTerminator
"Should terminate repl"
	input nextPutAll: 
	'!!!!
	'.
	
	input reset.
	[repl running] whileTrue: [(Delay forMilliseconds: 5) wait.].
	
	self deny: [repl running].! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 11:00:35'!
testEndImmediately
"Should terminate repl"
	input nextPutAll: 
	'self endImmediately!!
	'.
	
	input reset.
	[repl running] whileTrue: [(Delay forMilliseconds: 5) wait.].
	
	self deny: [repl running].! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 11:04:44'!
testObjectScope
"Shared variables are useable within the session"
	| answer |
	input nextPutAll: 
	'self obj set: #var1 value: 3.
	self obj set: #var2 value: 5!!
	(self obj get: #var1) * (self obj get: #var2)!!
	'.
	
	input reset.
	[ answer := repl sn outputAt: 2.
	  answer isNumber ] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self assert: (answer = 15).! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 9/Mar/2026 15:17:51'!
testRerunInput
"Inputs can be rerun"
	| answer |
	input nextPutAll: 
	'1+1!!
	self rerun!!
	'.
	
	input reset.
	[ answer := repl sn outputAt: 2.
	  answer isNumber ] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self assert: (answer = 2).! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 11:03:47'!
testReuseBlockClosuresFromObject
"Block closures can be reused when saved to a shared variable"
	| answer |
	input nextPutAll: 
	'self obj set: #aBlock value: [:a :b | a * b ]!!
	(self obj get: #aBlock) value: 3 value: 5!!
	'.
	
	input reset.
	[ answer := repl sn outputAt: 2.
	  answer isNumber ] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self assert: (answer = 15).! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 9/Mar/2026 15:17:47'!
testReuseBlockClosuresFromOutput
"Block closures can be reused when saved to an output"
	| answer |
	input nextPutAll: 
	'[:a :b | a * b ]!!
	self sn previousOutput value: 3 value: 5!!
	'.
	
	input reset.
	[ answer := repl sn outputAt: 2.
	  answer isNumber ] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self assert: (answer = 15).! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 9/Mar/2026 15:17:40'!
testReuseOutput
"Outputs can be retrieved and used as Smalltalk Objects not just a string"
	| answer |
	input nextPutAll: 
	'1!!
	(self sn previousOutput) + 1!!
	'.
	
	input reset.
	[ answer := repl sn outputAt: 2.
	  answer isNumber ] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self assert: (answer = 2).! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 6/Mar/2026 12:42:03'!
testSingleTerminator
"Should evaluate input"
	input nextPutAll: Random next asString.
	input nextPutAll: $!! asString.
	input nextPutAll: Character lf asString.
	
	input reset.
	[repl outputReady] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self assert: repl outputReady.! !

!StdIOReadEvalPrintTest methodsFor: 'tests' stamp: 'JZCH 13/Mar/2026 11:01:40'!
testTempVariablesScope
"Temp variables declared in each 'line' of the REPL are accessible only in that line. They are equivalent to private variables within a method"
	| answer |
	input nextPutAll: 
	'| x |
	x := 1!!
	1 + x!!
	'.
	
	input reset.
	[ answer := repl sn outputAt: 2.
	  answer isString ] whileFalse: [(Delay forMilliseconds: 5) wait.].
	
	self deny: (answer isNumber).! !

!StdIOReadEvalPrintTest methodsFor: 'setUp/tearDown' stamp: 'JZCH 4/Mar/2026 22:34:59'!
setUp
	input := ReadWriteStream with: ''.
	output := ReadWriteStream with: ''.
	
	repl := StdIOReadEvalPrint new.
	repl stdIn: input.
	repl stdOut: output.
	repl terminator: $!!.
	
	[repl readEvalPrint] fork.! !

!StdIOReadEvalPrintTest methodsFor: 'setUp/tearDown' stamp: 'JZCH 6/Mar/2026 12:19:50'!
tearDown
"Should terminate repl"
	repl endImmediately.
	input nextPutAll: repl terminator asString.
	input nextPutAll: repl terminator asString.
	input nextPutAll: Character lf asString.
	
	input reset.
	[repl running] whileTrue: [(Delay forMilliseconds: 5) wait.].! !
