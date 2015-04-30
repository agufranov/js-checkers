$ ->
    Vue.filter 'position', (value) ->
        "#{(parseInt(value) - 1) * 100}px"

    window.v = new Vue
        el: '.container'
        data:
            state:
                name: 'new'
            players: _.object [{ number: 1, color: 'white' }, { number: 2, color: 'green' }].map (p) ->
                [
                    p.number,
                    _(p).extend
                        name: localStorage["player_#{p.number}"] or "Игрок #{p.number}"
                        timer: 0
                        interval: null
                        active: false
                ]
            board: Board
            figures: []
        computed:
            stateNew: -> @state.name is 'new'
            stateNotNew: -> @state.name isnt 'new'
        methods:
            new_click: ->
                @state = name: 'new'
            play1_click: ->
                @state = name: 'play', playerNum: 1
            play2_click: ->
                @state = name: 'play', playerNum: 2

    for n of v.players
        v.$watch "players[#{n}]", (newVal, oldVal) ->
            localStorage["player_#{newVal.number}"] = newVal.name
        , true

    v.$watch 'state', (newState, oldState) ->
        console.log "#{oldState.name} (#{oldState.playerNum}) -> #{newState.name} (#{newState.playerNum})"
        if newState.name is 'play'
            player = @players[newState.playerNum]
            player.active = true
            do (player) =>
                player.interval = setInterval ->
                    player.timer++
                , 100
        if oldState.name is 'play'
            player = @players[oldState.playerNum]
            player.active = false
            console.log "clearInterval #{player.interval}"
            clearInterval player.interval

    fillWithCheckers = ->
        Board.figures = _(Board.fields)
            .filter (f) -> f.color is 'black' and (f.x <= 3 or f.x >= 6)
            # .forEach (f) -> f.color = 'test'
            .map (f) -> { field: f, type: 'checker', player: if f.x >= 6 then v.players[1] else v.players[2] }

    fillWithCheckers()
