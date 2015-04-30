class @Board
    constructor: ({ @cols, @rows }) ->
        @fields = _.flatten [1..@rows].map (i) =>
            [1..@cols].map (j) =>
                row: i, col: j, color: if (i + j) % 2 is 0 then 'white' else 'black'
        @figures = []


    getFigureAt: (col, row) ->
        @figures.filter( (f) -> f.field.col is col and f.field.row is row and not f.isKilled)[0]
        

class @Figure
    constructor: ({ @field, @type, @player, @data }) ->
        @isKilled = false
        @canMove = (field) -> throw new Error 'Not implemented'
        @move = (to) -> throw new Error 'Not implemented'


class @Checker extends Figure
    constructor: ({ @field, @player, @data }) ->
        super field: @field, type: 'checker', player: @player, data: @data

        @canAttack = ->
            attackCols = [2, -2].map( (t) => @field.col + t ).filter( (col) => 1 <= col <= @board.cols )
            attackRows = [2, -2].map( (t) => @field.row + t ).filter( (row) => 1 <= row <= @board.rows )
            for col in attackCols
                for row in attackRows
                    return [col, row] if @canAttackTo(col: col, row: row).allowed
            false

        @canAttackTo = (to) ->
            return allowed: true, moveType: 'attack', attackFigure: attackFigure if not @board.getFigureAt(to.col, to.row) and
                (middleField = col: (@field.col + to.col) / 2, row: (@field.row + to.row) / 2) and
                (attackFigure = @board.getFigureAt(middleField.col, middleField.row)) and
                attackFigure.player isnt @player
            allowed: false

        @canGo = ->
            goCols = [1, -1].map( (t) => @field.col + t ).filter( (col) => 1 <= col <= @board.cols )
            goRow = @field.row + if @data.direction is 'down' then 1 else -1
            for col in goCols
                return true if @canGoTo(col: col, row: goRow).allowed
            false

        @canGoTo = (to) ->
            return allowed: true, moveType: 'go', endMove: true if not @board.getFigureAt(to.col, to.row) and
                to.row is (@field.row + if @data.direction is 'down' then 1 else -1) and
                to.col - @field.col in [1, -1]
            allowed: false


        @move = (to) ->
            if @isAttacked
                canMove = @canAttackTo to
            else
                canMove = @canGoTo to
                canMove = @canAttackTo to unless canMove.allowed
            return unless canMove.allowed
            @field = to
            if canMove.attackFigure
                canMove.attackFigure.isKilled = true
                canMove.endMove = true unless @canAttack()
                @isAttacked = true

            if canMove.endMove
                @isAttacked = false
                @end_move()

                console.log 'index:', @$index
                @board.figures.$set(@$index, new King field: @field, player: @player, data: @data)
                # @board.figures.$remove @$index

            # if @data.direction is 'up' and @field.row is 1 or @data.direction is 'down' and @field.row is @board.rows

class @King extends Figure
    constructor: ({ @field, @player, @data }) ->
        super field: @field, type: 'king', player: @player, data: @data
