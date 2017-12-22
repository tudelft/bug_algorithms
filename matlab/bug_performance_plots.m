clear all, clc


load /home/knmcguire/Documents/experiments/bug_algorithms/results/results_12-19-2017_19-15.mat

bug_names = {'wf', 'com_bug', 'bug_2','alg_1', 'alg_2', 'i_bug', 'blind_bug'};

fitness = zeros(length(results.environment)-1,length(bug_names));
time = zeros(length(results.environment)-1,length(bug_names));
mean_gradient_env = zeros(length(bug_names),1);
mean_gradient = zeros(length(results.environment)-1,length(bug_names));

reached_goal = zeros(length(results.environment)-1,length(bug_names));
lenght_trajectory = zeros(length(results.environment)-1,length(bug_names));
lenght_trajectory_percentage = zeros(length(results.environment)-1,length(bug_names));

optimal_path_length_per_environment=0;

for it = 1:length(results.environment)-1
    
    it
    
        
        did_all_bugs_make_it = 1; 
        optimal_path_per_environment = astar_on_environment(results.environment(1).img,[9,9],[1,1]);
        
        diff_trajectory = diff(optimal_path_per_environment);
        
        optimal_path_length_per_environment = 1;%sum(sqrt(diff_trajectory(:,1).^2+diff_trajectory(:,2).^2))/10;
            

   for itk = 1:length(results.environment(it).bug)
        
    bug_temp = results.environment(it).bug;
    index = find(strcmp({bug_temp.bug_name},bug_names{itk}));
    
        if(~isempty(index))
        fitness(it,itk) = results.environment(it).bug(index).fitness(1);
        indices_time = find(results.environment(it).bug(index).distances<1);
        diff_trajectory = diff(results.environment(it).bug(index).trajectory);
        temp_lenght_trajectory = sum(sqrt(diff_trajectory(:,1).^2+diff_trajectory(:,2).^2));
        
        lenght_trajectory(it,itk)= temp_lenght_trajectory;
        lenght_trajectory_percentage(it,itk)= temp_lenght_trajectory/optimal_path_length_per_environment;

        if(isempty(indices_time))
           time(it,itk) = NaN;
            reached_goal(it,itk) = 0;
            did_all_bugs_make_it = 0;
        else
          time(it,itk) = indices_time(1);
            reached_goal(it,itk) = 1;
        end
        
%         temp_lenght_trajectory = 0;
%         for itm = 1:size(results.environment(it).bug(index).trajectory,1)-1
%             temp_lenght_trajectory = temp_lenght_trajectory + pdist(results.environment(it).bug(index).trajectory(itm:itm+1,:),'euclidean');
%         end

        mean_gradient_env(itk) = mean(diff(results.environment(it).bug(index).distances));
        mean_gradient(it,itk) =  mean(diff(results.environment(it).bug(index).distances));
        end

    end
    if did_all_bugs_make_it ==false
       time(it,:) = NaN;
       %lenght_trajectory(it,:) = NaN;
      % lenght_trajectory_percentage(it,:) = NaN;

    end
end
   

%figure,boxplot(fitness, 'Labels',bug_names)
%figure,boxplot(time, 'Labels',bug_names)
%figure,boxplot(mean_gradient, 'Labels',bug_names)
figure,boxplot(lenght_trajectory, 'Labels',bug_names)
figure,boxplot(lenght_trajectory_percentage, 'Labels',bug_names)

figure,bar(sum(reached_goal))
%set(gca,'xticklabel',bug_names)
