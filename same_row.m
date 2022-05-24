 function[answer]=same_row(a,b,inverse)
    answer = ((mod(inverse(a-'A'+1)-1,5)+1) == (mod(inverse(b-'A'+1)-1,5)+1));
    return
 end