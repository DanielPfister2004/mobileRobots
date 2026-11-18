%% How it works
%
%
%       It first looks at all neighbor and chooses the cheapest one.


function [path, cost, stats] = bfs_graph(W, s, t)
%BFS_GRAPH  TASK 2 -- breadth-first search.
%
%   Copy your finished dfs_graph in here, rename the function in the
%   first line, and change EXACTLY ONE WORD.
%
%   If you change more than one word you have misunderstood the task --
%   and that one word is the central claim of the whole lecture.
%
%   Target:  A - D - F, 2 steps, cost 7, 6 expansions.
%
%   Check:   check_my_code('bfs')
%
%   Watch the result: breadth-first search finds the path with the
%   FEWEST STEPS. That does not make it the cheapest -- here it costs 7
%   while a route for 3 exists.

%error('task:todo', 'Task 2 not started -- delete this line and begin.');

n      = size(W, 1);
par    = zeros(n, 1);     % par(v): which node did we come from to reach v
seen   = false(n, 1);     % already put into OPEN once?
closed = false(n, 1);     % neighbours already looked at?
order  = zeros(1, 0);     % which nodes came out, in order

% TODO 2 -- Which container belongs to depth-first search?
%           'lifo' = last in, first out
%           'fifo' = first in, first out
%           (Do TODO 1 first. The wrong one is deliberately here.)

OPEN = open_new('fifo');

seen(s) = true;
OPEN    = open_push(OPEN, s);

while ~open_isempty(OPEN)
    [OPEN, u] = open_pop(OPEN);

    % A stale entry? Skip it. (In this pattern the line never fires,
    % because seen already prevents duplicates. It is here so the loop
    % stays unchanged when you move to task 4, where it is essential.)
    if closed(u)
        continue
    end
    closed(u)      = true;
    order(end + 1) = u;   %#ok<AGROW>
    trace_step(numel(order), u);

    % TODO 3 -- When are we done? Replace false by the condition.
    if u == t %% when it reached the goal node it stops 
        fprintf('Finished with this code');
        break
    end

    nb = graph_neighbors(W, u);
    for k = 1:numel(nb)
        v = nb(k);
        if seen(v) || closed(v)
            continue
        end

        % TODO 1 -- Two lines are missing here:
        %             - remember that we reached v coming from u
        %             - put v into OPEN  (open_push)
        par(v) = u;
        OPEN = open_push(OPEN, v);
        seen(v) = true;
    end
end

[path, cost]     = reconstruct_path(par, s, t, W);
stats.expansions = numel(order);
stats.order      = order;
end
