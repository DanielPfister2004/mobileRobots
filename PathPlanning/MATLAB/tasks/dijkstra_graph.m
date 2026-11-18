%%      How it works
%
%           It looks at all neighbor and chooses the one with the least
%           weight. If there is then a path that could be cheaper, it goes
%           back and takes this one. 


function [path, cost, stats] = dijkstra_graph(W, s, t)
%DIJKSTRA_GRAPH  TASK 4 -- Dijkstra.
%
%   From here on there is arithmetic. Two things come in:
%
%     g(v)         what the best route to v found so far costs
%     relaxation   is going through u cheaper than what we knew?
%
%   That is why the seen array is gone: a node MAY enter OPEN again when
%   a cheaper route to it turns up. And that is why the line
%   "if closed(u)" now really matters -- the same node can sit in OPEN
%   several times and only the first one out counts.
%
%   Target:  A - B - E - F, cost 3, 5 expansions.
%            D stays in OPEN with g = 6 and is never taken out.
%
%   Check:   check_my_code('dijkstra')

%error('task:todo', 'Task 4 not started -- delete this line and begin.');

n      = size(W, 1);
    g      = inf(n, 1);       % no route known yet
    g(s)   = 0;               % the start costs nothing
    par    = zeros(n, 1);
    closed = false(n, 1);
    order  = zeros(1, 0);

    OPEN = open_new('minkey');
    OPEN = open_push(OPEN, s, g(s));

    while ~open_isempty(OPEN)
        [OPEN, u] = open_pop(OPEN);
        
        if closed(u)
            continue
        end
        closed(u)      = true;
        order(end + 1) = u;   %#ok<AGROW>
        trace_step(numel(order), u);
        
        if u == t
            break
        end

        [nb, w] = graph_neighbors(W, u);
        for k = 1:numel(nb)
            v = nb(k);
            if closed(v)
                continue
            end
            
            % TODO 1 -- Kosten zum Nachbarn v über u berechnen
            candidate = g(u) + w(k);
            
            % TODO 2 -- Ist das besser als der bisherige Wert von g(v)?
            if candidate < g(v)
                % TODO 3 -- Werte aktualisieren und in OPEN pushen
                g(v)   = candidate;
                par(v) = u;
                OPEN   = open_push(OPEN, v, g(v));
            end
        end
    end

    [path, cost]     = reconstruct_path(par, s, t, W);
    stats.expansions = numel(order);
    stats.order      = order;
    stats.g          = g;
end