$ ->
    require ['util', 'board', 'game', 'figures/figure', 'figures/checkers/checker', 'figures/checkers/checker-pawn', 'figures/checkers/checker-king'], ->
        Vue.filter 'position', (value) ->
            "#{(parseInt(value) - 1) * 100}px"

        Vue.filter 'killed', (figures) ->
            figures
                .filter (f) => f.player?.number isnt @$data.number and f.isKilled
                .length

        gameVM = new Vue
            el: '.container'
            data:
                game: new Game
                    boardData: { cols: 8, rows: 8 }
                    playersData: [{ number: 1, color: 'beige' }, { number: 2, color: 'black' }]
                selected_figure: null
            computed:
                winner: ->
                    @game.players[@game.state.winner].name
                gameover: ->
                    @game.state.name is 'gameover'
            methods:
                new_click: ->
                    @game.new()

                select_figure: (e) ->
                    figureVM = e.targetVM
                    return unless @game.state.name is 'play' and @game.state.playerNum is figureVM.player.number
                    @$set 'selected_figure', figureVM

                end_move: ->
                    @$set 'selected_figure', null
                play1_click: ->
                    @game.play()
                cell_click: (e) ->
                    @selected_figure?.$data.move e.targetVM

        window.vm = gameVM # debug

        gameVM.$watch 'selected_figure', (newVal, oldVal) ->
            if oldVal and oldVal.$data
                oldVal.$set 'selected', false
            if newVal and newVal.$data
                newVal.$set 'selected', true

        gameVM.$watch 'game.state', (newState, oldState) ->
            @$set 'selected_figure', null
            if oldState.name is 'play'
                player = @game.players[oldState.playerNum]
                player.active = false
                clearInterval player.interval
            if newState.name is 'play'
                player = @game.players[newState.playerNum]
                player.active = true
                do (player) =>
                    player.interval = setInterval ->
                        player.timer++
                    , 100
        , true

        for n of gameVM.game.players
            gameVM.$watch "game.players[#{n}]", (newVal, oldVal) ->
                localStorage["player_#{newVal.number}"] = newVal.name
            , true
