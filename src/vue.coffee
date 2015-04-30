$ ->
    Vue.filter 'position', (value) ->
        "#{(parseInt(value) - 1) * 100}px"

    Vue.filter 'killed', (figures) ->
        figures
            .filter (f) => f.player.number isnt @$data.number and f.isKilled
            .length

    window.v = new Vue
        el: '.container'
        data:
            state:
                name: 'new'
            players: _.object [{ number: 1, color: 'beige' }, { number: 2, color: 'black' }].map (p) ->
                [
                    p.number,
                    _(p).extend
                        name: localStorage["player_#{p.number}"] or "Игрок #{p.number}"
                        timer: 0
                        interval: null
                        active: false
                ]
            board: new Board cols: 8, rows: 5
            selected_figure: null
        computed:
            stateNew: -> @state.name is 'new'
            stateNotNew: -> @state.name isnt 'new'
        methods:
            end_move: ->
                @$set 'selected_figure', null
                playerNum = @state.playerNum + 1
                playerNum = 1 unless @players[playerNum]
                @$set 'state', name: 'play', playerNum: playerNum
            new_click: ->
                @state = name: 'new'
            play1_click: ->
                @state = name: 'play', playerNum: 1
            play2_click: ->
                @state = name: 'play', playerNum: 2
            select_figure: (e) ->
                figure = e.targetVM
                return unless @state.name is 'play' and @state.playerNum is figure.player.number
                v.$set 'selected_figure', figure
            cell_click: (e) ->
                console.log [e.targetVM.col, e.targetVM.row]
                @selected_figure?.move e.targetVM

    for n of v.players
        v.$watch "players[#{n}]", (newVal, oldVal) ->
            localStorage["player_#{newVal.number}"] = newVal.name
        , true

    v.$watch 'selected_figure', (newVal, oldVal) ->
        if newVal and newVal.$data
            newVal.$set 'selected', true
        if oldVal and oldVal.$data
            oldVal.$set 'selected', false

    v.$watch 'state', (newState, oldState) ->
        console.log "#{oldState.name} (#{oldState.playerNum}) -> #{newState.name} (#{newState.playerNum})"
        if oldState.name is 'play'
            player = @players[oldState.playerNum]
            player.active = false
            clearInterval player.interval
        if newState.name is 'play'
            player = @players[newState.playerNum]
            player.active = true
            do (player) =>
                player.interval = setInterval ->
                    player.timer++
                , 100
    , true

    fillWithCheckers = ->
        checkerRows = 2
        v.board.figures = _(v.board.fields)
            .filter (f) -> f.color is 'black' and (f.row <= checkerRows or f.row >= v.board.rows - checkerRows + 1)
            .map (f) ->
                firstPlayer = f.row <= checkerRows
                new Checker { field: f, player: v.players[if firstPlayer then 1 else 2], data: { direction: if firstPlayer then 'down' else 'up' } }

    fillWithCheckers()
