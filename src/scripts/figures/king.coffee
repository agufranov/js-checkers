class @King extends Figure
    constructor: ({ @field, @player, @data }) ->
        super field: @field, type: 'king', player: @player, data: @data

        @canGoTo = (to) ->
            dcol = to.col - @field.col
            drow = to.row - @field.row
            console.log 'dcol, drow:', dcol, drow
            if dcol isnt 0 and Math.abs(dcol) is Math.abs(drow)
                console.log 'true'
                result = _([1..Math.abs(dcol)]).all (d) =>
                    console.log 'checking:', @field.col + d * Math.abs(dcol) / dcol, @field.row + d * Math.abs(drow) / drow
                    not @board.getFigureAt(@field.col + d * Math.abs(dcol) / dcol, @field.row + d * Math.abs(drow) / drow)
                console.log result
                if result
                    return allowed: true, moveType: 'go', endMove: true
                else
                    return allowed: false
            else
                return allowed: false

        @canAttackTo = (to) ->

        @move = (to) ->
            if @isAttacked
                canMove = @canAttackTo to
            else
                canMove = @canGoTo to
                canMove = @canAttackTO to unless canMove.allowed
            return unless canMove.allowed
            @field = to
            if canMove.attackFigure
                canMove.attackFigure.isKilled = true
                canMove.endMove = true unless @canAttack()
                @isAttacked = true

            if canMove.endMove
                @isAttacked = false
                @end_move()
