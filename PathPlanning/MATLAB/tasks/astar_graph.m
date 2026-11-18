function [path, cost, stats] = astar_graph(W, s, t, h)
%ASTAR_GRAPH  TASK 5 -- A*.
%
%   Copy your finished dijkstra_graph in here and change ONLY THE KEY.
%
%       Dijkstra   key = g(v)
%       A*         key = g(v) + h(v)
%
%   Careful: the key appears at TWO places -- once when the start is
%   pushed, once inside the loop. Both have to change.
%
%   Target:  A - B - E - F, cost 3, 4 expansions.
%            Same path as Dijkstra, one expansion less.
%
%   Check:   check_my_code('astar')
n      = size(W, 1);
    g      = inf(n, 1);       % no route known yet
    g(s)   = 0;               % the start costs nothing
    par    = zeros(n, 1);
    closed = false(n, 1);
    order  = zeros(1, 0);
    OPEN = open_new('minkey');
    OPEN = open_push(OPEN, s, g(s)); % Start wie bei Dijkstra belassen, um Crashs zu vermeiden
    while ~open_isempty(OPEN)
        [OPEN, u] = open_pop(OPEN);
        
        if closed(u)
            continue
        end
        closed(u)      = true;
        order(end + 1) = u;   %#ok
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
            
            % TODO 1 -- Kosten zum Nachbarn v über u berechnen (g(u) + Kantengewicht)
            candidate = g(u) + w(k);
            
            % TODO 2 -- Ist das besser als der bisherige Wert von g(v)?
            if candidate < g(v)
                % TODO 3 -- Werte aktualisieren und in OPEN pushen (A*-Key: g(v) + h(v))
                g(v)   = candidate;
                par(v) = u;
                OPEN   = open_push(OPEN, v, g(v) + h(v));
            end
        end
    end
    [path, cost]     = reconstruct_path(par, s, t, W);
    stats.expansions = numel(order);
    stats.order      = order;
    stats.g          = g;
end