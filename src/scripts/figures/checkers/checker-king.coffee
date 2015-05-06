class CheckerKing extends Checker
    constructor: ({ @field, @player, @data, @game }) ->
        super field: @field, player: @player, type: 'checker-king', data: @data, game: @game

    canAttack: ->
        result = false
        _(Util.cartesian([-1, 1], [-1, 1]))
            .any ([dcol, drow]) =>
                # must return a boolean - are there any moves by this direction
                [col, row] = [@field.col + dcol, @field.row + drow]
                while 1 <= col <= @game.board.cols and 1 <= row <= @game.board.rows
                    return true if @canAttackTo(col: col, row: row).allowed
                    col += dcol
                    row += drow
                false

    canAttackTo: (to) ->
        dcol = to.col - @field.col
        drow = to.row - @field.row
        if dcol isnt 0 and Math.abs(dcol) is Math.abs(drow) and not @game.board.getFigureAt to.col, to.row
            attackFigure = null
            result = _.chain [1..Math.abs(dcol)]
                .map (d) =>
                    col: @field.col + d * Math.abs(dcol) / dcol
                    row: @field.row + d * Math.abs(drow) / drow
                .countBy (f) =>
                    result = (figure = @game.board.getFigureAt(f.col, f.row)) and figure.player isnt @player
                    if result
                        attackFigure = figure
                    result
                .value()
            if result.true is 1
                return allowed: true, moveType: 'attack', attackFigure: attackFigure
            else
                return allowed: false
        else
            return allowed: false

    canGo: ->
        goCols = [1, -1].map( (t) => @field.col + t ).filter( (col) => 1 <= col <= @game.board.cols )
        goRow = @field.row + if @data.direction is 'down' then 1 else -1
        for col in goCols
            return true if @canGoTo(col: col, row: goRow).allowed
        false

    canGoTo: (to) ->
        dcol = to.col - @field.col
        drow = to.row - @field.row
        if dcol isnt 0 and Math.abs(dcol) is Math.abs(drow)
            result = _([1..Math.abs(dcol)]).all (d) =>
                not @game.board.getFigureAt(@field.col + d * Math.abs(dcol) / dcol, @field.row + d * Math.abs(drow) / drow)
            if result
                return allowed: true, moveType: 'go', endMove: true
            else
                return allowed: false
        else
            return allowed: false
