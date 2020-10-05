clear
%initialize parameters
alpha=0.9;
gamma=.8;
[a,aa]=makeR(3)
R=aa;
states=a;
N=3;
final_state=27;
threshhold=300;
Q=zeros(length(R),length(R))
N_episodes=300;
start_state=[0 0 0 1];
current_state=start_state;
episode=1;
total_reward=zeros(1,N_episodes);
total_Q=zeros(1,N_episodes);
number_of_iteration=zeros(1,N_episodes);

%starting the loops of episodes
while(episode<N_episodes)
    if(episode < threshhold)
        e=.9;
    else
        e=0.99;
    end
    reward=0; 
    c=1;
    first=1;
    flag=0;
    clear next_states
    clear next_Q_possible
    
    %find the maximum of next states for vurrent states
    for j=1:1:(length(R))
        if(R(current_state(N+1),j) ~= -inf)
            next_states(c)=j;
            next_Q_possible(c)=Q(current_state(N+1),j) ;
            c=c+1;
        end
    end
    
    %use epsilon greedy pokicy
    if(rand<e)
        [MAX, MAX_INDEX]=max(next_Q_possible);
        Q_max=MAX;
        next_state_index=next_states((MAX_INDEX));
    else
        next_state_index=(datasample(next_states,1));
    end
    reward=R(current_state(N+1),next_state_index);
    
    
    %finding the maximum amount of Q for next states of next_state 
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

    %updating the Q
    Q(current_state(N+1),next_state_index)=(1-alpha)*Q(current_state(N+1),next_state_index)+alpha*(reward+gamma*Q_max);
    
    
    %calculate the expected value of reward and Q
    total_Q(episode)=total_Q(episode)+Q(current_state(N+1),next_state_index);
    total_reward(episode)=total_reward(episode)+reward;
    number_of_iteration(episode)=number_of_iteration(episode)+1;
    ecpected_reward(episode)=total_reward(episode)/number_of_iteration(episode);
    ecpected_Q(episode)=total_Q(episode)/number_of_iteration(episode);
    
    %check if it's the final state of not
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
min(number_of_iteration(1:(N_episodes-1)))-1
