class Board
    constructor: ({ @cols, @rows, @game }) ->
        @fields = _.flatten [1..@rows].map (i) =>
            [1..@cols].map (j) =>
                row: i, col: j, color: if (i + j) % 2 is 0 then 'white' else 'black'
        @figures = []

    getField: (col, row) ->
        _(@fields).find (f) -> f.col is col and f.row is row

    getFigureAt: (col, row) ->
        @figures.filter( (f) -> f.field.col is col and f.field.row is row and not f.isKilled)[0]

    addPawn: (col, row, player) ->
        @figures.push new CheckerPawn
            field: @getField(col, row)
            player: @game.players[player]
            data: { direction: if player is 1 then 'down' else 'up' }
            game: @game

    fill: ->
        checkerRows = 3
        @figures = _(@fields)
            .filter (f) => f.color is 'black' and (f.row <= checkerRows or f.row >= @rows - checkerRows + 1)
            .map (f) =>
                firstPlayer = f.row <= checkerRows
                # @addPawn f.col, f.row, if firstPlayer then 1 else 2
                new CheckerPawn { field: f, player: @game.players[if firstPlayer then 1 else 2], data: { direction: if firstPlayer then 'down' else 'up' }, game: @game }
