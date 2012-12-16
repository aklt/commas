# Commas - read a stream of comma separated values

This is a simple implementation of a CSV reader compatible with 
[RFC 4180](http://tools.ietf.org/html/rfc4180).  It is written in C and the
state machine has been created with the 
[Ragel State Machine Compiler](http://www.complang.org/ragel/) making it very
fast.  The drawback is that input data must conform to RFC 4180 which is not the
case with many CSV files.
