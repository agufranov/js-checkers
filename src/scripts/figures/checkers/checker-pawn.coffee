class CheckerPawn extends Checker
    constructor: ({ @field, @player, @data, @game }) ->
        super field: @field, player: @player, type: 'checker-pawn', data: @data, game: @game

    canAttack: ->
        attackCols = [2, -2].map( (t) => @field.col + t ).filter( (col) => 1 <= col <= @game.board.cols )
        attackRows = [2, -2].map( (t) => @field.row + t ).filter( (row) => 1 <= row <= @game.board.rows )
        for col in attackCols
            for row in attackRows
                return [col, row] if @canAttackTo(col: col, row: row).allowed
        false

    canAttackTo: (to) ->
        return allowed: true, moveType: 'attack', attackFigure: attackFigure if not @game.board.getFigureAt(to.col, to.row) and
            (middleField = col: (@field.col + to.col) / 2, row: (@field.row + to.row) / 2) and
            (attackFigure = @game.board.getFigureAt(middleField.col, middleField.row)) and
            attackFigure.player isnt @player
        @allowed = false

    canGo: ->
        goCols = [1, -1].map( (t) => @field.col + t ).filter( (col) => 1 <= col <= @game.board.cols )
        goRow = @field.row + if @data.direction is 'down' then 1 else -1
        for col in goCols
            return true if @canGoTo(col: col, row: goRow).allowed
        false

    canGoTo: (to) ->
        return allowed: true, moveType: 'go', endMove: true if not @game.board.getFigureAt(to.col, to.row) and
            to.row is (@field.row + if @data.direction is 'down' then 1 else -1) and
            to.col - @field.col in [1, -1]
        @allowed = false

    canBecomeKing: ->
      @field.row is if @data.direction is 'down' then @game.board.rows else 1

    move: (to) ->
        super to
        if @canBecomeKing()
          @game.board.figures.$set(@game.board.figures.indexOf(@), new CheckerKing field: @field, player: @player, data: @data, game: @game)
