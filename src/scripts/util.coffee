Util =
    cartesian: (X, Y) ->
        _.chain(X)
            .map (x) ->
                _(Y).map (y) -> [x, y]
            .flatten(true)
            .value()
