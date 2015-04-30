$ ->
    Vue.filter 'position', (value) ->
        "#{(parseInt(value) - 1) * 100}px"

    window.v = new Vue
        el: '.container'
        data:
            state: 'new'
            players: [1..2].map (n) ->
                number: n
                name: localStorage["player_#{n}"] or "Игрок #{n}"
            # players: [ {
            #     number: 1
            #     name: localStorage'Игрок 1'
            # }, {
            #     number: 2
            #     name: 'Игрок 2'
            # } ]
            board: Board
            figures: []
        computed:
            stateNew: -> @state is 'new'
            stateNotNew: -> @state isnt 'new'
        methods:
            new_click: ->
                @state = 'new'
            play_click: ->
                @state = 'play'

    [0...v.players.length].forEach (n) ->
        v.$watch "players[#{n}]", (newVal, oldVal) ->
            localStorage["player_#{newVal.number}"] = newVal.name
        , true
