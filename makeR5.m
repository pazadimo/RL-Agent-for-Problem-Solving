function [states,R]=makeR5(N)
outs=0;
final_state=[2 2 2 2 2 243];
c=1
    for i5=0:1:2
        for i4=0:1:2
        	for i3=0:1:2
                for i2=0:1:2
                    for i1=0:1:2
                        states(c,:)=[i5 i4 i3 i2 i1 c];
                        c=c+1;
                    end
                end
            end
        end
    end
c=c-1;
R=zeros(c,c);
b=0
l=0;
for i=1:1:c
    for j=1:1:c
        current_state(:)=states(i,:);
        next_state(:)=states(j,:);
        diff=current_state-next_state;
        b=0;
        allowed_move=0;
        for z=1:1:N
            if(diff(z)~= 0)
                b=b+1;
            end
            if(diff(z)~= 0)
                for gg=z+1:1:N
                    if(current_state(gg)==current_state(z))
                        allowed_move=1;
                    end
                end
                for g=z+1:1:N
                    if(current_state(g)==next_state(z))
                        allowed_move=1;
                    end
                end
            end
        end
        if(b>1)
            R(i,j)=-inf;
            l=l+1;
        elseif(allowed_move==1)
            R(i,j)=-inf;
            l=l+1;
        elseif(next_state==current_state)
            R(i,j)=-inf
            l=l+1;
        elseif(next_state==final_state)
            R(i,j)=100;
        else
            R(i,j)=-0.01;
        end
    end
end
