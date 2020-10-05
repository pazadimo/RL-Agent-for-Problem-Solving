clear
alpha=1;
gamma=.679;
[a4,aa4]=makeR4(4)
R=aa4;
states=a4;
N=4;
final_state=81;
threshhold=100;
Q=zeros(length(R),length(R))
N_episodes=100;
start_state=[0 0 0 0 1];

current_state=start_state;
episode=1;
total_reward=zeros(1,N_episodes);
total_Q=zeros(1,N_episodes);
number_of_iteration=zeros(1,N_episodes);
while(episode<N_episodes)
    if(episode < threshhold)
        e=.84;
    else
        e=0.99;
    end
    reward=0; 
    c=1;
    first=1;
    flag=0;
    clear next_states
    clear next_Q_possible
    for j=1:1:(length(R))
        if(R(current_state(N+1),j) ~= -inf)
            next_states(c)=j;
            next_Q_possible(c)=Q(current_state(N+1),j) ;
            c=c+1;
        end
    end
    if(rand<e)
        %next_state_index=possible_max;
        [MAX, MAX_INDEX]=max(next_Q_possible);
%         Q_max=MAX;
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
            next_states(c)=j;
            next_Q_possible(c)=Q(next_state_index,j) ;
            c=c+1;
        end
    end
    [MAX, MAX_INDEX]=max(next_Q_possible);
    Q_max=MAX;
    
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
figure
subplot(2,1,1)
plot(ecpected_reward)
title 'Expected Reward in Each Episode'

subplot(2,1,2)
plot(ecpected_Q)
title 'Expexted Q in Each Episode'
% 
% figure
% stem(number_of_iteration(1:50))
% title 'number_of_iteration_in_each_episode'
% 
% figure
% stem(total_reward(1:50))
% title 'total_reward_in_each_episode'
min(number_of_iteration(1:(N_episodes-1)))
