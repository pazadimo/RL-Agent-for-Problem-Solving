 clear
[a5,aa5]=makeR5(5)
alpha=1;
gamma=.9;
%lambda=.9;
R=aa5;
states=a5;
N=5;
final_state=243;
threshhold=1000;
%N_forseen=15;
Q=zeros(length(R),length(R))
N_episodes=1000;
start_state=[0 0 0 0 0 1];

current_state=start_state;
%for episode=1:1:N_episodes
episode=1;
total_reward=zeros(1,N_episodes);
total_Q=zeros(1,N_episodes);
number_of_iteration=zeros(1,N_episodes);
while(episode<N_episodes)
    if(episode < threshhold)
        e=.95;
    else
        e=0.999;
    end
    reward=0; 
    c=1;
    first=1;
    flag=0;
    clear next_states
    clear next_Q_possible
    for j=1:1:(length(R))
        if(R(current_state(N+1),j) ~= -inf)
%             if(first==1)
%                 possible_max=j;
%                 Q_max=Q(current_state(N+1),j);
%                 first=0;
%             end
            next_states(c)=j;
            next_Q_possible(c)=Q(current_state(N+1),j) ;
            c=c+1;
%             if(Q(current_state(N+1),j)>Q_max)
%                 possible_max=j;
%                 Q_max=Q(current_state(N+1),j);
%                 flag=1;
%             end
        end
    end
    if(rand<e)
        %next_state_index=possible_max;
        [MAX, MAX_INDEX]=max(next_Q_possible);
        Q_max=MAX;
        next_state_index=next_states((MAX_INDEX));
    else
        next_state_index=(datasample(next_states,1));
    end
    reward=R(current_state(N+1),next_state_index);
    
    
    c=1;
    first=1;
    flag=0;
    clear next_states
    clear next_Q_possible
    for j=1:1:(length(R))
        if(R(next_state_index,j) ~= -inf)
%             if(first==1)
%                 possible_max=j;
%                 Q_max=Q(current_state(N+1),j);
%                 first=0;
%             end
            next_states(c)=j;
            next_Q_possible(c)=Q(next_state_index,j) ;
            c=c+1;
%             if(Q(current_state(N+1),j)>Q_max)
%                 possible_max=j;
%                 Q_max=Q(current_state(N+1),j);
%                 flag=1;
%             end
        end
    end
    [MAX, MAX_INDEX]=max(next_Q_possible);
    Q_max=MAX;
%     current_forseen_state(:)=states(next_state_index,:);
%     for forseen=1:1:N_forseen
%         c=1;
%         first_forseen=1;
%         flag=0;
%         clear next_forseen_states
%     for j=1:1:(length(R))
%         if(R(current_forseen_state(N+1),j) ~= -10000)
%             if(first_forseen==1)
%                 possible_max_forseen=j;
%                 Q_max_forseen=Q(current_forseen_state(N+1),j);
%                 first_forseen=0;
%             end
%             next_forseen_states(c)=j;
%             c=c+1;
%             if(Q(current_forseen_state(N+1),j)>Q_max_forseen)
%                 possible_max_forseen=j;
%                 flag=1;
%                 Q_max_forseen=Q(current_forseen_state(N+1),j);
%             end
%         end
%     end
%    next_forseen_state_index=possible_max_forseen;
%     if( flag==1)
%         next_forseen_state_index=possible_max_forseen;
%     else
%         next_forseen_state_index=(datasample(next_forseen_states,1));
%     end
%       current_forseen_state=states(next_forseen_state_index,:);;
%      reward=(lambda^forseen)*R(current_forseen_state(N+1),next_forseen_state_index)+reward;
%     end
    Q(current_state(N+1),next_state_index)=(1-alpha)*Q(current_state(N+1),next_state_index)+alpha*(reward+gamma*Q_max);
    
    total_Q(episode)=total_Q(episode)+Q(current_state(N+1),next_state_index);
    total_reward(episode)=total_reward(episode)+reward;
    number_of_iteration(episode)=number_of_iteration(episode)+1;
    ecpected_reward(episode)=total_reward(episode)/number_of_iteration(episode);
    ecpected_Q(episode)=total_Q(episode)/number_of_iteration(episode);
    
    if(current_state(N+1)==final_state)
        % break;
          episode=episode+1;
          next_state_index=1;
    end
    current_state=states(next_state_index,:);
end
% figure
figure
subplot(2,1,1)
plot(ecpected_reward)
title 'Expected Reward in Each Episode'

subplot(2,1,2)
plot(ecpected_Q)
title 'Expexted Q in Each Episode'

min(number_of_iteration(1:(N_episodes-1)))
