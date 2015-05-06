class Checker extends Figure
    canMove: -> @canGo() or @canAttack()
    move: (to) ->
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
            @game.endMove()
