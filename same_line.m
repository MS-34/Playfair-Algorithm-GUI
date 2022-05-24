 function[answer]=same_line(a,b,inverse)
    answer = ((floor((inverse(a-'A'+1)-1)/5)+1) == (floor((inverse(b-'A'+1)-1)/5)+1));
    return
 end