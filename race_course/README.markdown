### Exercise is hard, Especially for Geeks. 

  A bunch of coworkers are getting ready for a 5K race. Each one of them has different attributes that will help them along the way. Jark is a smart runner, Will is a fast runner, Dove has long legs
  and EJ has good running rhythm.  
  
### Jogger
  A class has been defined 'Jogger', It has attributes for smart, long_legs, fast and good_rhythm
  A smart runner can find the best way to attack a course
  A Long Legged Runner takes many fewer steps
  A Fast Runner takes many steps quickly
  A Runner with good rhythm takes many even and equal strides  
  
### Race Condition
  A race condition is a  flaw in a process where its result unexpectedly dependent on the sequence or timing of events.
  When events happen out of order a system may become unstable, corrupted, or altogether fail. In this case, our runners must
  finish in an order dictated by their abilities but they can be lined up in any order on the track. 
  
### A fair and balanced Race
  A fast runner must always win unless another runner is long legged and (smart or has rhythm)
  A runner with good rhythm must beat a smart runner unless the smart runner has long legs
  A runner who has long legs and is smart and has rhythm will beat everyone else
  Multiple runners with the same attributes must finish in sequence 
  ...
  
### A race
  We need to make sure that the joggers finish the race (are written to the finish_line array) in the proper sequence. 
    
  
  
  
