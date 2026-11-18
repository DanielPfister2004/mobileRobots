%% How it works
%
%       Looks at all neighbors and chooses the cheapest one.
%       It then ignores the rest that have a heavy weight. 
%       If there is "sackgasse" then it must go back. 


function [path, cost, stats] = greedy_graph(W, s, t, h)
%GREEDY_GRAPH  TASK 3 -- greedy best-first search.
%
%   Same pattern again. This time the order is decided by a number: the
%   estimate h(v) of how far it still is from v to the goal.
%
%   Copy your bfs_graph and change two things:
%     - the container has to sort by a key
%     - the key has to be handed over when pushing:
%           open_push(OPEN, v, <key>)
%
%   Nothing else. No g, no relaxation -- greedy only ever looks ahead.
%
%   h is a vector with one estimate per node, h(t) = 0.
%
%   Target:  A - D - F, cost 7, 3 expansions.
%
%   Check:   check_my_code('greedy')
%
%   Worth thinking about: greedy needs the same number of expansions as
%   depth-first search and finds the same path. Is that a coincidence?


    n      = size(W, 1);
    par    = zeros(n, 1);
    seen   = false(n, 1);
    closed = false(n, 1);
    order  = zeros(1, 0);

    OPEN = open_new('prio');                    % sortiert nach kleinest zuerst

    seen(s) = true;
    OPEN    = open_push(OPEN, s, h(s));         % h(s) schätzung

    while ~open_isempty(OPEN)
        [OPEN, u] = open_pop(OPEN);

        if closed(u)
            continue
        end
        closed(u)      = true;
        order(end + 1) = u;
        trace_step(numel(order), u);

        if u == t
            fprintf('Finished with this code\n');
            break
        end

        nb = graph_neighbors(W, u);
        for k = 1:numel(nb)
            v = nb(k);
            if seen(v) || closed(v)
                continue
            end

            par(v) = u;
            OPEN = open_push(OPEN, v, h(v));     % schätzung h(v)
            seen(v) = true;
        end
    end

    [path, cost]     = reconstruct_path(par, s, t, W);
    stats.expansions = numel(order);
    stats.order      = order;
end
