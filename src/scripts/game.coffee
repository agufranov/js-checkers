class Game
    constructor: ({ boardData, playersData }) ->
        @state = { name: 'initializing' }
        @board = new Board _(boardData).extend game: @
        @players = _.object playersData.map (p) ->
            [
                p.number,
                _(p).extend
                    name: localStorage["player_#{p.number}"] or "Игрок #{p.number}"
                    timer: 0
                    interval: null
                    active: false
                    wins: parseInt(localStorage["wins_#{p.number}"]) or 0
            ]
        @new()

    new: ->
        @state = { name: 'new' }
        @board.fill()

    play: ->
        @state = { name: 'play', playerNum: 1 }
        _(@players).each (p) -> p.timer = 0

    endMove: ->
        oldPlayerNum = @state.playerNum
        playerNum = @state.playerNum + 1
        playerNum = 1 unless @players[playerNum]
        hasMoves = _.chain @board.figures
            .filter (f) -> f.player.number is playerNum and not f.isKilled
            .any (f) -> f.canMove()
            .value()
        if hasMoves
            @state = { name: 'play', playerNum: playerNum }
        else
            winner = @players[oldPlayerNum]
            winner.wins++
            localStorage["wins_#{oldPlayerNum}"] = winner.wins
            @state = { name: 'gameover', winner: oldPlayerNum }
