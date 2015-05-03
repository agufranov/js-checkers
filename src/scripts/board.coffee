class @Board
    constructor: ({ @cols, @rows }) ->
        @fields = _.flatten [1..@rows].map (i) =>
            [1..@cols].map (j) =>
                row: i, col: j, color: if (i + j) % 2 is 0 then 'white' else 'black'
        @figures = []


    getFigureAt: (col, row) ->
        @figures.filter( (f) -> f.field.col is col and f.field.row is row and not f.isKilled)[0]
