function bits_dec = traceback2(path_metrics,compare_path,num_steps)

% Finding the minimum value in compare_path to decide the 
% first state in the path back.

[r,c] = find(compare_path == min(compare_path,[],'all'));
state = [1 2; 3 4 ;5 6 ;7 8;9 10; 11 12 ;13 14 ;15 16;17 18; 19 20 ; 21 22 ;23 24;25 26; 27 28 ;29 30 ;31 32];
state = state(r(1),c(1));


    for t = num_steps:-1:1    

        column = path_metrics(state,t); 
        if state == 1 && column == 1
                bits_dec(t) = 0;
                next_state = 1;
        elseif state == 1 && column == 2
                bits_dec(t) = 0;
                next_state = 2;
        elseif state == 2 && column == 1
                bits_dec(t) = 0;
                next_state = 3;
        elseif state == 2 && column == 2 
                bits_dec(t) = 0;
                next_state = 4;
        elseif state == 3 && column == 1
                bits_dec(t) = 0;
                next_state = 5;
        elseif state == 3 && column == 2 
                bits_dec(t) = 0;
                next_state = 6;
        elseif state == 4 && column == 1
                bits_dec(t) = 0;
                next_state = 7;
        elseif state == 4 && column == 2 
                bits_dec(t) = 0;
                next_state = 8;
        elseif state == 5 && column == 1
                bits_dec(t) = 0;
                next_state = 9;
        elseif state == 5 && column == 2 
                bits_dec(t) = 0;
                next_state = 10;
        elseif state == 6 && column == 1
                bits_dec(t) = 0;
                next_state = 11;
        elseif state == 6 && column == 2 
                bits_dec(t) = 0;
                next_state = 12;        
        elseif state == 7 && column == 1
                bits_dec(t) = 0;
                next_state = 13;
        elseif state == 7 && column == 2 
                bits_dec(t) = 0;
                next_state = 14;
        elseif state == 8 && column == 1
                bits_dec(t) = 0;
                next_state = 15;
        elseif state == 8 && column == 2 
                bits_dec(t) = 0;
                next_state = 16;
        elseif state == 9 && column == 1
                bits_dec(t) = 1;
                next_state = 1;
        elseif state == 9 && column == 2 
                bits_dec(t) = 1;
                next_state = 2;
        elseif state == 10 && column == 1
                bits_dec(t) = 1;
                next_state = 3;
        elseif state == 10 && column == 2 
                bits_dec(t) = 1;
                next_state = 4;
        elseif state == 11 && column == 1
                bits_dec(t) = 1;
                next_state = 5;
        elseif state == 11 && column == 2
                bits_dec(t) = 1;
                next_state = 6;
        elseif state == 12 && column == 1 
                bits_dec(t) = 1;
                next_state = 7;
        elseif state == 12 && column == 2 
                bits_dec(t) = 1;
                next_state = 8;        
        elseif state == 13 && column == 1
                bits_dec(t) = 1;
                next_state = 9;
        elseif state == 13 && column == 2 
                bits_dec(t) = 1;
                next_state = 10;
        elseif state == 14 && column == 1
                bits_dec(t) = 1;
                next_state = 11;
        elseif state == 14 && column == 2 
                bits_dec(t) = 1;
                next_state = 12;
        elseif state == 15 && column == 1
                bits_dec(t) = 1;
                next_state = 13;
        elseif state == 15 && column == 2 
                bits_dec(t) = 1;
                next_state = 14;
        elseif state == 16 && column == 1
                bits_dec(t) = 1;
                next_state = 15;
        elseif state == 16 && column == 2 
                bits_dec(t) = 1;
                next_state = 16;
        end
        
        state = next_state;
    end
        
        
        
        
  
end 